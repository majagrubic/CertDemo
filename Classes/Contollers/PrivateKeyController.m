//
//  PrivateKeyController.m
//  FinaCertDemo
//
//  Created by Maja on 3/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PrivateKeyController.h"
#import "CertificateParser.h"
#import "Localized.h"

@implementation PrivateKeyController
@synthesize pKey = _pKey;
@synthesize algorithmLabel;
@synthesize lengthLabel;
@synthesize key;

-(void) dealloc {
    [lengthLabel release];
    [algorithmLabel release];
    [key release];
    [super dealloc];
}

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
    self.title = [Localized string:@"Private Key"];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:[Localized string:@"Done"] style:UIBarButtonItemStyleBordered target:self action:@selector(dismiss)];
    self.navigationItem.rightBarButtonItem = item;
    [item release];
    
    NSDictionary *privateKeyInfo = [CertificateParser certificateGetPrivateKey:self.pKey];
    if ([privateKeyInfo valueForKey:@"Error"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Localized string:@"Error"] message:[privateKeyInfo valueForKey:@"Error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    if ([privateKeyInfo valueForKey:@"Algorithm"]) {
        self.algorithmLabel.text = [NSString stringWithFormat:@"%@ %@",[privateKeyInfo valueForKey:@"Algorithm"], [Localized string:@"private key"]];
    } 
    if ([privateKeyInfo valueForKey:@"Length"]) {
        self.lengthLabel.text = [NSString stringWithFormat:@"%@ %@", [privateKeyInfo valueForKey:@"Length"], [Localized string:@"bits"]];
    }
    if ([privateKeyInfo valueForKey:@"Key"]) {
        [self.key setText:[privateKeyInfo valueForKey:@"Key"]];
    }
}


-(void) dismiss{
    [self dismissModalViewControllerAnimated:YES];
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

@end
