 //
//  DetailedInfoController.m
//  CertViewer
//
//  Created by MacBook Pro on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailedInfoController.h"
#import "InfoCell.h"
#import "Localized.h"
#import "CertificateParser.h"
#import "DetailsCell.h"
#import "ExtensionCell.h"
#import "Extension.h"

@interface DetailedInfoController ()
@property(nonatomic, copy) NSString *selectedItem;
@property (nonatomic, retain) NSIndexPath *selectedIndexPath;
-(void) configureView;
@end


@implementation DetailedInfoController
@synthesize horizMenu = _horizMenu;
@synthesize menuItems = _menuItems;
@synthesize selectedItem;
@synthesize selectedIndexPath;
@synthesize detailsTableView = _detailsTableView;
@synthesize tableViewData; 
@synthesize labels;
@synthesize certificateX509;
@synthesize subjectInfo, issuerInfo;
@synthesize extensions = _extensions;
@synthesize criticalExtensions = _criticalExtensions;
@synthesize keys;

static NSString * const kSubject = @"Subject Name";         //0
static NSString * const kIssuer = @"Issuer Name";           //1
static NSString * const kGeneral = @"General Info";         //2
static NSString * const kPublicKey = @"Public Key Info";    //3
static NSString * const kCritical = @"Critical Extensions";  //4
static NSString * const kOther = @"All Extensions";         //5
static NSString * const kFingerprints = @"Fingerprints";    //6


- (void)dealloc
{
    [_horizMenu release];
    [_menuItems release];
    [selectedItem release];
    [selectedIndexPath release];
    [labels release];
    [keys release];
    [_detailsTableView release];
    [subjectInfo release];
    [issuerInfo release];
    [_extensions release];
    [_criticalExtensions release];
    [super dealloc];
}

- (void)configureView
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.menuItems = [NSArray arrayWithObjects:kSubject, kIssuer, kGeneral, kPublicKey, kCritical, kOther, kFingerprints, nil]; 
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    
    self.horizMenu = [[MKHorizMenu alloc] initWithFrame:CGRectMake(0, 0, bounds.size.width, 41)];
	self.horizMenu.dataSource = self;
	self.horizMenu.itemSelectedDelegate = self;
	[self.horizMenu awakeFromNib];
    [self.horizMenu setSelectedIndex:0 animated:NO];
    [self.horizMenu reloadData];
    [self.view addSubview:self.horizMenu];
    
    self.detailsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 41, bounds.size.width, 400) style:UITableViewStylePlain];
    self.detailsTableView.delegate = self;
    self.detailsTableView.dataSource = self;
    [self.view addSubview:self.detailsTableView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *finalPath = [path stringByAppendingPathComponent:@"Labels.plist"];
    self.labels = [[NSDictionary dictionaryWithContentsOfFile:finalPath] retain];
    self.title = [Localized string:@"Details"];
	self.selectedIndexPath = nil;
    self.subjectInfo = [CertificateParser certificateGetSubject:certificateX509];
    self.issuerInfo = [CertificateParser certificateGetIssuer:certificateX509];
    self.extensions = [CertificateParser certificateGetExtensions:certificateX509];
    NSMutableArray *criticalExt = [[NSMutableArray alloc] init];
    for (Extension *ext in self.extensions) {
        if (ext.critical) {
            [criticalExt addObject:ext];
        }
    }
    self.criticalExtensions = criticalExt;
    [criticalExt release];
    self.keys = [[CertificateParser certificateGetPublicKey:certificateX509] allKeys];
    [self configureView];
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
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma mark HorizMenu Data Source
- (UIImage*) selectedItemImageForMenu:(MKHorizMenu*) tabMenu
{
    return [[UIImage imageNamed:@"ButtonSelected"] stretchableImageWithLeftCapWidth:16 topCapHeight:0];
}

- (UIColor*) backgroundColorForMenu:(MKHorizMenu *)tabView
{
	//return [UIColor lightGrayColor];
    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"MenuBar"]];
}

- (int) numberOfItemsForMenu:(MKHorizMenu *)tabView
{
    return [self.menuItems count];
}

- (NSString*) horizMenu:(MKHorizMenu *)horizMenu titleForItemAtIndex:(NSUInteger)index
{
    return [self.menuItems objectAtIndex:index];
}

#pragma mark -
#pragma mark HorizMenu Delegate
-(void) horizMenu:(MKHorizMenu *)horizMenu itemSelectedAtIndex:(NSUInteger)index
{        
	if ([self.selectedItem isEqualToString:[self.menuItems objectAtIndex:index]]) {
		return;
	}
    self.selectedItem = [self.menuItems objectAtIndex:index];
    [self.detailsTableView reloadData];
}

