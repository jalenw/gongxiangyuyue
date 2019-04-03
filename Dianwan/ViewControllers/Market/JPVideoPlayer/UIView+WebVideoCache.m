/*
 * This file is part of the JPVideoPlayer package.
 * (c) NewPan <13246884282@163.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 *
 * Click https://github.com/newyjp
 * or http://www.jianshu.com/users/e2f2d779c022/latest_articles to contact me.
 */

#import "UIView+WebVideoCache.h"
#import <objc/runtime.h>
#import "JPVideoPlayer.h"
#import "JPVideoPlayerSupportUtils.h"
#import "JPVideoPlayerControlViews.h"

@interface JPVideoPlayerView (JPVideoPlayerHelper)

@property(nonatomic, assign) JPVideoPlayerOrientation orientation;

@end

@interface JPVideoPlayerHelper : NSObject

@property(nonatomic, strong) JPVideoPlayerView *videoPlayerView;

@property(nonatomic, strong) UIView<JPVideoPlayerProtocol> *progressView;

@property(nonatomic, strong) UIView<JPVideoPlayerProtocol> *controlView;

@property(nonatomic, strong) UIView<JPVideoPlayerBufferingProtocol> *bufferingIndicator;

@property(nonatomic, weak) id<JPVideoPlayerDelegate> videoPlayerDelegate;

@property(nonatomic, assign) JPVideoPlayerOrientation orientation;

@property(nonatomic, assign)JPVideoPlayerStatus playerStatus;

@property (nonatomic, weak) UIView *playVideoView;

@property(nonatomic, copy) NSURL *videoURL;

@property (nonatomic) NSTimeInterval resizeVideoViewAnimationTimeInterval;

@end

@implementation JPVideoPlayerHelper

- (instancetype)initWithPlayVideoView:(UIView *)playVideoView {
    self = [super init];
    if(self){
        _playVideoView = playVideoView;
        _orientation = JPVideoPlayerOrientationUnknown;
        _resizeVideoViewAnimationTimeInterval = 0.25;
    }
    return self;
}

- (JPVideoPlayerView *)videoPlayerView {
    if(!_videoPlayerView){
        BOOL autoHide = YES;
        if (_playVideoView.jp_videoPlayerDelegate && [_playVideoView.jp_videoPlayerDelegate respondsToSelector:@selector(shouldAutoHideControlContainerViewWhenUserTapping)]) {
            autoHide = [_playVideoView.jp_videoPlayerDelegate shouldAutoHideControlContainerViewWhenUserTapping];
        }
        _videoPlayerView = [[JPVideoPlayerView alloc] initWithNeedAutoHideControlViewWhenUserTapping:autoHide];
    }
    return _videoPlayerView;
}

- (void)setOrientation:(JPVideoPlayerOrientation)orientation {
    _orientation = orientation;
    self.videoPlayerView.orientation = orientation;
}

@end

@interface _JPVideoPlayerVideoViewResizingObject : NSObject

@property(nonatomic, assign, readonly) BOOL fromPortraitToLandscape;

@property(nonatomic, assign, readonly) BOOL fromLandscapeToPortrait;

@property(nonatomic, assign, readonly) BOOL fromLandscapeToLandscape;

@end

@implementation _JPVideoPlayerVideoViewResizingObject

- (instancetype)initWithFromOrientation:(JPVideoPlayerOrientation)fromOrientation
                          toOrientation:(JPVideoPlayerOrientation)toOrientation {
    self = [super init];
    if (self) {
        /// from portrait to landscape.
        _fromPortraitToLandscape = (fromOrientation == JPVideoPlayerOrientationPortrait || fromOrientation == JPVideoPlayerOrientationUnknown) &&
                (toOrientation == JPVideoPlayerOrientationLandscapeLeft || toOrientation == JPVideoPlayerOrientationLandscapeRight);
        _fromLandscapeToPortrait = (fromOrientation == JPVideoPlayerOrientationLandscapeLeft || fromOrientation == JPVideoPlayerOrientationLandscapeRight) &&
                (toOrientation == JPVideoPlayerOrientationPortrait);
        _fromLandscapeToLandscape = (fromOrientation == JPVideoPlayerOrientationLandscapeLeft || fromOrientation == JPVideoPlayerOrientationLandscapeRight) &&
                (toOrientation == JPVideoPlayerOrientationLandscapeLeft || toOrientation == JPVideoPlayerOrientationLandscapeRight);
    }
    return self;
}

@end

@interface UIView()

@property(nonatomic, readonly) JPVideoPlayerHelper *jpVideoPlayerHelper;

@end

NSString *const JPVideoPlayerWillResizeVideoViewToFitDeviceOrientationNotification = @"com.jpvideoplayer.will.resize.videoview.when.deviceorientation.changed.www";
NSString *const JPVideoPlayerDidResizeVideoViewToFitDeviceOrientationNotification = @"com.jpvideoplayer.did.resize.videoview.when.deviceorientation.changed.www";
@implementation UIView (WebVideoCache)

#pragma mark - Properties

- (JPVideoPlayerOrientation)jp_orientation {
    return self.jpVideoPlayerHelper.orientation;
}

- (JPVideoPlayerStatus)jp_playerStatus {
    return self.jpVideoPlayerHelper.playerStatus;
}

- (JPVideoPlayerView *)jp_videoPlayerView {
    return self.jpVideoPlayerHelper.videoPlayerView;
}

- (void)setJp_progressView:(UIView <JPVideoPlayerProtocol> *)jp_progressView {
    self.jpVideoPlayerHelper.progressView = jp_progressView;
}

- (UIView <JPVideoPlayerProtocol> *)jp_progressView {
    return self.jpVideoPlayerHelper.progressView;
}

