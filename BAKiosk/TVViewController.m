//
//  TVViewController.m
//  BAKiosk
//
//  Created by Eirik Eikås on 20.05.15.
//  Copyright (c) 2015 Evil Corp ENK. All rights reserved.
//

#import "TVViewController.h"
#import "KASlideShow.h"
@import MediaPlayer;
@import AVFoundation;

@interface TVViewController () <KASlideShowDelegate>

@property KASlideShow *slideshow;
@property MPMoviePlayerController *player;
@property UIView *container;
@property UIView *slideplayercontainer;
@property AVPlayerLayer *slideplayerlayer;
@property AVQueuePlayer *slideplayer;

@end

@implementation TVViewController

NSString * const KioskSlideshowNextImage = @"KioskSlideshowNextImage";
NSString * const KioskSlideshowPrevImage = @"KioskSlideshowPrevImage";
NSString * const KioskSlideshowLoadImageSet = @"KioskSlideshowLoadImageSet";
NSString * const KioskSlideshowLoadVideo = @"KioskSlideshowLoadVideo";
NSString * const KioskSlideshowStandby = @"KioskSlideshowStandby";
NSString * const KioskSlideshowPlayForBreakpointIndex = @"KioskSlideshowPlayForBreakpointIndex";

@synthesize slideshow;
@synthesize slideplayer;
@synthesize slideplayerlayer;
@synthesize player;
@synthesize container;
@synthesize slideplayercontainer;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIScreen *external = [[UIScreen screens] objectAtIndex:1];
    CGSize size = external.bounds.size;
    
    // Container
    container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    slideplayercontainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    //[slideplayercontainer setBackgroundColor:[UIColor purpleColor]];
    [slideplayercontainer setAlpha:0];
    
    // Video
    player = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"vegaloop" ofType:@"mp4"]]];
    [player setControlStyle:MPMovieControlStyleNone];
    [player setRepeatMode:MPMovieRepeatModeOne];
    [player prepareToPlay];
    [player.view setFrame:container.bounds];
    [container addSubview:player.view];
    [player play];
    
    // Slideplayer
    slideplayer = [[AVQueuePlayer alloc] init];
    [slideplayer pause];
    [slideplayer setActionAtItemEnd:AVPlayerActionAtItemEndPause];
    
    // Slideplayer CALayer
    slideplayerlayer = [AVPlayerLayer playerLayerWithPlayer:slideplayer];
    [slideplayerlayer setFrame:CGRectMake(0, 0, size.width, size.height)];
    [slideplayercontainer.layer addSublayer:slideplayerlayer];
    
    
    
    // View
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:container];
    [self.view addSubview:slideplayercontainer];
    
    // Observers
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nextImage:) name:KioskSlideshowNextImage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prevImage:) name:KioskSlideshowPrevImage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadImages:) name:KioskSlideshowLoadImageSet object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(standby:) name:KioskSlideshowStandby object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadVideo:) name:KioskSlideshowLoadVideo object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playTo:) name:KioskSlideshowPlayForBreakpointIndex object:nil];
    
    // KVO
    [slideplayer addObserver:self forKeyPath:@"currentPlaybackTime" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)nextImage:(NSNotification*)notification {
    [slideshow next];
}

- (void)prevImage:(NSNotification*)notification {
    [slideshow previous];
}

- (void)loadImages:(NSNotification*)notification {
    UIScreen *external = [[UIScreen screens] objectAtIndex:1];
    CGSize size = external.bounds.size;
    // Slideshow
    slideshow = [[KASlideShow alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    [slideshow setDelay:3]; // Delay between transitions
    [slideshow setTransitionDuration:0.6]; // Transition duration
    [slideshow setTransitionType:KASlideShowTransitionSlide]; // Choose a transition type (fade or slide)
    [slideshow setImagesContentMode:UIViewContentModeScaleAspectFill]; // Choose a content mode for images to display
    [slideshow addImagesFromResources:@[@"EE_3707.jpg",@"EE_3709.jpg",@"EE_3710.jpg"]]; // Add images from resources
    [slideshow setAlpha:0];
    [slideshow setDelegate:self];
    
    [slideshow emptyAndAddImagesFromResources:notification.object];
    
    [self.view addSubview:slideshow];
    [UIView animateWithDuration:0.5 animations:^{
        slideshow.alpha = 1;
        slideplayercontainer.alpha = 0;
    } completion:^(BOOL finished) {
        if(finished){
            [player pause];
        }
    }];
}

- (void)loadVideo:(NSNotification*)notification {
    [slideplayer removeAllItems];
    for(int i = 0; i<[notification.object count]; i++){
        [slideplayer insertItem:[[AVPlayerItem alloc] initWithURL:[notification.object objectAtIndex:i]] afterItem:nil];
    }
    [UIView animateWithDuration:0.5 animations:^{
        slideshow.alpha = 0;
        slideplayercontainer.alpha = 1;
    } completion:^(BOOL finished) {
        if(finished){
            [player pause];
        }
    }];
}

- (void)playTo:(NSNotification*)notification {
    [slideplayer advanceToNextItem];
    [slideplayer play];
}

- (void)standby:(NSNotification*)notification {
    [slideplayer pause];
    [player play];
    [UIView animateWithDuration:0.5 animations:^{
        slideshow.alpha = 0;
        slideplayercontainer.alpha = 0;
    } completion:^(BOOL finished) {
        if(finished){
            [slideplayer removeAllItems];
            [slideshow removeFromSuperview];
            slideshow = nil;
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
