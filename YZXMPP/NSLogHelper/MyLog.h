//
//  MyLog.h
//  MyLog
//
//  Created by hl on 15/11/19.
//  Copyright © 2015年 hl. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
#define NSLog(format, ...) ([MyLog output:__FILE__ lineNumber:__LINE__ input:(format), ## __VA_ARGS__])
#else
#define NSLog(format, ...)
#endif

@interface MyLog : NSObject

+ (void)output:(const char*)fileName lineNumber:(int)lineNumber input:(NSString*)input, ...;

@end
