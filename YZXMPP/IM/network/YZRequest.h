//
//  YZRequest.h
//  YZXMPP
//
//  Created by Apple on 2021/1/12.
//

#import <YTKNetwork/YTKNetwork.h>

typedef void(^sucBlock)(id object);
typedef void(^failBlock)(NSString *error);


@interface YZRequest : YTKRequest
- (void)yzStartWithCompletionBlockWithSuccess:(sucBlock)success
                                      failure:(failBlock)failure;
@end

