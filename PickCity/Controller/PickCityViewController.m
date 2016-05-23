//
//  PickCityViewController.m
//  DoubanWorlds
//
//  Created by LYoung on 15/12/25.
//  Copyright © 2015年 LYoung. All rights reserved.
//

#import "PickCityViewController.h"
#import "PickOverseasController.h"
#import "PickChinaCityController.h"
#import "SearchCityController.h"

@interface PickCityViewController ()


@property (nonatomic, strong) PickChinaCityController *chinaVC;
@property (nonatomic, strong) PickOverseasController *overseasVC;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (nonatomic, strong) UIScrollView *backgroundScrollView;

@end

@implementation PickCityViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadSegmentedControl];
    
    [self loadControllers];
    
    [self loadScrollView];
    
    self.navigationItem.rightBarButtonItem = nil;
    
        
    UISearchBar *mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, UISCREENWIDTH, 44*aspect)];
    mySearchBar.placeholder = @"输入城市名查询";
    mySearchBar.userInteractionEnabled = YES;
    mySearchBar.backgroundImage = [UIImage imageNamed:@"searchBarBackImage"];
    
    UITextField *txfSearchField = [mySearchBar valueForKey:@"_searchField"];
    txfSearchField.backgroundColor = KBackgroundColor;
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, UISCREENWIDTH, 44*aspect);
    [btn addTarget:self action:@selector(pushSearchViewController) forControlEvents:UIControlEventTouchUpInside];
    [mySearchBar addSubview:btn];
    [self.view addSubview:mySearchBar];

    
}

- (void)pushSearchViewController{
    SearchCityController *searchVC = [[SearchCityController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchVC];
    nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;    // 设置动画效果
    
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}


- (void)loadSegmentedControl{
    self.view.backgroundColor = [UIColor whiteColor];

    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"国内",@"国外",nil];
    _segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    _segmentedControl.frame = CGRectMake(0,0,180,30);
    _segmentedControl.tintColor = [UIColor whiteColor];
    [_segmentedControl setSelectedSegmentIndex:0];
    [_segmentedControl addTarget:self action:@selector(segmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _segmentedControl;
}

- (void)segmentedControlAction:(id)sender{
    NSInteger selectedIndex = [sender selectedSegmentIndex];
    
    [self.backgroundScrollView setContentOffset:CGPointMake(UISCREENWIDTH*selectedIndex, 0) animated:NO];

}

- (void)loadControllers{
    
    _viewControllers = [[NSMutableArray alloc] init];
    
    _chinaVC = [[PickChinaCityController alloc] init];
    _overseasVC = [[PickOverseasController alloc] init];
    
    [self addChildViewController:_chinaVC];
    [self addChildViewController:_overseasVC];

    _viewControllers = [NSMutableArray arrayWithObjects:_chinaVC,_overseasVC,nil];
    
}

- (void)loadScrollView{
    
    NSInteger viewCounts = _viewControllers.count;
    
    //初始化最底部的scrollView,装tableView用
    self.backgroundScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.backgroundScrollView.backgroundColor = [UIColor whiteColor];
    self.backgroundScrollView.pagingEnabled = YES;
    self.backgroundScrollView.bounces = NO;
    self.backgroundScrollView.showsHorizontalScrollIndicator = NO;
    self.backgroundScrollView.delegate = (id<UIScrollViewDelegate>)self;
    self.backgroundScrollView.contentSize = CGSizeMake(UISCREENWIDTH * viewCounts, 0);
    [self.view addSubview:self.backgroundScrollView];
    
    
    for (int i = 0; i < viewCounts; i++) {
        UIViewController *listCtrl = self.viewControllers[i];
        listCtrl.view.frame = CGRectMake(UISCREENWIDTH*i, 44*aspect, UISCREENWIDTH, UISCREENHEIGHT);
        [self.backgroundScrollView addSubview:listCtrl.view];
    }
    
    [self.backgroundScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger pageIndex = (NSInteger)scrollView.contentOffset.x/UISCREENWIDTH;
    [_segmentedControl setSelectedSegmentIndex:pageIndex];
}





@end
