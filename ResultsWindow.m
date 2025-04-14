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

- (id)initWithWindowNibName:(NSString *)windowNibName
{
    NSLog(@"ResultsWindow initWithWindowNibName: %@", windowNibName);
    self = [super initWithWindowNibName:windowNibName];
    if (self) {
        _corpusFileList = nil;
        _suspectFileList = nil;
        _aliases = nil;
        NSLog(@"ResultsWindow initialized: %@", self);
    }
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    NSLog(@"ResultsWindow windowDidLoad");
    NSLog(@"Window: %@", [self window]);
}

- (void)awakeFromNib {
    NSLog(@"ResultsWindow awakeFromNib");
    
    // Add more detailed debug logging
    NSLog(@"self: %@", self);
    NSLog(@"window: %@", [self window]);
    NSLog(@"runButton: %@ (enabled: %d)", runButton, [runButton isEnabled]);
    NSLog(@"corpusFile: %@", corpusFile);
    NSLog(@"suspectFile: %@", suspectFile);
    
    // Test if buttons can receive actions
    NSLog(@"Run button action: %@", NSStringFromSelector([runButton action]));
    NSLog(@"Run button target: %@", [runButton target]);
    
    [[self window] setDelegate:self];
}

#pragma mark Input File Selection Actions

- (IBAction)selectCorpus:(id)sender
{
    NSLog(@"selectCorpus: was called");
    
    _corpusFileList = [self chooseInputFiles];
    NSMutableString *string = [[NSMutableString alloc] init];

    if ([_corpusFileList count] > 0) {
        [string setString:[[_corpusFileList objectAtIndex:0] lastPathComponent]];
        for (unsigned int i = 1; i < [_corpusFileList count]; i++) {
            [string appendFormat:@", %@", [[_corpusFileList objectAtIndex:i] lastPathComponent]];
        }
    }
    [corpusFile setStringValue:string];
}

- (IBAction)selectSuspect:(id)sender
{
    NSLog(@"selectSuspect: was called");

    _suspectFileList = [self chooseInputFiles];
    NSMutableString *string = [[NSMutableString alloc] init];

    if ([_suspectFileList count] > 0) {
        [string setString:[[_suspectFileList objectAtIndex:0] lastPathComponent]];
        for (unsigned int i = 1; i < [_suspectFileList count]; i++) {
            [string appendFormat:@", %@", [[_suspectFileList objectAtIndex:i] lastPathComponent]];
        }
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
    NSInteger result = [op runModal];
    
    if (result == NSModalResponseOK) {
        return [op filenames];
    }
    return @[]; // Return empty array if cancelled
}

#pragma mark Run Analysis Actions

- (IBAction)runButtonAction:(id)sender
{
    [NSThread detachNewThreadSelector:@selector(runAnalysisInThread:) toTarget:self withObject:sender];
}

- (void)runAnalysisInThread:(id)sender
{
    // Capture UI states on main thread before starting background work
    __block BOOL conflationOption;
    __block BOOL compressionOption;
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self->runButton setEnabled:NO];
        [self->activityIndicator startAnimation:self];
        
        // Get button states while on main thread
        conflationOption = ([self->conflationButton state] == NSOffState) ? NO : YES;
        compressionOption = ([self->compressionButton state] == NSOffState) ? NO : YES;
    });
    
    // Do the computation work in background
    Histogram *R = [[Histogram alloc] init];
    [R histogramFromFileList:_corpusFileList withConflation:conflationOption];
    Histogram *S = [[Histogram alloc] init];
    [S histogramFromFileList:_suspectFileList withConflation:conflationOption];

    ChiSquare *test = [[ChiSquare alloc] initWithSet:S andSet:R];
    [test calculateWithOptions:compressionOption];

    // Dispatch all UI updates back to the main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        // display results of test
        [self->x2Field setDoubleValue:[test value]];
        [self->degreesField setIntValue:[test degreesOfFreedom]];
        [self->probabilityField setDoubleValue:[test probability]];

        [self->wordTableController setHistogram:R];
        
        [self->summaryTextField setStringValue:[R summary]];

        [self->activityIndicator stopAnimation:self];
        [self->runButton setEnabled:YES];
    });
}

@end
