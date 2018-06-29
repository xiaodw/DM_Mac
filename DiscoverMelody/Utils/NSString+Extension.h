#import <Cocoa/Cocoa.h>

@interface NSString (Extension)

- (instancetype)trim;
- (CGFloat)stringHeightWithFont:(NSFont *)font maxWidth:(CGFloat)width;
- (CGFloat)stringWidthWithFont:(NSFont *)font maxHeight:(CGFloat)height;
- (instancetype)stringByPaddingLeftWithString:(NSString *)padString total:(NSInteger)total;
- (instancetype)stringByPaddingRightWithString:(NSString *)padString total:(NSInteger)total;

+ (instancetype)stringWithTimeToHHmmss:(NSInteger)second;

@end
