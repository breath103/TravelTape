//
//  macro.h
//  Ryokan
//
//  Created by ANTH on 11. 12. 20..
//  Copyright (c) 2011년 TwinMoon. All rights reserved.
//

#ifndef Ryokan_macro_h
#define Ryokan_macro_h

#include <UIKit/UIKit.h>

#define ARC4RANDOM_MAX      0x100000000
CGPoint CGPointRotateWithCenter( CGPoint p1 ,CGPoint center,float angle_radian);
CGPoint CGPointAdd(CGPoint p1,CGPoint p2); 
CGPoint CGPointSubtract(CGPoint p1,CGPoint p2);
CGPoint CGPointMultiply(CGPoint p1,float f);
CGPoint CGPointNormalize(CGPoint p1);
float   CGPointDot(CGPoint p1,CGPoint p2);
float   CGPointLength(CGPoint p);
float   CGPointDistance(CGPoint p1,CGPoint p2);
float   CGPointCross(CGPoint p1,CGPoint p2);
float   CGPointTheta(CGPoint v1,CGPoint v2);
float 	CGPointThetaWithBasis(CGPoint v1);
BOOL	CGRectPointIntersect(CGRect rect,CGPoint p1);
float   Lerp(float f1,float f2,float scale);
CGPoint CGRectCenter(CGRect rect);
void    setViewFrameByCenterPos( UIView* view,CGPoint center);
NSMutableArray* ImagesWithFormatString( NSString* formatString,int minIndex,int maxIndex);
int 	randRange(int min,int max) ;
double  randFloat();

void 	UIViewSetX(UIView* view, int x);
void 	UIViewSetY(UIView* view, int y);
void 	UIViewSetOrigin(UIView* view, CGPoint origin);
void 	UIViewSetWidth(UIView* view, int width);
void 	UIViewSetHeight(UIView* view, int height);
void 	UIViewSetSize(UIView* view, CGSize size);

void ShowAlertView(NSString* title,NSString* message,NSString* button1,NSString* button2);

UIView* ReadNib( NSString* name,NSObject* owner);

NSManagedObjectContext* getDefaultManagedObjectContext();

NSDictionary* parseJSON(NSString* str);

@interface NSDictionary (StringMacro)
-(NSString*) stringForKey : (id) key;
@end

#ifndef BETWEEN//(min,x,max) 
	#define BETWEEN(min,x,max) ( min<=x&&x<=max ) 
#endif

#endif
