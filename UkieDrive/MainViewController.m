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

@synthesize _audioPlayer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [self initPlayer];
        [self initView];
        
    }
    return self;
}

- (void)initView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIView *_blueTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _bounds.size.width, _bounds.size.height * 1/10)];
    _blueTop.backgroundColor = UIColorFromRGB(0x42adde);
    [self.view addSubview:_blueTop];
    
    UIView *_blueTopGradient = [[UIView alloc] initWithFrame:CGRectMake(0.0f, _bounds.size.height * 1/10, _bounds.size.width, _bounds.size.height * 2/10)];
    CAGradientLayer *_blueGradient = [CAGradientLayer layer];
    _blueGradient.frame = _blueTopGradient.bounds;
    _blueGradient.colors = [NSArray arrayWithObjects:(id)[UIColorFromRGB(0x42adde) CGColor], (id)[[UIColor whiteColor] CGColor], nil];
    [_blueTopGradient.layer insertSublayer:_blueGradient atIndex:0];
    [self.view addSubview:_blueTopGradient];
    
    UIView *_yellowBottomGradient = [[UIView alloc] initWithFrame:CGRectMake(0.0f, _bounds.size.height * 5/10, _bounds.size.width, _bounds.size.height * 2/10)];
    CAGradientLayer *_yellowGradient = [CAGradientLayer layer];
    _yellowGradient.frame = _yellowBottomGradient.bounds;
    _yellowGradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[UIColorFromRGB(0xffd600) CGColor], nil];
    [_yellowBottomGradient.layer insertSublayer:_yellowGradient atIndex:0];
    [self.view addSubview:_yellowBottomGradient];
    
    UIView *_yellowBottom = [[UIView alloc] initWithFrame:CGRectMake(0, _bounds.size.height * 7/10, _bounds.size.width, _bounds.size.height * 3/10)];
    _yellowBottom.backgroundColor = UIColorFromRGB(0xffd600);
    [self.view addSubview:_yellowBottom];
    
    CGFloat _logoWidth = 0;
    CGFloat _logoHeight = 0;
    
    if (_iPhone6Plus)
    {
        _logoWidth = 384;
        _logoHeight = 186;
        _playButtonImage = [UIImage imageNamed:@"play@3x.png"];
        _pauseButtonImage = [UIImage imageNamed:@"pause@3x.png"];

    }
    if (_iPhone6)
    {
        _logoWidth = 345;
        _logoHeight = 167;
        _playButtonImage = [UIImage imageNamed:@"play@2x-667.png"];
        _pauseButtonImage = [UIImage imageNamed:@"pause@2x-667.png"];
    }
    if (_iPhone5 || _iPhone4)
    {
        _logoWidth = 290;
        _logoHeight = 140;
        _playButtonImage = [UIImage imageNamed:@"play.png"];
        _pauseButtonImage = [UIImage imageNamed:@"pause.png"];
    }
    
    UIImage *_logo = [UIImage imageNamed:@"logo.png"];
    UIImageView *_logoView = [[UIImageView alloc] initWithImage:_logo];
    _logoView.frame = CGRectMake(15, _bounds.size.height * 2.5/10, _logoWidth, _logoHeight);
    [self.view addSubview:_logoView];
    
    
    
    CGRect _playButtonRect = CGRectMake((_bounds.size.width - _playButtonImage.size.width) / 2, _bounds.size.height * 0.75, _playButtonImage.size.width, _playButtonImage.size.height);
    _playButton = [[UIButton alloc] initWithFrame:_playButtonRect];
    [_playButton setImage:_playButtonImage forState:UIControlStateNormal];
    [_playButton setImage:_playButtonImage forState:UIControlStateHighlighted];
    [_playButton addTarget:self action:@selector(playRadio) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_playButton];
    
    
    _pauseButton = [[UIButton alloc] initWithFrame:_playButtonRect];
    [_pauseButton setImage:_pauseButtonImage forState:UIControlStateNormal];
    [_pauseButton setImage:_pauseButtonImage forState:UIControlStateHighlighted];
    [_pauseButton addTarget:self action:@selector(pauseRadio) forControlEvents:UIControlEventTouchUpInside];
    _pauseButton.hidden = YES;
    [self.view addSubview:_pauseButton];
    
    
    
}

- (void)initPlayer
{
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
        NSURL *_streamUrl = [NSURL URLWithString:@"http://192.99.0.170/proxy/beukrain?mp=/stream"];
        NSLog(@"path = %@", _streamUrl);
        //NSData *_audioStream = [NSData dataWithContentsOfURL:_streamUrl];
        NSError *_error = nil;
        //_audioPlayer = [[AVAudioPlayer alloc] initWithData:_audioStream error:&_error];
        //[_audioPlayer prepareToPlay];
    _audioPlayer = [[AVPlayer alloc] initWithURL:_streamUrl];
        _audioPlayer.volume = 1.0;
        //[_audioPlayer addObserver:self forKeyPath:@"status" options:0 context:nil];
   // });
}
- (void) observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary  *)change
                        context:(void *)context {
    
    if (object == _audioPlayer && [keyPath isEqualToString:@"status"]) {
        if (_audioPlayer.status == AVPlayerStatusReadyToPlay) {
            [_audioPlayer play];
        }
        if (_audioPlayer.status == AVPlayerStatusFailed) {
            NSLog(@"Something went wrong: %@", _audioPlayer.error);
        }
        
    }
}


- (void)playRadio
{
    [_audioPlayer play];
    _playButton.hidden = YES;
    _pauseButton.hidden = NO;
}

- (void)pauseRadio
{
    [_audioPlayer pause];
    _pauseButton.hidden = YES;
    _playButton.hidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
