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
@property (strong) ResultsWindow *resultsWindow;
@end

@implementation AppDelegate

#import "ResultsWindow.h"

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    [[NSBundle mainBundle] loadNibNamed:@"QuisMain" owner:NSApp topLevelObjects:nil];

    self.resultsWindow = [[ResultsWindow alloc] initWithWindowNibName:@"ResultsWindow"];
    NSLog(@"Created ResultsWindow controller: %@", self.resultsWindow);
    NSLog(@"ResultsWindow's window: %@", [self.resultsWindow window]);
    [self.resultsWindow showWindow:self];
}

@end
