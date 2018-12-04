//
//  LXMyFriendTableViewCell.m
//  LXAddressBookDemo
//
//  Created by LX Zeng on 2018/12/4.
//  Copyright © 2018   https://github.com/nick8brown   All rights reserved.
//

#import "LXMyFriendTableViewCell.h"
#import "PPPersonModel.h"

@interface LXMyFriendTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;

@end

@implementation LXMyFriendTableViewCell

#pragma mark - private func
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    return [[[self class] alloc] initWithTableView:tableView];
}

- (instancetype)initWithTableView:(UITableView *)tableView {
    if (self = [super init]) {
        self = DequeueReusable_Cell;
        
        self.iconImgView.layer.cornerRadius = CGRectGetWidth(self.iconImgView.frame) * 0.5;
        self.iconImgView.layer.masksToBounds = YES;
    }
    return self;
}

#pragma mark - setter&getter
- (void)setPersonModel:(PPPersonModel *)personModel {
    _personModel = personModel;
    
    if (personModel) {
        self.nameLabel.text = personModel.name;
        
        self.mobileLabel.text = [personModel.mobileArray firstObject];
    }
}

@end
