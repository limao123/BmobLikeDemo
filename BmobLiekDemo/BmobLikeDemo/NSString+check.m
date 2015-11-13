
//
//  NSString+check.m
//  ProgrammerMeeting
//
//  Created by limao on 15/8/24.
//  Copyright (c) 2015年 Bmob. All rights reserved.
//

#import "NSString+check.h"

@implementation NSString (check)


+(BOOL) isStrEmptyOrNull:(NSString *) str {
    if (!str) {
        // null object
        return YES;
    } else {
        
        NSString *trimedString = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([trimedString length] == 0) {
            // empty string
            return YES;
        } else {
            // is neither empty nor null
            return NO;
        }
    }
}

- (BOOL)isPasswordLegal{
    if ([NSString isStrEmptyOrNull:self]
        || self.length < 6
        || self.length > 20) {
        return NO;
    } else {
        return YES;
    }
}

- (int)convertToInt{
    int strlength = 0;
    char* p = (char*)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
}

//判断是否为汉字
+ (BOOL)isChineseCharacter:(unichar)c{
    if (c >=0x4E00 && c <=0x9FA5){
        return YES;//汉字
    } else{
        return NO;//英文
    }
}

+ (BOOL)isChinesecharacter:(NSString *)string{
    if (string.length == 0 && string.length > 1) {
        return NO;
    }
    unichar c = [string characterAtIndex:0];
    if ([NSString isChineseCharacter:c]){
        return YES;//汉字
    } else{
        return NO;//英文
    }
}

//计算汉字的个数
+ (NSInteger)chineseCountOfString:(NSString *)string{
    int ChineseCount = 0;
    if (string.length == 0) {
        return 0;
    }
    
    for (int i = 0; i<string.length; i++) {
        unichar c = [string characterAtIndex:i];
        if ([NSString isChineseCharacter:c]) {
            ChineseCount++ ;//汉字
        }
    }
    return ChineseCount;
}

//计算字母的个数
+ (NSInteger)characterCountOfString:(NSString *)string{
    int characterCount = 0;
    if (string.length == 0) {
        return 0;
    }
    
    for (int i = 0; i<string.length; i++) {
        unichar c = [string characterAtIndex:i];
        if ([NSString isChineseCharacter:c]){
        } else{
            characterCount++;//英文
        }
    }
    return characterCount;
}

+ (NSString *)getMaxNumberCount:(NSInteger)number withContent:(NSString *)content{
    if (content.length <= 0) {
        return @"";
    }
    
    NSInteger indexCharacterOfByte = 0;
    NSInteger indexCharacter = 0;
    for (indexCharacter = 0; indexCharacter < content.length;indexCharacter++) {
        if (content) {
            unichar c = [content characterAtIndex:indexCharacter];
            
            //计算字符数
            if ([NSString isChineseCharacter:c]) {
                indexCharacterOfByte += 2;
            } else {
                indexCharacterOfByte += 1;
            }
            
            //大于某个数量则返回
            if (indexCharacterOfByte > number) {
                break;
            }
        }
    }
    
    return [content substringToIndex:indexCharacter];
}

+ (NSInteger)getCountWithContent:(NSString *)content{
    NSInteger indexCharacterOfByte = 0;
    NSInteger indexCharacter = 0;
    for (indexCharacter = 0; indexCharacter < content.length;indexCharacter++) {
        if (content) {
            unichar c = [content characterAtIndex:indexCharacter];
            
            //计算字符数
            if ([NSString isChineseCharacter:c]) {
                indexCharacterOfByte += 2;
            } else {
                indexCharacterOfByte += 1;
            }
        }
    }
    return indexCharacterOfByte;
}

+(id)stringToJson:(NSString *)str{
    NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
}

+(NSString*)jsonToString:(NSDictionary*)json{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
@end
