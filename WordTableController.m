//
//  WordTableController.m
//  Quis
//
//  Created by Craig Schamp on 10/16/04.
//  $Id: WordTableController.m,v 1.3 2004/11/10 06:51:10 chs Exp $
//

#import "WordTableController.h"

@implementation WordTableController

-(id) init
{
	if (self = [super init]) {
		_histogram = nil;
	}
	return self;
}

-(void)dealloc
{
	[_histogram release]; _histogram = nil;
	[super dealloc];
}

- (int)numberOfRowsInTableView:(NSTableView *)tableView
{
	if (_histogram)
		return [_histogram count];
	else
		return 0;
}

- (id)tableView:(NSTableView *)tableView
		objectValueForTableColumn:(NSTableColumn *)tableColumn
		row:(int)row
{
	int column = [[tableColumn identifier] intValue];
	NSString *result = nil;
	NSString *word = [[_histogram wordList] objectAtIndex:row];

	switch (column) {
	case 0: result = word;
			break;
	case 1: result = [[_histogram valueForKey:word] stringValue];
			break;
	case 2: result = nil;
			break;
	default:
			NSLog(@"Unexpected column value");
			result = nil;
			break;
	}
	return result;
}

- (BOOL)tableView:(NSTableView *)tableView writeRows:(NSArray *)rows toPasteboard:(NSPasteboard *)pboard
{
	BOOL success;

	NSEnumerator *enumerator = [rows objectEnumerator];
	NSMutableString *result = [[[NSMutableString alloc] init] autorelease];
	NSNumber *rowNum;
	while (rowNum = [enumerator nextObject]) {
		NSString *word = [[_histogram wordList] objectAtIndex:[rowNum intValue]];
		[result appendFormat:@"%@\t%@\n", word, [[_histogram valueForKey:word] stringValue]];
	}
	NSArray *types = [NSArray arrayWithObjects:NSStringPboardType, nil];
	[pboard declareTypes:types owner:self];
	success = [pboard setString:result forType:NSStringPboardType];
	return success;
}

- (void)setHistogram:(Histogram *)histogram
{
	if (_histogram) [_histogram release];
	_histogram = [histogram retain];
	[wordTable noteNumberOfRowsChanged];
}

@end
