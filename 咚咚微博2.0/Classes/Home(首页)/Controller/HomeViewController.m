//
//  HomeViewController.m
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/6/23.
//  Copyright (c) 2015年 J.Beyond. All rights reserved.
//

#import "HomeViewController.h"
#import "DropdownMenu.h"
#import "AFNetworking.h"
#import "WBAccountTool.h"
#import "TitleButton.h"
#import "UIImageView+WebCache.h"
#import "MJExtension.h"
#import "WBStatus.h"
#import "WBUser.h"
#import "LoadMoreFooter.h"
#import "WBStatusCell.h"


@interface HomeViewController ()<DropdownMenuDelegate>
/**
 *  微博数组（里面放的都是字典，一个字典就是一条微博）
 */
@property(nonatomic,strong)NSMutableArray *statusFrames;
@end

@implementation HomeViewController


- (NSMutableArray *)statusFrames
{
    if (!_statusFrames) {
        _statusFrames = [NSMutableArray array];
    }
    return _statusFrames;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBColor(211, 211, 211);
    //以下方式设置tableView距离顶部间距会导致下拉刷新进度条也会向下移动
//    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    //设置导航栏内容
    [self setupNav];
    //获取用户信息
    [self setupUserInfo];
//    //加载最新的微博数据
//    [self loadNewStatus];
    //集成下拉刷新控件
    [self setupRefresh];
    
    //集成上拉加载更多控件
    [self loadMoreView];
    
    // 获得未读数（每隔60s中调用setupUnreadCount）
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(setupUnreadCount) userInfo:nil repeats:YES];
    // 主线程也会抽时间处理一下timer（不管主线程是否正在其他事件）
    //NSRunLoopCommonModes:
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

/**
 *  获得未读数
 */
