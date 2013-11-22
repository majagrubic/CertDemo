//
//  JimbaStandardEdition
//
//  Created by Boris Bošnjak on 3/9/10.
//  Copyright Asseco SEE 2010. All rights reserved.
//

// $Id: JimbaStandardEditionAppDelegate.m 20739 2010-03-15 08:47:55Z sime $

#import "CertDemoAppDelegate.h"

@implementation CertDemoAppDelegate
@synthesize window;
@synthesize navigationController;

@synthesize startURL;


- (void)dealloc {
  [startURL release];
	[navigationController release];
	[window release];
	[super dealloc];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
  // Override point for customization after app launch    
  
	[window addSubview:[navigationController view]];
  [window makeKeyAndVisible];

}

/*- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
 if ([[url scheme] isEqualToString:@"mzaba"]) {
 self.startURL = [url absoluteString];
 return YES;
 }
 return NO;
 }*/

- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}



@end

