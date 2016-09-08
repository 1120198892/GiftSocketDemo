//
//  NSMutableDictionary+Check.m
//  框架
//
//  Created by mayanwei on 14-9-3.
//  Copyright (c) 2014年 mayanwei. All rights reserved.
//

#import "NSMutableDictionary+Check.h"
#import "NSString+Check.h"

@implementation NSMutableDictionary (Check)

+ (NSDictionary *)checkServerReturnForDictionary:(id)object
{
    if ([object isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dict = (NSDictionary *)object;
        return dict;
    }
    else
    {
        return nil;
    }
}

- (void)setNilObject:(id)anObject forKey:(id)aKey
{
    [self setObject:[NSString checkNullValueForString:anObject] forKey:aKey];
}

- (id)objectNilForKey:(id)key
{
   return [self objectForKey:[NSString checkNullValueForString:key]];
}

- (NSString*)dictionary2Json

{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}


@end
