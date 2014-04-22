#import <Foundation/Foundation.h>

@interface NSString (DryDock)

- (NSString *)stringByReplacingEscapedNewlines;

- (BOOL)hasContent;

@end
