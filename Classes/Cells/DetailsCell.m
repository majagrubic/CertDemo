//
//  DetailsCell.m
//  FinaCertDemo
//
//  Created by Maja on 3/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailsCell.h"

@implementation DetailsCell

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.detailTextLabel.textAlignment = UITextAlignmentRight;
        self.detailTextLabel.font = [UIFont systemFontOfSize:16.0];
        self.detailTextLabel.textColor = [UIColor darkGrayColor];
        self.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
    }
    return self;
}

-(void) layoutSubviews {
	[super layoutSubviews];
	CGRect contentRect=self.contentView.bounds;
	CGRect frame;
	
	frame = CGRectMake(5.0f, 5.0f, 310.0, 20.0f);
	self.textLabel.frame = frame;
	
    float cellHeight = contentRect.size.height;
    frame = CGRectMake(5.0f, 27.0f, 310.f, 20.0f);
	self.detailTextLabel.frame = frame;
	
}

@end
