#import "SettingsViewController.h"
#import "AboutViewController.h"
#import "SettingsData.h"


@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize mySlider,mySwitch,myTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [myTextField setText: [SettingsData getDefaultPlayer]];
    [mySwitch setOn: [SettingsData getTutorial]];
    [mySlider setValue: [SettingsData getVolume]];
    
    [self.volumeLabel setText:[NSString stringWithFormat:@"Volume : %d%%",(int)(mySlider.value*100)]];
    if([self.mySwitch isOn]){
        [self.tutorialLabel setText:@"Show Guidelines : ON"];
    }else{
        [self.tutorialLabel setText:@"Show Guidelines : OFF"];
    }

}

- (void) viewDidAppear:(BOOL)animated{
    [myTextField setText: [SettingsData getDefaultPlayer]];
    [mySwitch setOn: [SettingsData getTutorial]];
    [mySlider setValue: [SettingsData getVolume]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sliderValueChanged:(UISlider *)slider{
    [self.volumeLabel setText:[NSString stringWithFormat:@"Volume : %d%%",(int)(mySlider.value*100)]];
    [SettingsData setVolume:slider.value];
    [SettingsData saveData];
}

- (IBAction)switchValueChanged:(UISwitch *)sender{
    if(sender.isOn){
        [self.tutorialLabel setText:@"Show Guidelines : ON"];
    }else{
        [self.tutorialLabel setText:@"Show Guidelines : OFF"];
    }
    
    [SettingsData setTutorial:sender.isOn];
    [SettingsData saveData];
}

- (IBAction)touchUpOutsideTextField:(id)sender{
    [sender endEditing:YES];
}

- (IBAction)showAboutPage:(id)sender{
    AboutViewController *avc = [[AboutViewController alloc]initWithNibName:@"AboutViewController" bundle:nil];
    [self presentViewController:avc animated:YES completion:^(void){}];
}

- (IBAction)resetHighscores:(id)sender{
    [SettingsData setScore:NULL];
    [SettingsData saveData];
    UIAlertView *confirmation = [[UIAlertView alloc]initWithTitle:@"Highscores Reset" message:@"All the highscores have been successfully reset." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [confirmation show];
}

- (IBAction)back:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^(void){}];
}

- (IBAction)changeMusic:(id)sender{
    [[SettingsData getAudioPlayer]advanceToNextItem];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    [SettingsData setDefaultPlayer:textField.text];
    [SettingsData saveData];
    
    return YES;
}


@end
