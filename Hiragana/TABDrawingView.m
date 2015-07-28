#import "TABDrawingView.h"
#import "TABLine.h"
#import "UIColor+ApplicationColors.h"

@interface TABDrawingView()

@property (nonatomic, strong) TABLine *currentLine;
@property (nonatomic, strong) NSMutableArray *finishedLines;
@property (nonatomic, strong) UIButton *clearButton;

// Playing with animation
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIGravityBehavior *gravity;
@property (nonatomic, strong) UIAttachmentBehavior *attachment;
@property (nonatomic, strong) UIDynamicItemBehavior *itemBehavior;

@property (nonatomic, assign) BOOL draggingView;
@property (nonatomic, assign) CGPoint initialTouchPoint;

@end

@implementation TABDrawingView

-(instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        
        _clearButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(clearButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(8, 8, 44, 44);
            button.backgroundColor = [UIColor whiteColor];
            [button setImage:[UIImage imageNamed:@"trash"] forState:UIControlStateNormal];
            [button.layer setCornerRadius:22.0f];
            [button.layer setMasksToBounds:NO];
            [button.layer setShadowOffset:CGSizeMake(-15, 20)];
            [button.layer setShadowRadius:5];
            [button.layer setShadowOpacity:0.2];
            button;
        });
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [_clearButton addGestureRecognizer:panGesture];
        
        [self addSubview:_clearButton];
        
        _animator = ({
            UIDynamicAnimator *animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
            animator;
        });
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    [[UIColor tab_applicationColorRed] set];
    for (TABLine *line in self.finishedLines) {
        [self strokeLine:line];
    }
    
    if (self.currentLine) {
        [[UIColor blackColor] set];
        [self strokeLine:self.currentLine];
    }
}

-(void)strokeLine:(TABLine *)line
{
    UIBezierPath *bp = [UIBezierPath bezierPath];
    bp.lineWidth = 25.0f;
    bp.lineCapStyle = kCGLineCapRound;
    
    [bp moveToPoint:line.begin];
    [bp addLineToPoint:line.end];
    [bp stroke];
}

#pragma mark - Touch Handling

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint location = [touch locationInView:self];
    
    self.currentLine = [[TABLine alloc] init];
    self.currentLine.begin = location;
    self.currentLine.end = location;
    
    [self setNeedsDisplay];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch= [touches anyObject];
    CGPoint location = [touch locationInView:self];
    self.currentLine.end = location;
    
    self.currentLine.bounds = CGRectMake(0, 0, 0.5, 0.5);
    self.currentLine.center = CGPointMake(50, 50);
    self.currentLine.transform = CGAffineTransformIdentity;
    
    [self.finishedLines addObject:self.currentLine];
    
    //Start New Line
    self.currentLine = nil;
    self.currentLine = [[TABLine alloc] init];
    self.currentLine.begin = location;
    self.currentLine.end = location;
    
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.finishedLines addObject:self.currentLine];
    self.currentLine = nil;
    [self setNeedsDisplay];
}

-(void) clearButtonPressed:(UIButton *)sender {
    
    sender.transform = CGAffineTransformMakeScale(0.7, 0.7);
    [UIView animateWithDuration:0.45f delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        sender.transform = CGAffineTransformIdentity;
    } completion:^(BOOL succeeded) {
        self.finishedLines = nil;
        [self setNeedsDisplay];
    }];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position.x";
    animation.values = @[@0, @30, @-20, @10, @0];
    animation.keyTimes = @[@0, @(1/6.0), @(3/6.0), @(5/6.0), @1.0];
    animation.duration = 0.5;
    animation.additive = YES;
    [self.layer addAnimation:animation forKey:@"shake"];

    CABasicAnimation *fadeAnimation = [CABasicAnimation animation];
    fadeAnimation.keyPath = @"opacity";
    fadeAnimation.duration = 0.5;
    fadeAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
    fadeAnimation.toValue = [NSNumber numberWithFloat:0.0f];
    fadeAnimation.removedOnCompletion = YES;
    [self.layer addAnimation:fadeAnimation forKey:@"fade"];
    
    if ([self.delegate respondsToSelector:@selector(DrawingView:pressedClearButton:)]) {
        [self.delegate DrawingView:self pressedClearButton:sender];
    }
}

-(void)handlePan:(UIPanGestureRecognizer *)gesture
{
    CGPoint touchPoint = [gesture locationInView:self];
    UIButton *trashButton = (UIButton *)gesture.view;
    CGSize buttonSize = self.clearButton.frame.size;
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            self.draggingView = YES;
            self.initialTouchPoint = trashButton.center;
            [self.animator removeBehavior:self.attachment];
        }
            break;
        case UIGestureRecognizerStateChanged: {
            trashButton.frame = CGRectMake(touchPoint.x - buttonSize.width/2.0, touchPoint.y - buttonSize.height/2.0, buttonSize.width, buttonSize.height);
        }
            break;
        case UIGestureRecognizerStateEnded: {
            self.draggingView = NO;
            self.attachment = ({
                UIAttachmentBehavior *attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:trashButton attachedToAnchor:self.initialTouchPoint];
                attachmentBehavior.frequency = 1.5;
                attachmentBehavior.damping = .7;
                attachmentBehavior.length = 0;
                attachmentBehavior;
            });
            [self.animator addBehavior:self.attachment];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Lazy Instantiation

-(NSMutableArray *)finishedLines
{
    if (!_finishedLines) {
        _finishedLines = [[NSMutableArray alloc] init];
    }
    
    return _finishedLines;
}

@end
