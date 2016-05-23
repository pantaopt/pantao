//
//  messageViewController.m
//  weibo_myTest
//
//  Created by wkr on 16/3/14.
//  Copyright © 2016年 wkr. All rights reserved.
//

/**
 *  高德地图sdk比apple官方api多一些接口：1.封装了自定义大头针方法，2.可以单次定位，apple只有调用startUpdatingLocation进行持续定位
 *
 *  @return 因此高德地图sdk比apple官方api更好用更精确
 */


#import "secondViewController.h"
//#import <AMapSearchKit/AMapSearchKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

@interface secondViewController ()<MAMapViewDelegate,AMapLocationManagerDelegate>
{
    MAMapView *_mapView;
    CLLocationCoordinate2D centerCoordinate;
}

@property (nonatomic, strong)AMapLocationManager *locationManager;

@end

@implementation secondViewController

- (void)viewDidLoad {
//    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    //配置用户Key
    [MAMapServices sharedServices].apiKey = @"72319abc89aa5e2ba3fe7f1f6b04c8c1";
    
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;// YES是开启位置更新立即定位
    _mapView.zoomLevel = 16;
    //    _mapView.customizeUserLocationAccuracyCircleRepresentation = YES;
    [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES]; //地图跟着位置移动
    [self.view addSubview:_mapView];
    
    [AMapLocationServices sharedServices].apiKey =@"72319abc89aa5e2ba3fe7f1f6b04c8c1";
    self.locationManager = [[AMapLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    
    UIButton *updateLocationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    updateLocationBtn.frame = CGRectMake(10*aspect, 10*aspect, 30*aspect, 30*aspect);
    updateLocationBtn.layer.cornerRadius = 15*aspect;
    [_mapView addSubview:updateLocationBtn];
    updateLocationBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [updateLocationBtn addTarget:self action:@selector(updateLocation) forControlEvents:UIControlEventTouchUpInside];
}

/**
 *  更新位置
 */
- (void)updateLocation
{
    _mapView.centerCoordinate = centerCoordinate;
    [self locateAction];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //    [self updateLocation];
}

#pragma mark --MAMapView
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        //取出当前位置的坐标
        //        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        centerCoordinate = userLocation.coordinate;
    }
}

#pragma mark --AMapLocationManager
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    //定位错误
    NSLog(@"%s, amapLocationManager = %@, error = %@", __func__, [manager class], error);
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    //定位结果
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
}

- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    [self.locationManager setLocationTimeout:6];
    [self.locationManager setReGeocodeTimeout:3];
}

- (void)locateAction
{
    //带逆地理的单次定位
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        
        //定位信息
        NSLog(@"location:%@", location);
        
        //逆地理信息
        if (regeocode)
        {
            NSLog(@"reGeocode:%@", regeocode);
        }
    }];
}

//- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
//{
//    /* 自定义定位精度对应的MACircleView. */
////    if (overlay == mapView.userLocationAccuracyCircle)
////    {
//        MACircleRenderer *accuracyCircleRenderer = [[MACircleRenderer alloc] initWithCircle:overlay];
//
//        accuracyCircleRenderer.lineWidth    = 2.f;
//        accuracyCircleRenderer.strokeColor  = [UIColor lightGrayColor];
//        accuracyCircleRenderer.fillColor    = [UIColor colorWithRed:1 green:0 blue:0 alpha:.3];
//
//        return accuracyCircleRenderer;
////    }
//
//    return nil;
//}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    /* 自定义userLocation对应的annotationView. */
    if ([annotation isKindOfClass:[MAUserLocation class]])
    {
        static NSString *userLocationStyleReuseIndetifier = @"userLocationStyleReuseIndetifier";
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:userLocationStyleReuseIndetifier];
        }
        UIImage *image = [UIImage imageNamed:@"QQ"];
        
        annotationView.image = [self image:image scaledToSize:CGSizeMake(30, 30)];
        
        return annotationView;
    }
    return nil;
}



//压缩图片
- (UIImage *)image:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}

@end
