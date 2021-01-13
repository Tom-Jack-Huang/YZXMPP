//
//  UserInfo.h
//  YZXMPP
//
//  Created by Apple on 2021/1/12.
//

#import <Foundation/Foundation.h>

#import <BGFMDB/BGFMDB.h>

@interface UserInfo : NSObject
@property (nonatomic, strong) NSString *userName;

@property (nonatomic, strong) NSNumber *useId;

@property (nonatomic,strong) NSString* telephone;

@property (nonatomic,strong) NSString* password;

@property (nonatomic, strong) NSString *access_token;
@end


