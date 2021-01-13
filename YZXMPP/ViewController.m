//
//  ViewController.m
//  YZXMPP
//
//  Created by Apple on 2021/1/11.
//

#import "ViewController.h"
#import "YZXMPPManage+Message.h"
#import "YZKitConfig.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[YZXMPPManage sharedInstance] setupStreamWithHostName:@"192.168.0.120" hostPort:5222];
    
    [[YZXMPPManage sharedInstance] login:@"15861478002" password:@"123456" succ:^{
        NSLog(@"登录成功");
    } fail:^(NSString * _Nonnull msg) {
        NSLog(@"%@",msg);
    }];
    
    UIButton *btn = [[UIButton alloc]init];
    btn.backgroundColor = [UIColor yellowColor];
    [btn addTarget:self action:@selector(onBUttonClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"发送" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    btn.frame = CGRectMake(100, 100, 100, 100);
}

- (void)onBUttonClick {
    YZIMMessage *message = [[YZIMMessage alloc]init];
    //{"fromUserName":"哈喽","content":"了，立即","fromUserId":"10000004","timeSend":1610437249,"type":1,"toUserId":"10000003","deleteTime":0}
    message.toUserId = @"10000004";
    message.type = @(kWCMessageTypeText);
    message.content = @"10000004";
    [[YZXMPPManage sharedInstance] sendMessage:message roomName:nil];
}
@end
