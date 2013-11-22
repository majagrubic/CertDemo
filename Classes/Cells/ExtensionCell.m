//
//  ExtensionCell.m
//  FinaCertDemo
//
//  Created by Maja on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ExtensionCell.h"

@implementation ExtensionCell
@synthesize extensionLabel, extensionValue;
@synthesize oidLabel, oidValue;
@synthesize criticalLabel, criticalValue;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        extensionLabel = [[[UILabel alloc] init] autorelease];
        extensionLabel.font = [UIFont boldSystemFontOfSize:17.0];
        oidLabel = [[[UILabel alloc] init] autorelease];
        oidLabel.font =  [UIFont boldSystemFontOfSize:17.0];
        criticalLabel = [[[UILabel alloc] init] autorelease];
        criticalLabel.font = [UIFont boldSystemFontOfSize:17.0];
        
        extensionValue = [[[UILabel alloc] init] autorelease];
        extensionValue.textAlignment = UITextAlignmentRight;
        extensionValue.font = [UIFont systemFontOfSize:16.0];
        extensionValue.textColor = [UIColor darkGrayColor];
        
        oidValue = [[[UILabel alloc] init] autorelease];
        oidValue.textAlignment = UITextAlignmentRight;
        oidValue.font = [UIFont systemFontOfSize:16.0];
        oidValue.textColor = [UIColor darkGrayColor];

        criticalValue = [[[UILabel alloc] init] autorelease];
        criticalValue.textAlignment = UITextAlignmentRight;
        criticalValue.font = [UIFont systemFontOfSize:16.0];
        criticalValue.textColor = [UIColor darkGrayColor];
        
        [self.contentView addSubview:extensionLabel];
        [self.contentView addSubview:oidLabel];
        [self.contentView addSubview:criticalLabel];
        [self.contentView addSubview:extensionValue];
        [self.contentView addSubview:oidValue];
        [self.contentView addSubview:criticalValue];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = self.contentView.frame;
    CGRect frame;
    
    float y = bounds.origin.y + 5.0;
    frame = CGRectMake(bounds.origin.x + 5.0,y, 80, 20);
    extensionLabel.frame = frame;
    
    y+= 25;
    frame.origin.y = y;
    oidLabel.frame = frame;
    
    y+= 25;
    frame.origin.y = y;
    criticalLabel.frame = frame;
    
    frame = CGRectMake(90, bounds.origin.y+5.0, 220, 20);
    extensionValue.frame = frame;
    
    frame = CGRectMake(90, bounds.origin.y+30.0, 220, 20);
    oidValue.frame = frame;
    
    frame = CGRectMake(90, bounds.origin.y+55.0, 220, 20);
    criticalValue.frame = frame;
}

@end
