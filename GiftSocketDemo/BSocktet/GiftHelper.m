//
//  GiftHelper.m
//  Wantiku
//
//  Created by erice on 16/7/29.
//  Copyright © 2016年 mayw. All rights reserved.
//

#import "GiftHelper.h"
#import "BSocket.h"

#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI)) //弧度转角度
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)  //角度转弧度
@implementation GiftHelper


DISPATCH_ONCE_CLASS

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        NSOperationQueue *queue1 = [[NSOperationQueue alloc] init];
        queue1.maxConcurrentOperationCount = 1; // 队列分发
        _queue1 = queue1;
        
        NSOperationQueue *queue2 = [[NSOperationQueue alloc] init];
        queue2.maxConcurrentOperationCount = 1; // 队列分发
        _queue2 = queue2;
     
        _giftInfos = [[NSMutableArray alloc] initWithCapacity:100];
        _operations = [[NSMutableArray alloc] initWithCapacity:10000];
       
    }
    return self;
}


- (void)showGiftAnimation:(UIView*)oriView frame:(CGRect)frame imageUrl:(NSString*)imgUrl{

       UIImageView * imageView = [[UIImageView alloc] initWithFrame:frame];
    
       [imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
       [oriView addSubview:imageView];
       [UIView animateKeyframesWithDuration:1.25 delay:0 options:0 animations:^{
           
           [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1/1.5 animations:^{
               imageView.transform = CGAffineTransformMakeScale(1.1,1.1);
           }];
           
           [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1.5/2 animations:^{
               imageView.transform = CGAffineTransformMakeScale(0.3,0.3);
           }];
        
           CGPoint point = oriView.center;
           point.y = kScreenWidth *0.75/2;
           CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
           CGMutablePathRef path=CGPathCreateMutable();
           
           CGPathMoveToPoint(path, NULL, imageView.frame.origin.x, imageView.frame.origin.y);
           CGPathAddCurveToPoint(path, NULL,point.x/2,frame.origin.y/2,point.x,kScreenHeight/2, point.x, point.y);
           animation.path=path;
           CGPathRelease(path);
           animation.removedOnCompletion = NO;
           animation.calculationMode = kCAAnimationCubic;
           animation.fillMode = kCAFillModeForwards;
           animation.duration = 1.5f;
           animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
           [imageView.layer addAnimation:animation forKey:@"position"];
      
           
       } completion:^(BOOL finished) {
           
           [imageView removeFromSuperview];
           
       }];

    
}

- (void)sendGift2View:(UIView*)toView model:(GiftModel*)giftModel{

    for (GiftOperation*op in self.operations) {
        if ([op.model.UserId isEqualToString:giftModel.UserId] && [op.model.GiftId isEqualToString:giftModel.GiftId]){
            [op.giftView doubleHit];
        }
    }
    if (self.operations.count>2) {
        
        GiftOperation * oop = [self.operations objectNilAtIndex:0];
        [oop.giftView reset];
    }
    BOOL isContain = NO;
    for (GiftModel * obj in self.giftInfos) {
        
        if ([obj.GiftId isEqualToString:giftModel.GiftId] && [obj.UserId isEqualToString:giftModel.UserId]) {
            isContain = YES;
        }
    }
    if (isContain)return;
    
    [self.giftInfos addNilObject:giftModel];
    
    if ([self isQueueContainObj:giftModel]) {
        [self.giftInfos removeObject:giftModel];
        return;
    }
    @autoreleasepool {
    
        GiftOperation * op =[[GiftOperation alloc] init];
        NSLock * lock = [[NSLock alloc] init];
        op.listView =toView;
        op.model = giftModel;
        op.completionBlock = ^(){
            if (self.giftInfos.count>0) {
                [lock lock];
                if ([self.giftInfos containsObject:giftModel]) {
                    [self.giftInfos removeObject:giftModel];
                }
                [lock unlock];
            }
        };
        if (self.queue2.operations.count <= self.queue1.operations.count || self.queue2.operations.count == 0) {
            if (op.model.GiftNum != 0) {
                 op.index = 2;
                [self.queue2 addOperation:op];
            }
        }else{
            
            if (op.model.GiftNum != 0 ) {
                op.index = 1;
                [self.queue1 addOperation:op];
            }
            
        }
        [self.operations addNilObject:op];
         
    }
    
}


- (BOOL)isQueueContainObj:(GiftModel*)model{
    
    BOOL isContain = NO;
    for (GiftOperation * op in self.queue1.operations) {
        
        if ([model.GiftId isEqualToString:op.model.GiftId]&&[model.UserId isEqualToString:op.model.UserId]) {
            
            isContain = YES;
        }
        
    }
    for (GiftOperation * op in self.queue2.operations) {
        
        if ([model.GiftId isEqualToString:op.model.GiftId]&&[model.UserId isEqualToString:op.model.UserId]) {
            
            isContain = YES;
        }
        
    }
    return isContain;
    
}


@end
