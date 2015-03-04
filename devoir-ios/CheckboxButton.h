//
//  CheckboxButton.h
//  devoir-ios
//
//  Created by Candice Davis on 2/28/15.
//  Copyright (c) 2015 Candice Davis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckboxButton : UIButton

@property (nonatomic, readonly) BOOL checked;
- (void) changeState:(BOOL)isChecked;
-(id) initWithState:(BOOL)isChecked;

@end
