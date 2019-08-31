//
//  ApplePayComponent.m
//  ImageRecognition
//
//  Created by 刘永杰 on 2019/6/4.
//  Copyright © 2019 刘永杰. All rights reserved.
//

/*
 
 x颗糖果
 com.sail.xrecognition.release.x
 x元人民币相当于x颗糖果
 打赏开发者功能
 
 */

#import "ApplePayComponent.h"
#import <StoreKit/StoreKit.h>

@interface ApplePayComponent ()<SKPaymentTransactionObserver, SKProductsRequestDelegate>

@property (copy, nonatomic) void(^tempSuccess)(void);
@property (copy, nonatomic) void(^tempFailure)(NSString *error);

@end

@implementation ApplePayComponent

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static ApplePayComponent *instance;
    dispatch_once(&onceToken, ^{
        instance = [[ApplePayComponent alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}

- (void)purchase:(NSString *)productId success:(void(^)(void))success failure:(void(^)(NSString *error))failure {

    self.tempSuccess = success;
    self.tempFailure = failure;
    
    [MBProgressHUD showMessage:@""];
    if ([SKPaymentQueue canMakePayments]) {
        NSSet *set = [NSSet setWithObjects:productId, nil];
        SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
        request.delegate = self;
        [request start];
    } else {
        if (failure) {
            failure(@"您的设备未开通支付功能，请联系客服解决");
        }
    }
}

#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    NSArray *products = response.products;
    if (products.count == 0) {
        [MBProgressHUD hideHUD];
        if (self.tempFailure) {
            self.tempFailure(@"商品信息无效，请联系客服");
        }
        return;
    }
    SKProduct *product = products.firstObject;
    NSLog(@"请求购买:%@",product.productIdentifier);
    SKPayment * payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)requestDidFinish:(SKRequest *)request{
    NSLog(@"%s",__FUNCTION__);
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"%s:%@",__FUNCTION__,error.localizedDescription);
    [MBProgressHUD hideHUD];
    if (self.tempFailure) {
        self.tempFailure(@"商品信息无效，请联系客服");
    }
}

#pragma mark - SKPaymentTransactionObserver

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    
    for (SKPaymentTransaction *transaction in transactions) {
        NSLog(@"transaction_id:%@",transaction.transactionIdentifier);
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing: // 0 购买事务进行中
                NSLog(@"购买中。。");
                break;
            case SKPaymentTransactionStatePurchased: {
                // 1 交易完成
                [MBProgressHUD hideHUD];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                
                if (self.tempSuccess) {
                    self.tempSuccess();
                }
                break;
            } case SKPaymentTransactionStateFailed: {
                // 2 交易失败
                [MBProgressHUD hideHUD];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];//结束支付事务
                
                if (self.tempFailure) {
                    self.tempFailure(@"操作未成功，请重试！");
                }
                break;
            } default:
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];//结束支付事务
                break;
        }
    }
}

@end

