//
//  TABControlPanelView.h
//  Hiragana
//
//  Created by Travis Buttaccio on 7/27/15.
//  Copyright (c) 2015 LangueMatch. All rights reserved.
//

@import UIKit;
@class TABControlPanelView;

@protocol TABControlPanelViewDelegate <NSObject>

-(void)ControlPanelView:(TABControlPanelView *)view didPressNextButton:(UIButton *)sender;
-(void)ControlPanelView:(TABControlPanelView *)view didPressPlayButton:(UIButton *)sender;
-(void)ControlPanelView:(TABControlPanelView *)view didPressPreviousButton:(UIButton *)sender;

@end

@interface TABControlPanelView : UIView

@property (weak, nonatomic) id <TABControlPanelViewDelegate> delegate;
@property (strong, nonatomic, readonly) UIButton *playButton;
@property (strong, nonatomic, readonly) UIButton *nextButton;
@property (strong, nonatomic, readonly) UIButton *previousButton;

@end
