//
//  CartTableViewController.m
//  Client
//
//  Created by Bilal Nazir on 12/5/10.
//  Copyright 2010 iShop. All rights reserved.
//

#import "CartTableViewController.h"
#import "ShoppingItem.h"
#import "CartViewController.h"
#import "Constants.h"
#import "ShippingDetailedViewController.h"
#import "CreateAccountTableViewController.h"

@implementation CartTableViewController



-(void)showCartViewControllerWithCartItem:(ShoppingItem *)cartItem 
{
	CartViewController *cartViewController = [[CartViewController alloc] initWithItem:cartItem];
	[self.navigationController pushViewController:cartViewController animated:YES];

	self.tabBarController.selectedIndex = 1;
	[cartViewController release];
}

-(void) addToCartList:(ShoppingItem*) cartItem withCount:(NSInteger)count 
{
	totalPrice = 0.0;
	
	cartItem.count = count;
	[cartListSet  addObject:cartItem];
	
	cartListArray = [[NSMutableArray alloc] init];
	
	for (ShoppingItem *tempItem in cartListSet) {
		
		totalPrice +=tempItem.count*tempItem.price;
		
		[cartListArray addObject:tempItem];
	}
	
	
	self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"Total: %.2f",totalPrice];
	
	[self.tableView reloadData];
}
#pragma mark -
#pragma mark Initialization

/**/
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) {
		self.title = @"Cart Items";
		self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Cart" image:[UIImage imageNamed:@"shopping-cart.png"] tag:0];
		cartListSet = [[NSMutableSet alloc] init];
		
		totalPrice= 0;
	}
    return self;
}
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

	ShippingDetailedViewController *shippingDetailVC = nil;
	CreateAccountTableViewController *createAccountVC = nil;
    switch (buttonIndex) {
        case 0:
            NSLog(@"Cancel Button Pressed");
            break;
			
		case 1:
			shippingDetailVC = [[ShippingDetailedViewController alloc] initWithStyle:UITableViewStyleGrouped];
			[self.navigationController pushViewController:shippingDetailVC animated:YES];
			[shippingDetailVC release];
			
		    break;
			case 2:
			createAccountVC = [[CreateAccountTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
			[self.navigationController pushViewController:createAccountVC animated:YES];
			[createAccountVC release];
			break;


		default:
		break;
	}
}
-(void)CheckOut_Button_Clicked
{
	
	UIAlertView *prompt = [[UIAlertView alloc] initWithTitle:@"ACCOUNT INFO" 
													 message:@"You must login first" // IMPORTANT
													delegate:self 
										   cancelButtonTitle:@"Cancel" 
										   otherButtonTitles:@"Login Into Account", @"Create Account",nil];
	
	[prompt show];
	[prompt release];

}

#pragma mark -
#pragma mark View lifecycle

-(void) totalPriceBtn_Clicked:(id) sender
{
	
}
- (void)viewDidLoad {
    [super viewDidLoad];

  
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Check Out" style:UIBarButtonItemStyleBordered
	                                                                          target:self action:@selector(CheckOut_Button_Clicked)]autorelease];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
											  initWithTitle:[NSString stringWithFormat:@"Total: %.2f",totalPrice] style:UIBarButtonItemStyleBordered
											   target:self action:@selector(totalPriceBtn_Clicked:)]autorelease];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	self.tableView.editing = YES;
	self.tableView.allowsSelectionDuringEditing = YES;
	
}

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
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [cartListArray count];
}
- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	return 150;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
   
		cell.selectionStyle = UITableViewCellSelectionStyleNone;

		cell.editingAccessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	}

	ShoppingItem *item =[cartListArray objectAtIndex:indexPath.row];
	NSString *itemName = item.name;
	int stringLength = [itemName length];
	NSRange range;
	range.location = 0;
	range.length = stringLength;
	
	NSString *imageName = [itemName stringByReplacingOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:range];
	
	imageName = [imageName stringByAppendingString:@".jpg"];
	NSString *urlString = [Thumbnail_URL stringByAppendingString:imageName];
	NSURL *url = [NSURL URLWithString:urlString];		
	NSData * imageData = [[NSData alloc] initWithContentsOfURL: url];
	UIImageView *imageView = [[UIImageView alloc] initWithFrame: CGRectMake(10, 10, 100, 130)];
	imageView.image = [UIImage imageWithData: imageData];
	[cell.contentView addSubview:imageView];
	[imageView release];
	[imageData release];
	
	
	
	UILabel *itemNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 10, 160, 50)];
	itemNameLabel.text = item.name;
	itemNameLabel.numberOfLines = 0;
	itemNameLabel.font = [UIFont systemFontOfSize:14];
	[cell.contentView addSubview:itemNameLabel];
	[itemNameLabel release];
	
	//
	UILabel *totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 90, 170, 20)];
	totalPriceLabel.text = [NSString stringWithFormat:@"Total Price : $%.02f",(item.count*item.price)];
	totalPriceLabel.textColor = [UIColor redColor];
	totalPriceLabel.font = [UIFont systemFontOfSize:14];
	[cell.contentView addSubview:totalPriceLabel];
	[totalPriceLabel release];
	
	UILabel *itemCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 120, 170, 20)];
	itemCountLabel.text = [NSString stringWithFormat:@"Number of items : %d",item.count];
	itemCountLabel.font = [UIFont systemFontOfSize:14];
	[cell.contentView addSubview:itemCountLabel];
	[itemCountLabel release];

    // Configure the cell...
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}




// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
		ShoppingItem *deleteItem = [cartListArray objectAtIndex:indexPath.row];
		totalPrice -=deleteItem.count*deleteItem.price;
		self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"Total: %.2f",totalPrice];
        [cartListSet removeObject:deleteItem];
		[cartListArray removeObjectAtIndex:indexPath.row];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
		
	
	}   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}



/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	
	ShoppingItem *item = [cartListArray objectAtIndex:indexPath.row];
	CartViewController *cartViewController = [[CartViewController alloc] initWithItem:item];
	[self.navigationController pushViewController:cartViewController animated:YES];
	[cartViewController release];
	//[self.navigationController pushViewController:cartViewDelegate animated:YES];

}


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


- (void)dealloc {
    [super dealloc];
}


@end

