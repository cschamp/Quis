//
//  Aliases.m
//  Quis
//
//  Created by Craig Schamp on 10/24/04.
//  Copyright 2004 Craig Schamp. All rights reserved.
//  $Id: Aliases.m,v 1.3 2004/10/28 01:38:13 chs Exp $
//
//  Modified by Craig Schamp on 4/8/2025 for modern macOS
//

#import "Aliases.h"


@implementation Aliases

-(id)init
{
	return [self initWithContentsOfFile:nil];
}

-(id)initWithContentsOfFile:(NSString *)filePath
{
	_aliasDictionary = nil;
	if (self = [super init]) {
		if (filePath)
			_aliasDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];	// XXX retain???
			// The values in the dictionary form the list of aliases. Create
			// an array of aliases, containing only one instance of each alias.
			NSEnumerator *aliasEnumerator = [[_aliasDictionary allValues] objectEnumerator];
			NSMutableDictionary *aliasValues = [[NSMutableDictionary alloc] init];
			NSString *alias;
			while (alias = [aliasEnumerator nextObject]) {
				NSNumber *count = [aliasValues objectForKey:alias];
				if (count == nil) {
					[aliasValues setObject:[NSNumber numberWithInt:1] forKey:alias];
				} else {
					NSNumber *newValue = [NSNumber numberWithInt:[count intValue] + 1];
					[aliasValues setValue:newValue forKey:alias];
				}
			}
			_allAliases = [aliasValues allKeys];
	}
	return self;
}

-(BOOL)writeToFile:(NSString *)file atomically:(BOOL)flag
{
	return [_aliasDictionary writeToFile:file atomically:flag];
}

- (void)setAlias:(NSString *)alias forWord:(NSString *)word
{
	// prevent circular aliases to self
	if ([alias isEqualToString:word]) return;

	[_aliasDictionary setValue:alias forKey:word];
}

//
// Given a word, return its alias. If a word has an alias, it
// will be counted as if the alias, not the word, appeared in the text.
// 
- (NSString *)aliasForWord:(NSString *)word
{
	return [_aliasDictionary valueForKey:word];
}

//
// Return the list of words aliased to the "alias" word.
//
- (NSArray *)wordListForAlias:(NSString *)alias
{
	return [[_aliasDictionary allKeysForObject:alias] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

//
// Return the list of all alias names
//
- (NSArray *)allAliases
{
	return [_allAliases sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

@end
