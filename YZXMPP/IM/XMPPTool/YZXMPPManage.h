//
//  YZXMPPManage.h
//  YZXMPP
//
//  Created by Apple on 2021/1/11.
//

#import <Foundation/Foundation.h>
#import <XMPPFramework/XMPPFramework.h>
#import "YZKitConfig.h"
#import "YZIMMessage.h"
typedef void (^TFail)(NSString * msg);
typedef void (^TSucc)(void);

@protocol YZXMPPManageDelegate <NSObject>
@optional

/// SDK 已经成功连接到服务器
- (void)onConnectSuccess;

/// SDK 连接服务器失败
- (void)onConnectFailedErr:(NSString*)err;

/// 当前用户被踢下线，
- (void)onKickedOffline;

- (void)didReceiveMessage:(YZIMMessage *)msg;


@end


@interface YZXMPPManage : NSObject
+ (instancetype)sharedInstance;

@property (nonatomic, strong,readonly) XMPPStream *yzXMPPStream;

@property(nonatomic,weak)id<YZXMPPManageDelegate>delegate;

- (void)setupStreamWithHostName:(NSString *)hostName hostPort:(int)hostPort;

- (void)login:(NSString *)telephone password:(NSString *)password succ:(TSucc)succ fail:(TFail)fail;

- (void)autoLogin:(NSString *)userID succ:(TSucc)succ fail:(TFail)fail;

- (void)logout;

@end

