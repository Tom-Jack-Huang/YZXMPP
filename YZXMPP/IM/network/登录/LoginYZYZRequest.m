//
//  LoginYZYZRequest.m
//  YZXMPP
//
//  Created by Apple on 2021/1/12.
//

#import "LoginYZYZRequest.h"

@implementation LoginYZYZRequest{
    NSString *_password;
    NSString *_telephone;
}

- (instancetype)initWithPassword:(NSString *)password telephone:(NSString *)telephone
{
    self = [super init];
    if (self) {
        _password = password;
        _telephone = telephone;
    }
    return self;
}
- (NSString *)requestUrl {
    return @"/user/login";
}

- (id)requestArgument {
    return @{
        @"password": _password,
        @"telephone": _telephone,
        @"time":@([[NSDate date] timeIntervalSince1970]),
        @"grant_type":@"client_credentials",
        @"appId":[[NSBundle mainBundle] bundleIdentifier],
        @"xmppVersion":@(1)
    };
}
@end
