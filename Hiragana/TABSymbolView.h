//
//  TABSymbolView.h
//  Hiragana
//
//  Created by Travis Buttaccio on 7/22/15.
//  Copyright (c) 2015 LangueMatch. All rights reserved.
//

@class FLAnimatedImage, FLAnimatedImageView;
@import UIKit;

@interface TABSymbolView : UIView

// Image is centered in view and is 2/3 the size of the view
@property (strong, nonatomic) FLAnimatedImage *image;
@property (strong, nonatomic) FLAnimatedImageView *imageView;
@property (strong, nonatomic) UILabel *romanLetterLabel;
@property (strong, nonatomic) UILabel *symbolLabel;
@property (strong, nonatomic) UILabel *tapToPlayLabel;

@end
