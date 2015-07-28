//
//  TABLine.h
//  Hiragana
//
//  Created by Travis Buttaccio on 7/22/15.
//  Copyright (c) 2015 LangueMatch. All rights reserved.
//

@import UIKit;

@interface TABLine : NSObject <UIDynamicItem>

@property (nonatomic) CGRect bounds;
@property (nonatomic) CGPoint center;
@property (nonatomic) CGAffineTransform transform;

@property (nonatomic) CGPoint begin;
@property (nonatomic) CGPoint end;

@end
