//
//  AudioUtility.m
//  MyCount
//
//  Created by forrest on 13-10-19.
//  Copyright (c) 2013年 Forrest Shi. All rights reserved.
//

#import "AudioUtility.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation AudioUtility

+(instancetype)sharedInstance{
    static AudioUtility *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [AudioUtility new];
    });
    return instance;
}

-(void) playSound:(NSString*)fileName withType:(NSString*)fileType{
    BOOL soundOn = [[NSUserDefaults standardUserDefaults] boolForKey:@"sound"];
    if (soundOn) {
        NSString *soundPath = [[NSBundle mainBundle] pathForResource:fileName ofType:fileType];
        if (!soundPath) {
            return;
        }
        SystemSoundID soundID;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath: soundPath], &soundID);
        AudioServicesPlaySystemSound (soundID);
    }
}

@end
