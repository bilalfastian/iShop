//
//  ShoppingItemFullImageViewController.m
//  Client
//
//  Created by Bilal Nazir on 11/18/10.
//  Copyright 2010 iShop. All rights reserved.
//

#import "ShoppingItemFullImageViewController.h"



#import "ShoppingItem.h"
#import "Constants.h"

#define THUMB_HEIGHT 130
#define ZOOM_VIEW_TAG 100
#define THUMB_V_PADDING 10
#define THUMB_H_PADDING 10
#define AUTOSCROLL_THRESHOLD 30
#define ZOOM_STEP 1.5



@interface ShoppingItemFullImageViewController (ViewHandingMethods)
-(void)createSlideUpViewIfNecessary;
- (void)pickImageNamed:(NSString *)name;
-(NSMutableArray*)imageNames;
-(void)createThumbScrollViewIfNecessary;
- (void)toggleReelView;
@end

@interface ShoppingItemFullImageViewController (AutoscrollingMethods)
- (void)maybeAutoscrollForThumb:(ThumbImageView *)thumb;
- (void)autoscrollTimerFired:(NSTimer *)timer;
- (void)legalizeAutoscrollDistance;
- (float)autoscrollDistanceForProximityToEdge:(float)proximity;
@end

@interface ShoppingItemFullImageViewController (UtilityMethods)
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;
@end


@implementation ShoppingItemFullImageViewController

@synthesize itemsArray;
@synthesize selectedIndex;
@synthesize detailedViewController;
@synthesize listViewController;
@synthesize imagesNames;
@synthesize cartdelegate;

- (id)initWithItems:(NSArray*)itemsdata	andSelectedItemIndex:(NSInteger) index cartDelegate:(id)cartDel{
		// Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
		if ((self = [super init])) {
			listViewController = [[ShoppingItemListViewController alloc] init];
			

			itemsArray = [[NSMutableArray alloc] initWithArray:itemsdata];
			selectedIndex = index;
			
			cartdelegate = cartDel;
		}
		return self;
		
}
#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/
- (void)loadView {
    [super loadView];
    
    imageScrollView = [[UIScrollView alloc] initWithFrame:[[self view] bounds]];
    [imageScrollView setBackgroundColor:[UIColor blackColor]];
    [imageScrollView setDelegate:self];
    [imageScrollView setBouncesZoom:YES];
    [[self view] addSubview:imageScrollView];
    
	
	ShoppingItem *item = [itemsArray objectAtIndex:selectedIndex];
	int stringLength = [item.name length];
	
	NSRange range;
	range.location = 0;
	range.length = stringLength;
	
	NSString *imageName = [item.name stringByReplacingOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:range];
	
	
	imageName = [imageName stringByAppendingString:@".jpg"];
	NSString *urlString = [FullImage_URL stringByAppendingString:imageName];
	
    [self pickImageNamed:urlString];
}

#pragma mark UIScrollViewDelegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    UIView *view = nil;
    if (scrollView == imageScrollView) {
        view = [imageScrollView viewWithTag:ZOOM_VIEW_TAG];
    }
    return view;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
    [scrollView setZoomScale:scale+0.01 animated:NO];
    [scrollView setZoomScale:scale animated:NO];
}

#pragma mark TapDetectingImageViewDelegate methods

- (void)tapDetectingImageView:(TapDetectingImageView *)view gotSingleTapAtPoint:(CGPoint)tapPoint {
    // Single tap shows or hides drawer of thumbnails.
    [self toggleReelView];
}

- (void)tapDetectingImageView:(TapDetectingImageView *)view gotDoubleTapAtPoint:(CGPoint)tapPoint {
    // double tap zooms in
    float newScale = [imageScrollView zoomScale]*ZOOM_STEP;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:tapPoint];
    [imageScrollView zoomToRect:zoomRect animated:YES];
}

- (void)tapDetectingImageView:(TapDetectingImageView *)view gotTwoFingerTapAtPoint:(CGPoint)tapPoint {
    // two-finger tap zooms out
    float newScale = [imageScrollView zoomScale] / ZOOM_STEP;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:tapPoint];
    [imageScrollView zoomToRect:zoomRect animated:YES];
}


-(NSInteger) searchIndex:(NSString *)itemName
{
	int i;
	for (i=0; i < [imagesNames count]; i++) {
		if ([itemName isEqualToString:[imagesNames objectAtIndex:i ]]) {
			break;
		}
	}
	return i;
}
#pragma mark ThumbImageViewDelegate methods

- (void)thumbImageViewWasTapped:(ThumbImageView *)tiv {
	
	
	selectedIndex = [self searchIndex:[tiv imageName]];
	int stringLength = [[tiv imageName] length];

	NSRange range;
	range.location = 0;
	range.length = stringLength;
	
	NSString *imageName = [[tiv imageName] stringByReplacingOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:range];
	
	
	imageName = [imageName stringByAppendingString:@".jpg"];
	NSString *urlString = [FullImage_URL stringByAppendingString:imageName];
	
    [self pickImageNamed:urlString];
    [self toggleReelView];
}

