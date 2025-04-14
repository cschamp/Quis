//
//  AppDelegate.m
//  Quis
//
//  Created by Craig Schamp on 4/8/25.
//

#import "AppDelegate.h"
#import "ResultsWindow.h"

@interface AppDelegate ()

@property (strong) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

#import "ResultsWindow.h"

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    [[NSBundle mainBundle] loadNibNamed:@"QuisMain" owner:NSApp topLevelObjects:nil];

    ResultsWindow *results = [[ResultsWindow alloc] initWithWindowNibName:@"ResultsWindow"];
    [results showWindow:self];
}

@end
