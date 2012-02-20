//
//  MainViewController.m
//  ModalUIView
//
//  Created by Jake Foster on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()
-(void)_findAndResignFirstResponder;
@end

@implementation MainViewController

@synthesize tap = _tap;
@synthesize modalUIView = _modalUIView;
@synthesize modalValueTextField = _modalValueTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setModalValueTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (IBAction)onShowModalButton_TouchUpInside:(id)sender
{
    self.modalUIView = [[ModalUIView alloc] init];
    self.modalUIView.delegate = self;
    self.modalUIView.valueTextField.text = self.modalValueTextField.text; 
    [self.modalUIView showOnSuperview:self.view];
}

- (IBAction)onTextField_EditingDidBegin:(id)sender 
{
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_findAndResignFirstResponder)];
    [self.tap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:self.tap];
}

- (IBAction)onTextField_DidEndOnExit:(id)sender 
{
    [sender resignFirstResponder];
    
    [self.view removeGestureRecognizer:self.tap]; 
}

#pragma mark ModalUIViewDelegate methods
- (void)modalUIViewDidShow:(ModalUIView *)view onSuperView:(UIView *)superview
{
    // NOTE: Additional logic when modal is shown goes here.  JF
}

- (void)modalUIViewDidHide:(ModalUIView *)view
{
    // NOTE: Additional logic when modal is hidden goes here.  JF    
}

-(void)modalUIView:(ModalUIView *)view wasDismissed:(ModalUIViewDelegate_Dismissal)dismissal
{
    if(dismissal==ModalUIViewDelegate_Dismissal_Ok)
    {
        self.modalValueTextField.text = self.modalUIView.valueTextField.text;
    }
    [self.modalUIView hide];
    self.modalUIView = nil;
}

#pragma mark - Hidden Implementation
- (void)_findAndResignFirstResponder
{
    if (self.view.isFirstResponder) 
    {
        [self.view resignFirstResponder];
    }
    for (UIView *subView in self.view.subviews) 
    {
        if( subView.isFirstResponder )
        {
            [subView resignFirstResponder];
        }
    }
    
    [self.view removeGestureRecognizer:self.tap]; 
}
@end
