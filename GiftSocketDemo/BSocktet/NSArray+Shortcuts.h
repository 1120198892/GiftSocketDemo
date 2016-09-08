//
//  NSArray+Shortcuts.h
//  框架
//
//  Created by mayanwei on 14-9-2.
//  Copyright (c) 2014年 mayanwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Shortcuts)

- (BOOL)containsObjectAtIndex:(NSInteger)index;

- (id)objectNilAtIndex:(NSInteger)index;

- (NSArray *)sortArrayByKey:(id)key inAscending:(BOOL)ascending;

@end
