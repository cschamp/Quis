//
//  AppDelegate.m
//  Quis
//
//  Created by Craig Schamp on 4/8/25.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (strong) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    BOOL success = [[NSBundle mainBundle] loadNibNamed:@"QuisMain" owner:NSApp topLevelObjects:nil];
    if (!success) {
        NSLog(@"Failed to load QuisMain.xib");
    } else {
        NSLog(@"Successfully loaded QuisMain.xib");
    }
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}


@end
