//
//  TABSymbol.h
//  Hiragana
//
//  Created by Travis Buttaccio on 7/21/15.
//  Copyright (c) 2015 LangueMatch. All rights reserved.
//

@import Foundation;

@interface TABSymbol : NSObject

-(instancetype) initWithSymbol:(NSString *)symbol;

@property (copy, nonatomic, readonly) NSString *symbol;
@property (copy, nonatomic, readonly) NSString *gifPath;

@end
