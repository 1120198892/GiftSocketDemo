//
//  NSMutableArray+Shortcuts.m
//  Wantiku
//
//  Created by mayw on 15/12/11.
//  Copyright © 2015年 mayw. All rights reserved.
//

#import "NSMutableArray+Shortcuts.h"

@implementation NSMutableArray (Shortcuts)

- (void)addNilObject:(NSObject *)object
{
    if (object != nil) {
        [self addObject:object];
    }
}

@end
