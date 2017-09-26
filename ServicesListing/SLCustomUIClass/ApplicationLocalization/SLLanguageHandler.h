//
//  CTLanguageHandler.h
//  CrafTechApplication
//
//  Created by Ratneshwar Singh on 11/30/16.
//  Copyright © 2016 Mobiloitte Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Macro.h"
#import "Header.h"

#undef NSLocalizedString

// Use "LocalizedString(key)" the same way you would use "NSLocalizedString(key,comment)"
#define SLLocalizedString(key) [[SLLanguageHandler sharedLocalSystem] localizedStringForKey:(key)]
// "language" can be (for american english): "en", "en-US", "english". Analogous for other languages.
#define LocalizationSetLanguage(language) [[SLLanguageHandler sharedLocalSystem] setLanguage:(language)]


@interface SLLanguageHandler : NSObject

// a singleton:
+ (SLLanguageHandler *) sharedLocalSystem;

// this gets the string localized:
- (NSString*) localizedStringForKey:(NSString*) key;

//set a new language:
- (void) setLanguage:(NSString*) lang;

@end
