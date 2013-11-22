//
//  GeneralInfoController.m
//  CertViewer
//
//  Created by MacBook Pro on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GeneralInfoController.h"
#import "CertificateCell.h"
#import "DetailedInfoController.h"
#import "CertificateParser.h"
#import "Localized.h"
#import "PrivateKeyController.h"


@implementation GeneralInfoController
@synthesize generalTableView = _generalTableView;
@synthesize certificateX509 = certificateX509;
@synthesize formatter;
@synthesize pKey = _pKey;

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


// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == HEADER_SECTION) return 1;
    if (section == PURPOSE_SECTION) return 1;
    if (section == ISSUER_SECTION) return 4;
    if (section == DETAILS_SECTION) return 1;
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    int section = [indexPath section];
    switch (section) {
        case 0:
            return HEADER_HEIGHT;
        default:
            return ROW_HEIGHT;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return [Localized string:@"Purpose"];
    }
    return @"";
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier0 = @"Cell0";
    static NSString *cellIdentifier1 = @"Cell1";
    static NSString *cellIdentifier2 = @"Cell2";
    static NSString *cellIdentifier3 = @"Cell3";
    
    NSArray *cellIdentifiers = [NSArray arrayWithObjects:cellIdentifier0, cellIdentifier1, 
                                cellIdentifier2, cellIdentifier3, nil];
    
    NSArray *cellTypes = [NSArray arrayWithObjects:[NSNumber numberWithInt:UITableViewCellStyleDefault],               [NSNumber numberWithInt:UITableViewCellStyleDefault], 
                          [NSNumber numberWithInt:UITableViewCellStyleValue1], 
                          [NSNumber numberWithInt:UITableViewCellStyleDefault], nil];
    UITableViewCell *cell;
    int section = [indexPath section];
    
    if (section == 0) {
       cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier0];
        if (cell == nil) {
            cell = [[[CertificateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier0] autorelease];
                
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:[cellIdentifiers objectAtIndex:section]];
        if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:[[cellTypes objectAtIndex:section] intValue] reuseIdentifier:[cellIdentifiers objectAtIndex:section]];
        }
    }
 
    //customize cells
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSArray *issuer = [CertificateParser certificateGetIssuer:self.certificateX509];
    NSArray *subject =  [CertificateParser certificateGetSubject:self.certificateX509];
    NSString *commonName = [CertificateParser certificateGetSubjectName:self.certificateX509 attribute:"CN"];
    if (section == HEADER_SECTION) {
        CertificateCell *certCell = (CertificateCell*) cell;
       
        if (commonName) {
            certCell.certName.text =  commonName;
        }
        NSMutableString *issuerLabel = [[NSMutableString alloc] init];
        for (int i=0; i<[issuer count]; i++) {
            NSDictionary *dict = [issuer objectAtIndex:i];
            NSArray *keys = [dict allKeys];
            NSString *key = [keys objectAtIndex:0];
            [issuerLabel appendString:[NSString stringWithFormat:@"%@, ", [dict objectForKey:key]]];
        }
      
        certCell.certIssuer.text = issuerLabel;
        [issuerLabel release];
    
    } else if (section == PURPOSE_SECTION) {
        if ([indexPath row] == 0) {
            cell.textLabel.text = [CertificateParser certificateGetKeyUsage:certificateX509];
        }
    } else if (section == ISSUER_SECTION) {
        if ([indexPath row] == 0) {
            cell.textLabel.text = [Localized string:@"Issued To"];
            if (commonName) {
                cell.detailTextLabel.text = commonName;
            }
        }
        if ([indexPath row] == 1) {
            cell.textLabel.text = [Localized string:@"Issued By"];
            NSString *temp = [CertificateParser CertificateGetIssuerName:self.certificateX509 attribute:"CN"];
            if (temp != nil) {
                cell.detailTextLabel.text = temp;
            } else if ((temp = [CertificateParser CertificateGetIssuerName:self.certificateX509 attribute:"DN"]) != nil) {
                cell.detailTextLabel.text = temp;
            } else if ((temp = [CertificateParser CertificateGetIssuerName:self.certificateX509 attribute:"O"]) != nil) {
                cell.detailTextLabel.text = temp;
            } else if ((temp = [CertificateParser CertificateGetIssuerName:self.certificateX509 attribute:"OU"]) != nil) {
                cell.detailTextLabel.text = temp;
            }
        }

        if ([indexPath row] == 2) {
            cell.textLabel.text = [Localized string:@"Valid From"];
            NSDate *startDate = [CertificateParser certificateGetStartDate:
                                 self.certificateX509];
            NSString *startString = [self.formatter stringFromDate:startDate];
            cell.detailTextLabel.text =  startString;
        }
        if ([indexPath row] == 3) {
            NSDate *expiryDate = [CertificateParser certificateGetExpiryDate:certificateX509];
            NSString *expiryString = [self.formatter stringFromDate:expiryDate];
            cell.textLabel.text = [Localized string:@"Valid To"];
            cell.detailTextLabel.text = expiryString;
        }
    } else if (section == DETAILS_SECTION) {
        if ([indexPath row] == 0) {
            cell.textLabel.text = [Localized string:@"Details"];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 3 && [indexPath row] == 0) {
        DetailedInfoController *detailViewController = [[DetailedInfoController alloc] init];
        detailViewController.certificateX509 = self.certificateX509;
        [self.navigationController pushViewController:detailViewController animated:YES];
        [detailViewController release];
    }
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    self.title = [Localized string:@"General Info"];
    self.formatter = [[NSDateFormatter alloc] init];
    [self.formatter setDateFormat:@"dd.MM.yyyy"];
    self.generalTableView.showsVerticalScrollIndicator = NO;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:[Localized string:@"Key"] style:UIBarButtonItemStyleBordered target:self action:@selector(showKey)];
    self.navigationItem.rightBarButtonItem = item;
    [item release];
    
    self.navigationItem.hidesBackButton = YES;
    

}

-(void) backToMain {
    NSArray *viewControllers = self.navigationController.viewControllers;
    UIViewController *mainController = [viewControllers objectAtIndex:[viewControllers count] - 3];
    [self.navigationController popToViewController:mainController animated:YES];
}


-(void) showKey {
    PrivateKeyController *pKController = [[PrivateKeyController alloc] initWithNibName:@"PrivateKeyController" bundle:nil];
    pKController.pKey = self.pKey;
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:pKController];
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController presentModalViewController:controller animated:YES];
    [controller release];
    [pKController release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) setX509Certificate:(X509*) certX509 {
    certificateX509 = certX509;
}

-(void) dealloc {
    [_generalTableView release];
    [formatter release];
    [super dealloc];
}

@end
