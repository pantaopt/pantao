//
//  fristPageViewController.m
//  weibo_myTest
//
//  Created by wkr on 16/3/14.
//  Copyright © 2016年 wkr. All rights reserved.
//

#import "fristPageViewController.h"
#import "VideoCell.h"
#import "WMPlayer.h"
#import "VideoModel.h"
#import "mainTabBarViewController.h"
#import "DetailViewController.h"

#import "cityHeaderView.h"
#import "PickCityViewController.h"

@interface fristPageViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>{
    NSMutableArray *dataSource;
    WMPlayer *wmPlayer;
    NSIndexPath *currentIndexPath;
    BOOL isSmallScreen;
    cityHeaderView *headView;
}

//@property (nonatomic, strong) IQKeyboardReturnKeyHandler *returnKeyHandler;
@property(nonatomic,retain)VideoCell *currentCell;

@end

@implementation fristPageViewController

- (void)dealloc
{
//    self.returnKeyHandler = nil;
    NSLog(@"%@ dealloc",[self class]);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self releaseWMPlayer];
}

//-(void)loadView
//
//{
//    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    
//    self.view = scrollView;
//}

- (instancetype)init
{
    self = [super init];
    if (self) {
        dataSource = [NSMutableArray array];
        isSmallScreen = NO;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //旋转屏幕通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
    [self prepareVisibleCellsForAnimation];
}

-(void)videoDidFinished:(NSNotification *)notice{
    VideoCell *currentCell = (VideoCell *)[self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:currentIndexPath.row inSection:0]];
    [currentCell.playBtn.superview bringSubviewToFront:currentCell.playBtn];
    [wmPlayer removeFromSuperview];
    
}

-(void)closeTheVideo:(NSNotification *)obj{
    VideoCell *currentCell = (VideoCell *)[self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:currentIndexPath.row inSection:0]];
    [currentCell.playBtn.superview bringSubviewToFront:currentCell.playBtn];
    [self releaseWMPlayer];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
    
}

-(void)fullScreenBtnClick:(NSNotification *)notice{
    UIButton *fullScreenBtn = (UIButton *)[notice object];
    if (fullScreenBtn.isSelected) {//全屏显示
        [self toFullScreenWithInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
    }else{
        if (isSmallScreen) {
            //放widow上,小屏显示
            [self toSmallScreen];
        }else{
            [self toCell];
        }
    }
}
/**
 *  旋转屏幕通知
 */
- (void)onDeviceOrientationChange{
    if (wmPlayer==nil||wmPlayer.superview==nil){
        return;
    }
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:{
            NSLog(@"第3个旋转方向---电池栏在下");
        }
            break;
        case UIInterfaceOrientationPortrait:{
            NSLog(@"第0个旋转方向---电池栏在上");
            if (wmPlayer.isFullscreen) {
                if (isSmallScreen) {
                    //放widow上,小屏显示
                    [self toSmallScreen];
                }else{
                    [self toCell];
                }
                
            }
            
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            NSLog(@"第2个旋转方向---电池栏在左");
            if (wmPlayer.isFullscreen == NO) {
                [self toFullScreenWithInterfaceOrientation:interfaceOrientation];
            }
            
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            NSLog(@"第1个旋转方向---电池栏在右");
            if (wmPlayer.isFullscreen == NO) {
                [self toFullScreenWithInterfaceOrientation:interfaceOrientation];
            }
            
        }
            break;
        default:
            break;
    }
}

-(void)toCell{
    VideoCell *currentCell = [self currentCell];
    
    [wmPlayer removeFromSuperview];
    NSLog(@"row = %ld",currentIndexPath.row);
    [UIView animateWithDuration:0.5f animations:^{
        wmPlayer.transform = CGAffineTransformIdentity;
        wmPlayer.frame = currentCell.backgroundIV.bounds;
        wmPlayer.playerLayer.frame =  wmPlayer.bounds;
//        [ptPlayer shareManager].playerLayer.frame =  wmPlayer.bounds;
        [currentCell.backgroundIV addSubview:wmPlayer];
        [currentCell.backgroundIV bringSubviewToFront:wmPlayer];
        [wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer).with.offset(0);
            make.right.equalTo(wmPlayer).with.offset(0);
            make.height.mas_equalTo(40);
            make.bottom.equalTo(wmPlayer).with.offset(0);
            
        }];
        
        [wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(wmPlayer).with.offset(5);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(30);
            make.top.equalTo(wmPlayer).with.offset(5);
            
        }];
        
        
    }completion:^(BOOL finished) {
        wmPlayer.isFullscreen = NO;
        isSmallScreen = NO;
        wmPlayer.fullScreenBtn.selected = NO;
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
        
    }];
    
}