#pragma mark -
#pragma mark TableView DataSource
// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int index = [self.menuItems indexOfObject:self.selectedItem];
    
    if  (index == 0 ) {
        return [self.subjectInfo count];
    } else if (index == 1) {
        return [self.issuerInfo count];
    } else if (index == 2) {
        return 6;
    } else if (index == 3) {
        return [[CertificateParser certificateGetPublicKey:certificateX509] count];
    } else if (index == 4) {
        
        return ([self.criticalExtensions count] == 0) ? 1 : [self.criticalExtensions count];
    }else if (index == 5) {
        return ([self.extensions count]);
    } else if (index == 6) {
        return 2;
    }
    return [tableViewData count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    int row = [indexPath row];
    int selectedRow = [self.selectedIndexPath row];
   
    int index = [self.menuItems indexOfObject:self.selectedItem];
    
    if (index == 4 && [self.criticalExtensions count] == 0) {
        static NSString *extensionCellIdentifier = @"Critial Cell";
        cell = [tableView dequeueReusableCellWithIdentifier:extensionCellIdentifier];
        if (cell == nil) {
            cell = [[[DetailsCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:extensionCellIdentifier] autorelease];
        }
        cell.textLabel.text = [Localized string:@"No Critical Extensions"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else if (index == 4 || index == 5) {
        static NSString *extensionCellIdentifier = @"Extension Cell";
        cell = [tableView dequeueReusableCellWithIdentifier:extensionCellIdentifier];
        if (cell == nil) {
            cell = [[ExtensionCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:extensionCellIdentifier];
        }
        ExtensionCell *extensionCell = (ExtensionCell*) cell;
        extensionCell.extensionLabel.text = @"Extension";
        extensionCell.oidLabel.text = @"OID";
        extensionCell.criticalLabel.text = @"Critical";
    
        Extension *ext;
        if (index == 5) {
            ext = [self.extensions objectAtIndex:[indexPath row]];
        } else if (index == 4) {
            ext = [self.criticalExtensions objectAtIndex:[indexPath row]];
        }
        NSString *extensionValue = ext.name;
        if ([extensionValue hasPrefix:@"X509v3"] || [extensionValue hasPrefix:@"X509v2"]) {
            extensionCell.extensionValue.text = [extensionValue substringFromIndex:7];
        } else {
            extensionCell.extensionValue.text = ext.name;
        }
        extensionCell.oidValue.text = ext.nid;
        extensionCell.criticalValue.text = (ext.critical) ? @"YES" : @"NO";
        extensionCell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else if (index == 6) {
        static NSString *DropDownCellIdentifier = @"DropDownCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:DropDownCellIdentifier];
        if (cell == nil) {
            cell = [[InfoCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:DropDownCellIdentifier];
        }
        InfoCell *infoCell = (InfoCell*) cell;
        if ([indexPath row] == 0) {
            NSString *fingerprint = [CertificateParser certificateGetFingerprint:certificateX509 digestAlg:@"sha1"];
            infoCell.textLabel.text = @"SHA1";
            infoCell.detailTextLabel.text = fingerprint;
        } else {
            NSString *fingerprint = [CertificateParser certificateGetFingerprint:certificateX509 digestAlg:@"md5"];
            infoCell.textLabel.text = @"MD5";
            infoCell.detailTextLabel.text = fingerprint;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else  if (index == 3 && ([indexPath row] == [self.keys indexOfObject:@"PubKey"] || [indexPath row] == [self.keys indexOfObject:@"Signature"])) {
        static NSString *CellIdentifier = @"PublicKeyInfo";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
           cell = [[[InfoCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        } 
        InfoCell *infoCell = (InfoCell*) cell;
        NSString *key = [keys objectAtIndex:[indexPath row]];
        if ([self.labels objectForKey:key]) {
            infoCell.textLabel.text = [self.labels objectForKey:key];
        } else {
            infoCell.textLabel.text = key;
        }
        infoCell.detailTextLabel.text = [[CertificateParser certificateGetPublicKey:certificateX509] objectForKey:key];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else{
        static NSString *DataCellIdentifier = @"DataCell";
        cell = [tableView dequeueReusableCellWithIdentifier:DataCellIdentifier];
        if (cell == nil) {
            cell = [[[DetailsCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:DataCellIdentifier] autorelease];
        } 
       
        NSDictionary *tempDictionary;
        if (index == 0) {
            tempDictionary = [self.subjectInfo objectAtIndex:[indexPath row]];
        } else if (index == 1) {
            tempDictionary = [self.issuerInfo objectAtIndex:[indexPath row]];
        } else if (index == 3) {
            tempDictionary = [CertificateParser certificateGetPublicKey:certificateX509];
        }
        
        if (index == 0 || index == 1) {
            NSArray *key = [[tempDictionary allKeys] objectAtIndex:0];
            cell.textLabel.text = [self.labels objectForKey:key];
            cell.detailTextLabel.text = [tempDictionary objectForKey:key];
        } else if (index == 3) {
            NSArray *keys = [tempDictionary allKeys];
            NSString *key = [keys objectAtIndex:[indexPath row]];
            if ([self.labels objectForKey:key]) {
                cell.textLabel.text = [self.labels objectForKey:key];
            } else {
                cell.textLabel.text = key;
            }
            cell.detailTextLabel.text = [tempDictionary objectForKey:key];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        } else if (index == 2) {
            NSArray *generalInfo = [CertificateParser certificateGetGeneralInfo:certificateX509];
            NSArray *generalInfoLabels = [self.labels objectForKey:@"General Info"];
            cell.textLabel.text = [generalInfoLabels objectAtIndex:[indexPath row]];
            cell.detailTextLabel.text = [generalInfo objectAtIndex:[indexPath row]];
        } 
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
   }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    int row = [indexPath row];
    if ([self.selectedItem isEqualToString:kFingerprints]) {
        return 85.0;
    } else if ([self.selectedItem isEqualToString:kOther] || ([self.selectedItem isEqualToString:kCritical] && [self.criticalExtensions count] != 0)) {
        return 80.0;
    } else if ([self.selectedItem isEqualToString:kPublicKey]) {
        if ([self.keys indexOfObject:@"PubKey"] == row || [self.keys indexOfObject:@"Signature"] == row) {
            return 250.0;
        }
    }
    return 52.0;
        
}

@end
