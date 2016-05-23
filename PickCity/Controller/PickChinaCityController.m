//
//  PickChinaCityController.m
//  DoubanWorlds
//
//  Created by LYoung on 15/12/28.
//  Copyright © 2015年 LYoung. All rights reserved.
//

#import "PickChinaCityController.h"
#import "YLYTableViewIndexView.h"
#import "SectionHeaderView.h"
#import "HotCityCell.h"
#import "LYCityHandler.h"
#import "LocationCityCell.h"

#import "CityIndexCell.h"
@interface PickChinaCityController ()<YLYTableViewIndexDelegate>

@property (nonatomic, strong) NSMutableArray *sectionArray;
@property (nonatomic, strong) NSMutableArray *allIndexArray;
@property (nonatomic, strong) NSMutableArray *twoCityArray;

@property (nonatomic, strong) NSDictionary *citiesDic;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *flotageLabel;//显示视图

@end

@implementation PickChinaCityController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.sectionArray = [NSMutableArray arrayWithCapacity:1];
        self.allIndexArray = [NSMutableArray arrayWithCapacity:1];
        self.twoCityArray = [NSMutableArray arrayWithCapacity:1];
        self.citiesDic = [[NSDictionary alloc] init];
        
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.flotageLabel.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initTableView];
    
    //国内数据
    [self requestChinaData];
    
    [self initIndexView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityButtonClick:) name:kCityButtonClick object:nil];
}

#pragma mark - 城市按钮点击
-(void)cityButtonClick:(NSNotification *)note{
    NSString *cname = note.userInfo[kCityButtonClick];
    if (cname) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma - 国内数据
- (void)requestChinaData{
    
    [_twoCityArray addObjectsFromArray:@[@"当前城市",@"热门城市"]];
    
    
    //1.所有分区对应的字典
    NSString *inlandPlistURL = [[NSBundle mainBundle] pathForResource:@"inLandCityGroup" ofType:@"plist"];
    NSDictionary *cityGroupDic = [[NSDictionary alloc] initWithContentsOfFile:inlandPlistURL];
    //2.所有分区
    NSArray *sections = [cityGroupDic allKeys];
    sections = [sections sortedArrayUsingSelector:@selector(compare:)]; // 对该数组里边的元素进行升序排序
    //3.所有城市
    NSArray *indexs = [cityGroupDic allValues];

    _citiesDic = [cityGroupDic copy];
    _sectionArray = [sections copy];
    _allIndexArray = [indexs copy];
}

- (void)initTableView{
    self.view.backgroundColor = [UIColor whiteColor];

    _tableView                 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UISCREENWIDTH, UISCREENHEIGHT - 64 -44*aspect)];
    _tableView.delegate        = (id<UITableViewDelegate>)self;
    _tableView.dataSource      = (id<UITableViewDataSource>) self;
    _tableView.backgroundColor = KBackgroundColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
}

- (void)initIndexView{
    self.flotageLabel = [[UILabel alloc] init];
    self.flotageLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"flotageBackgroud"]];
    self.flotageLabel.hidden = YES;
    self.flotageLabel.textAlignment = NSTextAlignmentCenter;
    self.flotageLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.flotageLabel];
    [self.flotageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(64, 64));
    }];
    
    YLYTableViewIndexView *indexView = [[YLYTableViewIndexView alloc] initWithFrame:(CGRect){UISCREENWIDTH - 20,0,20,UISCREENHEIGHT}];
    indexView.tableViewIndexDelegate = self;
    [self.view addSubview:indexView];
    
    CGRect rect = indexView.frame;
    rect.size.height = _sectionArray.count * 16;
    rect.origin.y = (UISCREENHEIGHT - 64 - rect.size.height) / 2;
    indexView.frame = rect;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _allIndexArray.count + 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    SectionHeaderView *headerView = [[SectionHeaderView alloc] init];
    if (section <= 1) {
        headerView.text = [_twoCityArray objectAtIndex:section];
    }else{
        headerView.text = [_sectionArray objectAtIndex:section - 2];
    }
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [SectionHeaderView getSectionHeadHeight];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // 返回cell条数
    if (section <= 1) {
        return 1;
    }else{
        return [LYCityHandler getOneSectionCountWithSectionArr:_sectionArray cityDict:_citiesDic section:section - 2];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 44;
    }else if(indexPath.section == 1){
        return [HotCityCell getCellHeight];
    }else{
        return [CityIndexCell getCellHeight];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        LocationCityCell *cell = [LocationCityCell cellWithTableView:tableView];
        return cell;
    }else if(indexPath.section == 1){
        HotCityCell *cell = [HotCityCell cellWithTableView:tableView];
        return cell;
    }else{
        CityIndexCell *cell = [CityIndexCell cellWithTableView:tableView];
        NSString *objKey = [LYCityHandler getCNCityNameWithSectionArr:_sectionArray cityDict:_citiesDic indexPath:indexPath];
        cell.cityName = objKey;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section <= 1) {
        
    }else{
        NSString *objValue = [LYCityHandler getCNCityIDWithSectionArr:_sectionArray cityDict:_citiesDic indexPath:indexPath];
        NSString *objKey = [LYCityHandler getCNCityNameWithSectionArr:_sectionArray cityDict:_citiesDic indexPath:indexPath];
        NSLog(@"---------选择的城市name =%@ ,ID = %@",objKey,objValue);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kCityButtonClick object:nil userInfo:@{kCityButtonClick : objKey}];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark -YLYTableViewIndexDelegate
- (void)tableViewIndex:(YLYTableViewIndexView *)tableViewIndex didSelectSectionAtIndex:(NSInteger)index withTitle:(NSString *)title{
    if ([_tableView numberOfSections] > index && index > -1){   // for safety, should always be YES
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index + 2]
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:NO];
        self.flotageLabel.text = title;
    }
}
- (void)tableViewIndexTouchesBegan:(YLYTableViewIndexView *)tableViewIndex{
    self.flotageLabel.hidden = NO;
}
- (void)tableViewIndexTouchesEnd:(YLYTableViewIndexView *)tableViewIndex{
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = 0.4;
    [self.flotageLabel.layer addAnimation:animation forKey:nil];
    self.flotageLabel.hidden = YES;
}
- (NSArray *)tableViewIndexTitle:(YLYTableViewIndexView *)tableViewIndex{
    return _sectionArray;
}

@end
