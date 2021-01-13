//
//  YZKitConfig.h
//  YZXMPP
//
//  Created by Apple on 2021/1/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZKitConfig : NSObject
+ (instancetype)defaultConfig;
//获取IM用户信息的域名
@property (nonatomic, strong) NSString *IMHost;
//获取IM用户信息的端口
@property (nonatomic, strong) NSString *IMPort;

@property (nonatomic, assign) NSTimeInterval pingInterval;

@property(assign,nonatomic) BOOL isOpenReceipt;// 是否开启发送回执


/*   用户信息   */

@property (nonatomic, strong) NSString *userName;

@property (nonatomic, strong) NSNumber *useId;

@property (nonatomic, strong) NSString *access_token;

@property (nonatomic, strong) NSString *password;
@end

NS_ASSUME_NONNULL_END
