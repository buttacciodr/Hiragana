#import "TABSymbol.h"

#import "NSString+Hiragana.h"

@implementation TABSymbol

-(instancetype) initWithSymbol:(NSString *)symbol
{
    if (self = [super init]) {
        _symbol = symbol;
        _letter = [NSString tab_romanLetterForSymbol:symbol];
        _gifPath = [[NSBundle mainBundle] pathForResource:symbol ofType:@"gif"];
        NSString *path = [[NSBundle mainBundle] pathForResource:symbol ofType:@"wav" inDirectory:@"Sounds"];
        _audioURL = [[NSURL alloc] initFileURLWithPath:path];
    }
    return self;
}

+(NSArray *) createTABSymbolsFromCharacterList:(NSArray *)characters {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (NSString *character in characters) {
        TABSymbol *symbol = [[TABSymbol alloc] initWithSymbol:character];
        [array addObject:symbol];
    }
    return array;
}

@end
