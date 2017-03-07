/*
*  kohonen.c
*
*  implement a kohonen neural net to find a 
* 3-d space filling curve corresponding to the structure;
*
*  net links correspond to chemical bonds, angle distances, noel distances
*  eventually the distance update will also include vdw interactions
*  and chirality.
*
*/
/*
*  copyright 1993-1997 Robert W. Harrison
*  
*  This notice may not be removed
*  This program may be copied for scientific use
*  It may not be sold for profit without explicit
*  permission of the author(s) who retain any
*  commercial rights including the right to modify 
*  this notice
*/

#define ANSI 1
/* misc includes - ANSI and some are just to be safe */
#include <stdio.h>
#include <ctype.h>
#include <math.h>
#ifdef ANSI
#include <stdlib.h>
#endif
#include "ammp.h"

#define noel_target
#define MAX_LOCAL 200

void kohonen( vfs,ffs,nfs,niter, radius, initialize ,rx,ry,rz)
int (*vfs[])(),(*ffs[])(),nfs;
int niter;
float radius;
float rx,ry,rz;
int initialize;
{
ATOM *ap,*bp[MAX_LOCAL],*cp,*a_next();
ATOM *actp[600]; /* pointers which are frozen */
int inactp;  
int numatm , a_number();
int iter,local_iter, i,j;
float x,y,z,r,rc,randf();
float cx,cy,cz, dx,dy,dz;
int v_bond(),v_angle(),u_v_nonbon(),v_noel();
int v_mmbond(),v_mmangle(),v_c_angle(),v_nonbon();
int v_hard(),v_abc();
int v_hybrid();
int v_step();
int steep();
int use_noel,use_hybrid,use_step;
#ifdef GTK_VERSION
	void AMMP_whiz_bang(void);
#endif
#ifdef windows
void force_screen_update(); /* in animate.c */
#endif
void get_bond(); /* getbond(ap,atom*bp[],max,&howmany) */
void get_angle(); /* same call */
void get_noel(); /* same call */
void get_bond_and_length(); /* get...(ap,atom* bp[],float r[],max &howmany) */
void get_noel_and_length(); /* same call */
void get_noel_and_bounds(); /* get...(ap atom* bp,float r[],rup[],max,&howmany) */
void get_step_and_bounds(); /* similar to above but get r,rmid,rup */
float upper[MAX_LOCAL],middle[MAX_LOCAL];
float target[MAX_LOCAL];
void rand3();
float k,k_radius;
int prior_type;

numatm = a_number();
if( numatm < 2) return;
if(radius < 1.) radius = sqrt((float)numatm);
cx = 0.;
cy = 0.;
cz = 0.;
j = 0;
for( i=0; i< numatm; i++)
{
	ap = a_next(i);
	if( !ap->active){ j++;
		cx += ap->x; cy += ap->y; cz += ap->z;}
}

if( j > 0){
r = 1./(float)j;
cx *= r; cy *= r; cz *= r;
}

if( initialize > 0 )
{
	for( i=0; i< numatm; i++)
	{ap = a_next(i);
//		rand3(&x,&y,&z);
//		r = randf()*radius;
//		ap->x = x*r;
//		ap->y = y*r;
//		ap->z = z*r;
		x = 2*randf()-1.;
		y = 2*randf()-1.;
		z = 2*randf()-1.;
		if( ap->active){
		ap->x = x*radius+cx;
		ap->y = y*radius+cy;
		ap->z = z*radius+cz;}
	}
}
/* figure out what kind of prior to use
*  rx >= 0 ry == 0 rz == 0 spherical 
*  rx > 0 ry > 0 rz == 0  cylindrical
*  rx > 0 ry > 0 rz > 0   elipsoidal
*
*  cylindrical and elipsoidal ignore the radius 
*  spherical uses the radius value
*/
prior_type = 0;  /* default to sphere */
if( rx >= 0. && ry < 1.e-7 && rz < 1.e-7) prior_type = 0;
if( rx > 0. && ry > 0. && rz < 1.e-7) prior_type = 1;
if( rx > 0. && ry > 0. && rz > 0.) prior_type = 2;
use_noel = (1==0);
use_hybrid = use_noel;
use_step = use_noel;
for( i=0; i< nfs; i++)
{
	if( vfs[i] == v_noel){ use_noel = 1==1;}
	if( vfs[i] == v_hybrid) { use_hybrid = 1==1;}
	if( vfs[i] == v_step) { use_step = 1==1;}
}
for( iter = 0; iter< niter; iter++)
{ 


#ifdef windows
force_screen_update();
#endif
#ifdef GTK_VERSION
AMMP_whiz_bang();
#endif

k = (float)(niter-iter)/(float)niter ;
k_radius = k*k*radius*radius*0.25;
k = k*k*0.5+0.5;
k = 0.2*k;

	for( local_iter=0; local_iter< numatm; local_iter++)
	{
//	k = 0.01 + randf()*0.2;
//	k = 0.2;
	/* pick a random point in the sphere */
	/* trial of rigid chiral enforcement */
/*	if( use_hybrid) 
	{
		for( i=0; i< numatm; i++)
		{
			ap = a_next(i);
			if(ap->active)
				gsdg_hybrid(ap);

		}
	}
*/
	if( prior_type == 0){
		r = radius;
RE_RANDOM:;
		x = 2.*randf()-1.;
		y = 2.*randf()-1.;
		z = 2.*randf()-1.;
		rc = x*x + y*y + z*z;
		if(rc > 1.) goto RE_RANDOM;
		x = x*r +cx; y = y*r +cy ; z = z*r +cz;
	} else if( prior_type == 1){
RE_RANDOM_2D: ;
		x = 2.*randf()-1.; 
		y = 2.*randf()-1.;
		rc = x*x + y*y;
		if( rc > 1.) goto RE_RANDOM_2D;
		z = 2.*randf()-1.;
		x = x*rx + cx; y = y*rx + cy; z = z*ry;
	} else if( prior_type == 2){
RE_RANDOM_ELIPSE: ;
		x = 2.*randf()-1.;
		y = 2.*randf()-1.;
		z = 2.*randf()-1.;
		rc = x*x + y*y + z*z;
		if(rc > 1.) goto RE_RANDOM_ELIPSE;
		x = x*rx +cx; y = y*ry +cy ; z = z*rz +cz;
	}
		/* find the closest atom */
		inactp = 0;
		/*
//		cp = a_next(-1);
//		rc  = (cp->x - x)*(cp->x-x);
//		rc += (cp->y - y)*(cp->y-y);
//		rc += (cp->z - z)*(cp->z-z);
		*/
		rc = 10.e10;
		for(i=0;i < numatm; i++)
		{ap = a_next(i);
//			if( ap->active ){
			r  = (ap->x-x)*(ap->x-x);
			r += (ap->y-y)*(ap->y-y);
			r += (ap->z-z)*(ap->z-z);
			if( r < rc){ cp = ap; rc = r;}
//			}
		}
/* update it and its neighbors */

		for( i=0; i< numatm; i++)
		{
			ap = a_next(i);
			if( ap->active && ap != cp){
			r  = (ap->x-cp->x)*(ap->x-cp->x);
			r += (ap->y-cp->y)*(ap->y-cp->y);
			r += (ap->z-cp->z)*(ap->z-cp->z);
			if( r < k_radius)/* 25 (r==5) works well with good noe */
			{
				ap->x += (x-cp->x)*k;
				ap->y += (y-cp->y)*k;
				ap->z += (z-cp->z)*k;
		if( inactp < 599) actp[inactp++] = ap;
			}
			}
		}


		if( cp->active){
			dx = x-cp->x;
			dy = y-cp->y;
			dz = z-cp->z;
		cp->x += (dx)*k;
		cp->y += (dy)*k;
		cp->z += (dz)*k;

		actp[inactp++] = cp;
		} else { /* put the center at the atom */
			x = cp->x; y = cp->y; z = cp->z;
			dx = 0.; dy = 0.; dz = 0.;
		}
//		if(cp->active && use_hybrid)
//		{
//			gsdg_hybrid(cp);
//		}
		get_bond_and_length(cp,bp,target,20,&j);
		for( i=0; i< j ; i++)
		{ap = bp[i];
		if( ap->active){
			ap->x += (x-ap->x)*k;
		  ap->y += (y-ap->y)*k;
		  ap->z += (z-ap->z)*k;
#ifdef BELLMAN
		  r = (x - ap->x)*(x -ap->x);
		  r += (y - ap->y)*(y -ap->y);
		  r += (z - ap->z)*(z -ap->z);
		  if( r > 0.){
/*			r = target[i]/sqrt(r)-1.;
			ap->x -= (x-ap->x)*r;
			ap->y -= (y-ap->y)*r;
			ap->z -= (z-ap->z)*r;
*/			
/*  bellman step */
			r = target[i]/sqrt(r);
			ap->x = x + (ap->x-x)*r;
			ap->y = y + (ap->y-y)*r;
			ap->z = z + (ap->z-z)*r;
		
		  }
#endif
		}
		}


/*
		get_angle(cp,bp,20,&j);
		for( i=0; i< j ; i++)
		{ap = bp[i];
		  ap->x += (x-ap->x)*k*.1;
		  ap->y += (y-ap->y)*k*.1;
		  ap->z += (z-ap->z)*k*.1;
		}
*/
		if( use_step){
		get_step_and_bounds(cp,bp,target,middle,upper,MAX_LOCAL,&j);
		for( i=0; i<j; i++)
		{	ap = bp[i];
		if( ap->active){
/* define either step_metric for metrical usage
or step_neighborhood for neighborhood useage
*/
#define STEP_NEIGHBORHOOD
#ifdef STEP_METRIC
		 r = (x - ap->x)*(x -ap->x);
		  r += (y - ap->y)*(y -ap->y);
		  r += (z - ap->z)*(z -ap->z);
		  if( r <= upper[i]*upper[i] && r > 0.){
			  if( r > middle[i]*middle[i] ) r = middle[i]/sqrt(r);
			  else if( r < target[i]*target[i] ) r = target[i]/sqrt(r);
			  else r = 1.;
//			ap->x = x + (ap->x-x)*r*k;
//			ap->y = y + (ap->y-y)*r*k;
//			ap->z = z + (ap->z-z)*r*k;
		ap->x = x + (ap->x -x)*r;
		ap->y = y + (ap->y -y)*r;
		ap->z = z + (ap->z -z)*r;
#endif
#ifdef STEP_NEIGHBORHOOD
			r = (cp->x -ap->x)*(cp->x -ap->x);
			r += (cp->y -ap->y)*(cp->y - ap->y);
			r += (cp->z - ap->z)*(cp->z - ap->z);
			if( r < upper[i]*upper[i] ){
//			if( r > upper[i]*upper[i]) {
/* 1/15 test
//			ap->x += (x - cp->x)*k;
//			ap->y += (y - cp->y)*k;
//			ap->z += (z - cp->z)*k;
*/
				ap->x += dx*k;
				ap->y += dy*k;
				ap->z += dz*k;
#endif
		  }/* close enough to work on */
		}/* active */
			}/* for i */
		}/* use_step*/
		if( use_noel){
#ifdef noel_target
		get_noel_and_length(cp,bp,target,MAX_LOCAL,&j);
#else
		get_noel_and_bounds(cp,bp,target,upper,MAX_LOCAL,&j);
#endif
		for( i=0; i< j ; i++)
		{ap = bp[i];
		if( ap->active){
/*	ap->x += (x-ap->x)*k;
			ap->y += (y-ap->y)*k;
			ap->z += (z-ap->z)*k;
			*/
			ap->x += dx*k;
			ap->y += dy*k;
			ap->z += dz*k;
/* it is best to relax after choosing the new point
		  r = (cp->x - ap->x)*(cp->x -ap->x);
		  r += (cp->y - ap->y)*(cp->y -ap->y);
		  r += (cp->z - ap->z)*(cp->z -ap->z);
		  */
#ifdef BELLMAN
			r = (x-ap->x)*(x-ap->x);
			r += (y-ap->y)*(y-ap->y);
			r += (z-ap->z)*(z-ap->z);
			
		  if( r > 0.){
#ifdef noel_target
			r = target[i]/sqrt(r);
/* damped, relax after moving
			ap->x = ap->x*0.5 + (x + (ap->x-x)*r)*0.5;
			ap->y = ap->y*0.5 + (y + (ap->y-y)*r)*0.5;
			ap->z = ap->z*0.5 + (z + (ap->z-z)*r)*0.5;
*/
/*  damped, and relax before moving
			ap->x = ap->x*0.5 + (x + (ap->x-cp->x)*r)*0.5;
			ap->y = ap->y*0.5 + (y + (ap->y-cp->y)*r)*0.5;
			ap->z = ap->z*0.5 + (z + (ap->z-cp->z)*r)*0.5;
*/
		/*
			ap->x = x + (ap->x -x)*r;
			ap->y = y + (ap->y -y)*r;
			ap->z = z + (ap->z -z)*r;
		*/	
#else
			  r = sqrt(r);
			  if( r < target[i])
			  {
				  r = target[i]/r;
				  ap->x = x + (ap->x -x)*r;
				  ap->y = y + (ap->y -y)*r;
				  ap->z = z + (ap->z -z)*r;
			  }else if( r > upper[i])
			  {
				  r = upper[i]/r;
				  ap->x = x + (ap->x -x)*r;
				  ap->y = y + (ap->y -y)*r;
				  ap->z = z + (ap->z -z)*r;

			  }
#endif
		  }
#endif
		}
		}
		}

		if( inactp > 0 ){
			if( use_hybrid){
			for( i=0; i< inactp; i++)
				gsdg_hybrid(actp[i]);}
			for( i=0; i< inactp; i++)
				actp[i]->active = (1==0);
			kohonen_minimizer(vfs,ffs,nfs,1);
			for( i=0; i< inactp; i++)
				actp[i]->active = (1==1);
		}
	
	}/* end of local_iter */
}/* end of iter loop */
}/* end of routine */
/* copy of cngdel ,buggerized for one step */
int kohonen_minimizer( vfs,ffs,nfs, nstep )
int nfs,(*vfs[])(),(*ffs[])();
int nstep;
{
	int i,ifs;
	float a_max_f(),lam,vb;
	float linmin(),a_max_d();
	int a_ftodx();
#ifdef windows
	void force_screen_update(); /* in animate.c */
#endif
#ifdef GTK_VERSION
	void AMMP_whiz_bang(void);
#endif
/*  do at most nstep steps */

	a_g_zero();
	a_d_zero();
	for( i=0; i< nstep ; i++)
	{

	vb = 0.;
	for( ifs = 0; ifs < nfs; ifs++)
	{
		(*vfs[ifs])( &vb,  0.);
	}
	a_f_zero();
	for( ifs = 0; ifs < nfs; ifs++)
	{
		(*ffs[ifs])( 0.);
	}
	lam = a_max_f();
	a_ftodx(1.,0.);

	lam = linmin( vfs,nfs, sqrt(a_max_d()) );
	a_inc_d( lam );
	}
#ifdef windows
	force_screen_update();
#endif
#ifdef GTK_VERSION
/*
	AMMP_whiz_bang();
*/
#endif

	return 0;
}


