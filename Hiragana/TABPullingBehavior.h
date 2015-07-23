//
//  TABPullingBehavior.h
//  Hiragana
//
//  Created by Travis Buttaccio on 7/22/15.
//  Copyright (c) 2015 LangueMatch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TABPullingBehavior : UIDynamicBehavior

@property (nonatomic) CGPoint targetPoint;
@property (nonatomic) CGPoint velocity;

-(instancetype) initWithItem:(id <UIDynamicItem>)item;

@end
