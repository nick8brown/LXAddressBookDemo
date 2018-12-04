//
//  ViewController.m
//  LXAddressBookDemo
//
//  Created by LX Zeng on 2018/12/4.
//  Copyright © 2018   https://github.com/nick8brown   All rights reserved.
//

#import "ViewController.h"

#import "LXMyFriendTableViewCell.h"

#import "PPGetAddressBook.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *nameArray;
@property (nonatomic, strong) NSMutableArray *mobileArray;

@property (nonatomic, strong) NSArray *addressBookArray;

@end

@implementation ViewController

#pragma mark - lazy load
- (NSMutableArray *)nameArray {
    if (!_nameArray) {
        _nameArray = [NSMutableArray arrayWithCapacity:self.addressBookArray.count];
        for (int i = 0; i < self.addressBookArray.count; i++) {
            PPPersonModel *personModel = self.addressBookArray[i];
            [_nameArray addObject:personModel.name];
        }
    }
    return _nameArray;
}

- (NSMutableArray *)mobileArray {
    if (!_mobileArray) {
        _mobileArray = [NSMutableArray arrayWithCapacity:self.addressBookArray.count];
        for (int i = 0; i < self.addressBookArray.count; i++) {
            PPPersonModel *personModel = self.addressBookArray[i];
            [_mobileArray addObject:[personModel.mobileArray firstObject]];
        }
    }
    return _mobileArray;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"通讯录";
    
    // 初始化导航栏
    [self setupNavBar];
    
    // 初始化view
    [self setupView];
}

#pragma mark - 初始化导航栏
- (void)setupNavBar {
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:AppFont(18), NSForegroundColorAttributeName:SYS_White_Color}];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage getImageWithColor:AppHTMLColor(@"4bccbc")] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    // leftBarButtonItem（请求授权）
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(0, 0, 100, 15);
    [btn1 setTitle:@"请求授权" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btn1Item = [[UIBarButtonItem alloc] initWithCustomView:btn1];
    
    self.navigationItem.leftBarButtonItems = @[btn1Item];
    
    
    // rightBarButtonItem（获取通讯录）
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(0, 0, 100, 15);
    [btn2 setTitle:@"获取通讯录" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(btn2Click:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btn2Item = [[UIBarButtonItem alloc] initWithCustomView:btn2];
    
    self.navigationItem.rightBarButtonItems = @[btn2Item];
}

#pragma mark - 初始化view
- (void)setupView {
    // 初始化tableView
    [self setupTableView];
}

// 初始化tableView
- (void)setupTableView {
    // 设置tableView
    self.tableView.rowHeight = LXMyFriendTableViewCell_HEIGHT;
    RegisterNib_for_Cell(LXMyFriendTableViewCell);
}

#pragma mark - UITableViewDataSource
// 段数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.addressBookArray.count;
}

// cell样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LXMyFriendTableViewCell *cell = [LXMyFriendTableViewCell cellWithTableView:tableView];
    cell.personModel = self.addressBookArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
// 段头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

// 段尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

// 段头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

// 段尾视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

// 选中某行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
}

#pragma mark - 请求通讯录授权
- (void)btn1Click:(UIButton *)sender {
    // 请求用户获取通讯录权限
    [PPGetAddressBook requestAddressBookAuthorization];
}

#pragma mark - 获取通讯录列表
- (void)btn2Click:(UIButton *)sender {
    // 获取没有经过排序的联系人模型
    [PPGetAddressBook getOriginalAddressBook:^(NSArray<PPPersonModel *> *addressBookArray) {
        NSMutableArray *tempArray = [NSMutableArray array];
        for (int i = 0; i < addressBookArray.count; i++) {
            PPPersonModel *personModel = addressBookArray[i];
            
            NSString *mobile = [personModel.mobileArray firstObject];
            if (mobile.length == 11) { // 判断是否11位手机号
                [tempArray addObject:personModel];
            }
        }
        self.addressBookArray = [NSArray arrayWithArray:tempArray];
        
        [self.tableView reloadData];
    } authorizationFailure:^{
        NSLog(@"未获得用户授权访问通讯录");
    }];
}

@end
