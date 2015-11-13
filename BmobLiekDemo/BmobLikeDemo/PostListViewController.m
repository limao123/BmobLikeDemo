//
//  PostListViewController.m
//  BmobLikeDemo
//
//  Created by limao on 15/11/10.
//  Copyright © 2015年 limaofuyuanzhang. All rights reserved.
//

#import <BmobSDK/Bmob.h>
#import <MJRefresh/MJRefresh.h>
#import <SVProgressHUD.h>

#import "PostListViewController.h"
#import "CreatePostViewController.h"
#import "PostListTableViewCell.h"
#import "NSString+check.h"



@interface PostListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *postsArray;
@end

@implementation PostListViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _postsArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self settingNavigationBar];
    [self settingTableView];
}

#pragma mark - 导航栏设置
- (void)settingNavigationBar{
    //导航栏设置
    self.navigationItem.title = @"帖子列表";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"创建帖子" style:UIBarButtonItemStylePlain target:self action:@selector(jumpToCreatePostVC:)];
}

- (void)jumpToCreatePostVC:(id)sender{
    CreatePostViewController *createPostVC = [[CreatePostViewController alloc] init];
    [self.navigationController pushViewController:createPostVC animated:YES];
}

#pragma mark - tableview设置
- (void)settingTableView{
    self.postsArray = [[NSMutableArray alloc] init];
    
    //注册UITableViewCell
    UINib *nib = [UINib nibWithNibName:@"PostListTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"PostListTableViewCell"];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData:)];
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)loadData:(id)sender{
    [BmobCloud callFunctionInBackground:@"loadPost" withParameters:nil block:^(id object, NSError *error) {
        if (error) {
            NSString *errorDetail = error.description;
            [SVProgressHUD showErrorWithStatus:errorDetail];
        } else {
            NSLog(@"%@",object);
            self.postsArray = [NSString stringToJson:object];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.postsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *idertifier = @"PostListTableViewCell";
    PostListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idertifier];
    [cell setView:self.postsArray[indexPath.section]];
    __weak typeof(PostListTableViewCell *)weakCell = cell;
    weakCell.block = ^(void){
        [self loadData:nil];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    };

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

@end
