//
//  TableViewCell.m
//  Cart2Mobile
//
//  Created by Bilal Nazir on 11/14/10.
//  Copyright 2010 iBeamBack. All rights reserved.
//

#import "CategoryTableViewCell.h"

@implementation CategoryTableViewCell


@synthesize cellNumber;
@synthesize text;
@synthesize childImageView1,childImageView2;
@synthesize man2ImageView;
@synthesize SelectedCategory;
@synthesize women2ImageView,women1ImageView,man1ImageView;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		self.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
		man1ImageView = [[UIImageView alloc] init];
		man2ImageView = [[UIImageView alloc] init];
		women2ImageView = [[UIImageView alloc] init];
		women1ImageView = [[UIImageView alloc] init];
		childImageView1 = [[UIImageView alloc] init];
		childImageView2 = [[UIImageView alloc] init];

	}
    return self;
}

- (void)setText:(NSString *)string {
	text = [string copy];
	[self setNeedsDisplay];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void) layoutSubviews
{
	[super layoutSubviews];
	self.imageView.frame = CGRectMake(80, -5,180, 160) ;
	self.women2ImageView.frame = CGRectMake(100, 0, 150, 150) ;
	self.women1ImageView.frame = CGRectMake(-20, -15, 170, 170) ; 
    self.man1ImageView.frame   = CGRectMake(-35,-20, 200, 180) ;
	self.man2ImageView.frame   = CGRectMake(70,-25, 200, 200) ;
	self.childImageView1.frame = CGRectMake(-40,-15, 200, 200) ;
	self.childImageView2.frame = CGRectMake(80,-10, 160, 160) ;
}

- (void)drawRect:(CGRect)rect {
	CGContextRef c = UIGraphicsGetCurrentContext();
	
	CGGradientRef myGradient;
	CGColorSpaceRef myColorspace;
	//const CGFloat bottomSepColor[] = {238.0f/255.0f,130.0f/255.0f, 238.0f/255.0f, 1.0f }; // Cell Seperator Colour - Bottom
   
	size_t num_locations = 2;
	CGFloat locations[2] = {0.0, 1.0};
	float red,green,blue;
	CGRect smallRectFrame=CGRectMake(210, 23, 100, 25) ;
	
	if (cellNumber == 0) {
		red = 255.0f/255.0f;
		green = 246.0f/255.0f;
		blue = 143.0f/255.0f;
		
	}
	if (cellNumber == 1) {
		//red = 202.0f/255.0f;
		//green = 225.0f/255.0f;
		//blue = 255.0f/255.0f;
		
		red = 135.0f/255.0f;
		green = 206.0f/255.0f;
		blue = 250.0f/255.0f;
		
	}
	
	if (cellNumber == 2) {
		red = 238.0f/255.0f;
		green = 130.0f/255.0f;
		blue = 238.0f/255.0f;
	}
	
	CGFloat components[8] = {red,green, blue, 1.0f, // Bottom Colour: Red, Green, Blue, Alpha.
		0.9f, 0.9f, 0.9f, 1.0}; // Top Colour: Red, Green, Blue, Alpha.
	
	myColorspace = CGColorSpaceCreateDeviceRGB();
	myGradient = CGGradientCreateWithColorComponents (myColorspace, components,
													  locations, num_locations);
	
	CGColorSpaceRelease(myColorspace);
	
	CGPoint startPoint, endPoint;
	startPoint.x = 0.0;
	startPoint.y = self.frame.size.height;
	endPoint.x = 0.0;
	endPoint.y = 0.0;
	CGContextDrawLinearGradient (c, myGradient, startPoint, endPoint, 0);
	
	const CGFloat topSepColor[] = { 0.8f, 0.8f, 0.8f, 1.0f }; // Cell Seperator Colour - Top
	
	CGGradientRelease(myGradient);
	
	CGContextSetStrokeColor(c, topSepColor);
	
	CGContextMoveToPoint(c, 0.0, 0.0);
	CGContextSetLineWidth(c, 1.0);
	CGContextSetLineCap(c, kCGLineCapRound);
	CGContextAddLineToPoint(c, self.frame.size.width, 0.0);
	CGContextStrokePath(c);
	//238	130	238

	const CGFloat bottomSepColor[] = { 0.5f, 0.4f, 0.4f, 1.0f }; // Cell Seperator Colour - Bottom
	CGContextSetStrokeColor(c, bottomSepColor);
	
	CGContextMoveToPoint(c, 0.0, self.frame.size.height);
	CGContextSetLineWidth(c, 1.0);
	CGContextSetLineCap(c, kCGLineCapRound);
	CGContextAddLineToPoint(c, self.frame.size.width, self.frame.size.height);
	CGContextStrokePath(c);
	
	if (cellNumber == 0) {
		
		// Draw a transparent filled circle over other objects
		CGContextSaveGState(c);
		red = 255.0f/255.0f;
		green = 250.0f/255.0f;
		blue = 205.0f/255.0f;
		
		CGMutablePathRef path = CGPathCreateMutable();
		CGContextSetRGBFillColor(c, red,green, blue, 1.0);
		CGContextFillRect(c, smallRectFrame);
		CGContextAddPath(c, path);
		CGContextDrawPath(c, kCGPathFill);
		CFRelease(path);
		CGContextRestoreGState(c);
		[[UIColor colorWithRed:0.0f/255.0f green:201.0f/255.0f blue:87.0f/255.0f alpha:1.0f] set];
		//[[UIColor colorWithRed:46.0f/255.0f green:139.0f/255.0f blue:87.0f/255.0f alpha:1.0f] set];
		//[[UIColor colorWithRed:238.0f/255.0f green:238.0f/255.0f blue:0.0f/255.0f alpha:1.0f] set];
	}
	if (cellNumber == 1) {
		
		CGContextSaveGState(c);
		red = 135.0f/255.0f;
		green = 206.0f/255.0f;
		blue = 250.0f/255.0f;
		
		CGMutablePathRef path = CGPathCreateMutable();
		CGContextSetRGBFillColor(c, red,green, blue, 1.0);
		CGContextFillRect(c, smallRectFrame);
		CGContextAddPath(c, path);
		CGContextDrawPath(c, kCGPathFill);
		CFRelease(path);
		CGContextRestoreGState(c);
		[[UIColor colorWithRed:106.0f/255.0f green:90.0f/255.0f blue:205.0f/255.0f alpha:1.0f] set];
		
	}
	if (cellNumber == 2) {
		
		CGContextSaveGState(c);
		red = 238.0f/255.0f;
		green = 174.0f/255.0f;
		blue = 238.0f/255.0f;		
		CGMutablePathRef path = CGPathCreateMutable();
		CGContextSetRGBFillColor(c, red,green, blue, 1.0);
		CGContextFillRect(c, smallRectFrame);
		CGContextAddPath(c, path);
		CGContextDrawPath(c, kCGPathFill);
		CFRelease(path);
		CGContextRestoreGState(c);
		[[UIColor colorWithRed:205.0f/255.0f green:0.0f/255.0f blue:205.0f/255.0f alpha:1.0f] set];		
	}
	
	[text drawInRect:CGRectMake(220, self.frame.size.height / 3.5-20, self.frame.size.width - 20, self.frame.size.height - 10) withFont:[UIFont boldSystemFontOfSize:18] lineBreakMode:UILineBreakModeWordWrap];
}


- (void)dealloc {
    [super dealloc];
	[text release];
}


@end
