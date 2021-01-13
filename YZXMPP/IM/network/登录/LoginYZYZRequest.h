//
//  LoginYZYZRequest.h
//  YZXMPP
//
//  Created by Apple on 2021/1/12.
//

#import "YZRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginYZYZRequest : YZRequest
- (instancetype)initWithPassword:(NSString *)password telephone:(NSString *)telephone;
@end

NS_ASSUME_NONNULL_END
