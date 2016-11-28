//
//  JTAccountsViewController.m
//  JTKeychainDemo
//
//  Created by xia on 16/11/20.
//  Copyright © 2016年 JT. All rights reserved.
//

#import "JTAccountsViewController.h"
#import "KeychainWrapper.h"
#import "KeychainConfiguration.h"
#import "JTDetailAccountViewController.h"

@interface JTAccountsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *keychainWrappers;

@end

@implementation JTAccountsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationItem];
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSArray *keychains = [KeychainWrapper passwordItemsForService:kKeychainService accessGroup:kKeychainAccessGroup];
    
    self.keychainWrappers = [NSMutableArray arrayWithArray:keychains];
    
    [self.tableView reloadData];
}

- (void)add {
    JTDetailAccountViewController *detailVC = [[JTDetailAccountViewController alloc] init];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.keychainWrappers.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseID];
    }
    KeychainWrapper *wrapper = self.keychainWrappers[indexPath.row];
    cell.textLabel.text = wrapper.account;
    cell.detailTextLabel.text = [wrapper readPassword];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JTDetailAccountViewController *detailVC = [[JTDetailAccountViewController alloc] init];
    detailVC.account = [self.keychainWrappers[indexPath.row] account];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        KeychainWrapper *wrapper = self.keychainWrappers[indexPath.row];
        
        if (
            [wrapper deleteItem]) {
            [self.keychainWrappers removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
    
}

#pragma mark - UI
- (void)setupNavigationItem {
    UIButton *add = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [add addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:add];
}


#pragma mark - lazy
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