-(void)toFullScreenWithInterfaceOrientation:(UIInterfaceOrientation )interfaceOrientation{
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
    [wmPlayer removeFromSuperview];
    wmPlayer.transform = CGAffineTransformIdentity;
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft) {
        wmPlayer.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }else if(interfaceOrientation==UIInterfaceOrientationLandscapeRight){
        wmPlayer.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    wmPlayer.frame = CGRectMake(0, 0, UISCREENWIDTH, UISCREENHEIGHT);
    wmPlayer.playerLayer.frame =  CGRectMake(0,0, UISCREENHEIGHT,UISCREENWIDTH);
//    [ptPlayer shareManager].playerLayer.frame =  CGRectMake(0,0, UISCREENHEIGHT,UISCREENWIDTH);
    
    [wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(self.view.frame.size.width-40);
        make.width.mas_equalTo(self.view.frame.size.height);
    }];
    
    [wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wmPlayer).with.offset((-self.view.frame.size.height/2));
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
        make.top.equalTo(wmPlayer).with.offset(5);
        
    }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:wmPlayer];
    wmPlayer.isFullscreen = YES;
    wmPlayer.fullScreenBtn.selected = YES;
    [wmPlayer bringSubviewToFront:wmPlayer.bottomView];
    
}
-(void)toSmallScreen{
    //放widow上
    [wmPlayer removeFromSuperview];
    [UIView animateWithDuration:0.5f animations:^{
        wmPlayer.transform = CGAffineTransformIdentity;
        wmPlayer.frame = CGRectMake(UISCREENWIDTH/2,UISCREENHEIGHT-kTabBarHeight-(UISCREENWIDTH/2)*0.75, UISCREENWIDTH/2, (UISCREENWIDTH/2)*0.75);
        wmPlayer.playerLayer.frame =  wmPlayer.bounds;
//        [ptPlayer shareManager].playerLayer.frame =  wmPlayer.bounds;
        [[UIApplication sharedApplication].keyWindow addSubview:wmPlayer];
        [wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer.mas_left).with.offset(0);
            make.right.equalTo(wmPlayer.mas_right).with.offset(0);
            make.height.mas_equalTo(40);
            make.bottom.equalTo(wmPlayer.mas_bottom).with.offset(0);
        }];
        
        [wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer.mas_left).with.offset(5);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(30);
            make.top.equalTo(wmPlayer.mas_top).with.offset(5);
            
        }];
        
    }completion:^(BOOL finished) {
        wmPlayer.isFullscreen = NO;
        wmPlayer.fullScreenBtn.selected = NO;
        isSmallScreen = YES;
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:wmPlayer];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
    }];
    
}

#pragma mark viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor lightGrayColor];
    
//    self.returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
//    self.returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;
//    [IQKeyboardManager sharedManager].toolbarManageBehaviour = IQAutoToolbarBySubviews;
    
    //注册播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoDidFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    //注册播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullScreenBtnClick:) name:@"fullScreenBtnClickNotice" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushCitySelect) name:@"clickedCityBtn" object:nil];
    
    [self creatTableView];
    
    [self isSwitch];
}

