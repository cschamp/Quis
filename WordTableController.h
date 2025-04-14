//
//  WordTableController.h
//  Quis
//
//  Created by Craig Schamp on 10/16/04.
//  $Id: WordTableController.h,v 1.1 2004/10/16 21:48:45 chs Exp $
//
//  Modified by Craig Schamp on 4/8/2025 for modern macOS
//

#import <Cocoa/Cocoa.h>
#import "Histogram.h"

@interface WordTableController : NSObject <NSTableViewDataSource, NSTableViewDelegate> {
	IBOutlet NSTableView *wordTable;
	Histogram *_histogram;
}

@property (strong, nonatomic) Histogram *histogram;

@end
