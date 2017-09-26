//
//  OptionsPickerSheetView.h
//  VPW
//
//  Created by Sunil Verma on 10/1/14.
//  Copyright (c) 2014 Halosys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLCategoryInfo.h"

typedef void(^OptionPickerSheetBlock)(NSString  *selectedText,NSInteger selectedIndex);

@interface OptionsPickerSheetView : UIView<UIPickerViewDataSource, UIPickerViewDelegate>

+ (id)sharedPicker;

-(void)showPickerSheetWithOptions:(NSArray *)options AndComplitionblock:(OptionPickerSheetBlock )block;
//+(void)removePickerView;
//-(void)showPickerSheetWithOptions:(NSArray *)optionsWithString
//                                 :(NSString *)stringName AndComplitionblock:(OptionPickerSheetBlock)block;
@end