#pragma mark UIAlertController
- (void)isSwitch{
    NSString *cName = [[NSUserDefaults standardUserDefaults] objectForKey:kCityButtonClick];
    
    NSString *defaultsName = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentLocation];
    NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
    NSString *otherButtonTitle = NSLocalizedString(@"确认", nil);
    if (![defaultsName isEqualToString:cName]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"我们定位到您当前城市是在%@",defaultsName] message:@"您是否要切换到当前城市" preferredStyle:UIAlertControllerStyleAlert];
        
        // Create the actions.
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            headView.currentCity.text = cName;
        }];
        
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            headView.currentCity.text = defaultsName;
            [[NSUserDefaults standardUserDefaults] setValue:defaultsName forKey:kCityButtonClick];
        }];
        
        // Add the actions.
        [alertController addAction:cancelAction];
        [alertController addAction:otherAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark 跳转到城市的选择
- (void)pushCitySelect{
    PickCityViewController *pickCity = [[PickCityViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pickCity animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark 初始化tableview相关操作
- (void)creatTableView{
    self.table = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.view addSubview:self.table];
    [self.table registerNib:[UINib nibWithNibName:@"VideoCell" bundle:nil] forCellReuseIdentifier:@"VideoCell"];
    [self.table reloadData];
    
    headView = [[cityHeaderView alloc] initWithFrame:CGRectMake(0, 0, UISCREENWIDTH, 70)];
    self.table.tableHeaderView = headView;
    
    //    // 如果出现加载菊花和tableView重复出现的话，就设置FooterView，因为tableView默认对没有数据的列表也会显示cell
    //    self.table.tableFooterView = [UIView new];
    
    // 只需一行代码，我来解放你的代码
    self.table.loading = YES;
    
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
    
    //关闭通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(closeTheVideo:)
                                                 name:@"closeTheVideo"
                                               object:nil
     ];
    
    [self.table yzt_addHeaderWithTarget:self action:@selector(xiala)];
    [self addMJRefresh];
}

- (void)prepareVisibleCellsForAnimation {
    for (int i = 0; i < [self.table.visibleCells count]; i++) {
//        VideoCell * cell = (VideoCell *) [self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        self.table.visibleCells[i].frame = CGRectMake(-CGRectGetWidth(self.table.visibleCells[i].bounds), self.table.visibleCells[i].frame.origin.y, CGRectGetWidth(self.table.visibleCells[i].bounds), CGRectGetHeight(self.table.visibleCells[i].bounds));
        self.table.visibleCells[i].alpha = 0.f;
    }
}

#pragma mark viewDidAppear
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self animateVisibleCells];
}

- (void)animateVisibleCells {
    for (int i = 0; i < [self.table.visibleCells count]; i++) {
//        VideoCell * cell = (VideoCell *) [self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        
        self.table.visibleCells[i].alpha = 1.f;
        [UIView animateWithDuration:0.2f
                              delay:i * 0.1
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.table.visibleCells[i].frame = CGRectMake(0.f, self.table.visibleCells[i].frame.origin.y, CGRectGetWidth(self.table.visibleCells[i].bounds), CGRectGetHeight(self.table.visibleCells[i].bounds));
                         }
                         completion:nil];
    }
}

-(void)loadData{
    [[netWorking sharedManager] getResultWithParameter:nil url:@"http://c.m.163.com/nc/video/home/0-10.html" successBlock:^(id responseBody) {
//        NSLog(@"0 - responseBody %@",responseBody);
        [dataSource addObjectsFromArray:[responseBody objectForKey:@"videoList"]];
        dataSource = [VideoModel parsingWithJSONArr:dataSource];
        self.table.loading = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
           [self.table reloadData];
            [self prepareVisibleCellsForAnimation];
            [self animateVisibleCells];
        });
        
    } failureBlock:^(NSDictionary *error) {
//        NSLog(@"0 - error %@",error);
        self.table.loading = YES;
    }];
}

- (void)xiala
{
    __unsafe_unretained UITableView *tableView = self.table;
    __weak typeof(self) weakSelf = self;
    [tableView yzt_headerBeginRefreshing];
    [[netWorking sharedManager] getResultWithParameter:nil url:@"http://c.m.163.com/nc/video/home/0-10.html" successBlock:^(id responseBody) {
        NSLog(@"1 - responseBody %@",responseBody);
        dataSource =[NSMutableArray arrayWithArray:[responseBody objectForKey:@"videoList"]];
        dataSource = [VideoModel parsingWithJSONArr:dataSource];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (currentIndexPath.row>dataSource.count) {
                [weakSelf releaseWMPlayer];
            }
            [tableView reloadData];
            //刷新成功
            [tableView yzt_headerEndRefreshing];
        });
    } failureBlock:^(NSDictionary *error) {
        //            NSLog(@"1 - error %@",error);
        //刷新失败
        [tableView yzt_headerEndRefreshing];
    }];

}

