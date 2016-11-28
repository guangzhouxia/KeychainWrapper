//
//  JTBaseViewController.m
//  JTKeychainDemo
//
//  Created by xia on 16/11/27.
//  Copyright © 2016年 JT. All rights reserved.
//

#import "JTBaseViewController.h"

@interface JTBaseViewController ()

@end

@implementation JTBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSStringFromClass([self class]);
}

- (void)showAlertViewWithContent:(NSString *)content {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Tip" message:content delegate:nil cancelButtonTitle:@"OK~" otherButtonTitles:nil, nil];
    [alertView show];
}

@end
