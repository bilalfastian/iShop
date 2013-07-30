//
//  TapDetectingImageView.h
//  Client
//
//  Created by Bilal Nazir on 11/18/10.
//  Copyright 2010 iShop. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol TapDetectingImageViewDelegate;

@interface TapDetectingImageView : UIImageView {
	id<TapDetectingImageViewDelegate>delegate;
	
	CGPoint tapLocation;
	BOOL multipleTouches;
	BOOL twoFingerTapIsPossible;
}

@property(nonatomic,assign)id<TapDetectingImageViewDelegate>delegate;
@end


@protocol TapDetectingImageViewDelegate<NSObject>

@optional

-(void)tapDetectingImageView:(TapDetectingImageView *)view gotSingleTapAtPoint:(CGPoint)tapPoint;
-(void)tapDetectingImageView:(TapDetectingImageView *)view gotDoubleTapAtPoint:(CGPoint)tapPoint;
-(void)tapDetectingImageView:(TapDetectingImageView *)view gotTwoFingerTapAtPoint:(CGPoint)tapPoint;
@end
