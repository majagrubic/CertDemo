//
//  TableViewController.h
//  FinaCertDemo
//
//  Created by Maja on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface TableViewController : UITableViewController <UIActionSheetDelegate> {
    NSString *CN;
}

@property (nonatomic, retain) NSString *CN;
-(id) showActionSheet;

@end
