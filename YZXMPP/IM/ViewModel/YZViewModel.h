//
//  YZViewModel.h
//  YZXMPP
//
//  Created by Apple on 2021/1/12.
//

#import <Foundation/Foundation.h>

typedef void(^sucBlock)(id object);
typedef void(^failBlock)(NSString *error);

@interface YZViewModel : NSObject
+ (void)loginPassword:(NSString *)password telephone:(NSString *)telephone suc:(sucBlock)suc err:(failBlock)err;
@end

