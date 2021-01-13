//
//  YZXMPPManage+Message.h
//  YZXMPP
//
//  Created by Apple on 2021/1/11.
//

#import "YZXMPPManage.h"
#import "YZIMMessage.h"


@interface YZXMPPManage (Message)
/**
 发送邀请消息
 */
- (void)sendMessageInvite:(YZIMMessage *)msg;
/**
 发送消息
 */
- (void)sendMessage:(YZIMMessage *)msg roomName:(NSString*)roomName;


@end


