
#import "StringCategory.h"

CFStringRef charsToEscape = CFSTR("!*'();:@&=+$,/?%#[]");

@implementation NSString (URLEncoding)

- (NSString *)stringByAddingPercentEscapes
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (CFStringRef)self, NULL, charsToEscape,
                                                                                 CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
}

- (NSString *)stringByReplacingPercentEscapes
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self, CFSTR("")));
}

@end
