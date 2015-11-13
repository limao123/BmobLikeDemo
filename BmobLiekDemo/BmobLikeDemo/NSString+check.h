//
//  NSString+check.h
//  ProgrammerMeeting
//
//  Created by limao on 15/8/24.
//  Copyright (c) 2015年 Bmob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (check)
/**
 *  检查字符串是否为nil或者全是空字符
 *
 *  @return <#return value description#>
 */
+ (BOOL) isStrEmptyOrNull:(NSString *) str;

/**
 *  检查密码是否正确
 *
 *  @return <#return value description#>
 */
- (BOOL)isPasswordLegal;

/**
 *  计算NSString的字节数
 *
 *  @param strtemp <#strtemp description#>
 *
 *  @return <#return value description#>
 */
- (int)convertToInt;

+ (NSString *)getMaxNumberCount:(NSInteger)number withContent:(NSString *)content;

+ (NSInteger)getCountWithContent:(NSString *)content;

+(id)stringToJson:(NSString *)str;

+(NSString*)jsonToString:(NSDictionary*)json;
@end
