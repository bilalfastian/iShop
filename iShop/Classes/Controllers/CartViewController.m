    //
//  CartViewController.m
//  Client
//
//  Created by Bilal Nazir on 12/5/10.
//  Copyright 2010 iShop. All rights reserved.
//

#import "CartViewController.h"
#import "ItemDetailView.h"
#import "Constants.h"

@implementation CartViewController

@synthesize itemCartTableView;
@synthesize pickerView;
@synthesize numOfItemsLabel, sizeLabel,priceLabel;


-(id) initWithItem:(ShoppingItem*) newItem
{
	if ( self = [super init])
	{
		CGRect frame = CGRectMake(0, 0, 320, 480);
		itemCartTableView = [[UITableView alloc] initWithFrame:frame 
																style:UITableViewStyleGrouped];
		itemCartTableView.delegate = self;
		itemCartTableView.dataSource = self;
		
		item = newItem;
		pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, 320, 200)];
		
		
		arrayNo = [[NSMutableArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",nil];
		
		sizeArray = [[NSMutableArray alloc] init];
		[sizeArray addObject:@"XL"];
		[sizeArray addObject:@"L"];
		[sizeArray addObject:@"M"];
		
		sizeAndCountPickerArray = [[NSArray alloc] initWithObjects:arrayNo,sizeArray,nil];
		[arrayNo release];
		[sizeLabel release];
		
		pickerView.delegate = self;
		pickerView.dataSource = self;
		pickerView.showsSelectionIndicator = YES;
		
		numOfItemsLabel =[[UILabel alloc] initWithFrame:CGRectMake(250, 110, 50, 20)];
		sizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(250, 135, 60, 20)];
		priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(248, 160, 60, 20)];
		
		numOfItemsLabel.font = [UIFont systemFontOfSize:14];
		sizeLabel.font = [UIFont systemFontOfSize:14];
		priceLabel.font = [UIFont systemFontOfSize:14];
		
		numOfItemsLabel.textColor = [UIColor blueColor];
		sizeLabel.textColor = [UIColor blueColor];
		priceLabel.textColor = [UIColor blueColor];
		
		numOfItemsLabel.text = [arrayNo objectAtIndex:[pickerView selectedRowInComponent:0]];
		sizeLabel.text = [sizeArray objectAtIndex:[pickerView selectedRowInComponent:0]];
		
		priceLabel.text =[NSString stringWithFormat:@"$%.02f",item.price];
		
	}
	return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
	return [sizeAndCountPickerArray count];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	//numOfItemsLabel.text = [arrayNo objectAtIndex:row];
	if (component == 0) {
	    
		numOfItemsLabel.text = [[sizeAndCountPickerArray objectAtIndex:component] objectAtIndex:row];		
	
		NSString *temp = [[sizeAndCountPickerArray objectAtIndex:component] objectAtIndex:row];
		float totalPrice = [temp intValue]*item.price;
		priceLabel.text = [NSString stringWithFormat:@"$%.02f",totalPrice];
	
	}
	else {
		sizeLabel.text = [[sizeAndCountPickerArray objectAtIndex:component] objectAtIndex:row];
		//int price = item.price;
		//	NSString *temp = [[sizeAndCountPickerArray objectAtIndex:component] objectAtIndex:row];
		//float totalPrice = [temp intValue]*item.price;
		//sizeLabel.text = [NSString stringWithFormat:@"%@",totalPrice];
		//sizeLabel.text = [[sizeAndCountPickerArray objectAtIndex:component] objectAtIndex:row];
	}

}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
	return [[sizeAndCountPickerArray objectAtIndex:component]  count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
	return [[sizeAndCountPickerArray objectAtIndex:component]  objectAtIndex:row];
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

-(void) saveBtn_Clicked:(id)sender {
	
	NSArray *viewControllers = self.navigationController.viewControllers;
	UIViewController *cartTableViewController = [viewControllers objectAtIndex:viewControllers.count -2];
	
	
	objc_msgSend(cartTableViewController, @selector(addToCartList:withCount:),item,[numOfItemsLabel.text intValue]);

	[self.navigationController popViewControllerAnimated:YES];
	
	//[self.navigationController dismissModalViewControllerAnimated:YES];
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Edit";
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
											   initWithBarButtonSystemItem:UIBarButtonSystemItemSave
											   target:self action:@selector(saveBtn_Clicked:)] autorelease];
	
	
	[self.view addSubview:itemCartTableView];
	[self.view addSubview:pickerView];
	[self.view addSubview:numOfItemsLabel];
	[self.view addSubview:sizeLabel];
	[self.view addSubview:priceLabel];
	
}


#pragma mark -
#pragma mark Table view data source



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	return 1;

}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
   
	return 180;
	
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"Item Cart Cell";
	int stringLength = 0;
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
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
	[cell.contentView addSubview:detailView];
	[detailView release];


	UILabel *numOfItemsText = [[UILabel alloc] initWithFrame:CGRectMake(120, 100, 150, 20)];
	numOfItemsText.font = [UIFont systemFontOfSize:14];
	numOfItemsText.textColor = [UIColor redColor];
	numOfItemsText.text = @"Number of Items :";
	[cell.contentView addSubview:numOfItemsText];
	[numOfItemsText release];

	
	UILabel *sizeText = [[UILabel alloc] initWithFrame:CGRectMake(120, 125, 150, 20)];
	sizeText.font = [UIFont systemFontOfSize:14];
	sizeText.textColor = [UIColor redColor];
	sizeText.text = @"Size :";
	[cell.contentView addSubview:sizeText];
	[sizeText release];
	
		
	UILabel *priceText = [[UILabel alloc] initWithFrame:CGRectMake(120, 150, 150, 20)];
	priceText.font = [UIFont systemFontOfSize:14];
	priceText.textColor = [UIColor redColor];
	priceText.text = @"Total Price :";
	[cell.contentView addSubview:priceText];
	[priceText release];
	
	
	return cell;
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
	[itemCartTableView release];
	[sizeLabel release];
	[priceLabel release];
	[numOfItemsLabel release];
    [super dealloc];
}


@end
