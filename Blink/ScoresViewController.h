//
//  ScoresViewController.h
//  Blink
//
//  Created by Akshat on 16/09/13.
//  Copyright (c) 2013 Akshat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoresViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>{
    
    IBOutlet UILabel *number;
    IBOutlet UILabel *name;
    IBOutlet UILabel *score;
    IBOutlet UITableView *myTableView;
    
    NSMutableArray *scoreList;
}

@property (nonatomic, retain) NSMutableArray *scoreList;

@property (nonatomic, retain) IBOutlet UIButton *cancelButton;

-(IBAction)cancelButtonClicked:(id)sender;

@end
