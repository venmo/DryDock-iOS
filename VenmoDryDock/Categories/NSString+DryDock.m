#import "NSString+DryDock.h"

@implementation NSString (DryDock)

- (NSString *)stringByReplacingEscapedNewlines {
    return [self stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
}


- (BOOL)hasContent {
    NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
    return ([[self stringByTrimmingCharactersInSet: set] length] == 0) ? NO : YES;
}

@end
