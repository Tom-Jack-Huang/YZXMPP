//
//  YZIMMessage.m
//  YZXMPP
//
//  Created by Apple on 2021/1/12.
//

#import "YZIMMessage.h"
#import <XMPPFramework/XMPPFramework.h>
#import <MJExtension/MJExtension.h>
#import "YZKitConfig.h"
@interface YZIMMessage()
@property (nonatomic,strong,readwrite) NSString*  messageId;
@end
@implementation YZIMMessage
+(NSArray *)bg_unionPrimaryKeys{
    return @[@"messageId"];
}

- (NSString *)messageId {
    if (!_messageId) {
        _messageId = [[[XMPPStream generateUUID] stringByReplacingOccurrencesOfString:@"-" withString:@""] lowercaseString];
    }
    return _messageId;
}
//{"fromUserName":"金口","content":"123","fromUserId":"10000003","timeSend":1610427717,"type":1,"toUserId":"10000002","deleteTime":0}
- (NSString *)getMsgJson {
    NSDictionary *dic = @{
        @"fromUserName":[YZKitConfig defaultConfig].userName,
        @"content":self.content,
        @"fromUserId":[YZKitConfig defaultConfig].useId,
        @"timeSend":@([[NSDate date] timeIntervalSince1970]),
        @"type":self.type,
        @"toUserId":self.toUserId,
        @"deleteTime":@(0)
    };
    
    return [dic mj_JSONString];
}
- (void)saveReceiveMessage:(NSDictionary *)dic messageId:(NSString *)msgId chat:(NSString *)chat{
    self.messageId = msgId;
    self.userID = dic[@"fromUserId"];
    /*
     if ([chat isEqualToString:@"chat"]) {//p2p
         self.userID = dic[@"fromUserId"];
     } else 
     */
    if ([chat isEqualToString:@"groupchat"]) {
        self.groupID = dic[@"toUserId"];
    }
    self.type = dic[@"type"];
    self.fromUserId = dic[@"fromUserId"];
    self.fromUserName = dic[@"fromUserName"];
    self.toUserId = dic[@"toUserId"];
    self.toUserName = dic[@"toUserName"];
    self.timeSend = [NSDate dateWithTimeIntervalSince1970:[dic[@"timeSend"] integerValue]];
    self.content = dic[@"content"];
    [self bg_saveOrUpdateAsync:nil];
}
@end
