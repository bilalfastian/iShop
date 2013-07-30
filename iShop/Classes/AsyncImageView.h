//
//  AsyncImageView.h
//  YellowJacket
//
//  Created by Bilal Nazir on 7/26/09.
//  Copyright 2009 iShop. All rights reserved.
//


//
// Code heavily lifted from here:
// http://www.markj.net/iphone-asynchronous-table-image/
//

#import <UIKit/UIKit.h>


@interface AsyncImageView : UIView {
    NSURLConnection *connection;
    NSMutableData *data;
    NSString *urlString; // key for image cache dictionary
}

-(void)loadImageFromURL:(NSURL*)url withFrame:(CGRect) rect;

@end
