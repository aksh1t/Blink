//
//  PlayViewController.h
//  Blink
//
//  Created by Akshat on 18/09/13.
//  Copyright (c) 2013 Akshat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "JDFlipNumberView.h"

@interface PlayViewController : UIViewController
<UIGestureRecognizerDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>{
    
    IBOutlet UILabel *count;
    IBOutlet UILabel *facedetected;
    IBOutlet UILabel *capdrop;
    IBOutlet UILabel *timerCount;
    IBOutlet UILabel *resultLabel;
    JDFlipNumberView *flipNumberView;
    int tcount;
    int fcount;
    int blinkcount;
    int capture;
    int drop;
    int startframecount;
    BOOL detect;
    NSTimer *timer;
    
}

@property (nonatomic, weak) IBOutlet UIView *previewView;

- (IBAction)back:(id)sender;
- (IBAction)start:(id)sender;

@end
