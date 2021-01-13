//
//  YZKitConfig.m
//  YZXMPP
//
//  Created by Apple on 2021/1/11.
//

#import "YZKitConfig.h"
#import "UserInfo.h"
#import "YZHeader.h"
#import <CocoaSecurity/CocoaSecurity.h>
@implementation YZKitConfig
- (id)init
{
    self = [super init];
    if(self){
        bg_setDebug(NO);//打开调试模式,打印输出调试信息.
        self.pingInterval = 6;
        self.isOpenReceipt = YES;
        self.IMHost = @"http://192.168.0.120";
        self.IMPort = @"8080";
    }
    return self;
}

+ (instancetype)defaultConfig
{
    static dispatch_once_t onceToken;
    static YZKitConfig *config;
    dispatch_once(&onceToken, ^{
        config = [[YZKitConfig alloc] init];
    });
    return config;
}

- (NSNumber *)useId {
    if (_useId == nil) {
        _useId = [[NSUserDefaults standardUserDefaults]objectForKey:kMY_USER_ID];
    }
    return _useId;
}
- (NSString *)userName {
    if (!_userName) {
        NSArray *array = [UserInfo bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",bg_sqlKey(@"useId"),bg_sqlValue(self.useId)]];
        UserInfo *info = [array firstObject];
        if (info && info.userName) {
            _userName = info.userName;
        } else {
            _userName = @"";
        }
    }
    return _userName;
}
- (NSString *)access_token {
    if (!_access_token) {
        NSArray *array = [UserInfo bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",bg_sqlKey(@"useId"),bg_sqlValue(self.useId)]];
        UserInfo *info = [array firstObject];
        if (info && info.access_token) {
            _access_token = info.access_token;
        } else {
            _access_token = @"";
        }
    }
    return _access_token;
}
- (NSString *)password {
    if (!_password) {
        NSArray *array = [UserInfo bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",bg_sqlKey(@"useId"),bg_sqlValue(self.useId)]];
        UserInfo *info = [array firstObject];
        if (info && info.password) {
            CocoaSecurityResult *passwordmd5 = [CocoaSecurity md5:info.password];
            _password = passwordmd5.hexLower;
        } else {
            _password = @"";
        }
    }
    return _password;
}
@end
