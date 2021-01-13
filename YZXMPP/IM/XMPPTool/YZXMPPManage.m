//
//  YZXMPPManage.m
//  YZXMPP
//
//  Created by Apple on 2021/1/11.
//

#import "YZXMPPManage.h"
#import <YTKNetwork/YTKNetwork.h>
#import "YZViewModel.h"
#import "YZMultipleLogin.h"
@interface YZXMPPManage()
@property (nonatomic, strong,readwrite) XMPPStream *yzXMPPStream;
/**
 心跳包
 */
@property (nonatomic, strong) XMPPAutoPing *yzXMPPAutoPing;
/**
 重连
 */
@property (nonatomic, strong) XMPPReconnect *yzXMPPReconnect;

@property (nonatomic, strong) XMPPRoster *yzXMPPRoster;

@property (nonatomic, strong) XMPPStreamManagement *yzXMPPStreamManagement;

@property (nonatomic, strong) NSString *password;

@property (nonatomic, strong) NSString *userId;

@property (nonatomic, assign) int pingTimeoutCount;

@property (nonatomic, copy) TFail fail;

@property (nonatomic, copy) TSucc succ;

@end
@implementation YZXMPPManage
+ (instancetype)sharedInstance
{
    static YZXMPPManage *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[YZXMPPManage alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
        config.baseUrl = [NSString stringWithFormat:@"%@:%@",[YZKitConfig defaultConfig].IMHost,[YZKitConfig defaultConfig].IMPort];

        
        [self.yzXMPPStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return self;
}
- (void)dealloc
{
    NSLog(@"YZXMPPManage销毁了");
    [_yzXMPPAutoPing removeDelegate:self];
    [_yzXMPPStreamManagement removeDelegate:self];
    [_yzXMPPReconnect removeDelegate:self];
    [_yzXMPPReconnect         deactivate];
    
    [self.yzXMPPStream disconnect];
    
    self.yzXMPPStream = nil;
    _yzXMPPReconnect = nil;
}

- (void)setupStreamWithHostName:(NSString *)hostName hostPort:(int)hostPort {
    NSLog(@"%@---%@",hostName,@(hostPort));
    
    self.yzXMPPStream.hostName = hostName;
    self.yzXMPPStream.hostPort = hostPort;
    
}
//需要从服务器获取用户数据
- (void)login:(NSString *)telephone password:(NSString *)password succ:(TSucc)succ fail:(TFail)fail {
    
    [YZViewModel loginPassword:password telephone:telephone suc:^(NSDictionary *object) {
        
        [self autoLogin:[YZKitConfig defaultConfig].useId.stringValue succ:succ fail:fail];
    } err:^(NSString *error) {
        fail?fail(error):nil;
    }];
    
}
//需要从本地数据库获取用户数据
- (void)autoLogin:(NSString *)userID succ:(TSucc)succ fail:(TFail)fail {
    self.succ = succ;
    self.fail = fail;
    if ([self.yzXMPPStream isConnected]) {
        [self.yzXMPPStream disconnect];
    }
    self.userId = userID;
    self.password = [YZKitConfig defaultConfig].password;
    NSLog(@"%@",userID);
    NSLog(@"%@",self.password);
    XMPPJID *myJID = [XMPPJID jidWithUser:userID domain:self.yzXMPPStream.hostName resource:@"ios"];
    
    [self.yzXMPPStream setMyJID:myJID];
    
    NSError *error = nil;
    [self.yzXMPPStream connectWithTimeout:10 error:&error];
    if (error) {
        NSLog(@"connectWithTimeout:%@",error.localizedDescription);
        self.fail?self.fail(error.localizedDescription):nil;
        return;
    }
}
- (void)logout {
    [self disconnect];
}
- (void)doLogin {
    [self goOnline];
    
    [self.yzXMPPRoster fetchRoster];//获取花名册
    [_yzXMPPStreamManagement enableStreamManagementWithResumption:YES maxTimeout:60];
    //    [_xmppStreamManagement requestAck];
    [_yzXMPPStreamManagement sendAck];
    
    [YZMultipleLogin sendOnlineMessage];
}
- (void)disconnect
{
    // 离线前发送消息通知其他端
    [YZMultipleLogin sendOfflineMessage];
    
    [self goOffline];
    [self.yzXMPPStream disconnect];
}
- (void)goOnline
{
    XMPPPresence *presence = [XMPPPresence presence]; // type="available" is implicit
    
    [self.yzXMPPStream sendElement:presence];
}

- (void)goOffline
{
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    
    [self.yzXMPPStream sendElement:presence];
}

#pragma mark-XMPPStreamDelegate

- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket {
    NSLog(@"socketDidConnect:%@",sender);
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(onConnectSuccess)]) {
        [self.delegate onConnectSuccess];
    }
    NSError *error = nil;
    [self.yzXMPPStream authenticateWithPassword:self.password error:&error];
    if (error) {
        NSLog(@"认证错误：%@",[error localizedDescription]);
        self.fail?self.fail(error.localizedDescription):nil;
    }//e10adc3949ba59abbe56e057f20f883e d41d8cd98f00b204e9800998ecf8427e
}

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings {
    NSLog(@"willSecureWithSettings:%@",sender);
}
- (void)xmppStreamDidSecure:(XMPPStream *)sender {
    NSLog(@"xmppStreamDidSecure:%@",sender);
}
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    NSLog(@"登陆成功");
    [self doLogin];
    self.succ?self.succ():nil;
}
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error {
    NSLog(@"didNotAuthenticate:%@",error);
    if (error) {
        self.fail?self.fail(error.localName):nil;
    }
    
}
- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq {
    return NO;
}
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error {
    NSLog(@"didNotAuthenticate:%@",error);
    [self goOffline];
    if(self.delegate && [self.delegate respondsToSelector:@selector(onConnectFailedErr:)]) {
        [self.delegate onConnectFailedErr:error.localizedDescription];
    }
}
#pragma mark XMPPRosterDelegate
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    
    XMPPJID *jid=[XMPPJID jidWithString:[presence stringValue]];
    [self.yzXMPPRoster acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];
}

