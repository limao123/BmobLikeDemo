//
//  PostListTableViewCell.h
//  BmobLikeDemo
//
//  Created by limao on 15/11/11.
//  Copyright © 2015年 limaofuyuanzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BmobSDK/Bmob.h>

typedef void(^PostListTableViewCellBlock)(void);

@interface PostListTableViewCell : UITableViewCell
@property (copy, nonatomic) PostListTableViewCellBlock block;
- (void)setView:(NSDictionary *)post;
@end
