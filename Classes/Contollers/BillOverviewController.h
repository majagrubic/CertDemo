//
//  BillOverviewController.h
//  FinaCertDemo
//
//  Created by Maja on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BillOverviewController : UITableViewController {
    NSDictionary *tableData;
    NSArray *keyArray;
}
@property (nonatomic, retain) NSDictionary *tableData;

@end
