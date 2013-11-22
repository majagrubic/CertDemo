//
//  OverviewController.h
//  FinaCertDemo
//
//  Created by Maja on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    IssuerOverview,
    BillOverview,
    NewBillsOverview,
    MapBillsOverview, 
    MapDetailsOverview
} OverviewType;

@interface OverviewController : UITableViewController {
    OverviewType type;
    NSArray *tableDataSource;
}
@property (nonatomic, retain) NSArray *tableDataSource;
@property (nonatomic, assign) OverviewType type;
@end
