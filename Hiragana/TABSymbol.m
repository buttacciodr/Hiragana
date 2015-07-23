#import "TABSymbol.h"

@implementation TABSymbol

-(instancetype) initWithSymbol:(NSString *)symbol
{
    if (self = [super init]) {
        _symbol = symbol;
        _gifPath = [[NSBundle mainBundle] pathForResource:symbol ofType:@"gif"];
        NSString *path = [[NSBundle mainBundle] pathForResource:symbol ofType:@"wav" inDirectory:@"Sounds"];
        _audioURL = [[NSURL alloc] initFileURLWithPath:path];
    }
    return self;
}

@end
