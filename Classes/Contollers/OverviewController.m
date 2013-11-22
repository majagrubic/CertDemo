//
//  OverviewController.m
//  FinaCertDemo
//
//  Created by Maja on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OverviewController.h"
#import "Localized.h"
#import "BillOverviewController.h"

@implementation OverviewController
@synthesize tableDataSource, type;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if (type == BillOverview) {
        self.title = [Localized string:@"Pregled računa"];
        [array addObject:[Localized string:@"Novi računi"]];
        [array addObject:[Localized string:@"Pregled po mapama"]];
    } else if (type == IssuerOverview) {
        self.title = [Localized string:@"Pregled izdavatelja"];
        [array addObject:[Localized string:@"Vodovodi i odvodnja Šibenik"]];
        [array addObject:[Localized string:@"Vodovod Slavonski Brod"]];
        [array addObject:[Localized string:@"Općina Pitomača"]];
        [array addObject:[Localized string:@"Komunalno Pitomača"]];
    } else if (type == NewBillsOverview) {
        self.title = [Localized string:@"Novi računi"];
        [array addObject:[Localized string:@"Račun za vodu"]];
    } else if (type == MapBillsOverview) {
        self.title = [Localized string:@"Pregled po mapama"];
        [array addObject:[Localized string:@"Vikendica"]];
        [array addObject:[Localized string:@"Plin"]];
        [array addObject:[Localized string:@"Struja"]];
        [array addObject:[Localized string:@"Telefon"]];
    } else if (type == MapDetailsOverview) {
        [array addObject:[Localized string:@"Račun za vodu"]];
        [array addObject:[Localized string:@"Račun za vodu"]];
        [array addObject:[Localized string:@"Račun za vodu"]];
        [array addObject:[Localized string:@"Račun za vodu"]];
    }

    self.tableDataSource = array;
    self.tableView.backgroundColor = [UIColor clearColor];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background.png"]];
    self.tableView.backgroundView = imageView;
    [imageView release];

    [array release];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.tableDataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
   
    cell.textLabel.text = [self.tableDataSource objectAtIndex:indexPath.row];
    if (type == IssuerOverview)   cell.accessoryType = UITableViewCellAccessoryNone;
    else cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (type == IssuerOverview) {
        return;
    } else if (type == BillOverview) {
        OverviewController *detailViewController = [[OverviewController alloc] initWithStyle:UITableViewStyleGrouped];
        detailViewController.type = 2+ indexPath.row;
        [self.navigationController pushViewController:detailViewController animated:YES];
        [detailViewController release];
    } else if (type == MapBillsOverview) {
        OverviewController *detailViewController = [[OverviewController alloc] initWithStyle:UITableViewStyleGrouped];
        detailViewController.type = MapDetailsOverview;
        detailViewController.title = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
        [self.navigationController pushViewController:detailViewController animated:YES];
        [detailViewController release];
    } else if (type == MapDetailsOverview || type == NewBillsOverview) {
        BillOverviewController *controller = [[BillOverviewController alloc] initWithStyle:UITableViewStyleGrouped];
        controller.title = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
}


-(void) dealloc {
    [tableDataSource release];
    [super dealloc];
}
@end
