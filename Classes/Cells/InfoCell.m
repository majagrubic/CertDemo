//
//  InfoCell.m
//  CertViewer
//
//  Created by MacBook Pro on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InfoCell.h"

@implementation InfoCell


-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        NSLog([self.textLabel.font description]);
        self.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
        self.detailTextLabel.numberOfLines = 0;

    }
    return self;
}


-(void) layoutSubviews {
    [super layoutSubviews];
    CGRect contentRect=self.contentView.bounds;
    CGRect frame = CGRectMake(5.0, 10.0, contentRect.size.width -10.0, contentRect.size.height-10.0);
    self.detailTextLabel.frame = frame;
}


@end
