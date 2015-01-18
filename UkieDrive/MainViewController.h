//
//  ViewController.h
//  UkieDrive
//
//  Created by Admin on 1/15/15.
//  Copyright (c) 2015 Igor Zhariy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVFoundation/AVAudioPlayer.h"
#import "AVFoundation/AVFoundation.h"

@interface MainViewController : UIViewController
{
    UIImage *_playButtonImage;
    UIImage *_pauseButtonImage;
    
    UIButton *_playButton;
    UIButton *_pauseButton;
    
}

@property (strong, nonatomic) AVPlayer *_audioPlayer;

@end

