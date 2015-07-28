#import "ViewController.h"
#import "NSArray+Hiragana.h"
#import "UIColor+ApplicationColors.h"
#import "TABSymbol.h"
#import "Utility.h"
#import "TABDrawingView.h"
#import "TABSymbolView.h"
#import "TABControlPanelView.h"

@import AVFoundation;
#import <FLAnimatedImage/FLAnimatedImage.h>

@interface ViewController () <UIScrollViewDelegate, TABControlPanelViewDelegate, TABDrawingViewDelegate>

@property (strong, nonatomic) NSArray *symbols;
@property (strong, nonatomic) TABDrawingView *drawingView;
@property (strong, nonatomic) TABControlPanelView *controlPanel;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) NSMutableArray *symbolViews;

@end

@implementation ViewController

static NSString *const reuseIdentifier = @"reuseIdentifier";

#pragma mark - Lifecycle

-(instancetype) initWithSymbols:(NSArray *)symbols
{
    if (self = [super init]) {
        
        _symbols = symbols;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTapped:)];
        _scrollView = ({
            UIScrollView *scrollView = [[UIScrollView alloc] init];
            scrollView.pagingEnabled = YES;
            scrollView.delegate = self;
            scrollView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
            scrollView.showsHorizontalScrollIndicator = NO;
            scrollView;
        });
        [_scrollView addGestureRecognizer:tap];
        
        _drawingView = ({
            TABDrawingView *drawingView = [[TABDrawingView alloc] initWithFrame:CGRectZero];
            drawingView.backgroundColor = [UIColor tab_applicationColorYellow];
            drawingView;
        });
        
        _controlPanel = ({
            TABControlPanelView *control = [[TABControlPanelView alloc] initWithFrame:CGRectZero];
            control.backgroundColor = [UIColor tab_applicationColorRed];
            control.delegate = self;
            control;
        });
        
        for (UIView *view in @[ _scrollView, _controlPanel, _drawingView]) {
            view.translatesAutoresizingMaskIntoConstraints = NO;
            [self.view addSubview:view];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    CGFloat viewHeight = CGRectGetHeight(self.view.frame);
    
    [self.symbols enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        TABSymbol *symbol = (TABSymbol *)obj;
        TABSymbolView *symbolView = [[TABSymbolView alloc] initWithFrame:CGRectMake(idx * viewWidth, 0, viewWidth, viewHeight/3.0)];
        symbolView.image = [[FLAnimatedImage alloc] initWithAnimatedGIFData:[NSData dataWithContentsOfFile:symbol.gifPath]];
        symbolView.romanLetterLabel.text = symbol.letter;
        symbolView.symbolLabel.text = symbol.symbol;
        [self.symbolViews addObject:symbolView];
        [self.scrollView addSubview:symbolView];
    }];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    for (TABSymbolView *view in self.symbolViews) {
        [view.imageView stopAnimating];
    }
}

-(void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    CGFloat viewHeight = CGRectGetHeight(self.view.frame);
    CGFloat controlPanelHeight = 54.0f;
    
    CONSTRAIN_HEIGHT(self.scrollView, viewHeight/3.0);
    CONSTRAIN_WIDTH(self.scrollView, viewWidth);
    ALIGN_VIEW_TOP(self.view, self.scrollView);
    self.scrollView.contentSize = CGSizeMake(viewWidth*(self.symbols.count), viewHeight/3.0);
    
    CONSTRAIN_HEIGHT(self.controlPanel, controlPanelHeight);
    CONSTRAIN_WIDTH(self.controlPanel, viewWidth);
    ALIGN_VIEW_TOP_CONSTANT(self.view, self.controlPanel, viewHeight/3.0);
    ALIGN_VIEW_LEFT(self.view, self.controlPanel);
    
    CONSTRAIN_HEIGHT(self.drawingView, viewHeight * (2/3.0f) - controlPanelHeight);
    CONSTRAIN_WIDTH(self.drawingView, viewWidth);
    ALIGN_VIEW_BOTTOM(self.view, self.drawingView);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Touch Handling
#pragma mark - Scroll View
-(void)scrollViewTapped:(UIGestureRecognizer *)gesture {
    CGPoint touchPoint = [gesture locationInView:self.scrollView];
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    NSUInteger viewIndex = ceilf(touchPoint.x/viewWidth) - 1;
    
    TABSymbolView *symbolView = [self.symbolViews objectAtIndex:viewIndex];
    if (symbolView.imageView.isAnimating) [symbolView.imageView stopAnimating];
    else [symbolView.imageView startAnimating];
}

#pragma mark - TABControlPanelView Delegate

-(void)ControlPanelView:(TABControlPanelView *)view didPressPlayButton:(UIButton *)sender {
    [self animateButtonPush:sender];
    
    CGPoint contentOffset = self.scrollView.contentOffset;
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    NSUInteger viewIndex = (contentOffset.x/viewWidth);
    TABSymbol *symbol = [self.symbols objectAtIndex:viewIndex];
    
    NSError *error;
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:symbol.audioURL fileTypeHint:AVFileTypeWAVE error:&error];
    [_audioPlayer prepareToPlay];
    
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    } else {
        [_audioPlayer play];
    }
}

-(void) ControlPanelView:(TABControlPanelView *)view didPressNextButton:(UIButton *)sender {
    CGPoint currentScrollViewOffset = self.scrollView.contentOffset;
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    
    [self animateButtonPush:sender];
    
    if ((currentScrollViewOffset.x/viewWidth) < [NSArray tab_hiraganaSymbols].count - 1) {
        [UIView animateWithDuration:0.7f delay:0 usingSpringWithDamping:0.75 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self.scrollView setContentOffset:CGPointMake(currentScrollViewOffset.x+viewWidth, 0)];
        } completion:nil];
    } else {
        [self.scrollView setContentOffset:CGPointMake(currentScrollViewOffset.x+25.0, 0)];
        [UIView animateWithDuration:0.7f delay:0 usingSpringWithDamping:0.75 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self.scrollView setContentOffset:CGPointMake(currentScrollViewOffset.x, 0)];
        } completion:nil];
    }
}

-(void) ControlPanelView:(TABControlPanelView *)view didPressPreviousButton:(UIButton *)sender {
    CGPoint currentScrollViewOffset = self.scrollView.contentOffset;
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    
    [self animateButtonPush:sender];
    
    if (currentScrollViewOffset.x != 0) {
        [UIView animateWithDuration:0.7f delay:0 usingSpringWithDamping:0.75 initialSpringVelocity:1.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self.scrollView setContentOffset:CGPointMake(currentScrollViewOffset.x-viewWidth, 0)];
        } completion:nil];
    } else {
        [self.scrollView setContentOffset:CGPointMake(-25.0, 0)];
        [UIView animateWithDuration:0.7f delay:0 usingSpringWithDamping:0.75 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self.scrollView setContentOffset:CGPointMake(0, 0)];
        } completion:nil];
    }
}

-(void) animateButtonPush:(UIButton *)sender {
    sender.transform = CGAffineTransformMakeScale(0.7, 0.7);
    [UIView animateWithDuration:0.7f delay:0 usingSpringWithDamping:0.75 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        sender.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:nil];
}

#pragma mark - Lazy Instantiation

-(NSMutableArray *)symbolViews {
    if (!_symbolViews) {
        _symbolViews = [[NSMutableArray alloc] init];
    }
    return _symbolViews;
}

@end
