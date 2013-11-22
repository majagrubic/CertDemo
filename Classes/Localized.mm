//
//  An upgrade for the built-in localization features (e.g. adding more languages)
//
//  Created by Šimun Mikecin on 4/23/09.
//  Copyright 2009 Logos. All rights reserved.
//

// $Id: Localized.mm 43388 2012-10-02 11:47:16Z bbosnjak $

#import <cassert>
#import <string>
#import <vector>
#import "Localized.h"

using namespace std;

namespace {
  Localized *localized = nil;
}

@implementation Localized
@synthesize bundleAttribute;
@synthesize pathAttribute;

- (id)init {
  if ((self = [super init])) {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.pathAttribute = [defaults stringForKey:@"language_preference"];

#ifdef BUNDLE_PATH
    NSString *bundlePath =   [[NSBundle mainBundle] pathForResource:BUNDLE_PATH ofType:@"bundle"];
#else 
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
#endif
    NSString *dataPath;
    if ([self.pathAttribute length] > 0) {
      dataPath = [bundlePath stringByAppendingPathComponent:self.pathAttribute];
    } else {
      dataPath = bundlePath;
    }
    NSBundle *b = [[NSBundle alloc] initWithPath:dataPath];
    self.bundleAttribute = b;
    [b release];
    assert(self.bundleAttribute!= nil);
    [self.bundleAttribute load];
  }
  return self;
}

+ (NSBundle *)bundle {
  @synchronized(localized) {
    if (localized == nil) {
      localized = [[Localized alloc] init];
    }
    return localized.bundleAttribute;
  }
  return nil;
}

+ (NSString *)prefferedLocalization {
  @synchronized(localized) {
    if (localized == nil) {
      localized = [[Localized alloc] init];
    }
  }
  if (localized.pathAttribute == nil) {
    NSArray *localizations = [[NSBundle mainBundle] localizations];
    localizations = [NSBundle preferredLocalizationsFromArray:localizations];
    if ([localizations count] > 0) {
      return [localizations objectAtIndex:0];
    }
    return nil;
  }
  const NSRange range = [localized.pathAttribute rangeOfString:@"."];
  if (range.location == NSNotFound) {
    assert(false);
    return localized.pathAttribute;
  }
  return [localized.pathAttribute substringToIndex:range.location];
}

+ (NSString *)string:(NSString *)stringKey {
  NSString *s = NSLocalizedStringFromTableInBundle(stringKey, LocalizableFiles, [Localized bundle], @"comment");
  if (!s) {
    s = NSLocalizedStringFromTableInBundle(stringKey, LocalizableFiles, [NSBundle mainBundle], @"comment");
  }
  return s;
}

+ (void)save:(NSString *)languageKey {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setObject:[NSString stringWithFormat:@"%@.lproj",languageKey] forKey:@"language_preference"];
//NSLog(@"SAVING %@",[NSString stringWithFormat:@"%@.lproj",languageKey]);
  @synchronized(localized) {
    if (localized != nil) {
      [localized release];
      localized = nil;
    }
  }
	[defaults synchronize];
}

+ (void)reset {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults removeObjectForKey:@"language_preference"];
  @synchronized(localized) {
    if (localized != nil) {
      [localized release];
      localized = nil;
    }
  }
}

+ (NSString *)path {
  @synchronized(localized) {
    if (localized == nil) {
      localized = [[Localized alloc] init];
    }
    return localized.pathAttribute;
  }
  return nil;
}

- (void)dealloc {
  [pathAttribute release];
  [bundleAttribute release];
  [super dealloc];
}

@end
