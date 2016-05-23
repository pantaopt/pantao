//
//  ptPlayer.m
//  pantao
//
//  Created by wkr on 16/5/11.
//  Copyright © 2016年 pantao. All rights reserved.
//

#import "ptPlayer.h"

@implementation ptPlayer

+(ptPlayer *)shareManager
{
    static ptPlayer *sharePlayer = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        sharePlayer = [[self alloc]init];
    });
    return sharePlayer;
}

- (void)videoURLStr:(NSString *)videoURLStr :(CALayer *)layer
{
    self.currentItem = [self getPlayItemWithURLString:videoURLStr];
    //AVPlayer
    self.player = [AVPlayer playerWithPlayerItem:self.currentItem];
    //AVPlayerLayer
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.frame = layer.bounds;
    [layer addSublayer:_playerLayer];
}

-(AVPlayerItem *)getPlayItemWithURLString:(NSString *)urlString{
    if ([urlString containsString:@"http"]) {
        AVPlayerItem *playerItem=[AVPlayerItem playerItemWithURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        return playerItem;
    }else{
        AVAsset *movieAsset  = [[AVURLAsset alloc]initWithURL:[NSURL fileURLWithPath:urlString] options:nil];
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
        return playerItem;
    }
    
}

-(void)toNil
{
    [self.player pause];
    self.player = nil;
    self.currentItem = nil;
    [self.playerLayer removeFromSuperlayer];
}

@end
