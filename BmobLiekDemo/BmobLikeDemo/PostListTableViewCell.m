//
//  PostListTableViewCell.m
//  BmobLikeDemo
//
//  Created by limao on 15/11/11.
//  Copyright © 2015年 limaofuyuanzhang. All rights reserved.
//

#import "PostListTableViewCell.h"
#import "PMUILabel.h"
#import <BmobSDK/Bmob.h>
#import <SVProgressHUD.h>

@interface PostListTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleTf;
@property (weak, nonatomic) IBOutlet PMUILabel *contentTf;
@property (weak, nonatomic) IBOutlet UILabel *likeNumberTf;
@property (weak, nonatomic) IBOutlet PMUILabel *likesUserTf;
@property (weak, nonatomic) IBOutlet UIButton *likesButton;
@property (strong, nonatomic) NSString *postObjectId;
@end


@implementation PostListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setView:(NSDictionary *)post{
    self.postObjectId = post[@"objectId"];
    
    self.titleTf.text = post[@"title"];
    self.contentTf.text = post[@"content"];
    
    NSArray *likes = post[@"likes"];
    self.likeNumberTf.text = [NSString stringWithFormat:@"%d",likes.count];
    self.likesUserTf.text = likes.description;
    
    BmobUser *user = [BmobUser getCurrentUser];
    if ([likes containsObject:user.username]) {
        [self.likesButton setTitle:@"取消点赞" forState:UIControlStateNormal];
    } else {
        [self.likesButton setTitle:@"点赞" forState:UIControlStateNormal];
    }
    
}

- (IBAction)likesBtnClicked:(id)sender {
    
    NSString *status = self.likesButton.titleLabel.text;
    BmobUser *user = [BmobUser getCurrentUser];
    if ([status isEqualToString:@"点赞"]) {
        BmobObject *like = [[BmobObject alloc] initWithClassName:@"Likes"];
        [like setObject:user forKey:@"user"];
        [like setObject:[BmobObject objectWithoutDatatWithClassName:@"Post" objectId:self.postObjectId] forKey:@"post"];
        [like saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if (error) {
                NSString *errorDetail = error.description;
                [SVProgressHUD showErrorWithStatus:errorDetail];
            } else {
                [self.likesButton setTitle:@"取消点赞" forState:UIControlStateNormal];
                if (self.block) {
                    self.block();
                }
            }
        }];
    } else {
        //找到点赞记录
        BmobQuery *query = [[BmobQuery alloc] initWithClassName:@"Likes"];
        [query whereKey:@"user" equalTo:user];
        [query whereKey:@"post" equalTo:[BmobObject objectWithoutDatatWithClassName:@"Post" objectId:self.postObjectId]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            if (error) {
                NSString *errorDetail = error.description;
                [SVProgressHUD showErrorWithStatus:errorDetail];
            } else {
                //删除点赞记录
                BmobObject *object = [array firstObject];
                [object deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
                    if (error) {
                        NSString *errorDetail = error.description;
                        [SVProgressHUD showErrorWithStatus:errorDetail];
                    } else {
                        [self.likesButton setTitle:@"点赞" forState:UIControlStateNormal];
                        if (self.block) {
                            self.block();
                        }
                    }
                }];
            }
        }];
    }
    

}

@end
