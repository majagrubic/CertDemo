//
//  DescriptionCell.h
//  CertViewer
//
//  Created by MacBook Pro on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


@interface DescriptionCell : UITableViewCell {
    UILabel *descriptionLabel;
    UILabel *expiresLabel;
    UILabel *descriptionText;
    UILabel *expiresText;
}

@property (nonatomic, retain) UILabel *descriptionLabel;
@property (nonatomic, retain) UILabel *expiresLabel;
@property (nonatomic, retain) UILabel *descriptionText;
@property (nonatomic, retain) UILabel *expiresText;
@end
