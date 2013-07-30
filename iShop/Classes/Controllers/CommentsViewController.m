    //
//  CommentsViewController.m
//  Client
//
//  Created by Bilal Nazir on 11/19/10.
//  Copyright 2010 iShop. All rights reserved.
//

#import "CommentsViewController.h"
#import "BaseDataLoader.h"
#import "BaseDeserializer.h"
#import "Constants.h"
#import "ItemDetailView.h"
#import "CommentsView.h"

#import <QuartzCore/QuartzCore.h>

@interface CommentsViewController ()

@property (nonatomic) DeserializerType currentDataFormat;
@property (nonatomic, retain) BaseDataLoader *dataLoader;
@property (nonatomic, retain) NSArray *data;

@end


@implementation CommentsViewController

@synthesize dataLoader = _dataLoader;
@synthesize data = _data;
@synthesize currentDataFormat = _currentDataFormat;
@synthesize itemDescriptionTableView;
@synthesize dataArray ;

-(id) initWithItem:(ShoppingItem*) newItem
{
	if (self = [super init])
	{
		item = newItem;
		CGRect frame = CGRectMake(0, 0, 320, 480);
		itemDescriptionTableView = [[UITableView alloc] initWithFrame:frame 
																style:UITableViewStyleGrouped];
		itemDescriptionTableView.delegate = self;
		itemDescriptionTableView.dataSource = self;
		self.dataLoader.delegate = self;
		self.currentDataFormat = DeserializerTypeYAML;
		isFirstTime = TRUE;
		dataArray = [[NSMutableArray alloc] init];
	 }
	return self;
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"User Comments";
}
-(void) doneBtn_Clicked:(id)sender {
	
	[self.navigationController dismissModalViewControllerAnimated:YES];
}
- (void)willPresentAlertView:(UIAlertView *)alertView {

	int _dButtonShift = 90;
	CGRect _xbuttonRect;
	for (UIView *cView in [alertView subviews]) {
		if ([cView isKindOfClass:NSClassFromString(@"UIThreePartButton")]) {
			_xbuttonRect = ((UIButton*)cView).frame;
			_xbuttonRect.origin.y += _dButtonShift;
			((UIButton*)cView).frame = _xbuttonRect;
		}
	}
	
    alertView.frame = CGRectMake(20, 20, 280,280);
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	NSDictionary *temp;
    switch (buttonIndex) {
        case 0:
            NSLog(@"Cancel Button Pressed");
            break;
        case 1:
			if ([userNameField.text length] == 0)
			{
				userNameField.text = @"Anonymous";
			}
			temp = [NSDictionary dictionaryWithObjectsAndKeys:
						  [NSString stringWithFormat:@"%d",qualityRating],@"quality",
						  [NSString stringWithFormat:@"%d",comfortRating],@"comfort",
						  [NSString stringWithFormat:@"%d",appearanceRating],@"appearance",
						  [NSString stringWithFormat:@"%@",commentBox.text],@"comments",
						  [NSString stringWithFormat:@"%@",userNameField.text],@"customerName",
						  nil];
			//[self.dataLoader loadDataWithQuery:@"insertComment" withCategoryType:temp];
			//dataArray = [[NSMutableArray alloc] initWithArray:self.data];
			
			if (self.dataArray == (NSMutableArray*)[NSNull null]) {
				
				dataArray = [[NSMutableArray alloc] init];
			}
			if (self.data != (NSArray*)[NSNull null])
			{
				dataArray = (NSMutableArray*)self.data;
			}

			[dataArray addObject:temp];
			[self.itemDescriptionTableView reloadData];
			
            break;
         default:
            break;
    }
	
}
#pragma mark 
#pragma mark UITextFieldDelegate Methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	userNameField.text = nil;
	return YES;	
}

- (void)textFieldDidEndEditing:(UITextField *)textField {	
	
}

