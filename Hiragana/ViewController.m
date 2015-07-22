#import "ViewController.h"
#import "NSArray+Hiragana.h"
#import "TABSymbol.h"
#import "TABCollectionViewCell.h"
#import "PunchedLayout.h"
#import "Utility.h"
#import "TABDrawingView.h"

#import <FLAnimatedImage/FLAnimatedImage.h>

@interface ViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (strong, nonatomic) FLAnimatedImageView *animatedView;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) TABDrawingView *drawingView;
@property (strong, nonatomic) NSMutableDictionary *symbols;

@end

@implementation ViewController

static NSString *const reuseIdentifier = @"reuseIdentifier";

-(instancetype) init
{
    if (self = [super init]) {
        
        PunchedLayout *layout = [[PunchedLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(10.0f, 80.0f, 10.0f, 10.0f);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = ({
            UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
            collectionView.dataSource = self;
            collectionView.delegate = self;
            collectionView.backgroundColor = [UIColor whiteColor];
            collectionView.translatesAutoresizingMaskIntoConstraints = NO;
            collectionView;
        });
        
        _drawingView = [[TABDrawingView alloc] initWithFrame:CGRectZero];
        
        for (UIView *view in @[_drawingView, _collectionView]) {
            view.translatesAutoresizingMaskIntoConstraints = NO;
            [self.view addSubview:view];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerClass:[TABCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
}

-(void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    CGFloat viewHeight = CGRectGetHeight(self.view.frame);
    
    CONSTRAIN_HEIGHT(self.collectionView, viewHeight/3.0);
    CONSTRAIN_WIDTH(self.collectionView, viewWidth);
    ALIGN_VIEW_TOP(self.view, self.collectionView);
    
    CONSTRAIN_HEIGHT(self.drawingView, viewHeight/3.0f);
    CONSTRAIN_WIDTH(self.drawingView, viewWidth);
    ALIGN_VIEW_BOTTOM(self.view, self.drawingView);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UICollectionViewFlowLayout delegate

-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
    UIEdgeInsets sectionInsets = layout.sectionInset;
    CGFloat collectionViewHeight = collectionView.frame.size.height;
    return CGSizeMake(200, collectionViewHeight - sectionInsets.bottom - sectionInsets.top);
}

#pragma mark - UICollectionView Data Source

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [[NSArray tab_hiraganaSymbols] count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TABCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSString *letter = [NSArray tab_hiraganaSymbols][indexPath.section];
    TABSymbol *symbol = [self.symbols objectForKey:letter];
    
    if (!symbol) {
        symbol = [[TABSymbol alloc] initWithSymbol:letter];
        [self.symbols setObject:symbol forKey:letter];
    }
    
    cell.imageView.animatedImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:[NSData dataWithContentsOfFile:symbol.gifPath]];
    cell.imageView.animationDuration = 2.0;
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Stopped show cell %@", cell.description);
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - CollectionView Delegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TABCollectionViewCell *cell = (TABCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (cell.imageView.isAnimating) [cell.imageView stopAnimating];
    else [cell.imageView startAnimating];
}

-(NSMutableDictionary *)symbols
{
    if (!_symbols) {
        _symbols = [[NSMutableDictionary alloc] init];
    }
    
    return _symbols;
}

@end
