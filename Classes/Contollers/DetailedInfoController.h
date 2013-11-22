//
//  DetailedInfoController.h
//  CertViewer
//
//  Created by MacBook Pro on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKHorizMenu.h"
#import <openssl/x509.h>

@interface DetailedInfoController : UIViewController<MKHorizMenuDataSource, MKHorizMenuDelegate,
                                        UITableViewDelegate, UITableViewDataSource> {
    
    MKHorizMenu *_horizMenu;
    NSMutableArray *_menuItems;
    UITableView *_detailsTableView;
    NSMutableArray *_tableViewData;
    NSDictionary *labels;
    X509* certificateX509;       
    NSArray *_extensions;
                                            NSArray *_criticalExtensions;
    
}

@property (nonatomic, retain) MKHorizMenu *horizMenu;
@property (nonatomic, retain) NSMutableArray *menuItems;
@property (nonatomic, retain) UITableView *detailsTableView;
@property (nonatomic, retain) NSMutableArray *tableViewData;
@property (nonatomic, retain) NSDictionary *labels;

@property (nonatomic, retain) NSArray *subjectInfo;
@property (nonatomic, retain) NSArray *issuerInfo;
@property (nonatomic, retain) NSArray *extensions;
@property (nonatomic, retain) NSArray *criticalExtensions;
@property (nonatomic, retain) NSArray *keys;

@property (nonatomic, assign) X509 *certificateX509;

@end
