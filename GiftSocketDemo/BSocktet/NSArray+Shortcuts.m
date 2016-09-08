//
//  NSArray+Shortcuts.m
//  框架
//
//  Created by mayanwei on 14-9-2.
//  Copyright (c) 2014年 mayanwei. All rights reserved.
//

#import "NSArray+Shortcuts.h"

@implementation NSArray (Shortcuts)

- (BOOL)containsObjectAtIndex:(NSInteger)index
{
    return index >= 0 && index <self.count;
}

- (id)objectNilAtIndex:(NSInteger)index
{
    return [self containsObjectAtIndex:index] ? [self objectAtIndex:index] : nil;
}

- (NSArray *)sortArrayByKey:(id)key inAscending:(BOOL)ascending
{
    if (self == nil || self.count == 0)
        return self;
    
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:key ascending:ascending selector:@selector(compare:)];
    NSArray *descriptors = [NSArray arrayWithObjects:descriptor, nil];
    return [self sortedArrayUsingDescriptors:descriptors];
}

@end
