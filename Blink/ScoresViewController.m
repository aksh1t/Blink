//  ScoresViewController.m
//  Blink
//
//  Created by Akshat on 16/09/13.
//  Copyright (c) 2013 Akshat. All rights reserved.

#import "ScoresViewController.h"
#import "SettingsData.h"

@interface ScoresViewController ()

@end

@implementation ScoresViewController

@synthesize cancelButton,scoreList;

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
    self.title = @"High Scores";
    scoreList = [SettingsData getScore];
}

- (void)viewDidAppear:(BOOL)animated{
    scoreList = [SettingsData getScore];
    [myTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButtonClicked:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^(void){}];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return scoreList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    NSArray *cellarray = [[NSBundle mainBundle] loadNibNamed:@"Cell" owner:self options:nil];
    cell = [cellarray objectAtIndex:0];
    
    [name setText:[[self.scoreList objectAtIndex:indexPath.row]objectForKey:@"name"]];
    [number setText:[NSString stringWithFormat:@"%d",indexPath.row+1]];
    NSInteger scoreValue = [[[self.scoreList objectAtIndex:indexPath.row]objectForKey:@"score"] integerValue];
    [score setText:[NSString stringWithFormat:@"%d.%d seconds",scoreValue/100,scoreValue%100]];
    
    return cell;
}

@end
