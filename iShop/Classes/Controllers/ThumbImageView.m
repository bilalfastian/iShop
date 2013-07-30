//
//  ThumbImageView.m
//  Client
//
//  Created by Bilal Nazir on 11/18/10.
//  Copyright 2010 iShop. All rights reserved.
//

#import "ThumbImageView.h"


@implementation ThumbImageView

//float distanceBetweenPoints(CGPoint a,CGPoint b);
@synthesize delegate;
@synthesize imageName,home,touchLocation;


-(id)initWithImage:(UIImage *)image{
	
	self = [super initWithImage:image];
	if (self) {
		[self setUserInteractionEnabled:YES];
		[self setExclusiveTouch:YES];
	}
	return self;
	
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	touchLocation = [[touches anyObject] locationInView:self];
	if ([delegate respondsToSelector:@selector(thumbImageViewStartedTracking:) ]) {
		[delegate thumbImageViewStartedTracking:self];
	}	
	
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	
	if ([[touches anyObject] tapCount] ==1) {
		if ([delegate respondsToSelector:@selector(thumbImageViewWasTapped:) ]) {
			[delegate thumbImageViewWasTapped:self];
		}
		
		if ([delegate respondsToSelector:@selector(thumbImageViewStoppedTracking:)]) 
			[delegate thumbImageViewStoppedTracking:self];
		
	}
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
	
    if ([delegate respondsToSelector:@selector(thumbImageViewStoppedTracking:)]) 
        [delegate thumbImageViewStoppedTracking:self];
}



/*- (id)initWithFrame:(CGRect)frame {
 if ((self = [super initWithFrame:frame])) {
 // Initialization code
 }
 return self;
 }*/

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)dealloc {
    [super dealloc];
}


@end
