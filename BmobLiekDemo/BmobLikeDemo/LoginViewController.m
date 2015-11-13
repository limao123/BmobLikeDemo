//
//  LoginViewController.m
//  BmobLikeDemo
//
//  Created by limao on 15/11/10.
//  Copyright © 2015年 limaofuyuanzhang. All rights reserved.
//

#import "LoginViewController.h"
#import <BmobSDK/Bmob.h>
#import <SVProgressHUD.h>
#import "PostListViewController.h"
#import "RegisterViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTf;
@property (weak, nonatomic) IBOutlet UITextField *passwordTf;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"登录";
}

//登录
- (IBAction)loginBtnClicked:(UIButton *)sender {

    //错误检查
    if ([self.usernameTf.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入用户名"];
        return;
    }
    
    if ([self.passwordTf.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }
    
    //登录
    [SVProgressHUD showWithStatus:@"登录中..."];
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

//注册
- (IBAction)registerBtnClicked:(UIButton *)sender {
    RegisterViewController *registerViewVC = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerViewVC animated:YES];
}

@end
