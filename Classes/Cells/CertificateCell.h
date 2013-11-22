//
//  CertificateCell.h
//  CertViewer
//
//  Created by MacBook Pro on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


@interface CertificateCell : UITableViewCell {
    UIImageView *settingsIcon;
    UILabel *certName;
    UILabel *certIssuer;
}

@property (nonatomic, retain) UIImageView *settingsIcon;
@property (nonatomic, retain) UILabel *certName;
@property (nonatomic, retain) UILabel *certIssuer;

@end
