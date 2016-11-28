//
//  KeychainWrapper.h
//  JTKeychainDemo
//
//  Created by xia on 16/11/20.
//  Copyright © 2016年 JT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>

@interface KeychainWrapper : NSObject

@property (nonatomic, copy)NSString *service;
@property (nonatomic, copy)NSString *account;
@property (nonatomic, copy)NSString *accessGroup;

- (instancetype)initWithSevice:(NSString *)service account :(NSString *)account accessGroup:(NSString *)accessGroup;

- (void)savePassword:(NSString *)password;
- (BOOL)deleteItem;

- (NSString *)readPassword;

+ (NSArray *)passwordItemsForService:(NSString *)service accessGroup:(NSString *)accessGroup;

@end
