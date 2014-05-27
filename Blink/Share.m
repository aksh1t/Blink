#import "Share.h"

@implementation Share

+ (UIActivityViewController *)shareText:(NSString *)string
{
    NSMutableArray *sharingItems = [NSMutableArray new];
    
    if (string) {
        [sharingItems addObject:string];
    }
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
    
    return activityController;
}

@end
