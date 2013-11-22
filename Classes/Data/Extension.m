//
//  Extension.m
//  CertViewer
//
//  Created by Maja on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Extension.h"

@implementation Extension
@synthesize nid=_nid;
@synthesize name=_name;
@synthesize keyValue=_keyValue;
@synthesize critical= _critical;

-(void) dealloc {
    [_nid release];
    [_name release];
    [_keyValue release];
    [super dealloc];
}

-(id) initWithNid:(NSString*) nid andName:(NSString*) name {
    self = [super init];
    if (self) {
        self.nid = nid;
        self.name = name;
        self.critical = NO;
    }
    return self;
}

@end
