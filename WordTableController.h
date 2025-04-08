//
//  WordTableController.h
//  Quis
//
//  Created by Craig Schamp on 10/16/04.
//  $Id: WordTableController.h,v 1.1 2004/10/16 21:48:45 chs Exp $
//

#import <Cocoa/Cocoa.h>
#import "Histogram.h"

@interface WordTableController : NSObject {
	IBOutlet NSTableView *wordTable;
	Histogram *_histogram;
}

- (void)setHistogram:(Histogram *)histogram;

@end
