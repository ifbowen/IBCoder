//
//  IBGroup2Controller12.m
//  MBCoder
//
//  Created by Bowen on 2019/10/29.
//  Copyright © 2019 inke. All rights reserved.
//

#import "IBGroup2Controller12.h"
#import <AVFoundation/AVFoundation.h>
#import <UserNotifications/UserNotifications.h>

@interface IBGroup2Controller12 ()

@end

@implementation IBGroup2Controller12
{
    SystemSoundID _soundFileObject;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [self shake2];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self registerNotificationWithString:@"1004" completeHandler:^{
            
        }];
    });

}

static int i = 0;

- (void)shake2
{
    if (i % 3 == 0) {
        UIImpactFeedbackGenerator *feedBack = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleHeavy];
        [feedBack prepare];
        [feedBack impactOccurred];
        NSLog(@"UIImpactFeedbackGenerator");
    }
    
    if (i % 3 == 1) {
        UINotificationFeedbackGenerator *feedback = [[UINotificationFeedbackGenerator alloc] init];
        [feedback prepare];
        [feedback notificationOccurred:UINotificationFeedbackTypeWarning];
        NSLog(@"UINotificationFeedbackGenerator");
    }
    
    if (i % 3 == 2) {
        UISelectionFeedbackGenerator *feedback = [[UISelectionFeedbackGenerator alloc] init];
        [feedback prepare];
        [feedback selectionChanged];
        NSLog(@"UISelectionFeedbackGenerator");
    }
    
    i++;
}

- (void)shake1
{
    AudioServicesPlaySystemSoundWithCompletion(kSystemSoundID_Vibrate, ^{
        AudioServicesPlaySystemSoundWithCompletion(kSystemSoundID_Vibrate, ^{
            AudioServicesDisposeSystemSoundID(kSystemSoundID_Vibrate);
        });
    });
    
    // 普通短震，3D Touch 中 Peek 震动反馈
    AudioServicesPlaySystemSound(1519);
    
    // 普通短震，3D Touch 中 Pop 震动反馈
    AudioServicesPlaySystemSound(1520);
    
    // 连续三次短震
    AudioServicesPlaySystemSound(1521);
        
}


- (void)soundSpeak2
{
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"1004" ofType:@"m4a"];
    //将地址字符串转换成url
    NSURL *soundURL = [NSURL fileURLWithPath:soundFilePath];
    //生成系统音效id
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL, &_soundFileObject);
    //播放系统音效
    AudioServicesPlaySystemSound(_soundFileObject);
}

- (void)soundSpeak1
{
    [[AVAudioSession sharedInstance] setActive:YES error:NULL];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:NULL];
    NSString *str = [NSString stringWithFormat:@"成功收款%@元", @"100"];
    NSLog(@"bowen %@", str);
    AVSpeechUtterance *utt = [[AVSpeechUtterance alloc] initWithString:str];
    utt.rate = 0.5;
    AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
    utt.volume = 1;
    utt.voice = voice;
    AVSpeechSynthesizer *speaker = [[AVSpeechSynthesizer alloc] init];
    [speaker speakUtterance:utt];
}

- (void)registerNotificationWithString:(NSString *)string completeHandler:(dispatch_block_t)complete {
    
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
        if (granted) {
            
            UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
            
            content.title = @"";
            content.subtitle = @"";
            content.body = @"";
            content.sound = [UNNotificationSound soundNamed:[NSString stringWithFormat:@"%@.m4a",string]];
            
            content.categoryIdentifier = [NSString stringWithFormat:@"categoryIndentifier%@",string];
            
            UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.01 repeats:NO];
            
            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:[NSString stringWithFormat:@"categoryIndentifier%@",string] content:content trigger:trigger];
            
            [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                if (error == nil) {
                    if (complete) {
                        complete();
                    }
                }
            }];
        }
    }];
}

@end