-(void)addMJRefresh{
    __unsafe_unretained UITableView *tableView = self.table;
//    __weak typeof(self) weakSelf = self;
    // 下拉刷新
//    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [[netWorking sharedManager] getResultWithParameter:nil url:@"http://c.m.163.com/nc/video/home/0-10.html" successBlock:^(id responseBody) {
//            NSLog(@"1 - responseBody %@",responseBody);
//            dataSource =[NSMutableArray arrayWithArray:[responseBody objectForKey:@"videoList"]];
//            dataSource = [VideoModel parsingWithJSONArr:dataSource];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (currentIndexPath.row>dataSource.count) {
//                    [weakSelf releaseWMPlayer];
//                }
//                [tableView reloadData];
//                //刷新成功
//                [tableView.mj_header endRefreshing];
//            });
//        } failureBlock:^(NSDictionary *error) {
//            //            NSLog(@"1 - error %@",error);
//            //刷新失败
//            [tableView.mj_header endRefreshing];
//        }];
//    }];
//    [self.table addRefreshWithBlock:^{
//        
//    }];
    
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSString *URLString = [NSString stringWithFormat:@"http://c.m.163.com/nc/video/home/%ld-10.html",dataSource.count - dataSource.count%10];
        
        [[netWorking sharedManager] getResultWithParameter:nil url:URLString successBlock:^(id responseBody) {
            NSLog(@"2 - responseBody %@",responseBody);
            [dataSource addObjectsFromArray:[responseBody objectForKey:@"videoList"]];
            dataSource = [VideoModel parsingWithJSONArr:dataSource];
            dispatch_async(dispatch_get_main_queue(), ^{
                [tableView reloadData];
                [tableView.mj_footer endRefreshing];
            });

        } failureBlock:^(NSDictionary *error) {
            NSLog(@"2 - error %@",error);
            // 结束刷新
            [tableView.mj_footer endRefreshing];
        }];
    }];
        
    
}

-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 274;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"VideoCell";
    VideoCell *cell = (VideoCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    cell.model = [dataSource objectAtIndex:indexPath.row];
    NSLog(@"%@",cell.model.ptime);
    if (indexPath.row == 0)
    {
        NSLog(@"cell.model.title %@",cell.model);
    }
    
    [cell.playBtn addTarget:self action:@selector(startPlayVideo:) forControlEvents:UIControlEventTouchUpInside];
    cell.playBtn.tag = indexPath.row;
    
    //    model.title
    //    model.descriptionDe
    //    model.cover
    //    model.playCount
    //    model.ptime
    
    if (wmPlayer&&wmPlayer.superview) {
        if (indexPath==currentIndexPath) {
            [cell.playBtn.superview sendSubviewToBack:cell.playBtn];
        }else{
            [cell.playBtn.superview bringSubviewToFront:cell.playBtn];
        }
        NSArray *indexpaths = [tableView indexPathsForVisibleRows];
        if (![indexpaths containsObject:currentIndexPath]) {//复用
            
            if ([[UIApplication sharedApplication].keyWindow.subviews containsObject:wmPlayer]) {
                wmPlayer.hidden = NO;
                
            }else{
                wmPlayer.hidden = YES;
                [cell.playBtn.superview bringSubviewToFront:cell.playBtn];
            }
        }else{
            if ([cell.backgroundIV.subviews containsObject:wmPlayer]) {
                [cell.backgroundIV addSubview:wmPlayer];
                
                [wmPlayer.player play];
//                [[ptPlayer shareManager].player play];
                wmPlayer.playOrPauseBtn.selected = NO;
                wmPlayer.hidden = NO;
            }
            
        }
    }
    
    
    return cell;
}
-(void)startPlayVideo:(UIButton *)sender{
    currentIndexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"currentIndexPath.row = %ld",currentIndexPath.row);
    
    self.currentCell = (VideoCell *)sender.superview.superview;
    VideoModel *model = [dataSource objectAtIndex:sender.tag];
