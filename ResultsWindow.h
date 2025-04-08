//
//  ResultsWindow.h
//  Quis
//
//  Created by Craig Schamp on 10/21/04.
//  Copyright 2004 Craig Schamp. All rights reserved.
//
// $Id: ResultsWindow.h,v 1.9 2004/10/31 16:20:28 chs Exp $
//

#import <Cocoa/Cocoa.h>
#import "WordTableController.h"
#import "Aliases.h"

@interface ResultsWindow : NSDocument {
    IBOutlet NSButton *runButton;
    IBOutlet NSTextField *corpusFile;
	IBOutlet NSTextField *suspectFile;
	IBOutlet NSTextField *x2Field;
	IBOutlet NSTextField *degreesField;
	IBOutlet NSTextField *probabilityField;
	IBOutlet NSButton *compressionButton;
	IBOutlet NSButton *conflationButton;
	IBOutlet NSButton *wordStemmingButton;
	IBOutlet NSProgressIndicator *activityIndicator;
	IBOutlet WordTableController *wordTableController;
	IBOutlet NSTextField *summaryTextField;
	NSArray *_corpusFileList;
	NSArray *_suspectFileList;
	Aliases *_aliases;
}

- (IBAction)selectCorpus:(id)sender;
- (IBAction)selectSuspect:(id)sender;
- (NSArray *)chooseInputFiles;
- (IBAction)runButtonAction:(id)sender;
- (void)runAnalysisInThread:(id)sender;

@end
