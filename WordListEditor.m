//
//  WordListEditor.m
//  Quis
//
//  Created by Craig Schamp on 10/24/04.
//  Copyright 2004 Craig Schamp. All rights reserved.
//
//  $Id: WordListEditor.m,v 1.5 2004/10/30 16:19:52 chs Exp $
//

#import "WordListEditor.h"


@implementation WordListEditor

#pragma mark -- NSDocument
- (NSString *)windowNibName {
    // Implement this to return a nib to load OR implement -makeWindowControllers to manually create your controllers.
    return @"WordListEditor";
}

- (NSData *)dataRepresentationOfType:(NSString *)type {
    // Implement to provide a persistent data representation of your document OR remove this and implement the file-wrapper or file path based save methods.
    return nil;
}

- (BOOL)loadDataRepresentation:(NSData *)data ofType:(NSString *)type {
    // Implement to load a persistent data representation of your document OR remove this and implement the file-wrapper or file path based load methods.
    return YES;
}

- (BOOL)readFromFile:(NSString *)fileName ofType:(NSString *)type
{
	_aliases = [[[Aliases alloc] initWithContentsOfFile:fileName] retain];
	return _aliases != nil;
}

- (BOOL)writeToFile:(NSString *)fileName ofType:(NSString *)docType
{
	return [_aliases writeToFile:fileName atomically:YES];
}

#pragma mark -- NSOutlineView Data Source

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
	NSArray *children;
	if (!item) children = [_aliases allAliases];
	else children = [_aliases wordListForAlias:item];
	
	if ((!children) || ([children count] < 1)) return NO;
	return YES;
}

- (int)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
	NSArray *children;
	if (!item) children = [_aliases allAliases];
	else children = [_aliases wordListForAlias:item];

	return [children count];
}

-(id)outlineView:(NSOutlineView *)outlineView child:(int)index ofItem:(id)item
{
	NSArray *children;
	if (!item) children = [_aliases allAliases];
	else children = [_aliases wordListForAlias:item];

	if ((!children) || ([children count] <= (unsigned int) index)) return nil;
	return [children objectAtIndex:index];
}

-(id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
	return item;
}

#if 0
#pragma mark -- NSOutlineView Data Source Drag and Drop

- (BOOL)outlineView:(NSOutlineView *)ov writeItems:(NSArray *)items toPasteboard:(NSPasteboard *)pboard
{
	NSData *data;
	data = [self encodeDataRepresentationForObjects:items];
	[ov registerForDraggedTypes:[NSArray arrayWithObjects:CAT_DRAG_TYPE, nil]];
	[pboard declareTypes:[NSArray arrayWithObjects:CAT_DRAG_TYPE, nil] owner:self];
	[pboard setData:data forType:CAT_DRAG_TYPE];
	return YES;
}

- (unsigned int)outlineView:(NSOutlineView *)ov validateDrop:(id <NSDraggingInfo>)info proposedItem:(id)item proposedChildIndex:(int)index
{
}

- (BOOL)outlineView:(NSOutlineView *)ov acceptDrop:(id <NSDraggingInfo>)info item:(id)item childIndex:(int)index
{
}
#endif
@end
