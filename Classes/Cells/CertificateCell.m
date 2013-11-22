//
//  CertificateCell.m
//  CertViewer
//
//  Created by MacBook Pro on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CertificateCell.h"

@implementation CertificateCell 
@synthesize certName, certIssuer;
@synthesize settingsIcon;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier]) != nil) {
        settingsIcon = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cert.png"]]autorelease];
        
        certName = [[[UILabel alloc] init] autorelease];
        certName.font = [UIFont boldSystemFontOfSize:16.0];
        certName.backgroundColor = [UIColor clearColor];
        
        certIssuer = [[[UILabel alloc] init] autorelease];
        certIssuer.backgroundColor = [UIColor clearColor];
        certIssuer.font = [UIFont systemFontOfSize:14.0];
        certIssuer.textColor = [UIColor grayColor];
        certIssuer.lineBreakMode = UILineBreakModeWordWrap;
        certIssuer.numberOfLines = 1;
        
        [self.contentView addSubview:settingsIcon];
        [self.contentView addSubview:certName];
        [self.contentView addSubview:certIssuer];
        
    }
    
    return self;
}
-(void) layoutSubviews {
    CGRect frame;
    CGRect contentRect=self.contentView.bounds;

    frame = CGRectMake(contentRect.origin.x + 15.0f, contentRect.origin.y + 5.0f, 79.0f, 64.0f);
    settingsIcon.frame = frame;
    
    frame = CGRectMake(115, 5.0f, 190.0f, 25.0f);
    certName.frame = frame;
    
    frame = CGRectMake(115, 30.0f, 190.f, 20.0f);
    certIssuer.frame = frame;
}
@end
