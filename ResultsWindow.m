//
//  ResultsWindow.m
//  Quis
//
//  Created by Craig Schamp on 10/21/04.
//  Copyright 2004 Craig Schamp. All rights reserved.
//
//  $Id: ResultsWindow.m,v 1.13 2004/11/01 04:42:03 chs Exp $
//
//  Modified by Craig Schamp on 4/8/2025 for modern macOS
//

#import "ResultsWindow.h"
#import "ChiSquare.h"

@implementation ResultsWindow

- (id)init
{
    self = [super init];
    if (self) {
        _corpusFileList = nil;
        _suspectFileList = nil;
        _aliases = nil;
    }
    return self;
}

#pragma mark NSDocument

- (NSString *)windowNibName {
    // Implement this to return a nib to load OR implement -makeWindowControllers to manually create your controllers.
    return @"ResultsWindow";
}

- (NSData *)dataRepresentationOfType:(NSString *)type {
    // Implement to provide a persistent data representation of your document OR remove this and implement the file-wrapper or file path based save methods.
    return nil;
}

- (BOOL)loadDataRepresentation:(NSData *)data ofType:(NSString *)type {
    // Implement to load a persistent data representation of your document OR remove this and implement the file-wrapper or file path based load methods.
    return YES;
}

#pragma mark Input File Selection Actions

- (IBAction)selectCorpus:(id)sender
{
    _corpusFileList = [self chooseInputFiles];
    NSMutableString *string = [[NSMutableString alloc] init];

    [string setString:[[_corpusFileList objectAtIndex:0] lastPathComponent]];
    unsigned int i;
    for (i = 1; i < [_corpusFileList count]; i++) {
        [string appendFormat:@", %@", [[_corpusFileList objectAtIndex:i] lastPathComponent]];
    }
    [corpusFile setStringValue:string];
}

- (IBAction)selectSuspect:(id)sender
{
    _suspectFileList = [self chooseInputFiles];
    NSMutableString *string = [[NSMutableString alloc] init];

    [string setString:[[_suspectFileList objectAtIndex:0] lastPathComponent]];
    unsigned int i;
    for (i = 1; i < [_suspectFileList count]; i++) {
        [string appendFormat:@", %@", [[_suspectFileList objectAtIndex:i] lastPathComponent]];
    }
    [suspectFile setStringValue:string];
}

- (NSArray *)chooseInputFiles
{
    NSOpenPanel *op = [NSOpenPanel openPanel];
    NSAssert(op != nil, @"NSOpenPanel allocation failed");
    [op setAllowsMultipleSelection:YES];
    [op setCanChooseDirectories:NO];
    [op setCanChooseFiles:YES];
    [op setResolvesAliases:YES];
    [op runModalForDirectory:nil file:nil types:nil];
    return [op filenames];
}

#pragma mark Run Analysis Actions

- (IBAction)runButtonAction:(id)sender
{
    [NSThread detachNewThreadSelector:@selector(runAnalysisInThread:) toTarget:self withObject:sender];
}

- (void)runAnalysisInThread:(id)sender
{
    [runButton setEnabled:NO];
    [activityIndicator startAnimation:self];
    
    BOOL conflationOption = ([conflationButton state] == NSOffState) ? NO : YES;
    Histogram *R = [[Histogram alloc] init];
    [R histogramFromFileList:_corpusFileList withConflation:conflationOption];
    Histogram *S = [[Histogram alloc] init];
    [S histogramFromFileList:_suspectFileList withConflation:conflationOption];

    ChiSquare *test = [[ChiSquare alloc] initWithSet:S andSet:R];
    BOOL compressionOption = ([compressionButton state] == NSOffState) ? NO : YES;
    [test calculateWithOptions:compressionOption];

    // display results of test
    [x2Field setDoubleValue:[test value]];
    [degreesField setIntValue:[test degreesOfFreedom]];
    [probabilityField setDoubleValue:[test probability]];

    [wordTableController setHistogram:R];
    
    [summaryTextField setStringValue:[R summary]];

    [activityIndicator stopAnimation:self];
    [runButton setEnabled:YES];
}

@end
