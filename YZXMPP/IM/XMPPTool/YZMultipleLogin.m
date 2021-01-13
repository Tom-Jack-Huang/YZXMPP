//
//  YZMultipleLogin.m
//  YZXMPP
//
//  Created by Apple on 2021/1/13.
//

#import "YZMultipleLogin.h"
#import "YZXMPPManage+Message.h"
@implementation YZMultipleLogin

// 发送下线消息，通知其他端自己上线
+ (void)sendOnlineMessage {
    YZIMMessage *msg=[[YZIMMessage alloc]init];
    msg.toUserId = [YZKitConfig defaultConfig].useId.stringValue;
    msg.type = @(kWCMessageTypeMultipleLogin);
    msg.content = @"1";
    [[YZXMPPManage sharedInstance] sendMessage:msg roomName:nil];
}
// 发送下线消息，通知其他端自己下线
+ (void)sendOfflineMessage {
    YZIMMessage *msg=[[YZIMMessage alloc]init];
    msg.toUserId = [YZKitConfig defaultConfig].useId.stringValue;
    msg.type = @(kWCMessageTypeMultipleLogin);
    msg.content = @"0";
    [[YZXMPPManage sharedInstance] sendMessage:msg roomName:nil];
}
@end
