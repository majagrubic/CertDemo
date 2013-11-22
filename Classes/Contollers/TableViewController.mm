//
//  TableViewController.m
//  FinaCertDemo
//
//  Created by Maja on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TableViewController.h"
#import "Localized.h"
#import "MainController.h"
#import "OverviewController.h"

@implementation TableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
    [self.navigationItem setHidesBackButton:YES];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background.png"]];
    
    self.tableView.backgroundView = imageView;
    [imageView release];


  
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = [Localized string:@"Main Menu"];
     [self.tableView reloadData];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - UITableView delegate
// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{   
    if ([self hasCertificate]) return 3;
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) return 4;
    if (section == 1) return 1;
    if (section == 2) return 3;
    return 0;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    if (section == 1) {
//        return @"The certificate is intended for the following purpose(s):";
//    }
//    return @"";
//}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"MainCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if ([indexPath section] == 0) {
        
        if ([indexPath row] == 0) {
            cell.textLabel.text = [Localized string:@"OTP"];
        } else if ([indexPath row] == 1) {
            cell.textLabel.text = [Localized string:@"Get certificate"];
        } else if ([indexPath row] == 2) {
            cell.textLabel.text = [Localized string:@"View certificate"];
            cell.textLabel.enabled = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;

            if (![self hasCertificate]) {
                cell.textLabel.enabled = NO;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        } else {
            cell.textLabel.text = [Localized string:@"Clear certificate"];
            cell.textLabel.enabled = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            if (![self hasCertificate]) {
                cell.textLabel.enabled = NO;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if ([indexPath section] == 1) {
        cell.textLabel.text = [Localized string:@"Change language"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if ([indexPath section] == 2) {
        if ([indexPath row] == 0) {
            cell.textLabel.text = [Localized string:@"Pregled izdavatelja"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else if ([indexPath row] == 1) {
            cell.textLabel.text = [Localized string:@"Pregled računa"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell.textLabel.text = [Localized string:@"Pregled registriranih usluga"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    
    return cell;

}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @"";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 0 && [indexPath row] == 3) {
        if (![self hasCertificate]) return;
        [self showActionSheet];
        return;
    }
    
        UIViewController *viewController;       
        if (([indexPath section] == 0) && ([indexPath row] == 0)) {
           
        } else if ([indexPath section] == 0 &&[indexPath row] ==1) {
            MainController *mainController = [[MainController alloc] initWithNibName:@"MainController" bundle:nil];
            viewController = mainController;
        } else if ([indexPath section] == 0 && [indexPath row] == 2) {
            if (![self hasCertificate]) return;
            MainController *mainController = [[MainController alloc] initWithNibName:@"MainController" bundle:nil];
            viewController = mainController;
        } else if (([indexPath section] == 1) && ([indexPath row] == 0)) {
           

        } else if ([indexPath section] == 2) {
            if (![self isFinaMember]) {
              UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[Localized string:@"Warning"] message:[Localized string:@"Message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
                [alertView release];
                return;
            }
            if ([indexPath row] == 2) return;
            OverviewController *overviewController = [[OverviewController alloc] initWithStyle:UITableViewStyleGrouped];
            overviewController.type = (OverviewType) indexPath.row;
            viewController = overviewController;
        } else {
            return;
        }
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] 
                                       initWithTitle:[Localized string:@"Back"] 
                                       style: UIBarButtonItemStyleBordered
                                       target: nil action: nil];
        [self.navigationItem setBackBarButtonItem: backButton];
        [backButton release];
        
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];

}

-(id) showActionSheet {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:[Localized string:@"Delete certificate"] delegate:self cancelButtonTitle:
                            [Localized string:@"Cancel"] 
                                         destructiveButtonTitle:[Localized string:@"Delete"] otherButtonTitles:nil];
    sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [sheet showInView:self.view];
    [sheet release];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"cert.p12"];
        NSError *error = nil;
        NSFileManager *fileMgr = [[[NSFileManager alloc] init] autorelease];

        BOOL removeSuccess = [fileMgr removeItemAtPath:appFile error:&error];
        if (!removeSuccess) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[Localized string:@"Error"] message:[Localized string:@"Could not delete certificate"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            [alertView release];
        } else {
            [self.tableView reloadData];
        }

    }  
}

-(BOOL) hasCertificate {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"cert.p12"];
    NSData *appData = [NSData dataWithContentsOfFile:appFile];  
    if (appData) {
        return  YES;
    }
    return NO;
}


-(BOOL) isFinaMember {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *commonName = [prefs stringForKey:@"CN"];
    if (!commonName) {
        return NO;
    }
    NSString *commonNameToLower = [commonName lowercaseString];
    if ([commonNameToLower rangeOfString:@"andreja kajtaz"].location != NSNotFound || [commonNameToLower rangeOfString:@"zdenko spoljaric"].location != NSNotFound
        || [commonNameToLower rangeOfString:@"zdenko špoljarić"].location != NSNotFound || [commonNameToLower rangeOfString:@"maja grubic"].location != NSNotFound) {
        return  YES;
    }
    return NO;
        
}

@end
