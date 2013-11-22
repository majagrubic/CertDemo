//
//  An upgrade for the built-in localization features (e.g. adding more languages)
//
//  Created by Šimun Mikecin on 4/23/09.
//  Copyright 2009 Logos. All rights reserved.
//

// $Id: Localized.h 19523 2009-12-28 14:58:31Z sime $


@interface Localized : NSObject {
  NSBundle *bundleAttribute;
  NSString *pathAttribute;
}
@property (nonatomic, retain) NSBundle *bundleAttribute;
@property (nonatomic, retain) NSString *pathAttribute;
+ (NSBundle *)bundle;
+ (NSString *)string:(NSString *)stringKey;
+ (void)save:(NSString *)languageKey;
+ (void)reset;
+ (NSString *)path;
+ (NSString *)prefferedLocalization;
@end
