//
//  ModalUIView.h
//  ModalUIView
//
//  Created by Jake Foster on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ModalUIView;

typedef enum {
    ModalUIViewDelegate_Dismissal_Ok,
    ModalUIViewDelegate_Dismissal_Cancel
} ModalUIViewDelegate_Dismissal;

@protocol ModalUIViewDelegate <NSObject>
@optional
- (void)modalUIViewDidShow:(ModalUIView *)view onSuperView:(UIView *)superview;
- (void)modalUIViewDidHide:(ModalUIView *)view;
- (void)modalUIView:(ModalUIView *)view wasDismissed:(ModalUIViewDelegate_Dismissal) dismissal;
@end


@interface ModalUIView : UIView
{
    UITapGestureRecognizer *_tap;

    UIView *_maskView;
    UIView *_modalView;
    BOOL _isVisible;    

    id <ModalUIViewDelegate> _delegate;
    UITextField *_valueTextField;
}

@property (strong, nonatomic) UITapGestureRecognizer *tap;

@property (nonatomic, retain) UIView *maskView;
@property (nonatomic, retain) UIView *modalView;
@property (nonatomic) BOOL isVisible;

@property (nonatomic, strong) IBOutlet id<ModalUIViewDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITextField *valueTextField;

-(void)showOnSuperview:(UIView *)superview;
-(void)hide;

- (IBAction)onCancelButton_TouchUpInside:(id)sender;
- (IBAction)onOkBUtton_TouchUpInside:(id)sender;

- (IBAction)onTextField_EditingDidBegin:(id)sender;
- (IBAction)onTextField_DidEndOnExit:(id)sender;

@end
