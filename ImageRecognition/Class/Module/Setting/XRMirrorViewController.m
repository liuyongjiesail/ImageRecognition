//
//  XRMirrorViewController.m
//  ImageRecognition
//
//  Created by 刘永杰 on 2018/10/8.
//  Copyright © 2018 刘永杰. All rights reserved.
//

#import "XRMirrorViewController.h"

@interface XRMirrorViewController ()

@end

@implementation XRMirrorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    // Do any additional setup after loading the view.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:NO completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
