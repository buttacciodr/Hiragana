//
//  TABDraggableView.h
//  Hiragana
//
//  Created by Travis Buttaccio on 7/22/15.
//  Copyright (c) 2015 LangueMatch. All rights reserved.
//

@import UIKit;
@class TABDraggableView;


@protocol TABDraggableViewDelegate

- (void)draggableView:(TABDraggableView *)view draggingEndedWithVelocity:(CGPoint)velocity;
- (void)draggableViewBeganDragging:(TABDraggableView *)view;

@end


@interface TABDraggableView : UIView

@property (nonatomic, weak) id <TABDraggableViewDelegate> delegate;

@end
