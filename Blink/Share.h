//
//  Share.h
//  Blink
//
//  Created by Akshat on 18/09/13.
//  Copyright (c) 2013 Akshat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Share : NSObject

+ (UIActivityViewController *)shareText:(NSString *)string;

@end
