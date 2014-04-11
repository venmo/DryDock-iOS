#import "NSString+DryDock.h"

@implementation NSString (DryDock)

- (NSString *)stringByReplacingEscapedNewlines {
    return [self stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
}


- (BOOL)hasContent {
    NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
    if ([[self stringByTrimmingCharactersInSet: set] length] == 0)
    {
        return NO;
    }
    return YES;
}

@end
