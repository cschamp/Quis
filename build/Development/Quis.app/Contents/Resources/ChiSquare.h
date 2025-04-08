//
//  ChiSquare.h
//  Quis
//
//  Created by Craig Schamp on 10/10/04.
//  Copyright 2004 Craig Schamp. All rights reserved.
//  $Id: ChiSquare.h,v 1.5 2004/11/01 05:00:01 chs Exp $
//

#import <Cocoa/Cocoa.h>
#import "Histogram.h"


@interface ChiSquare : NSObject {
	Histogram *_setS;
	Histogram *_setR;
	NSArray *_allKeys;	// union of keys in _setS and _setR
	double _rootSoverR;
	double _rootRoverS;
	double _computation;
	int _degreesOfFreedom;
	double _probability;	// chi-square probability function
}

- (id) initWithSet:(Histogram *)S andSet:(Histogram*)R;
- (void) calculateWithOptions:(BOOL)compressionOption;
- (double) value;
- (double) probability;
- (int) degreesOfFreedom;

@end
