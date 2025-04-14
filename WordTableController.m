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

- (NSUInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    NSLog(@"numberOfRowsInTableView called, histogram: %@, count: %lu", _histogram, (unsigned long)[_histogram count]);
    if (_histogram)
        return [_histogram count];
    else
        return 0;
}

- (void)awakeFromNib {
    // Configure the table view and its columns for proper dark mode support
    for (NSTableColumn *column in [wordTable tableColumns]) {
        NSTextFieldCell *cell = [column dataCell];
        // Set the cell to use the label color which automatically adapts to dark/light mode
        [cell setTextColor:[NSColor labelColor]];
    }
    
    // Set the table view's background color
    [wordTable setBackgroundColor:[NSColor controlBackgroundColor]];
    
    // Set the table view's delegate
    [wordTable setDelegate:self];
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

// Add this method to handle text color in both selected and unselected states
- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSTextFieldCell *textCell = (NSTextFieldCell *)cell;
    if ([tableView isRowSelected:row]) {
        [textCell setTextColor:[NSColor selectedTextColor]];
    } else {
        [textCell setTextColor:[NSColor labelColor]];
    }
}

- (BOOL)tableView:(NSTableView *)tableView writeRows:(NSArray *)rows toPasteboard:(NSPasteboard *)pboard
{
    BOOL success;

    NSEnumerator *enumerator = [rows objectEnumerator];
    NSMutableString *result = [[NSMutableString alloc] init];
    NSNumber *rowNum;
    while (rowNum = [enumerator nextObject]) {
        NSString *word = [[_histogram wordList] objectAtIndex:[rowNum intValue]];
        [result appendFormat:@"%@\t%@\n", word, [[_histogram valueForKey:word] stringValue]];
    }
    NSArray *types = @[NSStringPboardType];
    [pboard declareTypes:types owner:self];
    success = [pboard setString:result forType:NSStringPboardType];
    return success;
}

- (void)setHistogram:(Histogram *)histogram
{
    NSLog(@"setHistogram called with histogram: %@", histogram);
    _histogram = histogram;
    [wordTable noteNumberOfRowsChanged];
    [wordTable reloadData];
}

@end
