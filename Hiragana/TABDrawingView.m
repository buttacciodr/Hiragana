#import "TABDrawingView.h"
#import "TABLine.h"

@interface TABDrawingView()

@property (nonatomic, strong) TABLine *currentLine;
@property (nonatomic, strong) NSMutableArray *finishedLines;
@property (nonatomic, strong) UIButton *clearButton;

@end

@implementation TABDrawingView

-(instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor lightGrayColor];
        
        _clearButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(clearButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(0, 0, 50, 50);
            button.backgroundColor = [UIColor whiteColor];
            [button setImage:[UIImage imageNamed:@"trash"] forState:UIControlStateNormal];
            [button.layer setCornerRadius:25.0f];
            [button.layer setMasksToBounds:YES];
            button;
        });
        
        [self addSubview:_clearButton];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    [[UIColor blackColor] set];
    for (TABLine *line in self.finishedLines) {
        [self strokeLine:line];
    }
    
    if (self.currentLine) {
        [[UIColor redColor] set];
        [self strokeLine:self.currentLine];
    }
}

-(void)strokeLine:(TABLine *)line
{
    UIBezierPath *bp = [UIBezierPath bezierPath];
    bp.lineWidth = 20.0f;
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

-(void) clearButtonPressed:(UIButton *)sender
{
    self.finishedLines = nil;
    
    [self setNeedsDisplay];
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
