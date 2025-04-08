//
//  WordTableView.m
//  Quis
//
//  Created by Craig Schamp on 11/9/04.
//  Copyright 2004 Craig Schamp. All rights reserved.
//

#import "WordTableView.h"

@implementation WordTableView

- (IBAction)copy:(id)sender
{
	id ds = [self dataSource];
	if (!ds || ![ds respondsToSelector:@selector(tableView:writeRows:toPasteboard:)])
		return;

	// XXX selectedRowEnumerator deprecated in 10.3. Use selectedRowIndexes instead.
	NSArray *rows = [[[self selectedRowEnumerator] allObjects] sortedArrayUsingSelector:@selector(compare:)];
	if (![ds tableView:self writeRows:rows toPasteboard:[NSPasteboard generalPasteboard]])
		NSBeep();

    return;
}

@end
