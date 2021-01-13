//
//  YZXMPPManage+Message.m
//  YZXMPP
//
//  Created by Apple on 2021/1/11.
//

#import "YZXMPPManage+Message.h"
#import <MJExtension/MJExtension.h>
@implementation YZXMPPManage (Message)

#pragma mark-XMPPStreamDelegate
/* *********************************       接受消息           *************************************** */
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {

    NSString* messageId = [[message attributeForName:@"id"] stringValue];
    if([message.type isEqualToString:@"chat"] || [message.type isEqualToString:@"groupchat"]) {
        NSDictionary *dic = [message.body mj_JSONObject];
        YZIMMessage *msg = [[YZIMMessage alloc]init];
        [msg saveReceiveMessage:dic messageId:messageId chat:message.type];
        if(self.delegate && [self.delegate respondsToSelector:@selector(didReceiveMessage:)]) {
            [self.delegate didReceiveMessage:msg];
        }
    }
}
- (void) sendMsgReceipt:(XMPPMessage *)message{//单聊发送消息回执

    if([message hasReceiptRequest]){//离线也发送回执，这样服务器可以确保消息送达
        XMPPMessage* reply = [message generateReceiptResponse];//发送回执
        [self.yzXMPPStream sendElement:reply];
    }
}
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence {
    
}
- (void)xmppStream:(XMPPStream *)sender didReceiveError:(NSXMLElement*)element {
    NSString *elementName = [element name];
    
    if ([elementName isEqualToString:@"stream:error"]){
        DDXMLNode * errorNode = (DDXMLNode *)element;
        NSArray * errorNodeArray = [errorNode children];
        for (DDXMLNode * node in errorNodeArray) {
            if ([[node name] isEqualToString:@"conflict"]) {
//                self.isReconnect = NO;
//                [_reconnectTimer invalidate];
//                _reconnectTimer = nil;
                NSLog(@"xmpp ---- error");
//                [self logout];
//                [g_notify postNotificationName:kXMPPLoginOtherNotification object:nil];
                return;
            }
        }
    }
    elementName = nil;
}
/* *********************************       发送消息          *************************************** */

- (void)sendMessageInvite:(YZIMMessage *)msg {
//    XMPPMessage *aMessage;
//    [self.yzXMPPStream sendElement:aMessage];
}
//发送消息
- (void)sendMessage:(YZIMMessage *)msg roomName:(NSString*)roomName {
    XMPPMessage *aMessage;
    if (roomName == nil) {//个人
        NSString* to = [NSString stringWithFormat:@"%@@%@",msg.toUserId,self.yzXMPPStream.hostName];
        aMessage=[XMPPMessage messageWithType:@"chat" to:[XMPPJID jidWithString:to]];
        to   = nil;
    } else {//群组
        NSString* roomJid = [NSString stringWithFormat:@"%@@muc.%@",roomName,self.yzXMPPStream.hostName];
        aMessage=[XMPPMessage messageWithType:@"groupchat" to:[XMPPJID jidWithString:roomJid]];
        roomJid = nil;
    }
    [aMessage addAttributeWithName:@"id" stringValue:msg.messageId];
    
    if ([YZKitConfig defaultConfig].isOpenReceipt || [msg.type intValue] == kWCMessageTypeMultipleLogin) {
        NSXMLElement * request = [NSXMLElement elementWithName:@"request" xmlns:@"urn:xmpp:receipts"];
        [aMessage addChild:request];
        request = nil;
    }

    
    NSString *jsonString = [msg getMsgJson];
    
    DDXMLNode* node = [DDXMLNode elementWithName:@"body" stringValue:jsonString];
    [aMessage addChild:node];
    node = nil;

    NSLog(@"sendMessage:%@,%@",msg.messageId,jsonString);

    [self.yzXMPPStream sendElement:aMessage];
}
//消息发送失败
- (void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error {
    
}

@end
