/*
 *  gamma.c
 *  Quis
 *
 *  Created by Craig Schamp on 10/12/04.
 *  $Id: gamma.c,v 1.1 2004/10/12 14:21:18 chs Exp $
 *
 * From Numerical Recipes in C, 2nd ed., ch. 6
 */

#include "gamma.h"

#define ITMAX 100		/* max allowed number of interations */
#define EPS 3.0e-7		/* relative accuracy */
#define FPMIN 1.0e-30	/* number near the smallest representable floating-point number */

/*
 * Returns the incomplete gamma function P(a, x)
 */
double gammq(double a, double x)
{
	require(x >= 0.0, GammaQ_NegativeXerror);
	require(a > 0.0, GammaQ_ZeroNegativeAerror);

	double gamser, gammcf, gln;

	if (x < (a + 1.0)) {
		gser(&gamser, a, x, &gln);
		return 1.0 - gamser;
	} else {
		gcf(&gammcf, a, x, &gln);
		return gammcf;
	}

GammaQ_ZeroNegativeAerror:
GammaQ_NegativeXerror:
	return 0.0;		/* XXX is this reliable error indicator? probably not. */
}

/*
 * Returns the incomplete gamma function Q(a, x) evaluated by its continued
 * fraction representation as gammcf. Also returns ln(Gamma(a)) as gln.
 */
void gcf(double *gammcf, double a, double x, double *gln)
{
	int i;
	double an, b, c, d, del, h;
	
	*gln = gammln(a);

	/*
	 * Set up for evaluating continued fraction by modified Lentz's method
	 * (section 5.2 of Numerical Recipes), with b0 = 0.
	 */
	b = x + 1.0 - a;
	c = 1.0 / FPMIN;
	d = 1.0 / b;
	h = d;
	for (i = 1; i <= ITMAX; i++) {
		an = -i * (i - a);
		b += 2.0;
		d = an * d + b;
		if (fabs(d) < FPMIN) d = FPMIN;
		c = b + an / c;
		if (fabs(c) < FPMIN) c = FPMIN;
		d = 1.0 / d;
		del = d * c;
		h *= del;
		if (fabs(del - 1.0) < EPS) break;
	}
	if (i > ITMAX) fprintf(stderr, "a too large, ITMAX too small in routine gcf\n%s line %d\n", __FILE__, __LINE__);
	/* put factors in front */
	*gammcf = exp(-x + a * log(x) - (*gln)) * h;
}

/*
 * Returns the incomplete gamma function P(a, x) evaluated by its series
 * representation as gamser. Also returns the ln(Gamma(a)) as gln.
 */
double gser(double *gamser, double a, double x, double *gln)
{
	int n;
	double sum, del, ap;

	*gln = gammln(a);
	if (x <= 0.0) {
		if (x < 0.0) fprintf(stderr, "x less than 0 in routine gser\n%s line %d\n", __FILE__, __LINE__);
		*gamser = 0.0;
		return;
	} else {
		ap = a;
		del = sum = 1.0 / a;
		for (n = 1; n <= ITMAX; n++) {
			++ap;
			del *= x / ap;
			sum += del;
			if (fabs(del) < fabs(sum) * EPS) {
				*gamser = sum * exp(-x + a * log(x) - (*gln));
				return;
			}
		}
		fprintf(stderr, "a too large, ITMAX too small in routine gser\n%s line %d\n", __FILE__, __LINE__);
		return;
	}
}

double gammln(double xx)
{
	double x, y, tmp, ser;
	static double cof[6]={76.18009172947146,-86.50532032941677,
	24.01409824083091,-1.231739572450155,
	0.1208650973866179e-2,-0.5395239384953e-5};
	int j;

	y = x = xx;
	tmp = x + 5.5;
	tmp -= (x + 0.5) * log(tmp);
	ser = 1.000000000190015;
	for (j = 0; j <= 5; j++) ser += cof[j] / ++y;
	return -tmp + log(2.5066282746310005 * ser / x);
}
