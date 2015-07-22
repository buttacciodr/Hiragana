#import "TABSymbol.h"

@implementation TABSymbol

-(instancetype) initWithSymbol:(NSString *)symbol
{
    if (self = [super init]) {
        _symbol = symbol;
        _gifPath = [[NSBundle mainBundle] pathForResource:symbol ofType:@"gif"];
    }
    return self;
}

@end
