//
//  AppDelegate.h
//  Blink
//
//  Created by Akshat on 16/09/13.
//  Copyright (c) 2013 Akshat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic,retain) AVQueuePlayer *audioPlayer;

@property (strong, nonatomic) UIWindow *window;

@end