-(void)textChanged:(NSNotification*)notif {
	

	if (isFirstTime) {
		commentBox.text = @"";
		commentBox.textColor = [UIColor blackColor];
		isFirstTime = FALSE;
	}
	
}
-(void) addComment_Clicked
{

	qualityRatingView =  [[RateView alloc] initWithFrame:CGRectMake(100, 145, 170, 25)];
	comfortRatingView = [[RateView alloc] initWithFrame:CGRectMake(100, 165, 170, 25)];
	appearanceRatingView = [[RateView alloc] initWithFrame:CGRectMake(100, 185, 170, 25)];
	
	qualityRatingView.ratingViewId = 1;
	comfortRatingView.ratingViewId = 2;
	appearanceRatingView.ratingViewId = 3;
	
	comfortRatingView.delegate = self;
	qualityRatingView.delegate = self;
	appearanceRatingView.delegate = self;
	
	qualityRating = 0;
	comfortRating = 0;
	appearanceRating = 0;
	
	userNameField = [[UITextField alloc] initWithFrame:CGRectMake(10.0, 35.0, 255, 25)];
	[userNameField setBorderStyle:UITextBorderStyleRoundedRect];
	userNameField.placeholder = @"Enter Your Name";
	
	commentBoxField = [[UITextField alloc] initWithFrame:CGRectMake(10.0, 65.0, 260, 75)];
	[commentBoxField setBorderStyle:UITextBorderStyleRoundedRect];
	commentBoxField.placeholder = @"Enter Your Comment.....";
	
	
	UIAlertView *prompt = [[UIAlertView alloc] initWithTitle:@"Enter Your Comment" 
													 message:@"\n\n\n" // IMPORTANT
													delegate:self 
										   cancelButtonTitle:@"Cancel" 
										   otherButtonTitles:@"OK", nil];
	
	
	commentBox = [[UITextView alloc] initWithFrame:CGRectMake(10.0, 65.0, 260, 75)];
	commentBox.textColor = [UIColor grayColor];
	commentBox.text = @"Enter Your Comment.....";
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];

	commentBox.layer.cornerRadius = 5;
	commentBox.clipsToBounds = YES;
	[commentBox.layer setBorderWidth: 1.0];
    [commentBox.layer setCornerRadius:8.0f];
    [commentBox.layer setMasksToBounds:YES];
	[commentBox becomeFirstResponder];
	[prompt addSubview:commentBox];
	[prompt addSubview:userNameField];
	[self willPresentAlertView:prompt];
	
	UILabel *qaulity = [[UILabel alloc] initWithFrame:CGRectMake(15, 145, 85, 25)];
	qaulity.text = @"Quality :";
	qaulity.font = [UIFont systemFontOfSize:14];
	[prompt addSubview:qaulity];
	[qaulity release];
	
	UILabel *comfort = [[UILabel alloc] initWithFrame:CGRectMake(15, 165, 85, 25)];
	comfort.text = @"Comfort :";
	comfort.font = [UIFont systemFontOfSize:14];
	[prompt addSubview:comfort];
	[comfort release];
	
	UILabel *appearance = [[UILabel alloc] initWithFrame:CGRectMake(15, 185, 85, 25)];
	appearance.text = @"Appearance :";
	appearance.font = [UIFont systemFontOfSize:14];
	[prompt addSubview:appearance];
	[appearance release];
	
	[prompt addSubview:qualityRatingView];
	[prompt addSubview:comfortRatingView];
	[prompt addSubview:appearanceRatingView];
	[prompt show];
	[commentBox release];
	[qualityRatingView release];
	[comfortRatingView release];
	[appearanceRatingView release];
	[prompt release];
	
	
}
- (void)rateView:(RateView *)rateView ratingDidChange:(NSInteger)rating {
	switch (rateView.ratingViewId) {
		case 1:
			qualityRating = rating;
			break;
		case 2:
			comfortRating = rating;
			break;
		case 3:
			appearanceRating = rating;
			break;
		default:
			break;
	}
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	//self.navigationItem.rightBarButtonItem = self.editButtonItem;

	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
															initWithBarButtonSystemItem:UIBarButtonSystemItemDone
															target:self action:@selector(doneBtn_Clicked:)] autorelease];
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Add Comment" style:UIBarButtonItemStyleBordered
																	  target:self action:@selector(addComment_Clicked)]autorelease];
	
	[self.view addSubview:itemDescriptionTableView];
	self.dataLoader.delegate = self;
	self.currentDataFormat = DeserializerTypeYAML;

}
- (void)dataLoader:(BaseDataLoader *)loader didLoadData:(NSArray *)data
{
    self.data = data;

	//dataArray = [[NSMutableArray alloc] initWithArray:data]; 
	dataArray = (NSMutableArray *)data;
	[self.itemDescriptionTableView reloadData];
	
}
- (IBAction)refresh:(id)sender
{
    self.data = nil;
	self.dataLoader.delegate = self;
	self.currentDataFormat = DeserializerTypeYAML;
	NSString *itemName = (NSString *)sender;
    [self.itemDescriptionTableView reloadData];
	
    if (self.currentDataFormat == DeserializerTypeSOAP)
    {
        self.dataLoader = [BaseDataLoader loaderWithMechanism:LoaderMechanismSOAP];
    }
    else
    {
        self.dataLoader = [BaseDataLoader loaderWithMechanism:LoaderMechanismASIHTTPRequest];
    }
    self.dataLoader.delegate = self;
    self.dataLoader.deserializer = [BaseDeserializer deserializerForFormat:self.currentDataFormat];
	
	int stringLength = [itemName length];
	
	NSRange range;
	range.location = 0;
	range.length = stringLength;
	
	NSString *imageName = [itemName stringByReplacingOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:range];
	
	[self.dataLoader loadDataWithQuery:@"getComments" withCategoryType:imageName];

}