// // ////// 如果是小屏 则移除该小屏在原有位置cell上播放
    
    if (isSmallScreen) {
        [wmPlayer removeFromSuperview];
        isSmallScreen = NO;
        wmPlayer = [[WMPlayer alloc]initWithFrame:self.currentCell.backgroundIV.bounds videoURLStr:model.mp4_url];
        [wmPlayer.player play];
//        [[ptPlayer shareManager].player play];
    }else
    {
        if (wmPlayer) {
            [wmPlayer removeFromSuperview];
            [wmPlayer setVideoURLStr:model.mp4_url];
            [wmPlayer.player play];
//            [[ptPlayer shareManager].player play];
            
        }else{
            wmPlayer = [[WMPlayer alloc]initWithFrame:self.currentCell.backgroundIV.bounds videoURLStr:model.mp4_url];
            [wmPlayer.player play];
//            [[ptPlayer shareManager].player play];
        }
    }
    
    [self.currentCell.backgroundIV addSubview:wmPlayer];
    [self.currentCell.backgroundIV bringSubviewToFront:wmPlayer];
    [self.currentCell.playBtn.superview sendSubviewToBack:self.currentCell.playBtn];
    [self.table reloadData];
    
}
#pragma mark scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView ==self.table){
        if (wmPlayer==nil) {
            return;
        }
        
        if (wmPlayer.superview) {
            CGRect rectInTableView = [self.table rectForRowAtIndexPath:currentIndexPath];
            CGRect rectInSuperview = [self.table convertRect:rectInTableView toView:[self.table superview]];
            
            NSLog(@"rectInSuperview = %@",NSStringFromCGRect(rectInSuperview));
            
            
            
            if (rectInSuperview.origin.y<-self.currentCell.backgroundIV.frame.size.height||rectInSuperview.origin.y>self.view.frame.size.height-kNavbarHeight-kTabBarHeight) {//往上拖动
                
                if ([[UIApplication sharedApplication].keyWindow.subviews containsObject:wmPlayer]&&isSmallScreen) {
                    isSmallScreen = YES;
                }else{
                    //放widow上,小屏显示
                    [self toSmallScreen];
                }
                
                
                
            }else{
                if ([self.currentCell.backgroundIV.subviews containsObject:wmPlayer]) {
                    
                }else{
                    [self toCell];
                }
            }
        }
        
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VideoModel *   model = [dataSource objectAtIndex:indexPath.row];
    
    DetailViewController *detailVC = [[DetailViewController alloc]init];
    detailVC.URLString  = model.m3u8_url;
    detailVC.title = model.title;
        detailVC.URLString = model.mp4_url;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}
-(void)releaseWMPlayer{
    [wmPlayer.player.currentItem cancelPendingSeeks];
    [wmPlayer.player.currentItem.asset cancelLoading];
//    [[ptPlayer shareManager].player.currentItem cancelPendingSeeks];
//    [[ptPlayer shareManager].player.currentItem.asset cancelLoading];
    
    [wmPlayer.player pause];
//    [[ptPlayer shareManager].player pause];
    [wmPlayer removeFromSuperview];
    [wmPlayer.playerLayer removeFromSuperlayer];
//    [[ptPlayer shareManager].playerLayer removeFromSuperlayer];
    [wmPlayer.player replaceCurrentItemWithPlayerItem:nil];
//    [[ptPlayer shareManager].player replaceCurrentItemWithPlayerItem:nil];
    wmPlayer = nil;
    wmPlayer.player = nil;
//    [ptPlayer shareManager].player = nil;
    wmPlayer.currentItem = nil;
//    [ptPlayer shareManager].currentItem = nil;
    
    wmPlayer.playOrPauseBtn = nil;
    wmPlayer.playerLayer = nil;
    currentIndexPath = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}




@end
