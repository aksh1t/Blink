//
//  SettingsViewController.h
//  Blink
//
//  Created by Akshat on 18/09/13.
//  Copyright (c) 2013 Akshat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, retain) IBOutlet UILabel *tutorialLabel;

@property (nonatomic, retain) IBOutlet UILabel *volumeLabel;

@property (nonatomic, retain) IBOutlet UISlider *mySlider;

@property (nonatomic, retain) IBOutlet UISwitch *mySwitch;

@property (nonatomic, retain) IBOutlet UITextField *myTextField;

- (IBAction)sliderValueChanged:(UISlider *)sender;

- (IBAction)switchValueChanged:(UISwitch *)sender;

- (IBAction)changeMusic:(id)sender;

- (IBAction)touchUpOutsideTextField:(id)sender;

- (IBAction)showAboutPage:(id)sender;

- (IBAction)resetHighscores:(id)sender;

- (IBAction)back:(id)sender;



@end
