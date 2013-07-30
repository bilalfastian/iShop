//
//  CommentsView.h
//  Client
//
//  Created by Bilal Nazir on 11/20/10.
//  Copyright 2010 iShop. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CommentsView : UIView {
	UILabel *userNameLabel;
	UITextView *commentText;
	UILabel *qualityLabel;
	UILabel *comfortLabel;
	UILabel *appearanceLabel;
	
}
@property (nonatomic, retain) UILabel *qualityLabel;
@property (nonatomic, retain) UILabel *comfortLabel;
@property (nonatomic, retain) UILabel *appearanceLabel;
@property (nonatomic, retain) UILabel *userNameLabel;
@property (nonatomic, retain) UITextView *commentText;

-(void) drawRating:(NSInteger) ratingValue withXPoint:(NSInteger)x andYPoint:(NSInteger) y;
@end