#pragma mark -
#pragma mark Table view data source



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// Return the number of sections.
	if (self.dataArray == (NSMutableArray*)[NSNull null]) {
		return 2;
	}
	else {
		if ([self.dataArray count] == 0) {
			return 0;
		}
		return [self.dataArray count]+1;
	}
}
 
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	if (self.dataArray == (NSMutableArray*)[NSNull null]) {
		return 2;
	}
	else {
		if ([self.dataArray count] == 0) {
			return 0;
		}
		return [self.dataArray count]+1;
	}


	//return 1;
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	return 1;
	
	/*if (self.data == (NSArray*)[NSNull null]) {
		return 1;
	}
	else {
		return 1;
		//return [self.data count]+1;
	}*/
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	if (indexPath.section == 0) {
	switch (indexPath.row) {
		case 0:
			return 145;
	}
   }else if (self.dataArray == (NSMutableArray*)[NSNull null]) {
		
	   return 50;
   
   }
	NSDictionary *newItem = [self.dataArray objectAtIndex:[indexPath row]];
	CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH, 10000.0f);
	CGSize size = [[newItem objectForKey:@"comments"] sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];

	return size.height+30+100;
	
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"Item Detail Cell";
	
	int stringLength = 0;
	UILabel *messageLabel = nil;
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	if (indexPath.section == 0) {
		
		if ([indexPath row] == 0) {
			NSString *itemName = item.name;
			stringLength = [itemName length];
			ItemDetailView *detailView = [[ItemDetailView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320, 145)];
			detailView.ratingLabel.hidden = YES;
			NSRange range;
			range.location = 0;
			range.length = stringLength;
			
			NSString *imageName = [itemName stringByReplacingOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:range];
			
			imageName = [imageName stringByAppendingString:@".jpg"];
			NSString *urlString = [Thumbnail_URL stringByAppendingString:imageName];
			NSURL *url = [NSURL URLWithString:urlString];		
			NSData * imageData = [[NSData alloc] initWithContentsOfURL: url];
			detailView.shopItemImage.image = [UIImage imageWithData: imageData];
			[imageData release];
			
			detailView.itemName.text = itemName;
			detailView.itemPrice.text = [NSString stringWithFormat:@"Price: $ %.02f",item.price];
			[cell.contentView addSubview:detailView];
			[detailView release];
		}
	}else if (self.dataArray  == (NSMutableArray*)[NSNull null]) {
		
		messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 5.0, 200, 20)];
		messageLabel.font = [UIFont fontWithName:@"Verdana-Italic" size:14];
		messageLabel.text = @"No comments yet....";
		[cell.contentView addSubview:messageLabel];
		[messageLabel release];
	}
	else {
		//[messageLabel removeFromSuperview];
		NSDictionary *newItem = [self.dataArray objectAtIndex:[indexPath section]-1];
		CommentsView *commentView = [[CommentsView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320, 145)]; 
		commentView.userNameLabel.text = [[newItem objectForKey:@"customerName"] stringByAppendingString:@" says..."];
		commentView.commentText.text = [newItem objectForKey:@"comments"];
		[commentView drawRating:[[newItem objectForKey:@"quality"]intValue] withXPoint:70 andYPoint:30];
		[commentView drawRating:[[newItem objectForKey:@"comfort"]intValue] withXPoint:70 andYPoint:50];
		[commentView drawRating:[[newItem objectForKey:@"appearance"]intValue] withXPoint:90 andYPoint:70];
		
		CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH, 10000.0f);
		CGSize size = [[newItem objectForKey:@"comments"] sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
		commentView.commentText.frame = CGRectMake(0.0, 90.0, 290, size.height+10);
		[cell.contentView addSubview:commentView];
		[commentView release];
	}
	return cell;
}	
/*
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"Item Detail Cell";
	
	int stringLength = 0;
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
  if (indexPath.section == 0) {
	
	  if ([indexPath row] == 0) {
			NSString *itemName = item.name;
			stringLength = [itemName length];
			ItemDetailView *detailView = [[ItemDetailView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320, 145)];
			detailView.ratingLabel.hidden = YES;
			NSRange range;
			range.location = 0;
			range.length = stringLength;
			
			NSString *imageName = [itemName stringByReplacingOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:range];
			
			imageName = [imageName stringByAppendingString:@".jpg"];
			NSString *urlString = [Thumbnail_URL stringByAppendingString:imageName];
			NSURL *url = [NSURL URLWithString:urlString];		
			NSData * imageData = [[NSData alloc] initWithContentsOfURL: url];
			detailView.shopItemImage.image = [UIImage imageWithData: imageData];
			[imageData release];
			
			detailView.itemName.text = itemName;
			detailView.itemPrice.text = [NSString stringWithFormat:@"Price: $ %.02f",item.price];
			[cell.contentView addSubview:detailView];
			[detailView release];
		}
	}else if (self.data == (NSArray*)[NSNull null]) {
		
		UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 10.0, 200, 20)];
		messageLabel.font = [UIFont fontWithName:@"Verdana-Italic" size:14];
		messageLabel.text = @"No comments yet....";
		[cell.contentView addSubview:messageLabel];
		[messageLabel release];
	}
	else {
		NSDictionary *newItem = [self.data objectAtIndex:[indexPath row]];
		NSLog(@"Row %d",[indexPath row]);
		CommentsView *commentView = [[CommentsView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320, 145)]; 
		commentView.userNameLabel.text = @"Anonymous Says...";
		commentView.commentText.text = [newItem objectForKey:@"comments"];
		[commentView drawRating:[[newItem objectForKey:@"quality"]intValue] withXPoint:70 andYPoint:30];
		[commentView drawRating:[[newItem objectForKey:@"comfort"]intValue] withXPoint:70 andYPoint:50];
		[commentView drawRating:[[newItem objectForKey:@"appearance"]intValue] withXPoint:90 andYPoint:70];
		
		CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH, 10000.0f);
		CGSize size = [[newItem objectForKey:@"comments"] sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
		//commentView.commentText.backgroundColor = [UIColor grayColor];
		commentView.commentText.frame = CGRectMake(0.0, 90.0, 290, size.height+10);
		[cell.contentView addSubview:commentView];
		[commentView release];
	}
	
	
	
	return cell;
}	
*/
/*
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	static NSString *CellIdentifier = @"Item Detail Cell";

	int stringLength = 0;
	NSDictionary *newItem = [self.data objectAtIndex:[indexPath row]];
	
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
			
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
	if (indexPath.section == 0) {
		
		if ([indexPath row] == 0) {
			NSString *itemName = [newItem objectForKey:@"name"];
			stringLength = [itemName length];
			ItemDetailView *detailView = [[ItemDetailView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320, 145)];
			detailView.ratingLabel.hidden = YES;
			NSRange range;
			range.location = 0;
			range.length = stringLength;
			
			NSString *imageName = [itemName stringByReplacingOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:range];
			
			imageName = [imageName stringByAppendingString:@".jpg"];
			NSString *urlString = [Thumbnail_URL stringByAppendingString:imageName];
			NSURL *url = [NSURL URLWithString:urlString];		
			NSData * imageData = [[NSData alloc] initWithContentsOfURL: url];
			detailView.shopItemImage.image = [UIImage imageWithData: imageData];
			[imageData release];
			
			detailView.itemName.text = itemName;
			detailView.itemPrice.text = [NSString stringWithFormat:@"Price: $ %.02f",item.price];
			[cell.contentView addSubview:detailView];
			[detailView release];
		}
	}
	else {
			CommentsView *commentView = [[CommentsView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320, 145)]; 
			commentView.userNameLabel.text = @"Anonymous Says...";
			commentView.commentText.text = [newItem objectForKey:@"comments"];
			[commentView drawRating:[[newItem objectForKey:@"quality"]intValue] withXPoint:70 andYPoint:30];
			[commentView drawRating:[[newItem objectForKey:@"comfort"]intValue] withXPoint:70 andYPoint:50];
			[commentView drawRating:[[newItem objectForKey:@"appearance"]intValue] withXPoint:90 andYPoint:70];
			
		    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
			CGSize size = [[newItem objectForKey:@"comments"] sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
		    //commentView.commentText.backgroundColor = [UIColor grayColor];
		    commentView.commentText.frame = CGRectMake(0.0, 90.0, 290, size.height+10);
			[cell.contentView addSubview:commentView];
			[commentView release];
		}
	

	
	return cell;
}	*/
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[itemDescriptionTableView release];
    [super dealloc];
}


@end
