//
//  ViewController.m
//  UkieDrive
//
//  Created by Admin on 1/15/15.
//  Copyright (c) 2015 Igor Zhariy. All rights reserved.
//

#import "MainViewController.h"
#import "Constants.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Set Internet connection notifier
        [self setReachabilityNotifier];
        
        // Check if there's Internet
        NetworkStatus _networkStatus = [_reach currentReachabilityStatus];
        if (_networkStatus == NotReachable)
            _availableInternet = NO;
        else
            _availableInternet = YES;
        
        // Init hanlers
        [self initHandlers];
        
        // Init View
        [self initView];
        
    }
    return self;
}


- (void)initView
{
    // Set white background color of the view controller
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Blue stripe on top
    UIView *_blueTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _bounds.size.width, _bounds.size.height * 1.2/10)];
    _blueTop.backgroundColor = UIColorFromRGB(0x42adde);
    [self.view addSubview:_blueTop];
    
    // Blue top gradient
    UIView *_blueTopGradient = [[UIView alloc] initWithFrame:CGRectMake(0.0f, _bounds.size.height * 1.2/10, _bounds.size.width, _bounds.size.height * 2.2/10)];
    CAGradientLayer *_blueGradient = [CAGradientLayer layer];
    _blueGradient.frame = _blueTopGradient.bounds;
    _blueGradient.colors = [NSArray arrayWithObjects:(id)[UIColorFromRGB(0x42adde) CGColor], (id)[[UIColor whiteColor] CGColor], nil];
    [_blueTopGradient.layer insertSublayer:_blueGradient atIndex:0];
    [self.view addSubview:_blueTopGradient];
    
    // Yellow bottom gradient
    UIView *_yellowBottomGradient = [[UIView alloc] initWithFrame:CGRectMake(0.0f, _bounds.size.height * 5.4/10, _bounds.size.width, _bounds.size.height * 1.9/10)];
    CAGradientLayer *_yellowGradient = [CAGradientLayer layer];
    _yellowGradient.frame = _yellowBottomGradient.bounds;
    _yellowGradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[UIColorFromRGB(0xffd600) CGColor], nil];
    [_yellowBottomGradient.layer insertSublayer:_yellowGradient atIndex:0];
    [self.view addSubview:_yellowBottomGradient];
    
    // Yellow stripe on bottom
    UIView *_yellowBottom = [[UIView alloc] initWithFrame:CGRectMake(0, _bounds.size.height * 7.3/10, _bounds.size.width, _bounds.size.height * 3/10)];
    _yellowBottom.backgroundColor = UIColorFromRGB(0xffd600);
    [self.view addSubview:_yellowBottom];
    
    // Live broadcast label
    _liveBroadcastLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _statusBarHeight, _bounds.size.width, 45)];
    _liveBroadcastLabel.textColor = [UIColor whiteColor];
    _liveBroadcastLabel.font = [UIFont systemFontOfSize:16];
    _liveBroadcastLabel.numberOfLines = 0;
    _liveBroadcastLabel.text = @"Live Broadcast";
    _liveBroadcastLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_liveBroadcastLabel];
    
    // Init logo width and height
    CGFloat _logoWidth = 0;
    CGFloat _logoHeight = 0;
    
    // Assign logo size and resources depending on device
    if (_iPhone6Plus)
    {
        _logoWidth = 384;
        _logoHeight = 186;

    }
    if (_iPhone6)
    {
        _logoWidth = 345;
        _logoHeight = 167;
        _playButtonImage = [UIImage imageNamed:@"play@2x-667.png"];
        _pauseButtonImage = [UIImage imageNamed:@"pause@2x-667.png"];
        _emptyButtonImage = [UIImage imageNamed:@"empty@2x-667.png"];
        _clockImage = [UIImage imageNamed:@"clock@2x-667.png"];
        _spinnerImage = [UIImage imageNamed:@"loading@2x-667.png"];
    }
    else
    {
        _playButtonImage = [UIImage imageNamed:@"play.png"];
        _pauseButtonImage = [UIImage imageNamed:@"pause.png"];
        _emptyButtonImage = [UIImage imageNamed:@"empty.png"];
        _clockImage = [UIImage imageNamed:@"clock.png"];
        _spinnerImage = [UIImage imageNamed:@"loading.png"];
    }
    if (_iPhone5 || _iPhone4)
    {
        _logoWidth = 290;
        _logoHeight = 140;
    }
    
    // Assign logo
    CGRect _logoViewRect = CGRectMake(15, _bounds.size.height * 2.8/10, _logoWidth, _logoHeight);
    UIImage *_logoImage = [UIImage imageNamed:@"logo.png"];
    UIImageView *_logoView = [[UIImageView alloc] initWithFrame:_logoViewRect];
    [_logoView setImage:_logoImage];
    [self.view addSubview:_logoView];
    
    // Play button
    CGRect _playButtonRect = CGRectMake((_bounds.size.width - _playButtonImage.size.width) / 2, _bounds.size.height * 0.75, _playButtonImage.size.width, _playButtonImage.size.height);
    _playButton = [[UIButton alloc] initWithFrame:_playButtonRect];
    [_playButton setImage:_playButtonImage forState:UIControlStateNormal];
    [_playButton setImage:_playButtonImage forState:UIControlStateHighlighted];
    [_playButton addTarget:self action:@selector(playPlayer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_playButton];
    
    // Pause button
    _pauseButton = [[UIButton alloc] initWithFrame:_playButtonRect];
    [_pauseButton setImage:_pauseButtonImage forState:UIControlStateNormal];
    [_pauseButton setImage:_pauseButtonImage forState:UIControlStateHighlighted];
    [_pauseButton addTarget:self action:@selector(pausePlayer) forControlEvents:UIControlEventTouchUpInside];
    _pauseButton.hidden = YES;
    [self.view addSubview:_pauseButton];
    
    // Empty button
    _emptyButton = [[UIButton alloc] initWithFrame:_playButtonRect];
    [_emptyButton setImage:_emptyButtonImage forState:UIControlStateNormal];
    [_emptyButton setImage:_emptyButtonImage forState:UIControlStateHighlighted];
    [_emptyButton addTarget:self action:@selector(tapSpinner) forControlEvents:UIControlEventTouchUpInside];
     _emptyButton.hidden = YES;
    [self.view addSubview:_emptyButton];
    
    // Loading spinner
    CGRect _loadingRect = CGRectMake((_bounds.size.width - _spinnerImage.size.width) / 2, _playButtonRect.origin.y + (_playButtonImage.size.height - _spinnerImage.size.height) / 2, _spinnerImage.size.width, _spinnerImage.size.height);
    _spinnerImageView = [[UIImageView alloc] initWithFrame:_loadingRect];
    [_spinnerImageView setImage:_spinnerImage];
    _spinnerImageView.hidden = YES;
    [self.view addSubview:_spinnerImageView];
    
    // Clock
    CGRect _clockRect = CGRectMake((_bounds.size.width - _playButtonImage.size.width) / 2 - _playButtonImage.size.width * 1.4, _bounds.size.height * 0.75 + (_playButtonImage.size.height - _clockImage.size.height) / 2, _clockImage.size.width, _clockImage.size.height);
    _clockImageView = [[UIImageView alloc] initWithFrame:_clockRect];
    [_clockImageView setImage: _clockImage];
    _clockImageView.hidden = YES;
    [self.view addSubview:_clockImageView];
    
    // Elapsed time label
    CGRect _timePlayingRect = CGRectMake((_bounds.size.width - _playButtonImage.size.width) / 2 - _playButtonImage.size.width * 1.4 + _clockImage.size.width + 5, _bounds.size.height * 0.75 + (_playButtonImage.size.height - _clockImage.size.height) / 2, 75, _clockImage.size.height);
    _timePlayingLabel = [[UILabel alloc] initWithFrame:_timePlayingRect];
    _timePlayingLabel.font = [UIFont systemFontOfSize:12];
    _timePlayingLabel.text = @"00:00:00";
    _timePlayingLabel.hidden = YES;
    [self.view addSubview:_timePlayingLabel];
    
    // Volume slider
    CGRect _volumeSliderRect = CGRectMake(_bounds.size.width / 6.4, _bounds.size.height * 9.1/10, _bounds.size.width - _bounds.size.width / 3.2, _bounds.size.height * 0.9/10);
    
    // In simulator
    #if TARGET_IPHONE_SIMULATOR
    UISlider *_volumeSliderSim = [[UISlider alloc] initWithFrame:_volumeSliderRect];
    _volumeSliderSim.backgroundColor = [UIColor clearColor];
    _volumeSliderSim.minimumValue = 0.0;
    _volumeSliderSim.maximumValue = 1.0;
    _volumeSliderSim.continuous = YES;
    _volumeSliderSim.value = 0.75;
    _volumeSliderSim.minimumTrackTintColor = [UIColor blackColor];
    _volumeSliderSim.maximumTrackTintColor = [UIColor whiteColor];
    [self.view addSubview:_volumeSliderSim];
    
    // On device
    #elif TARGET_OS_IPHONE
    _volumeSlider = [[SystemVolumeView alloc] initWithFrame: _volumeSliderRect];
    _volumeSlider.tintColor = [UIColor blackColor];
    [_volumeSlider setMinimumVolumeSliderImage:[self imageWithColor:[UIColor blackColor]] forState:UIControlStateNormal];
    [_volumeSlider setMaximumVolumeSliderImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.view addSubview: _volumeSlider];
    #endif
    
    // Prepare 'no Internet' AlertView
    _noInternetAlert = [[UIAlertView alloc] initWithTitle:@"No connection" message:@"Please check your Internet connection and try again" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
    
    // Prepare 'Something's wrong' AlertView
    _noStreamAlert = [[UIAlertView alloc] initWithTitle:@"No stream" message:@"Something is wrong with the audio stream. Please contact us at www.ukiedrive.net" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
}

// Init handlers
- (void)initHandlers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(startedPlaying)
                                                 name:@"_startedPlaying"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleAudioSessionInterruption:)
                                                 name:AVAudioSessionInterruptionNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMediaServicesReset)
                                                 name:AVAudioSessionMediaServicesWereResetNotification
                                               object:nil];
}


