//
//  AppDelegate.m
//  Blink
//
//  Created by Akshat on 16/09/13.
//  Copyright (c) 2013 Akshat. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import "HomeViewController.h"
#import "ScoresViewController.h"
#import "SettingsData.h"

@implementation AppDelegate

@synthesize audioPlayer;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    HomeViewController *hvc = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
    ScoresViewController *svc = [[ScoresViewController alloc]initWithNibName:@"ScoresViewController" bundle:nil];
    
    UINavigationController *hvcnav = [[UINavigationController alloc]initWithRootViewController:hvc];
    [hvcnav setNavigationBarHidden:YES];
    UINavigationController *svcnav = [[UINavigationController alloc]initWithRootViewController:svc];
    [svcnav setNavigationBarHidden:NO];
    
    self.window.rootViewController = hvcnav;
    
    [SettingsData loadData];
    
    [self.window makeKeyAndVisible];
    
//Audio
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"keyboardloop" ofType:@"wav"];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: path];
    AVPlayerItem *music1 = [[AVPlayerItem alloc]initWithURL:fileURL];
    
    path = [[NSBundle mainBundle] pathForResource:@"easylemon" ofType:@"mp3"];
    fileURL = [[NSURL alloc] initFileURLWithPath: path];
    AVPlayerItem *music2 = [[AVPlayerItem alloc]initWithURL:fileURL];
    
    path = [[NSBundle mainBundle] pathForResource:@"moonlightmining" ofType:@"mp3"];
    fileURL = [[NSURL alloc] initFileURLWithPath: path];
    AVPlayerItem *music3 = [[AVPlayerItem alloc]initWithURL:fileURL];
    
    NSArray *itemList = [[NSArray alloc]initWithObjects:music1,music2,music3, nil];
    
    audioPlayer=[[AVQueuePlayer alloc] initWithItems:itemList];
    
    [SettingsData setAudioPlayer:audioPlayer];
    
    audioPlayer.volume = [SettingsData getVolume];
	
	if (audioPlayer == nil)
		NSLog(@"error");
	else
		[audioPlayer play];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
