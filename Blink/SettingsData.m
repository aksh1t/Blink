#import "SettingsData.h"

@implementation SettingsData

+ (void)setTutorial:(BOOL)value{
    tutorial = value;
}

+ (BOOL)getTutorial{
    return tutorial;
}

+ (void)setVolume:(double)value{
    volume = value;
    audioPlayer.volume = value;
}

+ (double)getVolume{
    return volume;
}

+ (void)setDefaultPlayer:(NSString *)value{
    defaultPlayer = [NSString stringWithString:value];
}

+ (NSString *)getDefaultPlayer{
    return defaultPlayer;
}

+ (void)setAudioPlayer:(AVQueuePlayer *)player{
    audioPlayer = player;
}

+ (AVQueuePlayer *)getAudioPlayer{
    return audioPlayer;
}

+ (void)setScore:(NSMutableArray *)score{
    scores = score;
}

+ (NSMutableArray *)getScore{
    return scores;
}

+ (void)saveData{
    [data setObject:[NSNumber numberWithBool:tutorial] forKey:@"tutorial"];
    [data setObject:[NSNumber numberWithDouble:volume] forKey:@"volume"];
    [data setObject:defaultPlayer forKey:@"defaultplayer"];
    [data setObject:scores forKey:@"scores"];
    [data synchronize];
}

+ (void)loadData{
    
    data = [NSUserDefaults standardUserDefaults];
    
    if([data objectForKey:@"tutorial"]!=Nil){
        [self setTutorial:[[data objectForKey:@"tutorial"] boolValue]];
        [self setVolume:[[data objectForKey:@"volume"] doubleValue]];
        [self setDefaultPlayer:[data objectForKey:@"defaultplayer"]];
        [self setScore:[data objectForKey:@"scores"]];
    }
    [data synchronize];
}

@end
