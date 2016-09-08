//
//  GiftOperation.m
//  XiaoChentiku
//
//  Created by erice on 16/7/25.
//  Copyright © 2016年 erice. All rights reserved.
//

#import "GiftOperation.h"
#import "GiftHelper.h"
#import "UIView+Frame.h"
@interface GiftOperation ()

@property (nonatomic, getter = isFinished)  BOOL finished;
@property (nonatomic, getter = isExecuting) BOOL executing;

@end


@implementation GiftOperation
@synthesize finished = _finished;
@synthesize executing = _executing;


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _executing = NO;
        _finished  = NO;
        
    }
    return self;
}

-(void)start{
 
    if ([self isCancelled]) {
        self.finished = YES;
        return;
    }
      self.executing = YES;
    __weak GiftOperation * weakSelf = self;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
       
        weakSelf.giftView = [[livingGiftView alloc] init];
        weakSelf.giftView.model =weakSelf.model;
        CGFloat giftHeight = weakSelf.listView.height/2;
        if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait) {
            giftHeight = weakSelf.listView.height/2 + 40;
        }
        if (weakSelf.index % 2) {
            weakSelf.giftView.frame = CGRectMake(-weakSelf.listView.width/1.5,  giftHeight, MIN(weakSelf.listView.width, weakSelf.listView.height)/1.7, 40);
            
        }else{
           weakSelf.giftView.frame = CGRectMake(-weakSelf.listView.width /1.7,  giftHeight-70, MIN(weakSelf.listView.width, weakSelf.listView.height) / 1.7, 40);
      }
        weakSelf.giftView.originFrame = weakSelf.giftView.frame;
        [weakSelf.listView addSubview:weakSelf.giftView];
        [weakSelf.giftView animateWithCompleteBlock:^(BOOL finished) {
            if ([[GiftHelper shared].operations containsObject:weakSelf]) {
                NSLock * lock = [[NSLock alloc] init];
                [lock lock];
                if (weakSelf) {
                   [[GiftHelper shared].operations removeObject:weakSelf];
                }
                if (weakSelf.model) {
                    [[GiftHelper shared].giftInfos removeObject:weakSelf.model];
                }
                [lock unlock];
            }
            weakSelf.finished = finished;
        }];
        
    }];
    
}


- (void)setExecuting:(BOOL)executing
{
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)setFinished:(BOOL)finished
{
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}


@end
