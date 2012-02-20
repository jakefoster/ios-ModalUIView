//
//  MainViewController.h
//  ModalUIView
//
//  Created by Jake Foster on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModalUIView.h"

@interface MainViewController : UIViewController <ModalUIViewDelegate>
{
    UITapGestureRecognizer *_tap;
    ModalUIView *_modalUIView; 
    
    UITextField *_modalValueTextField;
}

@property (strong, nonatomic) UITapGestureRecognizer *tap;
@property (nonatomic, strong) ModalUIView *modalUIView;

@property (strong, nonatomic) IBOutlet UITextField *modalValueTextField;

- (IBAction)onShowModalButton_TouchUpInside:(id)sender;
- (IBAction)onTextField_EditingDidBegin:(id)sender;
- (IBAction)onTextField_DidEndOnExit:(id)sender;

@end
