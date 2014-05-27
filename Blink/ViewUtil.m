//
//  ViewUtil.m
//  Blink
//
//  Created by Akshat on 18/09/13.
//  Copyright (c) 2013 Akshat. All rights reserved.
//

#import "ViewUtil.h"

@implementation ViewUtil

+ (void)setSizeAndCenterFromParent:(UIViewController *)parent toChild:(UIViewController *)child{
    
    [child.view setBounds:CGRectMake(0,0,parent.view.bounds.size.width,parent.view.bounds.size.height)];
    child.view.center = parent.view.center;

}

@end
