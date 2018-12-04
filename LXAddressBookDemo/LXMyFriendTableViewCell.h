//
//  LXMyFriendTableViewCell.h
//  LXAddressBookDemo
//
//  Created by LX Zeng on 2018/12/4.
//  Copyright © 2018   https://github.com/nick8brown   All rights reserved.
//

#import <UIKit/UIKit.h>

#define LXMyFriendTableViewCell_HEIGHT 67

@class PPPersonModel;

@interface LXMyFriendTableViewCell : UITableViewCell

@property (nonatomic, strong) PPPersonModel *personModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (instancetype)initWithTableView:(UITableView *)tableView;

@end
