#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>

static BOOL tutorial = TRUE;
static double volume = 1.0;
static NSString *defaultPlayer = @"Player";
static NSMutableArray *scores;

static NSUserDefaults *data;

static AVQueuePlayer *audioPlayer;

@interface SettingsData : NSObject

+ (void)setTutorial:(BOOL)value;

+ (BOOL)getTutorial;

+ (void)setVolume:(double)value;

+ (double)getVolume;

+ (void)setDefaultPlayer:(NSString *)value;

+ (NSString *)getDefaultPlayer;

+ (void)setAudioPlayer:(AVQueuePlayer *)player;

+ (AVQueuePlayer *)getAudioPlayer;

+ (void)setScore:(NSMutableArray *)score;

+ (NSMutableArray *)getScore;

+ (void)saveData;

+ (void)loadData;

@end
