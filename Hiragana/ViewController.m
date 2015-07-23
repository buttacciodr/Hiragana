#import "ViewController.h"
#import "NSArray+Hiragana.h"
#import "UIColor+ApplicationColors.h"
#import "TABSymbol.h"
#import "Utility.h"
#import "TABDrawingView.h"
#import "TABSymbolView.h"
#import "TABDraggableView.h"

#import "TABPullingBehavior.h"

@import AVFoundation;
#import <FLAnimatedImage/FLAnimatedImage.h>

@interface ViewController () <UIScrollViewDelegate>

@property (strong, nonatomic) TABDrawingView *drawingView;
@property (strong, nonatomic) NSMutableDictionary *symbols;
@property (strong, nonatomic) UIDynamicAnimator *animator;

//Playing With ScrollView
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *symbolViews;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) TABDraggableView *draggableView;

@end

@implementation ViewController

static NSString *const reuseIdentifier = @"reuseIdentifier";

-(instancetype) init
{
    if (self = [super init]) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTapped:)];
        _scrollView = ({
            UIScrollView *scrollView = [[UIScrollView alloc] init];
            scrollView.pagingEnabled = YES;
            scrollView.delegate = self;
            scrollView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
            scrollView;
        });
        [_scrollView addGestureRecognizer:tap];
        
        _drawingView = ({
            TABDrawingView *drawingView = [[TABDrawingView alloc] initWithFrame:CGRectZero];
            drawingView.backgroundColor = [UIColor tab_applicationColorYellow];
            [drawingView.layer setBorderColor:[UIColor tab_applicationColorRed].CGColor];
            [drawingView.layer setBorderWidth:5.0f];
            drawingView;
        });
        
        for (UIView *view in @[ _scrollView, _drawingView]) {
            view.userInteractionEnabled = YES;
            view.translatesAutoresizingMaskIntoConstraints = NO;
            [self.view bringSubviewToFront:view];
            [self.view addSubview:view];
        }
        
        _animator = ({
            UIDynamicAnimator *animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
            animator;
        });
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (int i = 0; i < [[NSArray tab_hiraganaSymbols] count]; i++) {
        NSString *letter = [NSArray tab_hiraganaSymbols][i];
        
        TABSymbol *symbol = [self.symbols objectForKey:letter];
        if (!symbol) {
            symbol = [[TABSymbol alloc] initWithSymbol:letter];
            [self.symbols setObject:symbol forKey:letter];
        }
        
        FLAnimatedImageView *animatedView = [[FLAnimatedImageView alloc] init];
        animatedView.animationDuration = 10.0f;
        animatedView.animatedImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:[NSData dataWithContentsOfFile:symbol.gifPath]];
        [self.scrollView addSubview:animatedView];
        [self.symbolViews addObject:animatedView];
        
        CGFloat viewWidth = CGRectGetWidth(self.view.frame);
        CGFloat viewHeight = CGRectGetHeight(self.view.frame);
        
        animatedView.frame = CGRectMake(viewWidth * i, 0, viewWidth, viewHeight/3.0);
    }
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    for (FLAnimatedImageView *view in self.symbolViews) {
        [view stopAnimating];
    }
    
    //Testing
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    CGFloat viewHeight = CGRectGetHeight(self.view.frame);
    UIButton *headphones = [UIButton buttonWithType:UIButtonTypeCustom];
    [headphones setImage:[UIImage imageNamed:@"headphones"] forState:UIControlStateNormal];
    [headphones addTarget:self action:@selector(playButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    headphones.frame = CGRectMake(viewWidth - 35, viewHeight/3.0 - 35, 35, 35);
    [self.view addSubview:headphones];
    
    TABPullingBehavior *pullingBehavior = ({
        TABPullingBehavior *behavior = [[TABPullingBehavior alloc] initWithItem:headphones];
        behavior.targetPoint = CGPointMake(viewWidth - 35, viewHeight/3.0 - 35);
        behavior.velocity = CGPointZero;
        behavior;
    });
    
    [self.animator addBehavior:pullingBehavior];
    
}

-(void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    CGFloat viewHeight = CGRectGetHeight(self.view.frame);
    
    CONSTRAIN_HEIGHT(self.scrollView, viewHeight/3.0);
    CONSTRAIN_WIDTH(self.scrollView, viewWidth);
    ALIGN_VIEW_TOP(self.view, self.scrollView);
    
    self.scrollView.contentSize = CGSizeMake(viewWidth*5.0, viewHeight/3.0);
    
    CONSTRAIN_HEIGHT(self.drawingView, viewHeight * (2/3.0f));
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
    
    FLAnimatedImageView *imageView = [self.symbolViews objectAtIndex:viewIndex];
    if (imageView.isAnimating) [imageView stopAnimating];
    else [imageView startAnimating];
}

-(void)playButtonPressed:(UIButton *)sender {
    
    TABSymbol *symbol = [self.symbols objectForKey:[NSArray tab_hiraganaSymbols][1]];
    
    NSError *error;
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:symbol.audioURL fileTypeHint:AVFileTypeWAVE error:&error];
    [_audioPlayer prepareToPlay];
    
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    } else {
        [_audioPlayer play];
    }
}


#pragma mark - Lazy Instantiation

-(NSMutableDictionary *)symbols
{
    if (!_symbols) {
        _symbols = [[NSMutableDictionary alloc] init];
    }
    return _symbols;
}

-(NSMutableArray *)symbolViews
{
    if (!_symbolViews) {
        _symbolViews = [[NSMutableArray alloc] init];
    }
    return _symbolViews;
}

@end