- (void)setJp_controlView:(UIView <JPVideoPlayerProtocol> *)jp_controlView {
    self.jpVideoPlayerHelper.controlView = jp_controlView;
}

- (UIView <JPVideoPlayerProtocol> *)jp_controlView {
    return self.jpVideoPlayerHelper.controlView;
}

- (void)setJp_bufferingIndicator:(UIView <JPVideoPlayerBufferingProtocol> *)jp_bufferingIndicator {
    self.jpVideoPlayerHelper.bufferingIndicator = jp_bufferingIndicator;
}

- (UIView <JPVideoPlayerBufferingProtocol> *)jp_bufferingIndicator {
    return self.jpVideoPlayerHelper.bufferingIndicator;
}

- (void)setJp_videoPlayerDelegate:(id <JPVideoPlayerDelegate>)jp_videoPlayerDelegate {
    self.jpVideoPlayerHelper.videoPlayerDelegate = jp_videoPlayerDelegate;
}

- (id <JPVideoPlayerDelegate>)jp_videoPlayerDelegate {
    return self.jpVideoPlayerHelper.videoPlayerDelegate;
}

- (NSURL *)jp_videoURL {
    return self.jpVideoPlayerHelper.videoURL;
}

- (void)setJp_videoURL:(NSURL *)jp_videoURL {
    self.jpVideoPlayerHelper.videoURL = jp_videoURL.copy;
}

- (void)setJp_periodicTimeObserverInterval:(CMTime)jp_periodicTimeObserverInterval {
    NSParameterAssert(CMTIME_IS_VALID(jp_periodicTimeObserverInterval));
    if (!CMTIME_IS_VALID(jp_periodicTimeObserverInterval)) return;
    JPVideoPlayerManager.sharedManager.periodicTimeObserverInterval = jp_periodicTimeObserverInterval;
}

- (CMTime)jp_periodicTimeObserverInterval {
    return JPVideoPlayerManager.sharedManager.periodicTimeObserverInterval;
}


#pragma mark - Play Video Methods

- (void)jp_playVideoWithURL:(NSURL *)url {
    [self jp_playVideoWithURL:url
                      options:JPVideoPlayerContinueInBackground |
                              JPVideoPlayerLayerVideoGravityResizeAspect
                configuration:nil];
}

- (void)jp_playVideoMuteWithURL:(NSURL *)url
             bufferingIndicator:(UIView <JPVideoPlayerBufferingProtocol> *_Nullable)bufferingIndicator
                   progressView:(UIView <JPVideoPlayerProtocol> *_Nullable)progressView
                  configuration:(JPPlayVideoConfiguration _Nullable)configuration {
    [self setBufferingIndicator:bufferingIndicator
                    controlView:nil
                   progressView:progressView
             needSetControlView:NO];
    [self jp_stopPlay];
    [self jp_playVideoWithURL:url
                      options:JPVideoPlayerContinueInBackground |
                              JPVideoPlayerLayerVideoGravityResizeAspect |
                              JPVideoPlayerMutedPlay
                configuration:configuration];
}

- (void)jp_resumeMutePlayWithURL:(NSURL *)url
              bufferingIndicator:(UIView <JPVideoPlayerBufferingProtocol> *_Nullable)bufferingIndicator
                    progressView:(UIView <JPVideoPlayerProtocol> *_Nullable)progressView
                   configuration:(JPPlayVideoConfiguration _Nullable)configuration {
    [self setBufferingIndicator:bufferingIndicator
                    controlView:nil
                   progressView:progressView
             needSetControlView:NO];
    [self jp_resumePlayWithURL:url
                       options:JPVideoPlayerContinueInBackground |
                               JPVideoPlayerLayerVideoGravityResizeAspect |
                               JPVideoPlayerMutedPlay
                 configuration:configuration];
}

- (void)jp_playVideoWithURL:(NSURL *)url
         bufferingIndicator:(UIView <JPVideoPlayerBufferingProtocol> *_Nullable)bufferingIndicator
                controlView:(UIView <JPVideoPlayerProtocol> *_Nullable)controlView
               progressView:(UIView <JPVideoPlayerProtocol> *_Nullable)progressView
              configuration:(JPPlayVideoConfiguration _Nullable)configuration {
    [self setBufferingIndicator:bufferingIndicator
                    controlView:controlView
                   progressView:progressView
             needSetControlView:YES];
    [self jp_stopPlay];
    [self jp_playVideoWithURL:url
                      options:JPVideoPlayerContinueInBackground |
                              JPVideoPlayerLayerVideoGravityResizeAspect
                configuration:configuration];
}

- (void)jp_resumePlayWithURL:(NSURL *)url
          bufferingIndicator:(UIView <JPVideoPlayerBufferingProtocol> *_Nullable)bufferingIndicator
                 controlView:(UIView <JPVideoPlayerProtocol> *_Nullable)controlView
                progressView:(UIView <JPVideoPlayerProtocol> *_Nullable)progressView
               configuration:(JPPlayVideoConfiguration _Nullable)configuration {
    [self setBufferingIndicator:bufferingIndicator
                    controlView:controlView
                   progressView:progressView
             needSetControlView:YES];
    [self jp_resumePlayWithURL:url
                       options:JPVideoPlayerContinueInBackground |
                               JPVideoPlayerLayerVideoGravityResizeAspect
                 configuration:configuration];
}

