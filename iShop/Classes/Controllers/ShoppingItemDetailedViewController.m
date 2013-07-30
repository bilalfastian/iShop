    //
//  ShoppingItemDetailedViewController.m
//  Client
//
//  Created by Bilal Nazir on 11/18/10.
//  Copyright 2010 iShop. All rights reserved.
//

#import "ShoppingItemDetailedViewController.h"

#import "CommentsViewController.h"
#import "Constants.h"
#import "CartViewController.h"

@implementation ShoppingItemDetailedViewController

@synthesize cartDelegate;
@synthesize newItem;
@synthesize commentsBtn,cartBtn;


-(void)cartBtnBtnClicked
{
	//[cartDelegate showCartViewControllerWithCartItem:newItem];
	objc_msgSend(cartDelegate, @selector(showCartViewControllerWithCartItem:), newItem);

	/*
	CartViewController *cartViewController = [[CartViewController alloc] initWithItem:newItem];
	UINavigationController *cartNavController = [[UINavigationController alloc] initWithRootViewController:cartViewController];
	[delegate presentModalViewController:cartNavController animated:YES];
	
	[cartNavController release];
	[cartViewController release];
	 */
}
-(void)commentsBtnClicked:(id) sender
{
	
	CommentsViewController *commentsViewController = [[CommentsViewController alloc] initWithItem:newItem];
	UINavigationController *commNavController = [[UINavigationController alloc] initWithRootViewController:commentsViewController];
	
	[commentsViewController refresh:newItem.name];
	[delegate presentModalViewController:commNavController animated:YES];
	[commNavController release];
	[commentsViewController release];

}
-(id)initWithShoppingItem:(ShoppingItem *)item withViewController:(UIViewController*)controller cartDelegate:(id)cartDel
{
	if (self = [super init]) {
        // Custom initialization.
		delegate = controller;
		newItem = [[ShoppingItem alloc] init];
		newItem = item;
		CGRect frame = CGRectMake(0, -20, 320, 480);
		itemDescriptionTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
		itemDescriptionTableView.delegate = self;
		itemDescriptionTableView.dataSource = self;
		[self.view addSubview:itemDescriptionTableView];
		commentsBtn = [[MOGlassButton alloc] initWithFrame:CGRectMake(170, 305, 130, 35)];
		[commentsBtn setupAsRedButton];
		commentsBtn.titleLabel.font = [UIFont systemFontOfSize:16];
		[commentsBtn setTitle:@"View Comments" forState:UIControlStateNormal];
		[commentsBtn addTarget:self action:@selector(commentsBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

		cartBtn = [[MOGlassButton alloc] initWithFrame:CGRectMake(15, 305, 130, 35)];
		[cartBtn setupAsGreenButton];
		cartBtn.titleLabel.font = [UIFont systemFontOfSize:16];
		[cartBtn setTitle:@"Add To Cart" forState:UIControlStateNormal];
		[cartBtn addTarget:self action:@selector(cartBtnBtnClicked) forControlEvents:UIControlEventTouchUpInside];
		
		[self.view addSubview:cartBtn];
		[self.view addSubview:commentsBtn];


		cartDelegate = cartDel;
    }
    return self;
}


#pragma mark -
#pragma mark Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	return 2;
	
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	switch (indexPath.row) {
		case 0:
			return 145;
			break;
			
		case 1:
			return 165;
			break;
		default:
			break;
	}
	return 110;
	
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"Cell";
	int stringLength=0;
	ItemDetailView *detailView = nil;
	UITextView *itemDescription = nil;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	switch (indexPath.row) {
		case 0:
			stringLength = [newItem.name length];
			detailView = [[ItemDetailView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320, 145)];
			[detailView drawRating:newItem.rating];
			NSRange range;
			range.location = 0;
			range.length = stringLength;
			
			NSString *imageName = [newItem.name stringByReplacingOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:range];
			
			imageName = [imageName stringByAppendingString:@".jpg"];
			NSString *urlString = [Thumbnail_URL stringByAppendingString:imageName];
			NSURL *url = [NSURL URLWithString:urlString];		
			NSData * imageData = [[NSData alloc] initWithContentsOfURL: url];
			detailView.shopItemImage.image = [UIImage imageWithData: imageData];
			[imageData release];
			[cell.contentView addSubview:detailView.descriptionLabel];
			detailView.itemName.text = newItem.name;
			detailView.itemPrice.text = [NSString stringWithFormat:@"Price: $ %.02f",newItem.price];
			[cell.contentView addSubview:detailView];
			
			break;
		case 1:
			
			itemDescription = [[UITextView alloc] init];
			itemDescription.text = newItem.description;
			itemDescription.frame =  CGRectMake(5, 25, 290, 130);
			itemDescription.font = [UIFont systemFontOfSize:14];
			itemDescription.editable = NO;
			[cell.contentView addSubview:itemDescription];
			[itemDescription release];
			break;
			
		default:
			break;
	}
	
		[detailView release];
    return cell;
	
}
#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
}	


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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

}


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
	[cartBtn release];
	[commentsBtn release];
    [super dealloc];
}


@end
