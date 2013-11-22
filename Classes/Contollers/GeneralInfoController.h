//
//  GeneralInfoController.h
//  CertViewer
//
//  Created by MacBook Pro on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <openssl/pkcs12.h>
#import <openssl/err.h>

static const int HEADER_SECTION     = 0;
static const int PURPOSE_SECTION    = 1;
static const int ISSUER_SECTION     = 2;
static const int DETAILS_SECTION    = 3;
static const double HEADER_HEIGHT   = 74.0f;
static const double ROW_HEIGHT      = 44.0f;

@interface GeneralInfoController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    UITableView *_generalTableView;
    X509 *certificateX509;
    NSDateFormatter *formatter;
    EVP_PKEY *_pKey;
}

@property (nonatomic, retain) IBOutlet UITableView *generalTableView;
@property (nonatomic, assign) X509 *certificateX509;
@property (nonatomic, assign) EVP_PKEY *pKey;
@property (nonatomic, retain) NSDateFormatter *formatter;

-(void) setX509Certificate:(X509*) certX509;

@end
