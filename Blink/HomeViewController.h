//
//  HomeViewController.h
//  Blink
//
//  Created by Akshat on 16/09/13.
//  Copyright (c) 2013 Akshat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIButton *highScoresButton;

@property (nonatomic, retain) IBOutlet UIButton *highScoresImageButton;

@property (nonatomic, retain) IBOutlet UIButton *shareButton;

@property (nonatomic, retain) IBOutlet UIButton *shareImageButton;

@property (nonatomic, retain) IBOutlet UIButton *playButton;

@property (nonatomic, retain) IBOutlet UIButton *playImageButton;

@property (nonatomic, retain) IBOutlet UIButton *settingsButton;

@property (nonatomic, retain) IBOutlet UIButton *settingsImageButton;

- (IBAction)buttonPressed:(id)sender;

- (IBAction)buttonReleased:(id)sender;

- (IBAction)playButtonClicked:(id)sender;

- (IBAction)settingsButtonClicked:(id)sender;

- (IBAction)highScoresButtonClicked:(id)sender;

- (IBAction)shareButtonClicked:(id)sender;

@end
