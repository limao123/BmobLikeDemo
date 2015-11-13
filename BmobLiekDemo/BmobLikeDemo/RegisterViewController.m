//
//  RegisterViewController.m
//  BmobLikeDemo
//
//  Created by limao on 15/11/10.
//  Copyright © 2015年 limaofuyuanzhang. All rights reserved.
//

#import "RegisterViewController.h"
#import <SVProgressHUD.h>
#import <BmobSDK/Bmob.h>
#import "PostListViewController.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTf;
@property (weak, nonatomic) IBOutlet UITextField *passwordTf;
@property (weak, nonatomic) IBOutlet UITextField *repasswordTf;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"注册";
}

- (IBAction)registerBtnClicked:(UIButton *)sender {
    //错误检查
    if ([self.usernameTf.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入用户名"];
        return;
    }
    
    if ([self.passwordTf.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }
    
    if ([self.repasswordTf.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请再次输入密码"];
        return;
    }
    
    if (![self.passwordTf.text isEqualToString:self.repasswordTf.text]) {
        [SVProgressHUD showErrorWithStatus:@"两次输入密码不一致"];
        return;
    }
    
    //注册
    [SVProgressHUD show];
    BmobUser *user = [[BmobUser alloc] init];
    user.username = self.usernameTf.text;
    user.password = self.passwordTf.text;
    [user signUpInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
        if (error) {
            //注册失败
            NSString *errorDetail = error.description;
            [SVProgressHUD showErrorWithStatus:errorDetail];
        } else {
            //注册成功，登录
            [SVProgressHUD showSuccessWithStatus:@"注册成功，正在进行登录"];
            [BmobUser loginInbackgroundWithAccount:self.usernameTf.text andPassword:self.passwordTf.text block:^(BmobUser *user, NSError *error) {
                if (error) {
                    //登录失败
                    NSString *errorDetail = error.description;
                    [SVProgressHUD showErrorWithStatus:errorDetail];
                } else {
                    //登录成功
                    PostListViewController *postListVC = [[PostListViewController alloc] init];
                    [self.navigationController pushViewController:postListVC animated:YES];
                    [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                }
            }];
        }
    }];
}


@end
