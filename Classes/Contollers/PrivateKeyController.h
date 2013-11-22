//
//  PrivateKeyController.h
//  FinaCertDemo
//
//  Created by Maja on 3/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <openssl/x509.h>

@interface PrivateKeyController : UIViewController {
    
    EVP_PKEY *_pKey;
}

@property(nonatomic, retain) IBOutlet UILabel *algorithmLabel;
@property(nonatomic, retain) IBOutlet UILabel *lengthLabel;
@property(nonatomic, retain) IBOutlet UITextView *key;
@property(nonatomic, assign) EVP_PKEY *pKey;

@end
