//
//  TABPullingBehavior.m
//  Hiragana
//
//  Created by Travis Buttaccio on 7/22/15.
//  Copyright (c) 2015 LangueMatch. All rights reserved.
//

#import "TABPullingBehavior.h"

@interface TABPullingBehavior()

@property (strong, nonatomic) UIAttachmentBehavior *attachmentBehavior;
@property (strong, nonatomic) UIDynamicItemBehavior *itemBehavior;
@property (strong, nonatomic) id <UIDynamicItem> item;

@end

@implementation TABPullingBehavior

-(instancetype) initWithItem:(id<UIDynamicItem>)item
{
    if (self = [super init]) {
        self.item = item;
        [self setup];
    }
    return self;
}

- (void)setup
{
    UIAttachmentBehavior *attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.item attachedToAnchor:CGPointZero];
    attachmentBehavior.frequency = 3.5;
    attachmentBehavior.damping = .4;
    attachmentBehavior.length = 0;
    [self addChildBehavior:attachmentBehavior];
    self.attachmentBehavior = attachmentBehavior;
    
    UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.item]];
    itemBehavior.density = 100;
    itemBehavior.resistance = 10;
    [self addChildBehavior:itemBehavior];
    self.itemBehavior = itemBehavior;
}

- (void)setTargetPoint:(CGPoint)targetPoint
{
    _targetPoint = targetPoint;
    self.attachmentBehavior.anchorPoint = targetPoint;
}

- (void)setVelocity:(CGPoint)velocity
{
    _velocity = velocity;
    CGPoint currentVelocity = [self.itemBehavior linearVelocityForItem:self.item];
    CGPoint velocityDelta = CGPointMake(velocity.x - currentVelocity.x, velocity.y - currentVelocity.y);
    [self.itemBehavior addLinearVelocity:velocityDelta forItem:self.item];
}

@end
