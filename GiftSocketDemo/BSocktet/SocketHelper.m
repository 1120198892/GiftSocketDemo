//
//  SocketHelper.m
//  XiaoChentiku
//
//  Created by erice on 16/7/19.
//  Copyright © 2016年 erice. All rights reserved.
//

#import "SocketHelper.h"
#import "GiftHelper.h"

#define kHost @"122.426.326.222"
#define kPort 368332
#define kMessageHeadSize 9

#define kLoginOrd @"Login"
#define kLoginOutOrd @"LoginOut"
#define kResposeOrd @"Respose"
#define kGiftBroadcastOrd @"GiftBroadcast"
#define kTeacherGift @"TeacherGift"
#define kFocusTeacher @"FocusTeacher"

@interface SocketHelper ()

@property (nonatomic, strong) NSString* teachID;
@property (nonatomic, strong) NSString* courseId;
@property (nonatomic, assign) NSInteger courseType;
@end

@implementation SocketHelper


DISPATCH_ONCE_CLASS

- (instancetype)init
{
    self = [super init];
    if (self) {
   
     
    }
    return self;
}

#pragma mark event

//CourseType(直播：80 vip：70)
- (void)sendLoginMessageWithCourseType:(NSInteger)CourseType CourseId:(NSString*)CourseId teachId:(NSString*)teachid completionBlock:(SocketVoidBlock)block{
  
    // 这些参数是你断网以后，需要重新连接从新登陆需要的参数。socket长连接，如果你断网，后台会默认这个连接是无效连接，你再次连的话，会失败。这个地方需要记录下你需要的数据，此处知识说明逻辑。具体写法 自定义
    //--------------
    self.teachID = teachid;
    self.courseId = CourseId;
    self.courseType = CourseType;
    //---------------------------------
    
    
    
  // 此处传入你后台需要的参数注意格式
    NSMutableDictionary * dic =[self  requiredParams];
    [dic setNilObject:@(CourseType) forKey:@"CourseType"];
    [dic setNilObject:teachid forKey:@"TeacherId"];
    [dic setNilObject:CourseId forKey:@"CourseId"];
    [self sendOrderMessage:kLoginOrd message:dic completionBlock:block];
    
}

- (void)sendLoginOutMessageCourseType:(NSInteger)CourseType CourseId:(NSString*)CourseId completionBlock:(SocketVoidBlock)block{
    
    // 此处传入你后台需要的参数注意格式
    NSMutableDictionary * dic =[self  requiredParams];
    [dic setNilObject:@(CourseType) forKey:@"CourseType"];
    [dic setNilObject:CourseId forKey:@"CourseId"];
    
    [self sendOrderMessage:kLoginOutOrd message:dic completionBlock:block];
    
}

- (void)sendGiftBroadcastMessageGiftId:(NSString*)giftId GiftNum:(NSInteger)gifNum TeachId:(NSString*)teachId giftImg:(NSString*)giftImg GiftName:(NSString*)giftName giftPrice:(NSString*)price completionBlock:(SocketVoidBlock)block{
   
   
        NSMutableDictionary * dic =[NSMutableDictionary dictionary];
    
        // 此处传入你后台需要的参数注意格式
        [dic setNilObject:giftId forKey:@"GiftId"];
        [dic setNilObject:price forKey:@"GiftPrice"];
        [dic setNilObject:@(gifNum) forKey:@"GiftNum"];
    
        [self sendOrderMessage:kGiftBroadcastOrd message:dic completionBlock:block];
  
    
}

- (void)sendTeachAttention:(NSString*)teachid count:(NSString*)count completionBlock:(SocketVoidBlock)block{
    
    NSMutableDictionary * dic =[self  requiredParams];
    [dic setNilObject:count forKey:@"Count"];
    [dic setNilObject:teachid forKey:@"TeacherId"];
    [self sendOrderMessage:kFocusTeacher message:dic completionBlock:block];
    
    
}


- (void)sendOrderMessage:(NSString*)order message:(NSDictionary*)dic completionBlock:(SocketVoidBlock)block{
   
    
      @autoreleasepool {
          
            NSMutableDictionary * jsonDic =[NSMutableDictionary dictionaryWithDictionary:dic];
          
          /*
           此处数据，是公共参数，对比后台各个连接需要的参数，提取公共参数，写到这个地方， 此处只为说明逻辑，具体写法可自定义
           */
            [jsonDic setNilObject:@1 forKey:@"ClientType"];
            [jsonDic setNilObject:@"sdafjskfjklwejfkwwfwe" forKey:@"Token"];
          NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970]*1000;
          long long int time = (long long)timeInterval;
          
          [jsonDic setNilObject:[NSString stringWithFormat:@"%lld", time] forKey:@"currentTimeMillis"];
    
          //----------------------------------------
          
            NSMutableData* sendData =[NSMutableData data];
            NSString * json = [jsonDic dictionary2Json];
            NSData *JsonData = [json dataUsingEncoding: NSUTF8StringEncoding];
            NSData * ordata = [order dataUsingEncoding:NSUTF8StringEncoding];
            int jsonlen = (int)JsonData.length;
            char *p_json = (char *)&jsonlen;
            char str_json[4] = {0};
          
            for(int i= 0 ;i < 4 ;i++)
            {
                str_json[i] = *p_json;
                p_json ++;
            }
          
          /*
           这个demo 试用于 需要自定义socket消息格式的童鞋。我的消息结构，
           
           
           
           消息的格式采用固定头+Body 消息格式（头长度为9字节）
           
           前部分是消息头，后部分是整个消息内容，其中命令不能为空,低位在前高位在后
           
           1B         4B            4B          | 命令 |json|传输数据
           命令长度    json数据长度   二进制额外数据
           
           */
            Byte byte[] = {order.length,str_json[0],str_json[1],str_json[2],str_json[3],0,0,0,0};
            [sendData appendBytes:byte length:sizeof(byte)];
            [sendData appendData:ordata];
            [sendData appendData:JsonData];
          
            [self.socket writeData:sendData withTimeout:10 tag:0];
            if (block) {
                self.successBlock = block;
            }
         
     }
  
}

