//
//  ShippingDetailedViewController.m
//  Client
//
//  Created by Bilal Nazir on 12/6/10.
//  Copyright 2010 iShop. All rights reserved.
//

#import "ShippingDetailedViewController.h"


@implementation ShippingDetailedViewController

@synthesize countryTextField;
@synthesize passwordTextField;
@synthesize userNameTextField;
@synthesize submitBtn;

#pragma mark -
#pragma mark Initialization




- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	
    switch (buttonIndex) {
        case 0:
           // NSLog(@"Cancel Button Pressed");
            break;
			
		default:
			break;
	}
}
-(void)submitBtnClicked:(id) sender
{
	
	if ( [userNameTextField.text isEqualToString:@""] || [passwordTextField.text isEqualToString:@""] ||[countryTextField.text isEqualToString:@""]||
		[streetTextField.text isEqualToString:@""]  || [cityTextField.text isEqualToString:@""] ||[zipCodeTextField.text isEqualToString:@""] )
	{
		
		UIAlertView *prompt = [[UIAlertView alloc] initWithTitle:@"Requare data is not completed" 
														 message:@"Please fill all the data first" // IMPORTANT
														delegate:self 
											   cancelButtonTitle:@"OK" 
											   otherButtonTitles:nil,nil];
		
		[prompt show];
		[prompt release];
		
	}else
	{
		UIAlertView *prompt = [[UIAlertView alloc] initWithTitle:@"Request Submited Successfully" 
														 message:@"These items will be delivered in 2 or 3 days" // IMPORTANT
														delegate:self 
											   cancelButtonTitle:@"OK" 
											   otherButtonTitles:nil,nil];
		
		[prompt show];
		[prompt release];
		userNameTextField.text = @"";
		streetTextField.text = @"";
		passwordTextField.text = @"";
		countryTextField.text = @"";
		cityTextField.text= @"";
		zipCodeTextField.text = @"";
	
	}
	
	
}


- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization.
		userNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(90.0, 40.0, 190.0, 28.0)];
		[userNameTextField setBorderStyle:UITextBorderStyleRoundedRect];
		
		passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(90.0, 75.0, 190.0, 28.0)];
		passwordTextField.secureTextEntry = YES;
		[passwordTextField setBorderStyle:UITextBorderStyleRoundedRect];
		
		streetTextField = [[UITextField alloc] initWithFrame:CGRectMake(90.0, 35.0, 190.0, 28.0)];
		[streetTextField setBorderStyle:UITextBorderStyleRoundedRect];

		zipCodeTextField = [[UITextField alloc] initWithFrame:CGRectMake(90.0, 105.0, 190.0, 28.0)];
		[zipCodeTextField setBorderStyle:UITextBorderStyleRoundedRect];

		countryTextField = [[UITextField alloc] initWithFrame:CGRectMake(90.0, 140.0, 190.0, 28.0)];
		[countryTextField setBorderStyle:UITextBorderStyleRoundedRect];

		cityTextField = [[UITextField alloc] initWithFrame:CGRectMake(90.0, 70.0, 190.0, 28.0)];
		[cityTextField setBorderStyle:UITextBorderStyleRoundedRect];

		userNameTextField.text = @"";
		streetTextField.text = @"";
		passwordTextField.text = @"";
		countryTextField.text = @"";
		cityTextField.text= @"";
		zipCodeTextField.text = @"";
		
		submitBtn = [[MOGlassButton alloc] initWithFrame:CGRectMake(110, 325, 130, 35)];
		[submitBtn setupAsGreenButton];
		submitBtn.titleLabel.font = [UIFont systemFontOfSize:16];
		[submitBtn setTitle:@"Submit Request" forState:UIControlStateNormal];
		[submitBtn addTarget:self action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)keyboardWillHide:(NSNotification *)aNotification
{
    NSTimeInterval animationDuration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect frame = self.view.frame;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
}


-(void)viewWillAppear:(BOOL)animated 
{
	[super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewDidDisappear:(BOOL)animated 
{
    [super viewDidDisappear:animated];
   [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void) saveBtn_Clicked:(id) sender
{
    [self.countryTextField resignFirstResponder];
	[self.userNameTextField resignFirstResponder];
	[self.passwordTextField resignFirstResponder];
	
}
#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

 	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
											   initWithBarButtonSystemItem:UIBarButtonSystemItemSave
											   target:self action:@selector(saveBtn_Clicked:)] autorelease];
	
	[self.view addSubview:submitBtn];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	if (indexPath.section == 0) {
		switch (indexPath.row) {
			case 0:
				return 110;
		}
	}
		
     return 180;
		

	
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	}
	
	if (indexPath.section == 0) {
		
		if ([indexPath row] == 0) {
			
			UILabel *signinLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 5, 60, 20)];
			signinLabel.text = @"Sign in";
			signinLabel.textColor = [UIColor purpleColor];
			signinLabel.font =[UIFont systemFontOfSize:16];
			[cell.contentView addSubview:signinLabel];
			[signinLabel release];

			UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 40, 80, 20)];
			userNameLabel.text = @"Username :";
			userNameLabel.font =[UIFont systemFontOfSize:14];
			[cell.contentView addSubview:userNameLabel];
			[userNameLabel release];
			
			UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 80, 80, 20)];
			passwordLabel.text = @"Password :";
			passwordLabel.font =[UIFont systemFontOfSize:14];
			[cell.contentView addSubview:passwordLabel];
			[passwordLabel release];
			
			[cell.contentView addSubview:userNameTextField];
			
			//[userNameTextField release];
			
			[cell.contentView addSubview:passwordTextField];
			
			//[passwordTextField release];
		
		}
	}
	else {
		UILabel *shippingLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 140, 20)];
		
		shippingLabel.text = @"Shipping Detail";
		shippingLabel.textColor = [UIColor purpleColor];
		shippingLabel.font =[UIFont systemFontOfSize:16];
		[cell.contentView addSubview:shippingLabel];
		[shippingLabel release];
		
		UILabel *streetLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 40, 80, 20)];
		streetLabel.text = @"Street :";
		streetLabel.font =[UIFont systemFontOfSize:14];
		[cell.contentView addSubview:streetLabel];
		[streetLabel release];
		
		UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 70, 80, 20)];
		cityLabel.text = @"City :";
		cityLabel.font =[UIFont systemFontOfSize:14];
		[cell.contentView addSubview:cityLabel];
		[cityLabel release];
		
		UILabel *zipCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 107, 80, 20)];
		zipCodeLabel.text = @"Zip Code :";
		zipCodeLabel.font =[UIFont systemFontOfSize:14];
		[cell.contentView addSubview:zipCodeLabel];
		[zipCodeLabel release];
		
		UILabel *countryLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 142, 80, 20)];
		countryLabel.text = @"Country :";
		countryLabel.font =[UIFont systemFontOfSize:14];
		[cell.contentView addSubview:countryLabel];
		[countryLabel release];
		
		
		[cell.contentView addSubview:streetTextField];
		
		
		[cell.contentView addSubview:cityTextField];


		[cell.contentView addSubview:zipCodeTextField];

		
		[cell.contentView addSubview:countryTextField];
		
		//
		
	}

	
   // Configure the cell...
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


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
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
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
	[streetTextField release];
	[zipCodeTextField release];
	[cityTextField release];
	[countryTextField release];
	[userNameTextField release];
	[passwordTextField release];
	[countryTextField release];
    [super dealloc];
}


@end

