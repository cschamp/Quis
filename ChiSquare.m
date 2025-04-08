//
//  ChiSquare.m
//  Quis
//
//  Created by Craig Schamp on 10/10/04.
//  Copyright 2004 Craig Schamp. All rights reserved.
//  $Id: ChiSquare.m,v 1.9 2004/11/01 05:00:01 chs Exp $
//
//  Modified by Craig Schamp on 4/8/2025 for modern macOS
//

#import "ChiSquare.h"
#import <math.h>
#import "gamma.h"

@implementation ChiSquare

- (id) initWithSet:(Histogram *)S andSet:(Histogram*)R
{
	if (self = [super init]) {	
		_setS = S;
		_setR = R;
		NSMutableDictionary *concordance = [NSMutableDictionary dictionaryWithCapacity:([_setS count] + [_setR count])];
		[concordance setDictionary:[_setR dictionary]];
		[concordance addEntriesFromDictionary:[_setS dictionary]];
		_allKeys = [concordance allKeys];
		_rootSoverR = sqrt((double) [_setS summationIntValue] / [_setR summationIntValue]);
		_rootRoverS = sqrt((double) [_setR summationIntValue] / [_setS summationIntValue]);
	}
	return self;
}

- (double) value
{
	return _computation;
}

- (double) probability
{
	return _probability;
}

- (NSInteger) degreesOfFreedom
{
	return _degreesOfFreedom;
}

// See chstwo() and eqn 14.3.2 in Numerical Recipes in C, 2nd ed.
- (void) calculateWithOptions:(BOOL)compressionOption;
{
	NSEnumerator *enumerator = [_allKeys objectEnumerator];
	NSString *key;
	
	_degreesOfFreedom = [_allKeys count];
	_computation = 0.0;

	double sValue, rValue;
	while (key = [enumerator nextObject]) {
		// For some reason, if [_setS valueForKey:key] returns nil,
		// then "value = [[_setS valueForKey:key] doubleValue];" does
		// not set "value" to zero but seems to leave it at its previous value.
		id value;
		value = [_setS valueForKey:key];
		sValue = value != nil ? [value doubleValue] : 0;
		value = [_setR valueForKey:key];
		rValue = value != nil ? [value doubleValue] : 0;
		if (compressionOption && (sValue == 0.0 || rValue == 0.0)) {
			_degreesOfFreedom--;	// only count data contained in both sets
		} else if (!compressionOption && (sValue == 0.0 && rValue == 0.0)) {
			_degreesOfFreedom--;	// no data means one less degree of freedom
		} else {
			double t = (sValue * _rootRoverS) - (rValue * _rootSoverR);
			_computation += t * t / (sValue + rValue);
		}
	}
	_probability = gammq(0.5 * _degreesOfFreedom, 0.5 * _computation);
}

@end
