//
//  ptPlayer.h
//  pantao
//
//  Created by wkr on 16/5/11.
//  Copyright © 2016年 pantao. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MediaPlayer;
@import AVFoundation;

@interface ptPlayer : NSObject

+(ptPlayer *)shareManager;

@property(nonatomic,retain)AVPlayer *player;
/**
 *playerLayer,可以修改frame
 */
@property(nonatomic,retain)AVPlayerLayer *playerLayer;
/* playItem */
@property (nonatomic, retain) AVPlayerItem *currentItem;
/**
 *  初始化WMPlayer的方法
 *
 *  @param frame       frame
 *  @param videoURLStr URL字符串，包括网络的和本地的URL
 *
 *  @return id类型，实际上就是WMPlayer的一个对象
 */
- (void)videoURLStr:(NSString *)videoURLStr :(CALayer *)layer;

-(AVPlayerItem *)getPlayItemWithURLString:(NSString *)urlString;

-(void)toNil;

@end
