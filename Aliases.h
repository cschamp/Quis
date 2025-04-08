//
//  Aliases.h
//  Quis
//
//  Created by Craig Schamp on 10/24/04.
//  Copyright 2004 Craig Schamp. All rights reserved.
//  $Id: Aliases.h,v 1.3 2004/10/28 01:38:13 chs Exp $
//

#import <Cocoa/Cocoa.h>


@interface Aliases : NSObject {
	NSMutableDictionary *_aliasDictionary;	// use word as index, and get its alias
	NSArray *_allAliases;			// inverse: all aliases (values) in dictionary
}

-(id)initWithContentsOfFile:(NSString *)filePath;
-(BOOL)writeToFile:(NSString *)file atomically:(BOOL)flag;
- (void)setAlias:(NSString *)alias forWord:(NSString *)word;
- (NSString *)aliasForWord:(NSString *)word;
- (NSArray *)wordListForAlias:(NSString *)word;
- (NSArray *)allAliases;

@end
