//
//  ViewController.m
//  GiftSocketDemo
//
//  Created by erice on 16/9/8.
//  Copyright © 2016年 erice. All rights reserved.
//

#import "ViewController.h"
#import "BSocktet/BSocket.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    typeof(self) __weak weakSelf = self;
    
    // 链接
    [kSocketHelper connectTohost];
    [kSocketHelper sendLoginMessageWithCourseType:8 CourseId:@"" teachId:@"" completionBlock:nil];
    
    //接受到礼物信息后调用
    kSocketHelper.handleGiftBlock = ^(GiftModel*model){
        
        [[GiftHelper shared] sendGift2View:weakSelf.view model:model];
        
    };
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