- (void)setBufferingIndicator:(UIView <JPVideoPlayerBufferingProtocol> *_Nullable)bufferingIndicator
                  controlView:(UIView <JPVideoPlayerProtocol> *_Nullable)controlView
                 progressView:(UIView <JPVideoPlayerProtocol> *_Nullable)progressView
           needSetControlView:(BOOL)needSetControlView {
    @autoreleasepool {
        // should show default.
        BOOL showDefaultView = YES;
        if (self.jp_videoPlayerDelegate && [self.jp_videoPlayerDelegate respondsToSelector:@selector(shouldShowDefaultControlAndIndicatorViews)]) {
            showDefaultView = [self.jp_videoPlayerDelegate shouldShowDefaultControlAndIndicatorViews];
        }
        // user update progressView.
        if(progressView && self.jp_progressView){
            [self.jp_progressView removeFromSuperview];
        }
        if(showDefaultView && !progressView && !self.jp_progressView){
            // Use default `JPVideoPlayerProgressView` if no progressView.
            progressView = [JPVideoPlayerProgressView new];
        }
        if(progressView){
            self.jp_progressView = progressView;
        }

        // user update bufferingIndicator.
        if(bufferingIndicator && self.jp_bufferingIndicator){
            [self.jp_bufferingIndicator removeFromSuperview];
        }
        if(showDefaultView && !bufferingIndicator && !self.jp_bufferingIndicator){
            // Use default `JPVideoPlayerBufferingIndicator` if no bufferingIndicator.
            bufferingIndicator = [JPVideoPlayerBufferingIndicator new];
        }
        if(bufferingIndicator){
            self.jp_bufferingIndicator = bufferingIndicator;
        }

        if(needSetControlView){
            //before setting controllerView userInteractionEnabled should be enabled.
            self.userInteractionEnabled = YES;
            // user update controlView.
            if(controlView && self.jp_controlView){
                [self.jp_controlView removeFromSuperview];
            }
            if(showDefaultView && !controlView && !self.jp_controlView){
                // Use default `JPVideoPlayerControlView` if no controlView.
                controlView = [[JPVideoPlayerControlView alloc] initWithControlBar:nil blurImage:nil];
            }
            if(controlView){
                self.jp_controlView = controlView;
            }
        }
    }
}

- (void)jp_playVideoWithURL:(NSURL *)url
                    options:(JPVideoPlayerOptions)options
              configuration:(JPPlayVideoConfiguration _Nullable)configuration {
    [self playVideoWithURL:url
                   options:options
             configuration:configuration
                  isResume:NO];
}

- (void)jp_resumePlayWithURL:(NSURL *)url
                     options:(JPVideoPlayerOptions)options
               configuration:(JPPlayVideoConfiguration _Nullable)configuration {
    [self playVideoWithURL:url
                   options:options
             configuration:configuration
                  isResume:YES];
}

- (void)playVideoWithURL:(NSURL *)url
                 options:(JPVideoPlayerOptions)options
           configuration:(JPPlayVideoConfiguration _Nullable)configuration
                isResume:(BOOL)isResume {
    JPAssertMainThread;
    self.jp_videoURL = url;
    if (url) {
        [JPVideoPlayerManager sharedManager].delegate = self;
        self.jpVideoPlayerHelper.orientation = JPVideoPlayerOrientationPortrait;

        /// handler the reuse of progressView in `UITableView`.
        {
            if(self.jp_progressView && [self.jp_progressView respondsToSelector:@selector(viewWillPrepareToReuse)]){
                [self.jp_progressView viewWillPrepareToReuse];
            }
            if(self.jp_controlView && [self.jp_controlView respondsToSelector:@selector(viewWillPrepareToReuse)]){
                [self.jp_controlView viewWillPrepareToReuse];
            }
            [self invokeFinishBufferingDelegateMethod];
        }

        /// buffering indicator.
        {
            if(self.jp_bufferingIndicator && !self.jp_bufferingIndicator.superview){
                self.jp_bufferingIndicator.frame = self.bounds;
                [self.jpVideoPlayerHelper.videoPlayerView.bufferingIndicatorContainerView addSubview:self.jp_bufferingIndicator];
            }
            if(self.jp_bufferingIndicator){
                [self invokeFinishBufferingDelegateMethod];
            }
        }
        /// progress view.
        {
            if(self.jp_progressView && !self.jp_progressView.superview){
                self.jp_progressView.frame = self.bounds;
                if(self.jp_progressView && [self.jp_progressView respondsToSelector:@selector(viewWillAddToSuperView:)]){
                    [self.jp_progressView viewWillAddToSuperView:self];
                }
                [self.jpVideoPlayerHelper.videoPlayerView.progressContainerView addSubview:self.jp_progressView];
            }
        }
        /// control view.
        {
            if(self.jp_controlView && !self.jp_controlView.superview){
                self.jp_controlView.frame = self.bounds;
                if(self.jp_controlView && [self.jp_controlView respondsToSelector:@selector(viewWillAddToSuperView:)]){
                    [self.jp_controlView viewWillAddToSuperView:self];
                }
                [self.jpVideoPlayerHelper.videoPlayerView.controlContainerView addSubview:self.jp_controlView];
                if ([self jp_playerStatus] == JPVideoPlayerStatusUnknown) {
                    self.jpVideoPlayerHelper.videoPlayerView.progressContainerView.alpha = 0.f;
                }
            }
        }

        /// video player view.
        {
            self.jpVideoPlayerHelper.videoPlayerView.hidden = NO;
            if(!self.jpVideoPlayerHelper.videoPlayerView.superview){
                [self addSubview:self.jpVideoPlayerHelper.videoPlayerView];
            }
            self.jpVideoPlayerHelper.videoPlayerView.frame = self.bounds;
            self.jpVideoPlayerHelper.videoPlayerView.backgroundColor = [UIColor clearColor];
            if (self.jp_videoPlayerDelegate && [self.jp_videoPlayerDelegate respondsToSelector:@selector(shouldShowBlackBackgroundBeforePlaybackStart)]) {
                BOOL shouldShow = [self.jp_videoPlayerDelegate shouldShowBlackBackgroundBeforePlaybackStart];
                if(shouldShow){
                    self.jpVideoPlayerHelper.videoPlayerView.backgroundColor = [UIColor blackColor];
                }
            }
        }

        /// nobody retain this block.
        JPVideoPlayerConfiguration _configuration = ^(JPVideoPlayerModel *model){

            if (!model) JPDebugLog(@"model can not be nil");
            if(configuration) configuration(self, model);

        };

        if(!isResume){
            [[JPVideoPlayerManager sharedManager] playVideoWithURL:url
                                                       showOnLayer:self.jpVideoPlayerHelper.videoPlayerView.videoContainerLayer
                                                           options:options
                                                     configuration:_configuration];
            [self callOrientationDelegateWithOrientation:self.jp_orientation];
        }
        else {
            [[JPVideoPlayerManager sharedManager] resumePlayWithURL:url
                                                        showOnLayer:self.jpVideoPlayerHelper.videoPlayerView.videoContainerLayer
                                                            options:options
                                                      configuration:_configuration];
        }
    }
    else {
        JPDispatchSyncOnMainQueue(^{
            if (self.jp_videoPlayerDelegate && [self.jp_videoPlayerDelegate respondsToSelector:@selector(playVideoFailWithError:videoURL:)]) {
                [self.jp_videoPlayerDelegate playVideoFailWithError:JPErrorWithDescription(@"Try to play video with a invalid url")
                                                           videoURL:url];
            }
        });
    }
}


