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

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    // Load the menu bar from QuisMain.xib
    [[NSBundle mainBundle] loadNibNamed:@"QuisMain" owner:NSApp topLevelObjects:nil];

    // Manually instantiate and show the ResultsWindow
    ResultsWindow *results = [[ResultsWindow alloc] init];
    [results makeWindowControllers];
    [[results windowControllers][0] showWindow:self];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}


@end
