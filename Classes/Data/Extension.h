//
//  Extension.h
//  CertViewer
//
//  Created by Maja on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


@interface Extension : NSObject {
    NSString *_nid;
    NSString *_name;
    BOOL _critical;
    NSDictionary *_keyValue;
}

@property (nonatomic, retain) NSString *nid;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSDictionary *keyValue;
@property (nonatomic, assign) BOOL critical;

-(id) initWithNid:(NSString*) nid andName:(NSString*)name;

@end