#pragma mark - Playback Control

- (void)setJp_rate:(float)jp_rate {
    JPVideoPlayerManager.sharedManager.rate = jp_rate;
}

- (float)jp_rate {
    return JPVideoPlayerManager.sharedManager.rate;
}

- (void)setJp_muted:(BOOL)jp_muted {
    JPVideoPlayerManager.sharedManager.muted = jp_muted;
}

- (BOOL)jp_muted {
    return JPVideoPlayerManager.sharedManager.muted;
}

- (void)setJp_volume:(float)jp_volume {
    JPVideoPlayerManager.sharedManager.volume = jp_volume;
}

- (float)jp_volume {
    return JPVideoPlayerManager.sharedManager.volume;
}

- (BOOL)jp_seekToTime:(CMTime)time {
    return [[JPVideoPlayerManager sharedManager] seekToTime:time];
}

- (NSTimeInterval)jp_elapsedSeconds {
    return [JPVideoPlayerManager.sharedManager elapsedSeconds];
}

- (NSTimeInterval)jp_totalSeconds {
    return [JPVideoPlayerManager.sharedManager totalSeconds];
}

- (void)jp_pause {
    [[JPVideoPlayerManager sharedManager] pause];
}

- (void)jp_resume {
    [[JPVideoPlayerManager sharedManager] resume];
}

- (CMTime)jp_currentTime {
    return JPVideoPlayerManager.sharedManager.currentTime;
}

- (void)jp_stopPlay {
    [[JPVideoPlayerManager sharedManager] stopPlay];
    self.jpVideoPlayerHelper.videoPlayerView.hidden = YES;
    self.jpVideoPlayerHelper.videoPlayerView.backgroundColor = [UIColor clearColor];
    [self invokeFinishBufferingDelegateMethod];
}


#pragma mark - Landscape & Portrait Control

- (void)setJp_resizeVideoViewAnimationTimeInterval:(NSTimeInterval)jp_resizeVideoViewAnimationTimeInterval {
    self.jpVideoPlayerHelper.resizeVideoViewAnimationTimeInterval = jp_resizeVideoViewAnimationTimeInterval;
}

- (NSTimeInterval)jp_resizeVideoViewAnimationTimeInterval {
    return self.jpVideoPlayerHelper.resizeVideoViewAnimationTimeInterval;
}

- (void)jp_gotoLandscape {
    [self jp_gotoLandscapeAnimated:YES completion:nil];
}

- (void)jp_gotoLandscapeAnimated:(BOOL)flag completion:(dispatch_block_t)completion {
    if (self.jp_orientation == JPVideoPlayerOrientationLandscapeRight) return;
    [self jp_resizeVideoViewToFitOrientation:JPVideoPlayerOrientationLandscapeLeft
                                    animated:flag
                                  completion:completion];
}

- (void)jp_gotoPortrait {
    [self jp_gotoPortraitAnimated:YES completion:nil];
}

- (void)jp_gotoPortraitAnimated:(BOOL)flag completion:(dispatch_block_t)completion{
    if (self.jp_orientation == JPVideoPlayerOrientationPortrait) return;
    [self jp_resizeVideoViewToFitOrientation:JPVideoPlayerOrientationPortrait
                                    animated:flag
                                  completion:completion];
}

