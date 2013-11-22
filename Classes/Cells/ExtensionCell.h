//
//  ExtensionCell.h
//  FinaCertDemo
//
//  Created by Maja on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExtensionCell : UITableViewCell {
    UILabel *extensionLabel;
    UILabel *oidLabel;
    UILabel *criticalLabel;
    
    UILabel *extensionValue;
    UILabel *oidValue;
    UILabel *criticalValue;
}

@property (nonatomic, retain) UILabel *extensionLabel;
@property (nonatomic, retain) UILabel *oidLabel;
@property (nonatomic, retain) UILabel *criticalLabel;

@property (nonatomic, retain) UILabel *extensionValue;
@property (nonatomic, retain) UILabel *oidValue;
@property (nonatomic, retain) UILabel *criticalValue;

@end
