//
//  FullscreenViewController.m
//  damei
//
//  Created by ivan zhang on 2019/9/26.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "FullscreenViewController.h"

@interface FullscreenViewController () <BUNativeExpressFullscreenVideoAdDelegate>

@property (nonatomic, strong) BUNativeExpressFullscreenVideoAd *fullscreenVideoAd;

@end

@implementation FullscreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fullscreenVideoAd = [AdBoss getFullScreenAd];
    
    //ad 无缓存？
    self.fullscreenVideoAd.delegate = self;
    [self.fullscreenVideoAd loadAdData];
    
    //    [self.fullscreenVideoAd showAdFromRootViewController:self];
}

#pragma mark BUFullscreenVideoAdDelegate


- (void)nativeExpressFullscreenVideoAdDidLoad:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {
    BUD_Log(@"%s 全屏视频",__func__);
    //express只有渲染成功时才可以show
    [FullScreenVideo emitEvent: @{@"type": @"onAdLoaded", @"message": @"success"}];
}

- (void)nativeExpressFullscreenVideoAd:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd didFailWithError:(NSError *_Nullable)error {
    BUD_Log(@"%s 全屏视频",__func__);
    NSLog(@"error code : %ld , error message : %@",(long)error.code,error.description);
    [FullScreenVideo emitEvent: @{@"type": @"onAdError", @"message": @""}];
}

- (void)nativeExpressFullscreenVideoAdViewRenderSuccess:(BUNativeExpressFullscreenVideoAd *)rewardedVideoAd {
    BUD_Log(@"%s 全屏视频 渲染成功....",__func__);
    [self.fullscreenVideoAd showAdFromRootViewController:self];
}

- (void)nativeExpressFullscreenVideoAdViewRenderFail:(BUNativeExpressFullscreenVideoAd *)rewardedVideoAd error:(NSError *_Nullable)error {
    
    BUD_Log(@"%s 全屏视频",__func__);
}

- (void)nativeExpressFullscreenVideoAdDidDownLoadVideo:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {
    
    BUD_Log(@"%s 全屏视频",__func__);
}

- (void)nativeExpressFullscreenVideoAdWillVisible:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {
    BUD_Log(@"%s 全屏视频",__func__);
}

- (void)nativeExpressFullscreenVideoAdDidVisible:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {
    BUD_Log(@"%s 全屏视频",__func__);
}

- (void)nativeExpressFullscreenVideoAdDidClick:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {
    BUD_Log(@"%s",__func__);
    [FullScreenVideo emitEvent: @{@"type": @"onAdClicked", @"message": @""}];
}

- (void)nativeExpressFullscreenVideoAdDidClickSkip:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {
    BUD_Log(@"%s",__func__);
}

- (void)nativeExpressFullscreenVideoAdWillClose:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {
    BUD_Log(@"%s",__func__);
}

- (void)nativeExpressFullscreenVideoAdDidClose:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {
    BUD_Log(@"%s",__func__);
    [FullScreenVideo emitEvent: @{@"type": @"onAdClose", @"message": @""}];
    
    //完成播放 关闭广告 拿回promise结果
    [[AdBoss getRootVC] dismissViewControllerAnimated:true completion:^{
        if([AdBoss getRewardVideoClicks] > 0)
        {
            //每次返回rn后清空激励视频点击次数
            [AdBoss resetClickRewardVideo];
            
            [AdBoss getResolve](@{
                @"video_play":@1,
                @"ad_click":@1, //点击
                @"ad_skip":@1
            });
        }else{
            [AdBoss getResolve](@{
                @"video_play":@1,
                @"ad_click":@0, //没有点击
                @"ad_skip":@1
            });
        }
    }];
}

- (void)nativeExpressFullscreenVideoAdDidPlayFinish:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd didFailWithError:(NSError *_Nullable)error {
    BUD_Log(@"%s",__func__);
}

- (void)nativeExpressFullscreenVideoAdCallback:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd withType:(BUNativeExpressFullScreenAdType) nativeExpressVideoAdType{
    BUD_Log(@"%s",__func__);
}

- (void)nativeExpressFullscreenVideoAdDidCloseOtherController:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd interactionType:(BUInteractionType)interactionType {
    NSString *str = nil;
    if (interactionType == BUInteractionTypePage) {
        str = @"ladingpage";
    } else if (interactionType == BUInteractionTypeVideoAdDetail) {
        str = @"videoDetail";
    } else {
        str = @"appstoreInApp";
    }
    BUD_Log(@"%s __ %@",__func__,str);
}



@end