#import "TABControlPanelView.h"
#import "Utility.h"

@implementation TABControlPanelView

#pragma mark - Lifecycle

-(instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]){
        
        _playButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:@"headphones"] forState:UIControlStateNormal];
            [button.layer setCornerRadius:22.0f];
            [button.layer setBackgroundColor:[UIColor whiteColor].CGColor];
            [button.layer setMasksToBounds:YES];
            button.contentEdgeInsets = UIEdgeInsetsMake(7.5, 7.5, 7.5, 7.5);
            [button addTarget:self action:@selector(playButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
        
        _nextButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"▶︎" forState:UIControlStateNormal];
            [button.layer setCornerRadius:22.0f];
            [button.layer setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5f] .CGColor];
            [button.layer setMasksToBounds:YES];
            [button addTarget:self action:@selector(nextButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
        
        _previousButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"◀︎" forState:UIControlStateNormal];
            [button.layer setCornerRadius:22.0f];
            [button.layer setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5f] .CGColor];
            [button.layer setMasksToBounds:YES];
            [button addTarget:self action:@selector(previousButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
        
        for (UIView *view in @[_playButton, _nextButton, _previousButton]) {
            view.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:view];
        }
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize buttonSize = CGSizeMake(44.0f, 44.0f);
    
    CENTER_VIEW(self, self.playButton);
    CONSTRAIN_WIDTH(self.playButton, buttonSize.width);
    CONSTRAIN_HEIGHT(self.playButton, buttonSize.height);
    
    CONSTRAIN_WIDTH(self.nextButton, buttonSize.width);
    CONSTRAIN_HEIGHT(self.nextButton, buttonSize.height);
    CENTER_VIEW_V(self, self.nextButton);
    ALIGN_VIEW_RIGHT_CONSTANT(self, self.nextButton, - 8.0f);
    
    CONSTRAIN_WIDTH(self.previousButton, buttonSize.width);
    CONSTRAIN_HEIGHT(self.previousButton, buttonSize.height);
    CENTER_VIEW_V(self, self.previousButton);
    ALIGN_VIEW_LEFT_CONSTANT(self, self.previousButton, 8.0f);
}

#pragma mark - Touch Handling

-(void)playButtonPressed:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(ControlPanelView:didPressPlayButton:)]) {
        [self.delegate ControlPanelView:self didPressPlayButton:sender];
    }
}

-(void)nextButtonPressed:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(ControlPanelView:didPressNextButton:)]) {
        [self.delegate ControlPanelView:self didPressNextButton:sender];
    }
}

-(void)previousButtonPressed:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(ControlPanelView:didPressPreviousButton:)]) {
        [self.delegate ControlPanelView:self didPressPreviousButton:sender];
    }
}

@end
