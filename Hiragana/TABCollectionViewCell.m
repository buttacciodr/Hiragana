#import "TABCollectionViewCell.h"

#import <FLAnimatedImage/FLAnimatedImageView.h>

@implementation TABCollectionViewCell

-(instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

-(FLAnimatedImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[FLAnimatedImageView alloc] initWithFrame:self.contentView.frame];
        [self.contentView addSubview:_imageView];
    }
    
    return _imageView;
}

-(void) prepareForReuse
{
    [super prepareForReuse];
    
    [self.imageView removeFromSuperview];
    self.imageView = nil;
}

@end
