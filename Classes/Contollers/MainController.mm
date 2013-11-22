//
//  MainController.m
//  FinaCertDemo
//
//  Created by Maja on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainController.h"
#import "Localized.h"
#import "GeneralInfoController.h"
#import <openssl/x509.h>
#import <openssl/pkcs12.h>
#import <openssl/err.h>
#import "CertificateParser.h"

@implementation MainController


-(void) dealloc {
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
    self.navigationItem.backBarButtonItem.title = [Localized string:@"Back"];
    [Localized save:@"en"];
    [self loadCertificate];
    
}

-(void) viewWillAppear:(BOOL)animated {
   
    [super viewWillAppear:animated];
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


-(void) loadCertificate {
    FILE *p12_file;
    PKCS12 *p12_cert = NULL;
    EVP_PKEY *pkey = NULL;
    
    STACK_OF(X509) *additional_certs = NULL;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"cert.p12"];
    NSString *appFile = [[NSBundle mainBundle] pathForResource:@"cert" ofType:@"p12"]; 
    if (!appFile){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Localized string:@"Error"] message:[Localized string:@"Error loading certificate"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    OpenSSL_add_all_ciphers();
    OpenSSL_add_all_digests();
    ERR_load_crypto_strings();
    
    p12_file = fopen([appFile UTF8String], "rb");
    if (p12_file == NULL) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[Localized string:@"Error"] message:[Localized string:@"Could not open certificate"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
    d2i_PKCS12_fp(p12_file, &p12_cert);
    fclose(p12_file);
    
    X509 *certificateX509 = (X509*)malloc(sizeof(certificateX509));
    
    NSString *password = @"maja";
    PKCS12_parse(p12_cert, [password UTF8String], &pkey, &certificateX509, &additional_certs);
    
    unsigned long er = ERR_get_error();
    char errmsg[256];
    ERR_error_string_n(er, errmsg, sizeof errmsg);
    NSLog(@"%s", errmsg);
    NSLog(@"%ld", er);
    
    if (er != 0L && er != 185073780L) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Localized string:@"Error"] message:[Localized string:@"Error loading certificate"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setValue:[CertificateParser certificateGetSubjectName:certificateX509 attribute:"CN"] forKey:@"CN"];
    [prefs synchronize];
    GeneralInfoController *generalInfo = [[GeneralInfoController alloc] initWithNibName:@"CertGeneral" bundle:nil];
    [generalInfo setX509Certificate:certificateX509];
    generalInfo.pKey = pkey;
    [self.navigationController pushViewController:generalInfo animated:YES];
    [generalInfo release];

}




@end