- (void)jp_resizeVideoViewToFitOrientation:(JPVideoPlayerOrientation)orientation
                                  animated:(BOOL)animated
                                completion:(dispatch_block_t _Nullable)completion {
    if (self.jp_orientation == orientation || orientation == JPVideoPlayerOrientationUnknown) return;

    [NSNotificationCenter.defaultCenter postNotificationName:JPVideoPlayerWillResizeVideoViewToFitDeviceOrientationNotification
                                                      object:self
                                                    userInfo:@{@"JPVideoPlayerOrientation" : @(orientation)}];

    _JPVideoPlayerVideoViewResizingObject *resizingObject = [[_JPVideoPlayerVideoViewResizingObject alloc] initWithFromOrientation:self.jp_orientation toOrientation:orientation];
    JPVideoPlayerView *videoPlayerView = self.jpVideoPlayerHelper.videoPlayerView;

    /// from landscape to landscape.
    self.jpVideoPlayerHelper.orientation = orientation;

    /// from portrait to landscape.
    if (resizingObject.fromPortraitToLandscape) {
        CGRect videoPlayerViewFrameInWindow = [self convertRect:videoPlayerView.frame toView:nil];
        videoPlayerView.frame = videoPlayerViewFrameInWindow;
        [videoPlayerView removeFromSuperview];
        UIWindow *userWindow = [UIApplication.sharedApplication delegate].window;
        [userWindow addSubview:videoPlayerView];
        videoPlayerView.backgroundColor = [UIColor blackColor];
        [self _hideAttachmentViewsAnimated:NO completion:nil];
    }
    /// from landscape to portrait.
    else if (resizingObject.fromLandscapeToPortrait) {
        videoPlayerView.backgroundColor = [UIColor blackColor];
        if (self.jp_videoPlayerDelegate && [self.jp_videoPlayerDelegate respondsToSelector:@selector(shouldShowBlackBackgroundWhenPlaybackStart)]) {
            BOOL shouldShow = [self.jp_videoPlayerDelegate shouldShowBlackBackgroundWhenPlaybackStart];
            videoPlayerView.backgroundColor = shouldShow ? [UIColor blackColor] : [UIColor clearColor];
        }
        [self _hideAttachmentViewsAnimated:NO completion:nil];
    }

    /// handle status bar display or hide.
    BOOL needHideStatusBar = !(resizingObject.fromLandscapeToPortrait);
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#pragma clang diagnostic push
    if (needHideStatusBar != UIApplication.sharedApplication.statusBarHidden) {
        /// change status bar status.
        [[UIApplication sharedApplication] setStatusBarHidden:needHideStatusBar withAnimation:UIStatusBarAnimationFade];
    }
#pragma clang diagnostic pop

    if (animated) {
        [UIView animateWithDuration:self.jp_resizeVideoViewAnimationTimeInterval
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{

                             if (resizingObject.fromLandscapeToPortrait) {
                                 [self executeGotoPortrait];
                             }
                             else if(resizingObject.fromPortraitToLandscape || resizingObject.fromLandscapeToLandscape) {
                                 [self executeLandscapeWithOrientation:self.jp_orientation];
                             }

                         }
                         completion:^(BOOL finished) {

                             [NSNotificationCenter.defaultCenter postNotificationName:JPVideoPlayerDidResizeVideoViewToFitDeviceOrientationNotification
                                                                               object:self
                                                                             userInfo:@{@"JPVideoPlayerOrientation" : @(orientation)}];
                             if (resizingObject.fromLandscapeToPortrait) [self finishGotoPortrait];
                             if (completion) completion();
                             if (resizingObject.fromPortraitToLandscape || resizingObject.fromLandscapeToPortrait) [self _displayAttachmentViewsAnimated:YES completion:nil];

                         }];
    }
    else {
        if (resizingObject.fromLandscapeToPortrait) {
            [self executeGotoPortrait];
        }
        else if(resizingObject.fromPortraitToLandscape || resizingObject.fromLandscapeToLandscape) {
            [self executeLandscapeWithOrientation:self.jp_orientation];
        }
        [NSNotificationCenter.defaultCenter postNotificationName:JPVideoPlayerDidResizeVideoViewToFitDeviceOrientationNotification
                                                          object:self
                                                        userInfo:@{@"JPVideoPlayerOrientation" : @(orientation)}];
        if (resizingObject.fromLandscapeToPortrait) [self finishGotoPortrait];
        if (resizingObject.fromPortraitToLandscape || resizingObject.fromLandscapeToPortrait) [self _displayAttachmentViewsAnimated:YES completion:nil];
        if (completion) completion();
    }

    [self refreshStatusBarOrientation:orientation];
    [self callOrientationDelegateWithOrientation:orientation];
}


#pragma mark - Private

- (void)callOrientationDelegateWithOrientation:(JPVideoPlayerOrientation)orientation {
    if(self.jp_controlView && [self.jp_controlView respondsToSelector:@selector(videoPlayerOrientationDidChange:videoURL:)]){
        [self.jp_controlView videoPlayerOrientationDidChange:orientation videoURL:self.jp_videoURL];
    }
    if(self.jp_progressView && [self.jp_progressView respondsToSelector:@selector(videoPlayerOrientationDidChange:videoURL:)]){
        [self.jp_progressView videoPlayerOrientationDidChange:orientation videoURL:self.jp_videoURL];
    }
}

- (void)invokeStartBufferingDelegateMethod {
    if(self.jp_bufferingIndicator && [self.jp_bufferingIndicator respondsToSelector:@selector(didStartBufferingVideoURL:)]){
        [self.jp_bufferingIndicator didStartBufferingVideoURL:self.jp_videoURL];
    }
}

- (void)invokeFinishBufferingDelegateMethod {
    if(self.jp_bufferingIndicator && [self.jp_bufferingIndicator respondsToSelector:@selector(didFinishBufferingVideoURL:)]){
        [self.jp_bufferingIndicator didFinishBufferingVideoURL:self.jp_videoURL];
    }
}

- (void)finishGotoPortrait {
    JPVideoPlayerView *videoPlayerView = self.jpVideoPlayerHelper.videoPlayerView;
    [videoPlayerView removeFromSuperview];
    [self addSubview:videoPlayerView];
    videoPlayerView.frame = self.bounds;
    [[JPVideoPlayerManager sharedManager] videoPlayer].playerLayer.frame = self.bounds;
}

- (void)_hideAttachmentViewsAnimated:(BOOL)animated completion:(void (^ __nullable)(BOOL finished))completion {
    JPVideoPlayerView *videoPlayerView = self.jpVideoPlayerHelper.videoPlayerView;
    if (videoPlayerView.controlContainerView.alpha < 1e-3 && videoPlayerView.progressContainerView.alpha < 1e-3) {
        if (completion) completion(NO);
        return;
    }

    if (animated) {
        [UIView animateWithDuration:self.jp_resizeVideoViewAnimationTimeInterval
                         animations:^{

                             videoPlayerView.controlContainerView.alpha = 0.f;
                             videoPlayerView.progressContainerView.alpha = 0.f;

                         } completion:completion];
    }
    else {
        videoPlayerView.controlContainerView.alpha = 0.f;
        videoPlayerView.progressContainerView.alpha = 0.f;
        if (completion) completion(YES);
    }
}

