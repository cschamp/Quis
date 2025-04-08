//
//  WordListEditor.h
//  Quis
//
//  Created by Craig Schamp on 10/24/04.
//  Copyright 2004 Craig Schamp. All rights reserved.
//
//  $Id: WordListEditor.h,v 1.2 2004/10/25 04:44:16 chs Exp $
//

#import <Cocoa/Cocoa.h>
#import "Aliases.h"

@interface WordListEditor : NSDocument {
    IBOutlet NSTextField *infoField;
	Aliases *_aliases;
}

@end
