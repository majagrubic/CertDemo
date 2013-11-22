//
//  MainController.h
//  FinaCertDemo
//
//  Created by Maja on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainController : UIViewController<UITextFieldDelegate> {
    UIActivityIndicatorView *activityIndicator;
}


-(void) loadCertificate;

@end
