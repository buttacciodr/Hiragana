//
//  TABSymbolView.m
//  Hiragana
//
//  Created by Travis Buttaccio on 7/22/15.
//  Copyright (c) 2015 LangueMatch. All rights reserved.
//

#import "TABSymbolView.h"
#import "Utility.h"

#import <FLAnimatedImage/FLAnimatedImageView.h>

@interface TABSymbolView()

@end

@implementation TABSymbolView

-(instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _symbolLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont fontWithName:@"Didot" size:24.0f];
            [label sizeToFit];
            label;
        });
        
        _romanLetterLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont fontWithName:@"Didot" size:24.0f];
            [label sizeToFit];
            label;
        });
        
        _imageView = ({
            FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
            [imageView.layer setBorderColor:[UIColor whiteColor].CGColor];
            [imageView.layer setBorderWidth:3.0f];
            imageView;
        });
        
        _tapToPlayLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.text = @"Tap To Play/Pause";
            label.font = [UIFont fontWithName:@"Didot" size:9.0f];
            [label sizeToFit];
            label;
        });
        
        for (UIView *view in @[_imageView, _symbolLabel, _romanLetterLabel, _tapToPlayLabel]) {
            view.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:view];
        }
    }
    return self;
}

-(void) layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat viewWidth = CGRectGetWidth(self.frame);
    CGFloat viewHeight = CGRectGetHeight(self.frame);
    CGFloat buffer = 8.0f;
    
    CONSTRAIN_HEIGHT(self.imageView, viewHeight - buffer * 3.0);
    CONSTRAIN_WIDTH(self.imageView, viewWidth - buffer * 3.0);
    CENTER_VIEW(self, self.imageView);
    
    ALIGN_VIEW_BOTTOM_CONSTANT(self, self.tapToPlayLabel, -buffer);
    ALIGN_VIEW_LEFT_CONSTANT(self, self.tapToPlayLabel, buffer);
    
    ALIGN_VIEW_BOTTOM_CONSTANT(self, self.romanLetterLabel, -buffer);
    ALIGN_VIEW_RIGHT_CONSTANT(self, self.romanLetterLabel, -buffer);
    
    ALIGN_VIEW_TOP_CONSTANT(self, self.symbolLabel, buffer);
    ALIGN_VIEW_RIGHT_CONSTANT(self, self.symbolLabel, -buffer);
    
}

-(void)setImage:(FLAnimatedImage *)image
{
    _image = image;
    self.imageView.animatedImage = image;
}

-(UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[FLAnimatedImageView alloc] init];
        [self addSubview:_imageView];
    }
    
    return _imageView;
}


@end
