//
//  NSString+Hiragana.m
//  Hiragana
//
//  Created by Travis Buttaccio on 7/27/15.
//  Copyright (c) 2015 LangueMatch. All rights reserved.
//

#import "NSString+Hiragana.h"


@implementation NSString (Hiragana)

+(NSString *) tab_romanLetterForSymbol:(NSString *)symbol {
    return [self tab_romanCharacters][symbol];
}

+(NSDictionary *)tab_romanCharacters {
    return @{@"あ" : @"e", @"い" : @"i", @"う" : @"u", @"え" : @"e", @"お" : @"o"};
}

@end