// Listen for changes in connection
- (void)setReachabilityNotifier
{
    _reach = [Reachability reachabilityForInternetConnection];
    _reach.reachableOnWWAN = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    [_reach startNotifier];
}

// Actions when connection change
- (void)reachabilityChanged
{
    NetworkStatus _networkStatus = [_reach currentReachabilityStatus];
    
    if (_networkStatus == NotReachable)
    {
        #ifdef DEBUG
        NSLog(@"No internet");
        #endif
        _availableInternet = NO;
        [self pausePlayer];
    }
    else
    {
        #ifdef DEBUG
        NSLog(@"Internet is back");
        #endif
        _availableInternet = YES;
        [self pausePlayer];
        [self playPlayer];
    }
}

// Play button action
- (void)playPlayer
{
    if (_availableInternet == YES)
    {
        [self initPlayer];
        [self startSpin];
        [_audioPlayer play];
        _streamTimeout = [NSTimer scheduledTimerWithTimeInterval: 10.0 target:self selector:@selector(showStreamAlert) userInfo:nil repeats: NO];
    }
    else
    {
        [_noInternetAlert show];
    }
}

// Stop the spinner action
- (void)tapSpinner
{
    [_audioPlayer pause];
    _spinnerImageView.hidden = YES;
    _emptyButton.hidden = YES;
    _playButton.hidden = NO;
}

