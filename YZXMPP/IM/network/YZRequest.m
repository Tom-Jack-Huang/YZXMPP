//
//  YZRequest.m
//  YZXMPP
//
//  Created by Apple on 2021/1/12.
//

#import "YZRequest.h"

@implementation YZRequest
- (void)yzStartWithCompletionBlockWithSuccess:(sucBlock)success
                                      failure:(failBlock)failure {
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary *dic = request.responseJSONObject;
        if ([dic[@"resultCode"] intValue] == 1) {
            success?success(dic[@"data"]):nil;
        } else {
            failure?failure(dic[@"resultMsg"]):nil;
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        failure?failure(request.error.localizedDescription):nil;
    }];
}
@end
