//
//  YZIMMessage.h
//  YZXMPP
//
//  Created by Apple on 2021/1/12.
//

#import <Foundation/Foundation.h>
#import <BGFMDB/BGFMDB.h>
enum kWCMessageType {
    kWCMessageTypeNone = 0,//不显示的无用类型
    kWCMessageTypeText = 1,//文本
    kWCMessageTypeImage = 2,//图片
    kWCMessageTypeVoice = 3,//语音
    kWCMessageTypeLocation=4, //位置
    kWCMessageTypeGif=5,//动画
    kWCMessageTypeVideo=6,//视频
    kWCMessageTypeAudio=7,//音频
    kWCMessageTypeCard=8,//名片
    kWCMessageTypeFile=9, //文件
    kWCMessageTypeRemind=10, //提醒
    
    kWCMessageTypeIsRead = 26,//已读标志
    kWCMessageTypeRedPacket = 28, //发红包
    kWCMessageTypeSystemImage1=80,  //单条图文消息
    kWCMessageTypeSystemImage2=81,  //多条图文消息
    kWCMessageTypeLink = 82, //链接
    kWCMessageTypeRedPacketReceive = 83, //领红包
    kWCMessageTypeShake = 84, // 戳一戳
    kWCMessageTypeMergeRelay = 85,   // 合并转发
    kWCMessageTypeRedPacketReturn = 86, // 红包退回

    kWCMessageTypeEnterpriseJob=11, //企业发布的职位信息
    kWCMessageTypePersonJob=31, //个人发布的职位信息
    kWCMessageTypeResume=12, //简历信息
    kWCMessageTypePhoneAsk=13, //问交换手机
    kWCMessageTypePhoneAnswer=14, //答交换手机
    kWCMessageTypeResumeAsk=16, //问发送简历
    kWCMessageTypeResumeAnswer=17, //答发送简历
    kWCMessageTypeExamSend=19, //发起笔试题（暂无用）
    kWCMessageTypeExamAccept=20, //接受笔试题（暂无用）
    kWCMessageTypeExamEnd=21, //做完笔试题，显示结果（暂无用）

    kWCMessageTypeAudioChatAsk = 100, //询问是否准备好语音通话
    kWCMessageTypeAudioChatReady = 101, //已准备好语音通话
    kWCMessageTypeAudioChatAccept = 102, //接受语音通话
    kWCMessageTypeAudioChatCancel = 103, //拒绝语音通话 或 取消拔号
    kWCMessageTypeAudioChatEnd = 104, //结束语音通话

    kWCMessageTypeVideoChatAsk = 110, //询问是否准备好视频通话
    kWCMessageTypeVideoChatReady = 111, //已准备好视频通话
    kWCMessageTypeVideoChatAccept = 112, //接受视频通话
    kWCMessageTypeVideoChatCancel = 113, //拒绝视频通话 或 取消拔号
    kWCMessageTypeVideoChatEnd = 114, //结束视频通话

    kWCMessageTypeVideoMeetingInvite = 115, //邀请加入视频会议
    kWCMessageTypeVideoMeetingJoin = 116, //加入视频会议
    kWCMessageTypeVideoMeetingQuit = 117, //退出视频会议
    kWCMessageTypeVideoMeetingKick = 118, //踢出视频会议

    kWCMessageTypeAudioMeetingInvite = 120, //邀请加入语音会议
    kWCMessageTypeAudioMeetingJoin = 121, //加入语音会议
    kWCMessageTypeAudioMeetingQuit = 122, //退出语音会议
    kWCMessageTypeAudioMeetingKick = 123, //踢出语音会议
    kWCMessageTypeAudioMeetingSetSpeaker = 124, //轮麦
    kWCMessageTypeAudioMeetingAllSpeaker = 125, //取消轮麦

    kWCMessageTypeMultipleLogin = 200,  // 多点登录验证在线
    kWCMessageTypeRelay = 201, // 正在输入
    kWCMessageTypeWithdraw = 202, // 消息撤回
    
    kWCMessageTypeWeiboPraise = 301, // 朋友圈点赞
    kWCMessageTypeWeiboComment = 302, // 朋友圈评论
    kWCMessageTypeWeiboRemind = 304, // 朋友圈提醒谁看
    
    kWCMessageTypeGroupFileUpload = 401, //上传群文件
    kWCMessageTypeGroupFileDelete = 402, //删除群文件
    kWCMessageTypeGroupFileDownload = 403, //下载群文件

};
NS_ASSUME_NONNULL_BEGIN

@interface YZIMMessage : NSObject

//以下字段用于通讯,message里：数据存储
@property (nonatomic,strong,readonly) NSString*  messageId;//消息标识号，
/// 如果是群组消息，groupID 为会话群组 ID，否则为 nil
@property(nonatomic,strong) NSString *groupID;

/// 如果是单聊消息，userID 为会话用户 ID，否则为 nil，
/// 假设自己和 userA 聊天，无论是自己发给 userA 的消息还是 userA 发给自己的消息，这里的 userID 均为 userA
@property(nonatomic,strong) NSString *userID;

//以下字段用于通讯，Body里：
@property (nonatomic,strong) NSNumber*  type;//消息类型 <body>里
@property (nonatomic,strong) NSString*  fromUserId;//源
@property (nonatomic,strong) NSString*  fromUserName;//源
@property (nonatomic,strong) NSString*  toUserId;//目标
@property (nonatomic,strong) NSString*  toUserName;//目标
@property (nonatomic,strong) NSDate*    timeSend;//发送的时间，发送前赋当前机器时间

//消息主内容 内容,或URL,或祝福语或json字符串
@property (nonatomic, strong) NSString *content;

- (NSString *)getMsgJson;
//保存接受消息
- (void)saveReceiveMessage:(NSDictionary *)dic messageId:(NSString *)msgId chat:(NSString *)chat;
@end

NS_ASSUME_NONNULL_END