- (void)setupUnreadCount
{
    //    HWLog(@"setupUnreadCount");
    //    return;
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.拼接请求参数
    WBAccount *account = [WBAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;
    
    // 3.发送请求
    [mgr GET:@"https://rm.api.weibo.com/2/remind/unread_count.json" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        // 微博的未读数
        //        int status = [responseObject[@"status"] intValue];
        // 设置提醒数字
        //        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", status];
        
        // @20 --> @"20"
        // NSNumber --> NSString
        // 设置提醒数字(微博的未读数)
        NSString *status = [responseObject[@"status"] description];
        if ([status isEqualToString:@"0"]) { // 如果是0，得清空数字
            self.tabBarItem.badgeValue = nil;
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        } else { // 非0情况
            self.tabBarItem.badgeValue = status;
            [UIApplication sharedApplication].applicationIconBadgeNumber = status.intValue;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        Log(@"请求失败-%@", error);
    }];
}

/**
 *  上拉加载更多控件
 */
-(void)loadMoreView
{
    LoadMoreFooter *footer = [LoadMoreFooter footer];
    footer.hidden = YES;
    self.tableView.tableFooterView = footer;
}
//集成下拉刷新控件
-(void)setupRefresh
{
    //1.添加刷新控件
    UIRefreshControl *refresh = [[UIRefreshControl alloc]init];
    [refresh addTarget:self action:@selector(refreshStateChange:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refresh];
    
    //2.马上进入刷新状态(仅仅是显示刷新状态，并不会触发target事件)
    [refresh beginRefreshing];
    
    //3.加载数据
    [self refreshStateChange:refresh];
    
}
/**
 *  UIRefreshControl进入刷新状态，加载最新的数据
 */
-(void)refreshStateChange:(UIRefreshControl *)refresh
{
//    Log(@"refreshStateChange");
    //1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    //拼接请求参数
    WBAccount *account = [WBAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    //取出最前面的微博（最新的微博，id最大的微博）
    WBStatusFrame *firstStatusF = [self.statusFrames firstObject];
    if (firstStatusF) {
        params[@"since_id"] = firstStatusF.status.idstr;
    }
    
    //发送请求
    [mgr GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        Log(@"success:%@",responseObject);
        
        //取得微博数组
        NSArray *newStatuses = [WBStatus objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        
        //将WBStatus数组转为WBStatusFrame
        NSArray *newFrames = [self statusFramesWithStatuses:newStatuses];
        
        //将最新的微博添加到总数组的最前面
        NSRange range = NSMakeRange(0, newFrames.count);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.statusFrames insertObjects:newFrames atIndexes:set];
        
        //刷新表格
        [self.tableView reloadData];
        
        //结束下拉刷新
        [refresh endRefreshing];
        
        //显示最新微博的数量
        [self showNewStatusCount:newStatuses.count];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        Log(@"failure:%@",error.localizedDescription);
        //结束下拉刷新
        [refresh endRefreshing];
    }];
}

/**
 *  加载更多的微博数据
 */
- (void)loadMoreStatus
{
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.拼接请求参数
    WBAccount *account = [WBAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    
    // 取出最后面的微博（最新的微博，ID最大的微博）
    WBStatusFrame *lastStatusF = [self.statusFrames lastObject];
    if (lastStatusF) {
        // 若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
        // id这种数据一般都是比较大的，一般转成整数的话，最好是long long类型
        long long maxId = lastStatusF.status.idstr.longLongValue - 1;
        params[@"max_id"] = @(maxId);
    }
    
    // 3.发送请求
    [mgr GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        // 将 "微博字典"数组 转为 "微博模型"数组
        NSArray *newStatuses = [WBStatus objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        
        //将WBStatus数组转为WBStatusFrame
        NSArray *newFrames = [self statusFramesWithStatuses:newStatuses];
        // 将更多的微博数据，添加到总数组的最后面
        [self.statusFrames addObjectsFromArray:newFrames];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新(隐藏footer)
        self.tableView.tableFooterView.hidden = YES;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        Log(@"请求失败-%@", error);
        
        // 结束刷新
        self.tableView.tableFooterView.hidden = YES;
    }];
}

/**
 *  将WBStatus模型数组转为WBStatusFrame数组
 */
-(NSArray *)statusFramesWithStatuses:(NSArray *)statuses
{
    NSMutableArray *newFrames = [NSMutableArray array];
    for (WBStatus *status in statuses) {
        WBStatusFrame *frame = [[WBStatusFrame alloc]init];
        frame.status = status;
        [newFrames addObject:frame];
    }
    return newFrames;
}


-(void)showNewStatusCount:(NSInteger)count
{
    //0.刷新成功（清空数字提醒）
    self.tabBarItem.badgeValue = nil;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    //1.创建Label
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_new_status_background"]];
    label.width = [UIScreen mainScreen].bounds.size.width;
    label.height = 35;
    
    //2.设置其他属性
    if (count == 0) {
        label.text = @"没有最新的微博数据，稍后再试";
    }else{
        label.text = [NSString stringWithFormat:@"共有%ld条新的微博数据",count];
    }
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    
    //3.添加到视图
    label.y = 64 - label.height;
    [self.navigationController.view insertSubview:label belowSubview:self.navigationController.navigationBar];
    
    //4.动画效果
    CGFloat duration = 1.0;//动画执行的时间
    [UIView animateWithDuration:duration animations:^{
//        label.y += label.height;
        label.transform = CGAffineTransformMakeTranslation(0, label.height);
    } completion:^(BOOL finished) {
        CGFloat delay = 1.0;//停留时间
        //UIViewAnimationOptionCurveLinear:匀速
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
//            label.y -= label.height;
            label.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
        
    }];
    
    // 如果某个动画执行完毕后，又要回到动画执行完毕的状态，建议使用transform
    
}


/**
 *  获取用户信息
 */
-(void)setupUserInfo
{
    //1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    //拼接请求参数
    WBAccount *account = [WBAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;
    
    //发送请求
    [mgr GET:@"https://api.weibo.com/2/users/show.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        Log(@"success:%@",responseObject);
//        NSString *name = responseObject[@"name"];
        WBUser *user = [WBUser objectWithKeyValues:responseObject];
        
        //获取标题按钮
        UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
        
        //设置名称
        [titleButton setTitle:user.name forState:UIControlStateNormal];
        
        //存储昵称到沙盒
        account.name = user.name;
        [WBAccountTool saveAccount:account];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        Log(@"failure:%@",error.localizedDescription);
        
    }];
}

/**
 *  设置导航栏内容
 */
-(void)setupNav
{
    //设置导航栏上面的内容
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(firendSearch) image:@"navigationbar_friendsearch" hightImgae:@"navigationbar_friendsearch_highlighted"];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(pop) image:@"navigationbar_pop" hightImgae:@"navigationbar_pop_highlighted"];
    
    /**中间的标题按钮*/
    TitleButton *titleButton = [[TitleButton alloc]init];
    //设置按钮标题
    NSString *name = [WBAccountTool account].name;
    [titleButton setTitle:name?name:@"首页" forState:UIControlStateNormal];
    //监听标题点击
    [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = titleButton;
}

/**
 *  标题点击
 */
-(void)titleClick:(UIButton *)titleView
{
    //显示下拉菜单
    DropdownMenu *menu = [DropdownMenu menu];
    menu.delegate = self;
    UITableView *tableView=[[UITableView alloc]init];
    tableView.width = 150;
    tableView.height = 200;
    tableView.backgroundColor = [UIColor orangeColor];
    menu.contentView = tableView;
    
    [menu showFrom:titleView];
    
}

-(void)firendSearch
{
    NSLog(@"firendSearch");
}

-(void)pop
{
    NSLog(@"pop");
}


#pragma mark - DropdownMenuDelegate
- (void)dropdownMenuDidDismiss:(DropdownMenu *)dropMenu
{
    UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
    titleButton.selected = NO;
}

- (void)dropdownMenuDidShow:(DropdownMenu *)dropMenu
{
    UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
    //箭头向上
    titleButton.selected = YES;
}


#pragma mark - Table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.statusFrames.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WBStatusCell *cell = [WBStatusCell cellWithTableView:tableView];
    
    cell.statusFrame = self.statusFrames[indexPath.row];
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    //    scrollView == self.tableView == self.view
    // 如果tableView还没有数据，就直接返回
    if (self.statusFrames.count == 0 || self.tableView.tableFooterView.isHidden == NO) return;
    CGFloat offsetY = scrollView.contentOffset.y;
    
    // 当最后一个cell完全显示在眼前时，contentOffset的y值
    CGFloat judgeOffsetY = scrollView.contentSize.height + scrollView.contentInset.bottom - scrollView.height - self.tableView.tableFooterView.height;
    if (offsetY >= judgeOffsetY) { // 最后一个cell完全进入视野范围内
        // 显示footer
        self.tableView.tableFooterView.hidden = NO;
        
        // 加载更多的微博数据
        [self loadMoreStatus];
    }
    
    /*
     contentInset：除具体内容以外的边框尺寸
     contentSize: 里面的具体内容（header、cell、footer），除掉contentInset以外的尺寸
     contentOffset:
     1.它可以用来判断scrollView滚动到什么位置
     2.指scrollView的内容超出了scrollView顶部的距离（除掉contentInset以外的尺寸）
     */

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WBStatusFrame *frame = self.statusFrames[indexPath.row];
    return frame.cellHeight;
}

@end