- (void)thumbImageViewStartedTracking:(ThumbImageView *)tiv {
    [reelScrollView bringSubviewToFront:tiv];
}
- (void)thumbImageViewStoppedTracking:(ThumbImageView *)tiv {
    // if the user lets go of the thumb image view, stop autoscrolling
    [autoscrollTimer invalidate];
    autoscrollTimer = nil;
}
#pragma mark Autoscrolling methods

- (void)maybeAutoscrollForThumb:(ThumbImageView *)thumb {
	
    autoscrollDistance = 0;
    
    // only autoscroll if the thumb is overlapping the thumbScrollView
    if (CGRectIntersectsRect([thumb frame], [reelScrollView bounds])) {
        
        CGPoint touchLocation = [thumb convertPoint:[thumb touchLocation] toView:reelScrollView];
        float distanceFromLeftEdge  = touchLocation.x - CGRectGetMinX([reelScrollView bounds]);
        float distanceFromRightEdge = CGRectGetMaxX([reelScrollView bounds]) - touchLocation.x;
        
        if (distanceFromLeftEdge < AUTOSCROLL_THRESHOLD) {
            autoscrollDistance = [self autoscrollDistanceForProximityToEdge:distanceFromLeftEdge] * -1; // if scrolling left, distance is negative
        } else if (distanceFromRightEdge < AUTOSCROLL_THRESHOLD) {
            autoscrollDistance = [self autoscrollDistanceForProximityToEdge:distanceFromRightEdge];
        }        
    }
    
    // if no autoscrolling, stop an
	//d clear timer
    if (autoscrollDistance == 0) {
        [autoscrollTimer invalidate];
        autoscrollTimer = nil;
    } 
    
    // otherwise create and start timer (if we don't already have a timer going)
    else if (autoscrollTimer == nil) {
        autoscrollTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0 / 60.0)
                                                           target:self 
                                                         selector:@selector(autoscrollTimerFired:) 
                                                         userInfo:thumb 
                                                          repeats:YES];
    } 
}

- (float)autoscrollDistanceForProximityToEdge:(float)proximity {
    // the scroll distance grows as the proximity to the edge decreases, so that moving the thumb
    // further over results in faster scrolling.
    return ceilf((AUTOSCROLL_THRESHOLD - proximity) / 5.0);
}

- (void)legalizeAutoscrollDistance {
    // makes sure the autoscroll distance won't result in scrolling past the content of the scroll view
    float minimumLegalDistance = [reelScrollView contentOffset].x * -1;
    float maximumLegalDistance = [reelScrollView contentSize].width - ([reelScrollView frame].size.width + [reelScrollView contentOffset].x);
    autoscrollDistance = MAX(autoscrollDistance, minimumLegalDistance);
    autoscrollDistance = MIN(autoscrollDistance, maximumLegalDistance);
}

- (void)autoscrollTimerFired:(NSTimer*)timer {
    [self legalizeAutoscrollDistance];
    
    // autoscroll by changing content offset
    CGPoint contentOffset = [reelScrollView contentOffset];
    contentOffset.x += autoscrollDistance;
    [reelScrollView setContentOffset:contentOffset];
    
    // adjust thumb position so it appears to stay still
	// ThumbImageView *thumb = (ThumbImageView *)[timer userInfo];
	// [thumb moveByOffset:CGPointMake(autoscrollDistance, 0)];
}



