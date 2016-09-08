//
//  SocketHelper.h
//  XiaoChentiku
//
//  Created by erice on 16/7/19.
//  Copyright © 2016年 erice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"
#import "GiftModel.h"

#define kSocketHelper [SocketHelper shared]


typedef NS_ENUM(NSInteger,SocketStatusCode)
{
    SocketketUnKonw = -1,//未知
    SocketFaild = 100,//失败
    SocketLoginFaild = 101,//登录失败
    SocketLoginOutFaild = 102,//注销失败
    SocketSuccess = 200,// 成功
    SocketLoginSuccess=201,//登录成功
    SocketLoginOutSuccess = 202,//注销成功
    SocketSendGiftFaild = 203,//给老师送礼物失败
    SocketServerError = 300,
};

typedef void (^StringBlock)(NSString *string);
typedef void (^GetGiftBlock)(GiftModel*model);
typedef void (^SocketVoidBlock)(void);
typedef void (^SocketStringAndIntBlock)(NSString*string,NSInteger count);
@interface SocketHelper : NSObject<GCDAsyncSocketDelegate>

+ (instancetype)shared;

@property (nonatomic, strong) GCDAsyncSocket    *socket;

@property (nonatomic, copy) GetGiftBlock handleGiftBlock;// 收到礼物回调
@property (nonatomic, strong) SocketVoidBlock successBlock;
@property (nonatomic, copy)StringBlock handlePiaoBlock;
@property (nonatomic, strong) SocketStringAndIntBlock attentedTeachBlock;





- (void)connectTohost;
- (void)cutOffSocket;


- (void)sendLoginMessageWithCourseType:(NSInteger)CourseType CourseId:(NSString*)CourseId teachId:(NSString*)teachid completionBlock:(SocketVoidBlock)block;

- (void)sendLoginOutMessageCourseType:(NSInteger)CourseType CourseId:(NSString*)CourseId completionBlock:(SocketVoidBlock)block;

- (void)sendGiftBroadcastMessageGiftId:(NSString*)giftId GiftNum:(NSInteger)gifNum TeachId:(NSString*)teachId giftImg:(NSString*)giftImg GiftName:(NSString*)giftName giftPrice:(NSString*)price completionBlock:(SocketVoidBlock)block;


- (void)sendOrderMessage:(NSString*)order message:(NSDictionary*)dic completionBlock:(SocketVoidBlock)block;

- (void)sendTeachAttention:(NSString*)teachid count:(NSString*)count completionBlock:(SocketVoidBlock)block;

@end
