//
//  main.m
//  Quis
//
//  Created by Craig Schamp on 4/8/25.
//

#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSApplication *app = [NSApplication sharedApplication];
        AppDelegate *delegate = [[AppDelegate alloc] init];
        app.delegate = delegate;
        [app run]; // ← run the app manually instead of NSApplicationMain()
    }
    return 0;
}