#pragma mark -
#pragma mark View lifecycle
-(void) switchView:(id) sender
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.15];
	  UIViewAnimationTransition transition;
	//[UIView setAnimationTransition:([listViewController.view superview] ?
	//								UIViewAnimationTransitionFlipFromLeft : UIViewAnimationTransitionFlipFromRight)
	//					   forView:self.view cache:YES];
	
	if ([detailedViewController.view superview])
	{
		self.title = @"Item Full View";
		[detailedViewController.view removeFromSuperview];
		 transition = UIViewAnimationTransitionFlipFromLeft;
	}
	else
	{
		[listViewController.view removeFromSuperview];
		self.title = @"item Detail";
		[detailedViewController initWithShoppingItem:[itemsArray objectAtIndex:selectedIndex] withViewController:self cartDelegate:self.cartdelegate ];
		[self.view addSubview:detailedViewController.view];
		 transition = UIViewAnimationTransitionFlipFromRight;
	}
	 [UIView setAnimationTransition: transition forView:self.view cache:YES];
	[UIView commitAnimations];
}
- (void)viewDidLoad {
    [super viewDidLoad];

 	self.title = @"Item Full View";

	detailedViewController = [[ShoppingItemDetailedViewController alloc] init];
	UIButton* infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
	[infoButton addTarget:self action:@selector(switchView:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *modalButton = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
	[self.navigationItem setRightBarButtonItem:modalButton animated:YES];
	[modalButton release];
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/



#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

#pragma mark View handling methods
- (void)toggleReelView {
    [self createSlideUpViewIfNecessary]; // no-op if slideUpView has already been created
    CGRect frame = [slideUpView frame];
    if (thumbViewShowing) {
        frame.origin.y += frame.size.height;
    } else {
        frame.origin.y -= frame.size.height;
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [slideUpView setFrame:frame];
    [UIView commitAnimations];
    
    thumbViewShowing = !thumbViewShowing;
}
-(NSMutableArray *)imageNames
{
	imagesNames = [[NSMutableArray alloc]init];
	ShoppingItem *item;
	for(int i=0; i < [itemsArray count]; i++) {
		item = [itemsArray objectAtIndex:i];
		
		[imagesNames addObject:item.name];
		
	}

	return imagesNames;

}

- (void)pickImageNamed:(NSString *)urlString {
	
    // first remove previous image view, if any
    [[imageScrollView viewWithTag:ZOOM_VIEW_TAG] removeFromSuperview];
	
	NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlString]];
	UIImage *image = [UIImage imageWithData: imageData];
	[imageData release];
	
    TapDetectingImageView *zoomView = [[TapDetectingImageView alloc] initWithImage:image];
    [zoomView setDelegate:self];
    [zoomView setTag:ZOOM_VIEW_TAG];
    [imageScrollView addSubview:zoomView];
    [imageScrollView setContentSize:[zoomView frame].size];
    [zoomView release];
	
    // choose minimum scale so image width fits screen
    float minScale  = [imageScrollView frame].size.width  / [zoomView frame].size.width;
    [imageScrollView setMinimumZoomScale:minScale];
    [imageScrollView setZoomScale:minScale];
    [imageScrollView setContentOffset:CGPointZero];
}

-(void)createSlideUpViewIfNecessary
{
	if (!slideUpView) {
		[self createThumbScrollViewIfNecessary];
		CGRect bounds = [[self view] bounds];
		float thumbHeight = [reelScrollView frame].size.height;
		CGRect frame = CGRectMake(CGRectGetMinX(bounds), CGRectGetMaxY(bounds), bounds.size.width, thumbHeight+10);
		slideUpView = [[UIView alloc]initWithFrame:frame];
		[slideUpView setBackgroundColor:[UIColor blackColor]];
		[slideUpView setOpaque:NO];
		[slideUpView setAlpha:0.75];
		[[self view] addSubview:slideUpView];
		[slideUpView addSubview:reelScrollView];
		
	}
}
-(void)createThumbScrollViewIfNecessary
{
	if (!reelScrollView) {
		float reelViewHeight  =THUMB_V_PADDING +THUMB_HEIGHT;
		float reelViewWidth = [[self view]bounds].size.width;
		reelScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, reelViewWidth, reelViewHeight)];
		[reelScrollView setCanCancelContentTouches:NO];
		[reelScrollView setClipsToBounds:NO];
		float xPosition = THUMB_H_PADDING;
		for (NSString *name in [self imageNames]){
			int stringLength = [name length];
			
			NSRange range;
			range.location = 0;
			range.length = stringLength;
			
			NSString *imageName = [name stringByReplacingOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:range];
			
			imageName = [imageName stringByAppendingString:@".jpg"];
			NSString *urlString = [Thumbnail_URL stringByAppendingString:imageName];
			
			NSURL *url = [NSURL URLWithString:urlString];

			NSData * imageData = [[NSData alloc] initWithContentsOfURL: url];
			UIImage *image = [UIImage imageWithData: imageData];
			UIImage *thumbImage = image;
			[imageData release];
		
			
			if (thumbImage) {
				ThumbImageView *thumbView = [[ThumbImageView alloc] initWithImage:thumbImage];
				thumbView.delegate = self;
				
				[thumbView setImageName:name];
				CGRect frame = [thumbView frame];
				frame.origin.y = THUMB_V_PADDING;
				frame.origin.x = xPosition;
				thumbView.frame = frame;
				thumbView.home = frame;
				[reelScrollView addSubview:thumbView];
				[thumbView release];
				xPosition += (frame.size.width+THUMB_H_PADDING); 
			}
		}
		[reelScrollView setContentSize:CGSizeMake(xPosition, reelViewHeight)];
	}	
}

#pragma mark Utility methods

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    // the zoom rect is in the content view's coordinates. 
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = [imageScrollView frame].size.height / scale;
    zoomRect.size.width  = [imageScrollView frame].size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}



- (void)dealloc {
	[reelScrollView release];
	[imagesNames release];
    [super dealloc];
}

@end
