//
//  ViewController.h
//  UkieDrive
//
//  Created by Admin on 1/15/15.
//  Copyright (c) 2015 Igor Zhariy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVFoundation/AVFoundation.h"
#import "MediaPlayer/MediaPlayer.h"
#import "Reachability.h"

@interface SystemVolumeView : MPVolumeView

@end

@interface MainViewController : UIViewController
{
    // AVPlayer
    AVPlayer *_audioPlayer;
    AVPlayerItem *_audioStreamPlayerItem;
    
    // Labels
    UILabel *_liveBroadcastLabel;
    UILabel *_timePlayingLabel;
    
    // Images
    UIImage *_playButtonImage;
    UIImage *_pauseButtonImage;
    UIImage *_emptyButtonImage;
    UIImage *_spinnerImage;
    UIImage *_clockImage;
    
    // Image Views
    UIImageView *_clockImageView;
    UIImageView *_spinnerImageView;
    
    // Buttons
    UIButton *_playButton;
    UIButton *_pauseButton;
    UIButton *_emptyButton;
    
    // Volume slider
    SystemVolumeView *_volumeSlider;
    
    // Elapsed time timer
    NSTimer *_timer;
    NSTimer *_streamTimeout;
    
    // Internet availability
    Reachability *_reach;
    
    // Alert View
    UIAlertView *_noInternetAlert;
    UIAlertView *_noStreamAlert;
    
    // Variables
    int _elapsedSeconds;
    BOOL _availableInternet;
    BOOL _spinning;
}

@end