#pragma mark - connect

- (void)reconnectTohost{
    
    self.socket = nil;
    [self connectTohost];
    [self sendLoginMessageWithCourseType:self.courseType CourseId:self.courseId teachId:self.teachID completionBlock:nil];

}

- (void)connectTohost{
    
    self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
     NSError* err;
     self.socket.isCutOff = NO;
    [self.socket connectToHost:kHost onPort:kPort error:&err];
    if (err) {
        NSLog(@"err:%@",err);
    }
}

- (void)cutOffSocket{
    [self.socket disconnect];
     self.socket.isCutOff = YES;
    self.socket = nil;
}

#pragma mark delegate

- (void)socket:(GCDAsyncSocket*)sock didConnectToHost:(NSString*)host port:(uint16_t)port{
    
    self.socket.isCutOff = NO;
    [self.socket readDataWithTimeout:-1 tag:0];
    
}

- (void)socketDidDisconnect:(GCDAsyncSocket*)sock withError:(NSError*)err
{
        [self.socket connectToHost:kHost onPort:kPort error:&err];

    
}

- (void)socket:(GCDAsyncSocket*)sock didWriteDataWithTag:(long)tag{
    if (self.successBlock) {
        self.successBlock();
    }
}

- (void)socket:(GCDAsyncSocket*)sock didReadData:(NSData*)data withTag:(long)tag{
   
    [self handleSocketdata2dic:data];
    
    [self.socket readDataWithTimeout:-1 tag:tag];

}

#pragma mark - handle

- (void)handleSocketdata2dic:(NSData*)data{
 
    Byte *resverByte = (Byte *)[data bytes];
    Byte jsonlenByte[] = {resverByte[1],resverByte[2],resverByte[3],resverByte[4]};
    NSInteger lengthjson = [self lBytesToInt:jsonlenByte];
    if (lengthjson>= data.length-9) {
        return;
    }
    if (data.length<9) {
        [self handleSocketdata2dic:data];
    }
    
    NSInteger lengthcom = resverByte[0];
    
    Byte com[lengthcom];
    [self bytesplit2byte:resverByte orc:com begin:kMessageHeadSize count:lengthcom];
    
    Byte json[lengthjson];
    [self bytesplit2byte:resverByte orc:json begin:kMessageHeadSize+lengthcom count:lengthjson];
    
    NSString * comstring = [[NSString alloc] initWithData:[NSData dataWithBytes:com length:sizeof(com)] encoding:NSUTF8StringEncoding];
    
    NSString * jsonstring = [[NSString alloc] initWithData:[NSData dataWithBytes:json length:sizeof(json)] encoding:NSUTF8StringEncoding];
    
    [self handleObserver2Command:comstring json:[jsonstring JSONObject]];
    
    if (lengthjson+lengthcom+9 < data.length) {
        NSData * data2 = [data subdataWithRange:NSMakeRange(lengthjson+lengthcom+9, data.length -(lengthjson+lengthcom+9))];
        [self handleSocketdata2dic:data2];
    }
    
}




- (void)handleObserver2Command:(NSString*)command json:(NSMutableDictionary*)dic{
  
    NSInteger code = [[dic objectNilForKey:@"StatusCode"] integerValue];
    
    if ([command isEqualToString:kLoginOrd]) {
        
    }else  if ([command isEqualToString:kTeacherGift]){
       
    }else  if ([command isEqualToString:kFocusTeacher]){
        
    }
    else{
        
        if ([command isEqualToString:@"Respose"]) {
            
            if (code == SocketLoginSuccess) {
                
                
            }else if(code == SocketLoginOutSuccess){
                
                
            }else if (code == SocketSuccess){
                
                
            }
            else{
                
                
            }
            
        }
       
        
    }
    
}

- (void)handleGetGift:(NSDictionary*)json{
    
    // 此处使用MJ 解析，可替换
    GiftModel * model = [GiftModel objectWithKeyValues:json];
    if (self.handleGiftBlock) {
        self.handleGiftBlock(model);
    }
    
}

#pragma mark Api

- (void)bytesplit2byte:(Byte[])src orc:(Byte[])orc begin:(NSInteger)begin count:(NSInteger)count{
    
    if (count>=0) {
        memset(orc, 0, sizeof(char)*count);
        for (NSInteger i = begin; i < begin+count; i++){
            orc[i-begin] = src[i];
        }
    }
    
}


-(int) lBytesToInt:(Byte[]) byte
{
    int height = 0;
    NSData * testData =[NSData dataWithBytes:byte length:4];
    for (int i = 0; i < [testData length]; i++)
    {
        if (byte[[testData length]-i] >= 0)
        {
            height = height + byte[[testData length]-i];
        } else
        {
            height = height + 256 + byte[[testData length]-i];
        }
        height = height * 256;
    }
    if (byte[0] >= 0)
    {
        height = height + byte[0];
    } else {
        height = height + 256 + byte[0];
    }
    return height;
}


- (NSMutableDictionary *)requiredParams
{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    long long int time = (long long)timeInterval;
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setNilObject:[NSString stringWithFormat:@"%lld%d", time, arc4random() % 10000] forKey:@"time"];
    return dictionary;
}


@end
