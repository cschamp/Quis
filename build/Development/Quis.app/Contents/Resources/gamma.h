/*
 *  gamma.h
 *  Quis
 *
 *  Created by Craig Schamp on 10/12/04.
 *  $Id: gamma.h,v 1.1 2004/10/12 14:21:18 chs Exp $
 *
 * From Numerical Recipes in C, 2nd ed., ch. 6
 */

#include <Carbon/Carbon.h>
#include <math.h>

extern double gammq(double a, double x);
extern double gammln(double xx);
extern void gcf(double *gammcf, double a, double x, double *gln);
extern double gser(double *gamser, double a, double x, double *gln);
