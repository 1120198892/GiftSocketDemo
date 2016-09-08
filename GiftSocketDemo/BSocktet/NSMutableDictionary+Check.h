//
//  NSMutableDictionary+Check.h
//  框架
//
//  Created by mayanwei on 14-9-3.
//  Copyright (c) 2014年 mayanwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Check)

+ (NSDictionary *)checkServerReturnForDictionary:(id)object;

- (void)setNilObject:(id)anObject forKey:(id)aKey;

- (id)objectNilForKey:(id)key;

- (NSString*)dictionary2Json;

@end
