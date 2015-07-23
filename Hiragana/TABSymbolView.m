//
//  TABSymbolView.m
//  Hiragana
//
//  Created by Travis Buttaccio on 7/22/15.
//  Copyright (c) 2015 LangueMatch. All rights reserved.
//

#import "TABSymbolView.h"

#import <FLAnimatedImage/FLAnimatedImageView.h>

@interface TABSymbolView()

@property (strong, nonatomic) FLAnimatedImageView *imageView;

@end

@implementation TABSymbolView

-(void) layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat viewWidth = CGRectGetWidth(self.frame);
    CGFloat viewHeight = CGRectGetHeight(self.frame);
    
    self.imageView.frame = CGRectMake(viewWidth, viewHeight, viewWidth, viewHeight);
    
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