// Show alert when stream couldn't be loaded
- (void)showStreamAlert
{
    [_noStreamAlert show];
    [self stopSpin];
}

// Initializing AVPlayer
- (void)initPlayer
{
    if (_audioStreamPlayerItem != nil)
    {
        [_audioPlayer removeObserver:self forKeyPath:@"status" context:nil];
        [_audioStreamPlayerItem removeObserver:self forKeyPath:@"playbackBufferEmpty" context:nil];
        [_audioStreamPlayerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp" context:nil];
    }
    
    NSURL *_streamUrl = [NSURL URLWithString:_mainUrl];
    _audioStreamPlayerItem = [AVPlayerItem playerItemWithURL:_streamUrl];
    _audioPlayer = [AVPlayer playerWithPlayerItem:_audioStreamPlayerItem];
    
    
    [_audioPlayer addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [_audioStreamPlayerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    [_audioStreamPlayerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    
    __block AVPlayer* blockPlayer = _audioPlayer;
    __block id obs;
    
    // Post a notification when AVPlayer starts playing
    obs = [_audioPlayer addBoundaryTimeObserverForTimes:
           @[[NSValue valueWithCMTime:CMTimeMake(1, 10)]]
                                                  queue:NULL
                                             usingBlock:^{
                                                 
                                                 [[NSNotificationCenter defaultCenter]
                                                  postNotificationName:@"_startedPlaying"
                                                  object:nil];
                                                 
                                                 [blockPlayer removeTimeObserver:obs];
                                             }];
}

// Player starts playing
- (void)startedPlaying
{
    if ([_streamTimeout isValid])
    {
        [_streamTimeout invalidate];
        _streamTimeout = nil;
    }
    [self stopSpin];
    _clockImageView.hidden = NO;
    _timePlayingLabel.hidden = NO;
    _elapsedSeconds = 0;
    if (!_timer)
        _timer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target:self selector:@selector(updateTime) userInfo:nil repeats: YES];
}

// Update elapsed time label next to the clock
-(void)updateTime {
    int _hours, _minutes, _seconds;
    _elapsedSeconds++;
    _hours = _elapsedSeconds / 3600;
    _minutes = (_elapsedSeconds % 3600) / 60;
    _seconds = (_elapsedSeconds % 3600) % 60;
    _timePlayingLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", _hours, _minutes, _seconds];
}

// Pause button Action
- (void)pausePlayer
{
    [_audioPlayer pause];
    _pauseButton.hidden = YES;
    _playButton.hidden = NO;
    _clockImageView.hidden = YES;
    _timePlayingLabel.hidden = YES;
    _timePlayingLabel.text = @"00:00:00";
    if ([_timer isValid])
    {
        [_timer invalidate];
        _timer = nil;
    }
}

// Start spinner
- (void)startSpin {
    _playButton.hidden = YES;
    _pauseButton.hidden = YES;
    _emptyButton.hidden = NO;
    _spinnerImageView.hidden = NO;
    if (!_spinning) {
        _spinning = YES;
        [self spinWithOptions: UIViewAnimationOptionCurveLinear];
    }
}

// Spinner animation
- (void)spinWithOptions: (UIViewAnimationOptions) options {
    [UIView animateWithDuration: 0.5f
                          delay: 0.0f
                        options: options
                     animations: ^{
                         _spinnerImageView.transform = CGAffineTransformRotate(_spinnerImageView.transform, M_PI / 2);
                     }
                     completion: ^(BOOL finished) {
                         if (finished) {
                             if (_spinning) {
                                 [self spinWithOptions: UIViewAnimationOptionCurveLinear];
                             } else if (options != UIViewAnimationOptionCurveLinear) {
                                 [self spinWithOptions: UIViewAnimationOptionCurveLinear];
                             }
                         }
                     }];
}

// Stop spinner
- (void)stopSpin {
    _spinning = NO;
    _emptyButton.hidden = YES;
    _spinnerImageView.hidden = YES;
    _pauseButton.hidden = NO;
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context
{
    if (!_audioPlayer)
    {
        return;
    }
    
    else if (object == _audioStreamPlayerItem && [keyPath isEqualToString:@"playbackBufferEmpty"])
    {
        if (_audioStreamPlayerItem.playbackBufferEmpty)
        {
            #ifdef DEBUG
            NSLog(@"playbackBufferEmpty");
            #endif
            [self pausePlayer];
        }
    }
    
    else if (object == _audioStreamPlayerItem && [keyPath isEqualToString:@"playbackLikelyToKeepUp"])
    {
        if (_audioStreamPlayerItem.playbackLikelyToKeepUp)
        {
            #ifdef DEBUG
            NSLog(@"playbackLikelyToKeepUp");
            #endif
        }
    }
    
}

// Save and restore position if audio was interruped but could be restored
- (void)handleAudioSessionInterruption:(NSNotification*)notification {
    
    NSNumber *_interruptionType = [[notification userInfo] objectForKey:AVAudioSessionInterruptionTypeKey];
    NSNumber *_interruptionOption = [[notification userInfo] objectForKey:AVAudioSessionInterruptionOptionKey];
    
    switch (_interruptionType.unsignedIntegerValue) {
        case AVAudioSessionInterruptionTypeBegan:{
            [self pausePlayer];
        } break;
        case AVAudioSessionInterruptionTypeEnded:{
            if (_interruptionOption.unsignedIntegerValue == AVAudioSessionInterruptionOptionShouldResume) {
                [self playPlayer];
            }
        } break;
        default:
            break;
    }
}

// Reset player after it was abruptly closed
- (void)handleMediaServicesReset {
    [self playPlayer];
}

// Method of setting volume slider it's color instead of using images
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 2.0f, 2.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

// Handing remote controls from the control center
- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent {
    
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        switch (receivedEvent.subtype) {
            case UIEventSubtypeRemoteControlPlay:
                [self playPlayer];
                break;
            case UIEventSubtypeRemoteControlPause:
                [self pausePlayer];
                break;
            default:
                break;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

@end

// Subclassing the MPVolumeView
@implementation SystemVolumeView

- (CGRect)volumeSliderRectForBounds:(CGRect)bounds {
    
    return bounds;
}

@end