- (void)addSomeBody:(NSString *)userId
{
    [self.yzXMPPRoster subscribePresenceToUser:[XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",userId,self.yzXMPPStream.hostName]]];
}
#pragma mark XMPPStreamManagementDelegate
- (void)xmppStreamManagement:(XMPPStreamManagement *)sender wasEnabled:(NSXMLElement *)enabled {
    
}
- (void)xmppStreamManagement:(XMPPStreamManagement *)sender wasNotEnabled:(NSXMLElement *)failed {
    
}
//消息回执，已读判断
- (void)xmppStreamManagement:(XMPPStreamManagement *)sender didReceiveAckForStanzaIds:(NSArray<id> *)stanzaIds {
    
}
- (BOOL)xmppReconnect:(XMPPReconnect *)sender shouldAttemptAutoReconnect:(SCNetworkConnectionFlags)connectionFlags {
    
    return YES;
}
#pragma mark - XMPPAutoPingDelegate
//收到心跳
- (void)xmppAutoPingDidReceivePong:(XMPPAutoPing *)sender {
    if (self.pingTimeoutCount>0) {
        self.pingTimeoutCount = 0;
    }
}
//心跳链接超时
- (void)xmppAutoPingDidTimeout:(XMPPAutoPing *)sender {
    self.pingTimeoutCount++;
    if (self.pingTimeoutCount >5) {//超时
        [self goOffline];
        if(self.delegate && [self.delegate respondsToSelector:@selector(onConnectFailedErr:)]) {
            [self.delegate onConnectFailedErr:@"心跳链接超时"];
        }
    }
}
#pragma mark-lazy

- (XMPPStream *)yzXMPPStream {
    if (!_yzXMPPStream) {
        _yzXMPPStream = [[XMPPStream alloc]init];
        
        
       
    }
    return _yzXMPPStream;
}

@end
