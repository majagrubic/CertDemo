//
//  DescriptionCell.m
//  CertViewer
//
//  Created by MacBook Pro on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DescriptionCell.h"

@implementation DescriptionCell

@synthesize descriptionText, descriptionLabel;
@synthesize expiresText, expiresLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier]) != nil) {
        UIFont *leftFont = [UIFont boldSystemFontOfSize:13.0];

        descriptionLabel = [[[UILabel alloc] init] autorelease];
        descriptionLabel.font = leftFont;
        descriptionLabel.textColor = [UIColor grayColor];
        descriptionLabel.textAlignment = UITextAlignmentRight;
        descriptionLabel.backgroundColor = [UIColor clearColor];
        descriptionLabel.text = @"Description";
        
        expiresLabel = [[[UILabel alloc] init] autorelease];
        expiresLabel.font = leftFont;
        expiresLabel.textColor = [UIColor grayColor];
        expiresLabel.textAlignment = UITextAlignmentRight;
        expiresLabel.backgroundColor = [UIColor clearColor];
        expiresLabel.text = @"Expires";
        
        UIFont *rightFont = [UIFont systemFontOfSize:13.0];
        descriptionText = [[[UILabel alloc] init] autorelease];
        descriptionText.font = rightFont;
        descriptionText.backgroundColor = [UIColor clearColor];
        descriptionText.textAlignment = UITextAlignmentLeft;
        
        expiresText = [[[UILabel alloc] init] autorelease];
        expiresText.font = rightFont;
        expiresText.backgroundColor = [UIColor clearColor];
        expiresText.textAlignment = UITextAlignmentLeft;
        
        [self.contentView addSubview:descriptionLabel];
        [self.contentView addSubview:descriptionText];
        [self.contentView addSubview:expiresText];
		[self.contentView addSubview:expiresLabel];
    
        
    }
    return self;
}

-(void) layoutSubviews {
	[super layoutSubviews];
	CGRect contentRect=self.contentView.bounds;
	CGRect frame;
	
	frame = CGRectMake(5.0f, 5.0f, 90.0f, 20.0f);
	descriptionLabel.frame = frame;
	
	frame = CGRectMake(5.0f, 30.0f, 90.f, 20.0f);
	expiresLabel.frame = frame;
	
	frame = CGRectMake(105.0f, 5.0f, 190.0f, 20.0f);
	descriptionText.frame = frame;
	
	frame = CGRectMake(105.0f, 30.f, 190.0f, 20.0f);
	expiresText.frame = frame;
    
}

@end
