//
//  Histogram.h
//  Quis
//
//  Created by Craig Schamp on 10/9/04.
//  Updated for modern macOS on 2024
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Histogram : NSObject {
	NSMutableDictionary *_lexicon;	// list of each distinct word and frequency
	NSArray *_wordList;				// list of each distinct word
	int _sum;						// total of words in fiel at _filePath
}

- (void)histogramFromFileList:(NSArray<NSString *> *)fileList withConflation:(BOOL)conflationOption;
- (void) processWord:(NSString *)word;
- (NSInteger)summationIntValue;
- (NSUInteger)count;
- (NSArray<NSString *> *)wordList;
- (NSDictionary<NSString *, NSNumber *> *)dictionary;
- (nullable NSNumber *)valueForKey:(NSString *)key;
- (NSString *)summary;

@end

NS_ASSUME_NONNULL_END
