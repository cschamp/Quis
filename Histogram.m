//
//  Histogram.m
//  Quis
//
//  Created by Craig Schamp on 10/9/04.
//  Updated for modern macOS on 2024
//

#import "Histogram.h"

@implementation Histogram {
    NSMutableDictionary<NSString *, NSNumber *> *_lexicon;
    NSArray<NSString *> *_wordList;
    NSInteger _sum;
}

- (instancetype)init {
    if (self = [super init]) {
        _lexicon = [NSMutableDictionary dictionaryWithCapacity:1000];
        _wordList = nil;
        _sum = 0;
    }
    return self;
}

- (void) dealloc
{
	[_lexicon release];		_lexicon = nil;
	[_wordList release];	_wordList = nil;
	[super dealloc];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%lu keys in lexicon", (unsigned long)[_lexicon count]];
}

- (NSString *)summary
{
	NSMutableString *summaryText = [NSMutableString string];
	NSArray<NSString *> *sortedWords = [_lexicon keysSortedByValueUsingSelector:@selector(compare:)];
	NSInteger singletons = 0;
	NSInteger noise = 0;
	NSInteger largestvalue = 0;
	NSString *mostFrequentWord = nil;
	
	for (NSString *word in sortedWords) {
		NSInteger frequency = [_lexicon[word] integerValue];
		if (frequency == 1) {
			singletons++;
		}
		if (frequency < 6) {
			noise++;
		}
		if (frequency > largestvalue) {
			largestvalue = frequency;
			mostFrequentWord = word;
		}
	}
	
	[summaryText appendFormat:@"Total number of words: %ld\n", (long)_sum];
	[summaryText appendFormat:@"Number of distinct words: %lu (%4.2f%%)\n", (unsigned long)[_lexicon count], (float)[_lexicon count] / _sum * 100];
	[summaryText appendFormat:@"Number of words seen exactly once: %ld (%4.2f%%)\n", (long)singletons, (float)singletons / _sum * 100];
	[summaryText appendFormat:@"Number of words seen 5 or fewer times: %ld (%4.2f%%)\n", (long)noise, (float)noise / _sum * 100];
	[summaryText appendFormat:@"Most frequent: \"%@\" (%ld times)\n", mostFrequentWord, (long)largestvalue];
	return summaryText;
}

- (NSInteger)summationIntValue
{
	return _sum;
}

- (NSUInteger)count
{
	return [_lexicon count];
}

- (NSArray<NSString *> *)wordList
{
	return _wordList;
}

- (NSDictionary<NSString *, NSNumber *> *)dictionary
{
	return _lexicon;
}

- (NSNumber *)valueForKey:(NSString *)key
{
	return _lexicon[key];
}

- (void)histogramFromFileList:(NSArray<NSString *> *)fileList withConflation:(BOOL)conflationOption
{
	NSError *error = nil;
	NSRegularExpression *wordRegex = [NSRegularExpression regularExpressionWithPattern:@"[\\w]+" options:0 error:&error];
	if (!wordRegex) {
		NSLog(@"Error creating regex: %@", error);
		return;
	}
	
	for (NSString *filePath in fileList) {
		NSError *readError = nil;
		NSString *fileContents = [[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&readError] lowercaseString];
		if (!fileContents) {
			NSLog(@"Error reading file %@: %@", filePath, readError);
			continue;
		}
		
		fileContents = [fileContents stringByReplacingOccurrencesOfString:@"\r" withString:@"\n"];
		fileContents = [fileContents stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
		
		if (conflationOption) {
			fileContents = [fileContents stringByReplacingOccurrencesOfString:@"j" withString:@"i"];
			fileContents = [fileContents stringByReplacingOccurrencesOfString:@"u" withString:@"v"];
		}
		
		NSArray<NSString *> *tokens = [fileContents componentsSeparatedByString:@" "];
		for (NSString *word in tokens) {
			NSRange range = NSMakeRange(0, word.length);
			NSArray<NSTextCheckingResult *> *matches = [wordRegex matchesInString:word options:0 range:range];
			if (matches.count > 0) {
				NSTextCheckingResult *match = matches[0];
				NSString *matchedWord = [word substringWithRange:[match range]];
				[self processWord:matchedWord];
			}
		}
	}
	
	_wordList = [[_lexicon allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

- (void)processWord:(NSString *)word
{
	NSNumber *count = _lexicon[word];
	if (count == nil) {
		_lexicon[word] = @1;
	} else {
		_lexicon[word] = @(count.integerValue + 1);
	}
	_sum++;
}

@end