- (void)_displayAttachmentViewsAnimated:(BOOL)animated completion:(void (^ __nullable)(BOOL finished))completion {
    JPVideoPlayerView *videoPlayerView = self.jpVideoPlayerHelper.videoPlayerView;
    if (videoPlayerView.controlContainerView.alpha >= 1.f && videoPlayerView.progressContainerView.alpha >= 1.f) {
        if (completion) completion(NO);
        return;
    }
    if (animated) {
        [UIView animateWithDuration:self.jp_resizeVideoViewAnimationTimeInterval
                         animations:^{

                             videoPlayerView.controlContainerView.alpha = 1.f;

                         } completion:completion];
    }
    else {
        videoPlayerView.controlContainerView.alpha = 1.f;
        if (completion) completion(YES);
    }
}

- (void)executeGotoPortrait {
    UIView *videoPlayerView = self.jpVideoPlayerHelper.videoPlayerView;
    CGRect frame = [self.superview convertRect:self.frame toView:nil];
    videoPlayerView.transform = CGAffineTransformIdentity;
    videoPlayerView.frame = frame;
    [[JPVideoPlayerManager sharedManager] videoPlayer].playerLayer.frame = self.bounds;
}

- (void)executeLandscapeWithOrientation:(JPVideoPlayerOrientation)orientation {
    NSParameterAssert(orientation == JPVideoPlayerOrientationLandscapeRight || orientation == JPVideoPlayerOrientationLandscapeLeft);
    if (orientation != JPVideoPlayerOrientationLandscapeRight && orientation != JPVideoPlayerOrientationLandscapeLeft) return;
    UIView *videoPlayerView = self.jpVideoPlayerHelper.videoPlayerView;
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGRect bounds = CGRectMake(0, 0, CGRectGetHeight(screenBounds), CGRectGetWidth(screenBounds));
    CGPoint center = CGPointMake(CGRectGetMidX(screenBounds), CGRectGetMidY(screenBounds));
    videoPlayerView.bounds = bounds;
    videoPlayerView.center = center;
    double rotation = M_PI_2;
    if (orientation == JPVideoPlayerOrientationLandscapeRight) rotation *= 3.0;
    videoPlayerView.transform = CGAffineTransformMakeRotation((CGFloat)rotation);
    [[JPVideoPlayerManager sharedManager] videoPlayer].playerLayer.frame = bounds;
}

