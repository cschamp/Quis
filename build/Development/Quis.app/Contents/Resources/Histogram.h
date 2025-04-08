//
//  Histogram.h
//  Quis
//
//  Created by Craig Schamp on 10/9/04.
//  $Id: Histogram.h,v 1.8 2004/10/31 05:50:09 chs Exp $
//

#import <Cocoa/Cocoa.h>


@interface Histogram : NSObject {
	NSMutableDictionary *_lexicon;	// list of each distinct word and frequency
	NSArray *_wordList;				// list of each distinct word
	int _sum;						// total of words in fiel at _filePath
}

- (void)histogramFromFileList:(NSArray *)fileList withConflation:(BOOL)conflationOption;
- (void) processWord:(NSString *)word;
- (int) summationIntValue;
- (unsigned int) count;
- (NSArray *)wordList;
- (NSDictionary *)dictionary;
- (NSNumber *)valueForKey:(NSString *)key;
- (NSString *)summary;

@end
