//
//  TABDrawingView.h
//  Hiragana
//
//  Created by Travis Buttaccio on 7/22/15.
//  Copyright (c) 2015 LangueMatch. All rights reserved.
//

@import UIKit;
@class TABDrawingView;

@protocol TABDrawingViewDelegate <NSObject>

@optional
-(void)DrawingView:(TABDrawingView *)view pressedClearButton:(UIButton *)sender;

@end

@interface TABDrawingView : UIView

// Show near the top of the drawing view
@property (strong, nonatomic, readonly) UILabel *drawingLabel;

@property (weak, nonatomic) id <TABDrawingViewDelegate> delegate;

@end