- (void)refreshStatusBarOrientation:(JPVideoPlayerOrientation)orientation {
    UIInterfaceOrientation interfaceOrientation = UIInterfaceOrientationUnknown;
    switch (orientation) {
        case JPVideoPlayerOrientationPortrait: {
            interfaceOrientation = UIInterfaceOrientationPortrait;
            break;
        }

        case JPVideoPlayerOrientationLandscapeLeft: {
            interfaceOrientation = UIInterfaceOrientationLandscapeLeft;
            break;
        }

        case JPVideoPlayerOrientationLandscapeRight: {
            interfaceOrientation = UIInterfaceOrientationLandscapeRight;
            break;
        }

        default:
            break;
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [[UIApplication sharedApplication] setStatusBarOrientation:interfaceOrientation animated:YES];
#pragma clang diagnostic pop
}

- (JPVideoPlayerHelper *)jpVideoPlayerHelper {
    JPVideoPlayerHelper *helper = objc_getAssociatedObject(self, _cmd);
    if(!helper){
        helper = [[JPVideoPlayerHelper alloc] initWithPlayVideoView:self];
        objc_setAssociatedObject(self, _cmd, helper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return helper;
}


#pragma mark - JPVideoPlayerManager

- (BOOL)videoPlayerManager:(JPVideoPlayerManager *)videoPlayerManager
 shouldDownloadVideoForURL:(NSURL *)videoURL {
    if (self.jp_videoPlayerDelegate && [self.jp_videoPlayerDelegate respondsToSelector:@selector(shouldDownloadVideoForURL:)]) {
        return [self.jp_videoPlayerDelegate shouldDownloadVideoForURL:videoURL];
    }
    return YES;
}

- (BOOL)videoPlayerManager:(JPVideoPlayerManager *)videoPlayerManager
    shouldAutoReplayForURL:(NSURL *)videoURL {
    if (self.jp_videoPlayerDelegate && [self.jp_videoPlayerDelegate respondsToSelector:@selector(shouldAutoReplayForURL:)]) {
        return [self.jp_videoPlayerDelegate shouldAutoReplayForURL:videoURL];
    }
    return YES;
}

- (void)videoPlayerManager:(JPVideoPlayerManager *)videoPlayerManager
    playerStatusDidChanged:(JPVideoPlayerStatus)playerStatus {
    if(playerStatus == JPVideoPlayerStatusPlaying){
        self.jpVideoPlayerHelper.videoPlayerView.backgroundColor = [UIColor blackColor];
        if (self.jp_videoPlayerDelegate && [self.jp_videoPlayerDelegate respondsToSelector:@selector(shouldShowBlackBackgroundWhenPlaybackStart)]) {
            BOOL shouldShow = [self.jp_videoPlayerDelegate shouldShowBlackBackgroundWhenPlaybackStart];
            self.jpVideoPlayerHelper.videoPlayerView.backgroundColor = shouldShow ? [UIColor blackColor] : [UIColor clearColor];
        }
    }
    self.jpVideoPlayerHelper.playerStatus = playerStatus;
    // JPDebugLog(@"playerStatus: %ld", playerStatus);
    if (self.jp_videoPlayerDelegate && [self.jp_videoPlayerDelegate respondsToSelector:@selector(playerStatusDidChanged:)]) {
        [self.jp_videoPlayerDelegate playerStatusDidChanged:playerStatus];
    }
    BOOL needDisplayBufferingIndicator =
            playerStatus == JPVideoPlayerStatusBuffering ||
                    playerStatus == JPVideoPlayerStatusUnknown ||
                    playerStatus == JPVideoPlayerStatusFailed;
    needDisplayBufferingIndicator ? [self invokeStartBufferingDelegateMethod] : [self invokeFinishBufferingDelegateMethod];
    if(self.jp_controlView && [self.jp_controlView respondsToSelector:@selector(videoPlayerStatusDidChange:videoURL:)]){
        [self.jp_controlView videoPlayerStatusDidChange:playerStatus videoURL:self.jp_videoURL];
    }
    if(self.jp_progressView && [self.jp_progressView respondsToSelector:@selector(videoPlayerStatusDidChange:videoURL:)]){
        [self.jp_progressView videoPlayerStatusDidChange:playerStatus videoURL:self.jp_videoURL];
    }
}

- (void)videoPlayerManager:(JPVideoPlayerManager *)videoPlayerManager
   didFetchVideoFileLength:(NSUInteger)videoLength {
    if(self.jpVideoPlayerHelper.controlView && [self.jpVideoPlayerHelper.controlView respondsToSelector:@selector(didFetchVideoFileLength:videoURL:)]){
        [self.jpVideoPlayerHelper.controlView didFetchVideoFileLength:videoLength videoURL:self.jp_videoURL];
    }
    if(self.jpVideoPlayerHelper.progressView && [self.jpVideoPlayerHelper.progressView respondsToSelector:@selector(didFetchVideoFileLength:videoURL:)]){
        [self.jpVideoPlayerHelper.progressView didFetchVideoFileLength:videoLength videoURL:self.jp_videoURL];
    }
}

- (void)videoPlayerManagerDownloadProgressDidChange:(JPVideoPlayerManager *)videoPlayerManager
                                          cacheType:(JPVideoPlayerCacheType)cacheType
                                     fragmentRanges:(NSArray<NSValue *> *_Nullable)fragmentRanges
                                       expectedSize:(NSUInteger)expectedSize
                                              error:(NSError *_Nullable)error {
    if(error){
        if (self.jp_videoPlayerDelegate && [self.jp_videoPlayerDelegate respondsToSelector:@selector(playVideoFailWithError:videoURL:)]) {
            [self.jp_videoPlayerDelegate playVideoFailWithError:JPErrorWithDescription(@"Try to play video with a invalid url")
                                                       videoURL:videoPlayerManager.managerModel.videoURL];
        }
        return;
    }
    switch(cacheType){
        case JPVideoPlayerCacheTypeLocation:
            if (!fragmentRanges) {
                JPErrorLog(@"fragmentRanges can not be nil");
            }
            break;

        default:
            break;
    }
    if(self.jpVideoPlayerHelper.controlView && [self.jpVideoPlayerHelper.controlView respondsToSelector:@selector(cacheRangeDidChange:videoURL:)]){
        [self.jpVideoPlayerHelper.controlView cacheRangeDidChange:fragmentRanges videoURL:self.jp_videoURL];
    }
    if(self.jpVideoPlayerHelper.progressView && [self.jpVideoPlayerHelper.progressView respondsToSelector:@selector(cacheRangeDidChange:videoURL:)]){
        [self.jpVideoPlayerHelper.progressView cacheRangeDidChange:fragmentRanges videoURL:self.jp_videoURL];
    }
}

- (void)videoPlayerManagerPlayProgressDidChange:(JPVideoPlayerManager *)videoPlayerManager
                                 elapsedSeconds:(double)elapsedSeconds
                                   totalSeconds:(double)totalSeconds
                                          error:(NSError *_Nullable)error {
    if(error){
        if (self.jp_videoPlayerDelegate && [self.jp_videoPlayerDelegate respondsToSelector:@selector(playVideoFailWithError:videoURL:)]) {
            [self.jp_videoPlayerDelegate playVideoFailWithError:JPErrorWithDescription(@"Try to play video with a invalid url")
                                                       videoURL:videoPlayerManager.managerModel.videoURL];
        }
        return;
    }
    if(self.jpVideoPlayerHelper.controlView && [self.jpVideoPlayerHelper.controlView respondsToSelector:@selector(playProgressDidChangeElapsedSeconds:totalSeconds:videoURL:)]){
        [self.jpVideoPlayerHelper.controlView playProgressDidChangeElapsedSeconds:elapsedSeconds
                                                        totalSeconds:totalSeconds
                                                            videoURL:self.jp_videoURL];
    }
    if(self.jpVideoPlayerHelper.progressView && [self.jpVideoPlayerHelper.progressView respondsToSelector:@selector(playProgressDidChangeElapsedSeconds:totalSeconds:videoURL:)]){
        [self.jpVideoPlayerHelper.progressView playProgressDidChangeElapsedSeconds:elapsedSeconds
                                                         totalSeconds:totalSeconds
                                                             videoURL:self.jp_videoURL];
    }
}

- (BOOL)videoPlayerManager:(JPVideoPlayerManager *)videoPlayerManager
shouldPausePlaybackWhenApplicationWillResignActiveForURL:(NSURL *)videoURL {
    if (self.jp_videoPlayerDelegate && [self.jp_videoPlayerDelegate respondsToSelector:@selector(shouldPausePlaybackWhenApplicationWillResignActiveForURL:)]) {
        return [self.jp_videoPlayerDelegate shouldPausePlaybackWhenApplicationWillResignActiveForURL:videoURL];
    }
    return NO;
}

- (BOOL)videoPlayerManager:(JPVideoPlayerManager *)videoPlayerManager
shouldPausePlaybackWhenApplicationDidEnterBackgroundForURL:(NSURL *)videoURL {
    if (self.jp_videoPlayerDelegate && [self.jp_videoPlayerDelegate respondsToSelector:@selector(shouldPausePlaybackWhenApplicationDidEnterBackgroundForURL:)]) {
        return [self.jp_videoPlayerDelegate shouldPausePlaybackWhenApplicationDidEnterBackgroundForURL:videoURL];
    }
    return YES;
}

- (BOOL)videoPlayerManager:(JPVideoPlayerManager *)videoPlayerManager
shouldResumePlaybackWhenApplicationDidBecomeActiveFromBackgroundForURL:(NSURL *)videoURL {
    if (self.jp_videoPlayerDelegate && [self.jp_videoPlayerDelegate respondsToSelector:@selector(shouldResumePlaybackWhenApplicationDidBecomeActiveFromBackgroundForURL:)]) {
        return [self.jp_videoPlayerDelegate shouldResumePlaybackWhenApplicationDidBecomeActiveFromBackgroundForURL:videoURL];
    }
    return YES;
}

- (BOOL)videoPlayerManager:(JPVideoPlayerManager *)videoPlayerManager
shouldResumePlaybackWhenApplicationDidBecomeActiveFromResignActiveForURL:(NSURL *)videoURL {
    if (self.jp_videoPlayerDelegate && [self.jp_videoPlayerDelegate respondsToSelector:@selector(shouldResumePlaybackWhenApplicationDidBecomeActiveFromResignActiveForURL:)]) {
        return [self.jp_videoPlayerDelegate shouldResumePlaybackWhenApplicationDidBecomeActiveFromResignActiveForURL:videoURL];
    }
    return NO;
}

- (BOOL)videoPlayerManager:(JPVideoPlayerManager *)videoPlayerManager
shouldTranslateIntoPlayVideoFromResumePlayForURL:(NSURL *)videoURL {
    if (self.jp_videoPlayerDelegate && [self.jp_videoPlayerDelegate respondsToSelector:@selector(shouldTranslateIntoPlayVideoFromResumePlayForURL:)]) {
        return [self.jp_videoPlayerDelegate shouldTranslateIntoPlayVideoFromResumePlayForURL:videoURL];
    }
    return YES;
}

- (BOOL)videoPlayerManager:(JPVideoPlayerManager *)videoPlayerManager
shouldPausePlaybackWhenReceiveAudioSessionInterruptionNotificationForURL:(NSURL *)videoURL {
    if (self.jp_videoPlayerDelegate && [self.jp_videoPlayerDelegate respondsToSelector:@selector(shouldPausePlaybackWhenReceiveAudioSessionInterruptionNotificationForURL:)]) {
        return [self.jp_videoPlayerDelegate shouldPausePlaybackWhenReceiveAudioSessionInterruptionNotificationForURL:videoURL];
    }
    return YES;
}

- (AVAudioSessionCategory)videoPlayerManagerPreferAudioSessionCategory:(JPVideoPlayerManager *)videoPlayerManager {
    if (self.jp_videoPlayerDelegate && [self.jp_videoPlayerDelegate respondsToSelector:@selector(preferAudioSessionCategory)]) {
        return [self.jp_videoPlayerDelegate preferAudioSessionCategory];
    }
    return AVAudioSessionCategoryPlayback;
}

- (BOOL)videoPlayerManager:(JPVideoPlayerManager *)videoPlayerManager
shouldResumePlaybackFromPlaybackRecordForURL:(NSURL *)videoURL
        elapsedSeconds:(NSTimeInterval)elapsedSeconds {
    BOOL shouldResume = NO;
    if (self.jp_videoPlayerDelegate && [self.jp_videoPlayerDelegate respondsToSelector:@selector(shouldResumePlaybackFromPlaybackRecordForURL:elapsedSeconds:)]) {
        shouldResume = [self.jp_videoPlayerDelegate shouldResumePlaybackFromPlaybackRecordForURL:videoURL
                                                                                  elapsedSeconds:elapsedSeconds];
    }
    return shouldResume;
}

- (void)videoPlayerManager:(JPVideoPlayerManager *)videoPlayerManager
interfaceOrientationDidChange:(UIDeviceOrientation)deviceOrientation {
    BOOL shouldAutoChangeVideoLayerInterfaceOrientation = NO;
    if (self.jp_videoPlayerDelegate && [self.jp_videoPlayerDelegate respondsToSelector:@selector(shouldVideoViewResizeToFitWhenDeviceOrientationDidChange:)]) {
        shouldAutoChangeVideoLayerInterfaceOrientation = [self.jp_videoPlayerDelegate shouldVideoViewResizeToFitWhenDeviceOrientationDidChange:deviceOrientation];
    }

    if (shouldAutoChangeVideoLayerInterfaceOrientation) {
        JPVideoPlayerOrientation orientation = JPVideoPlayerOrientationUnknown;
        switch (deviceOrientation) {
            case UIDeviceOrientationPortrait: {
                orientation = JPVideoPlayerOrientationPortrait;
                break;
            }

            case UIDeviceOrientationLandscapeLeft: {
                orientation = JPVideoPlayerOrientationLandscapeLeft;
                break;
            }

            case UIDeviceOrientationLandscapeRight: {
                orientation = JPVideoPlayerOrientationLandscapeRight;
                break;
            }

            default:
                break;
        }
        if (orientation != JPVideoPlayerOrientationUnknown) {
            [self jp_resizeVideoViewToFitOrientation:orientation animated:YES completion:nil];
        }
    }
}

@end
