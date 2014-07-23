#import "NSString+DryDock.h"

SPEC_BEGIN(NSString_DryDock)

describe(@"stringByReplacingEscapedNewlines", ^{

    it(@"should handle empty string", ^{
        [[[@"" stringByReplacingEscapedNewlines] should] equal:@""];
    });

    it(@"should replace \\n with \n", ^{
        [[[@"\\n" stringByReplacingEscapedNewlines] should] equal:@"\n"];
        [[[@"Hello\\nWorld" stringByReplacingEscapedNewlines] should] equal:@"Hello\nWorld"];
        [[[@"\\n\\n\\n" stringByReplacingEscapedNewlines] should] equal:@"\n\n\n"];
        [[[@"\\nHello\\nWorld\n" stringByReplacingEscapedNewlines] should] equal:@"\nHello\nWorld\n"];
    });

    it(@"should not change anything if there is no occurrence of \\n", ^{
        [[[@"Hello world" stringByReplacingEscapedNewlines] should] equal:@"Hello world"];
        [[[@"Hello\nworld" stringByReplacingEscapedNewlines] should] equal:@"Hello\nworld"];
        [[[@"n" stringByReplacingEscapedNewlines] should] equal:@"n"];
        [[[@"\\N" stringByReplacingEscapedNewlines] should] equal:@"\\N"];
    });
});

describe(@"hasContent", ^{

    it(@"should return NO for empty string", ^{
        [[theValue([@"" hasContent]) should] beNo];
    });

    it(@"should return NO for a string that contains only whitespace characters", ^{
        [[theValue([@" " hasContent]) should] beNo];
        [[theValue([@"          " hasContent]) should] beNo];
    });
});

SPEC_END