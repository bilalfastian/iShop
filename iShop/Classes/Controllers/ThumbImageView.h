//
//  ThumbImageView.h
//  Client
//
//  Created by Bilal Nazir on 11/18/10.
//  Copyright 2010 iShop. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ThumbImageViewDelegate;


@interface ThumbImageView : UIImageView {
	id<ThumbImageViewDelegate>delegate;
	NSString *imageName;
	CGRect home;
	CGPoint touchLocation;
	
}
@property(nonatomic,retain)id<ThumbImageViewDelegate>delegate;
@property(nonatomic,retain)NSString *imageName;
@property(nonatomic,assign)CGRect home;
@property (nonatomic,assign)CGPoint touchLocation;

//-(void)goHome;
//-(void)moveByOffset:(CGPoint)offset;

@end

@protocol ThumbImageViewDelegate <NSObject>

@optional
- (void)thumbImageViewWasTapped:(ThumbImageView *)tiv;
- (void)thumbImageViewStartedTracking:(ThumbImageView *)tiv;
//- (void)thumbImageViewMoved:(ThumbImageView *)tiv;
- (void)thumbImageViewStoppedTracking:(ThumbImageView *)tiv;

@end
