//
//  HomeViewController.m
//  Blink
//
//  Created by Akshat on 16/09/13.
//  Copyright (c) 2013 Akshat. All rights reserved.
//

#import "HomeViewController.h"
#import "ScoresViewController.h"
#import "SettingsViewController.h"
#import "PlayViewController.h"
#import "TutorialViewController.h"
#import "Share.h"
#import "ViewUtil.h"
#import "SettingsData.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize highScoresButton,playButton,highScoresImageButton,playImageButton,settingsButton,settingsImageButton,shareButton,shareImageButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [UIView animateWithDuration:0.5f delay:0.0f options:(UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat | UIViewAnimationOptionAllowUserInteraction) animations:^{
        self.playImageButton.transform = CGAffineTransformMakeScale(1.5f, 1.5f);
    } completion:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)playButtonClicked:(id)sender{
    if([SettingsData getTutorial]){
        TutorialViewController *tvc = [[TutorialViewController alloc]initWithNibName:@"TutorialViewController" bundle:Nil];
        [ViewUtil setSizeAndCenterFromParent:self toChild:tvc];
        [self.navigationController pushViewController:tvc animated:YES];
    }else{
        PlayViewController *pvc = [[PlayViewController alloc]initWithNibName:@"PlayViewController" bundle:Nil];
        [ViewUtil setSizeAndCenterFromParent:self toChild:pvc];
        [self.navigationController pushViewController:pvc animated:YES];
    }
}

-(IBAction)settingsButtonClicked:(id)sender{
    SettingsViewController *svc = [[SettingsViewController alloc]initWithNibName:@"SettingsViewController" bundle:Nil];
    [ViewUtil setSizeAndCenterFromParent:self toChild:svc];
    [self presentViewController:svc animated:YES completion:^(void){}];
}

-(IBAction)highScoresButtonClicked:(id)sender{
    ScoresViewController *hsvc = [[ScoresViewController alloc]initWithNibName:@"ScoresViewController" bundle:nil];
    [ViewUtil setSizeAndCenterFromParent:self toChild:hsvc];
    [self presentViewController:hsvc animated:YES completion:^(void){}];
}

-(IBAction)shareButtonClicked:(id)sender{
    [self presentViewController:[Share shareText:@"temp"] animated:YES completion:^(void){}];
}

-(IBAction)buttonPressed:(id)sender{
    if([sender isEqual:playButton]||[sender isEqual:playImageButton]){
        playImageButton.highlighted = YES;
        playButton.highlighted = YES;
    }
    if([sender isEqual:shareButton]||[sender isEqual:shareImageButton]){
        shareImageButton.highlighted = YES;
        shareButton.highlighted = YES;
    }
    if([sender isEqual:highScoresButton]||[sender isEqual:highScoresImageButton]){
        highScoresImageButton.highlighted = YES;
        highScoresButton.highlighted = YES;
    }
    if([sender isEqual:settingsButton]||[sender isEqual:settingsImageButton]){
        settingsImageButton.highlighted = YES;
        settingsButton.highlighted = YES;
    }
}

-(IBAction)buttonReleased:(id)sender{
    if([sender isEqual:playButton]||[sender isEqual:playImageButton]){
        playImageButton.highlighted = NO;
        playButton.highlighted = NO;
    }
    if([sender isEqual:shareButton]||[sender isEqual:shareImageButton]){
        shareImageButton.highlighted = NO;
        shareButton.highlighted = NO;
    }
    if([sender isEqual:highScoresButton]||[sender isEqual:highScoresImageButton]){
        highScoresImageButton.highlighted = NO;
        highScoresButton.highlighted = NO;
    }
    if([sender isEqual:settingsButton]||[sender isEqual:settingsImageButton]){
        settingsImageButton.highlighted = NO;
        settingsButton.highlighted = NO;
    }
}

@end
