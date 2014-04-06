//
//  DCTConfirmationButton.h
//  DCTConfirmationButton
//
//  Created by Daniel Tull on 08.08.2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCTConfirmationButton : UIButton

- (NSString *)confirmationTitleForState:(UIControlState)state;
- (void)setConfirmationTitle:(NSString *)title forState:(UIControlState)state;
- (UIColor *)confirmationTitleColorForState:(UIControlState)state;
- (void)setConfirmationTitleColor:(UIColor *)color forState:(UIControlState)state;

@property (nonatomic) UIColor *confirmationTintColor;

@property (nonatomic, getter=isLoading) BOOL loading;
@property (nonatomic) BOOL shouldConfirmAction;

@end
