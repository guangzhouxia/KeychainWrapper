//
//  JTDetailAccountViewController.m
//  JTKeychainDemo
//
//  Created by xia on 16/11/27.
//  Copyright © 2016年 JT. All rights reserved.
//

#import "JTDetailAccountViewController.h"
#import "KeychainWrapper.h"
#import "KeychainConfiguration.h"

@interface JTDetailAccountViewController ()

@property (nonatomic, strong)UIScrollView *contentView;

@property (nonatomic, weak)UITextField *accountField;

@property (nonatomic, weak)UITextField *passwordField;

@end

@implementation JTDetailAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationItem];
    [self setupUI];
    
    //init account 、 password
    if (self.account.length > 0) {
        KeychainWrapper *wrapper = [[KeychainWrapper alloc] initWithSevice:kKeychainService account:self.account accessGroup:kKeychainAccessGroup];
        self.accountField.text = wrapper.account;
        self.passwordField.text = [wrapper readPassword];
    }
}

#pragma mark - private func
- (void)save {
    if (self.accountField.text.length == 0 || self.passwordField.text.length == 0) {
        [self showAlertViewWithContent:@"Acount or password couldn't be empty..."];
        return;
    }
    
    KeychainWrapper *wrapper = [[KeychainWrapper alloc] initWithSevice:kKeychainService account:self.accountField.text accessGroup:kKeychainAccessGroup];
    [wrapper savePassword:self.passwordField.text];

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UI
- (void)setNavigationItem {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"save" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
}
- (void)setupUI {
    [self.view addSubview:self.contentView];
    
    CGFloat padding = 10.0;
    CGFloat y = padding;
    CGFloat width = self.view.bounds.size.width - 2.0 * padding;
    CGFloat height = 44.0;
    
    UILabel *accontLabel = [self createLabel:@"account" frame:CGRectMake(padding, 20.0, width, height)];
    [self.contentView addSubview:accontLabel];
    
    y = CGRectGetMaxY(accontLabel.frame) + padding;
    UITextField *acountField = [self createTextField:nil frame:CGRectMake(padding, y, width, height)];
    [self.contentView addSubview:acountField];
    _accountField = acountField;
    
    y = CGRectGetMaxY(acountField.frame) + padding;
    UILabel *passwordLabel = [self createLabel:@"password" frame:CGRectMake(padding, y, width, height)];
    [self.contentView addSubview:passwordLabel];
    
    y = CGRectGetMaxY(passwordLabel.frame) + padding;
    UITextField *passwordField = [self createTextField:nil frame:CGRectMake(padding, y, width, height)];
    [self.contentView addSubview:passwordField];
    _passwordField = passwordField;
    
    CGFloat contentHeight = CGRectGetMaxY(passwordField.frame) + padding;
    self.contentView.contentSize = CGSizeMake(width, contentHeight);
}

- (UILabel *)createLabel:(NSString *)text frame:(CGRect)frame {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    return label;
}

- (UITextField *)createTextField:(NSString *)content frame:(CGRect)frame {
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.text = content;
    textField.backgroundColor = [UIColor lightGrayColor];
    return textField;
}

#pragma mark - lazy
- (UIScrollView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    }
    return _contentView;
}

@end
