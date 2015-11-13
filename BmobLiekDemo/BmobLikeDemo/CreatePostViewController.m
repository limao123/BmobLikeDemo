//
//  CreatePostViewController.m
//  BmobLikeDemo
//
//  Created by limao on 15/11/10.
//  Copyright © 2015年 limaofuyuanzhang. All rights reserved.
//

#import <BmobSDK/Bmob.h>
#import <SVProgressHUD.h>

#import "CreatePostViewController.h"

@interface CreatePostViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titleTf;
@property (weak, nonatomic) IBOutlet UITextView *contentTv;
@end

@implementation CreatePostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"发帖";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(createPost:)];
}

- (void)createPost:(id)sender{
    //错误检查
    if ([self.titleTf.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"标题不能为空"];
        return;
    }
    
    if ([self.contentTv.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"内容不能为空"];
        return;
    }
    
    //发布帖子
    [SVProgressHUD showInfoWithStatus:@"发布中..."];
    BmobObject *post = [[BmobObject alloc] initWithClassName:@"Post"];
    [post setObject:self.titleTf.text forKey:@"title"];
    [post setObject:self.contentTv.text forKey:@"content"];
    [post setObject:[BmobUser getCurrentUser] forKey:@"author"];
    [post saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (error) {
            NSString *errorDetail = error.description;
            [SVProgressHUD showErrorWithStatus:errorDetail];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
            [SVProgressHUD showSuccessWithStatus:@"发布成功"];
        }
    }];
}



@end
