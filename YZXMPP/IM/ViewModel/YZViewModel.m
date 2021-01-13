//
//  YZViewModel.m
//  YZXMPP
//
//  Created by Apple on 2021/1/12.
//

#import "YZViewModel.h"
#import "LoginYZYZRequest.h"
#import <CocoaSecurity/CocoaSecurity.h>
#import "UserInfo.h"
#import "YZHeader.h"
@implementation YZViewModel
+ (void)loginPassword:(NSString *)password telephone:(NSString *)telephone suc:(sucBlock)suc err:(failBlock)err{

    CocoaSecurityResult *passwordmd5 = [CocoaSecurity md5:password];
    CocoaSecurityResult *telephonemd5 = [CocoaSecurity md5:telephone];
    LoginYZYZRequest *loginYZYZRequest = [[LoginYZYZRequest alloc]initWithPassword:passwordmd5.hexLower telephone:telephonemd5.hexLower];
    [loginYZYZRequest yzStartWithCompletionBlockWithSuccess:^(id object) {
        [[NSUserDefaults standardUserDefaults] setValue:object[@"userId"] forKey:kMY_USER_ID];
        [[NSUserDefaults standardUserDefaults] synchronize];
        UserInfo *info = [[UserInfo alloc]init];
        info.useId = object[@"userId"];
        info.access_token = object[@"access_token"];
        info.userName = object[@"nickname"];
        info.telephone = telephone;
        info.password = password;
        [info bg_saveOrUpdateAsync:^(BOOL isSuccess) {
            suc?suc(object):nil;
        }];
        
    } failure:^(NSString *error) {
        err?err(error):nil;
    }];
}
@end
