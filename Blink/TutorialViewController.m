//
//  TutorialViewController.m
//  Blink
//
//  Created by Akshat on 18/09/13.
//  Copyright (c) 2013 Akshat. All rights reserved.
//

#import "TutorialViewController.h"
#import "PlayViewController.h"

@interface TutorialViewController ()

@end

@implementation TutorialViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)back:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)play:(id)sender{
    
    PlayViewController *pvc = [[PlayViewController alloc]initWithNibName:@"PlayViewController" bundle:nil];
    [self.navigationController pushViewController:pvc animated:YES];
}

@end
