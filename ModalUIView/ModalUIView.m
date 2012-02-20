//
//  ModalUIView.m
//  ModalUIView
//
//  Created by Jake Foster on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ModalUIView.h"

@interface ModalUIView ()
-(void)_findAndResignFirstResponder;
- (void)_findAndResignFirstResponder:(UIView *)view;
@end

@implementation ModalUIView

@synthesize tap = _tap;

@synthesize maskView = _maskView;
@synthesize modalView = _modalView;
@synthesize delegate = _delegate;
@synthesize isVisible = _isVisible;
@synthesize valueTextField = _valueTextField;

- (id)init
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGRect frame = CGRectMake(0, 0, screenSize.width, screenSize.height);
    self = [super initWithFrame:frame];
    if (self) 
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ModalUIView" owner:self options:nil];
        
        self.isVisible = NO;
        
        for(id item in nib) 
        {
            if ([item isKindOfClass:[UIView class]])
            {
                if( ((UIView *)item).tag == 1 )
                {
                    // NOTE: MaskView is tag #1
                    self.maskView = (UIView *)item;
                }
                else if( ((UIView *)item).tag == 2 )
                {
                    // NOTE: ModalView is tag #2
                    self.modalView = (UIView *)item;
                }
                
            }
        }
        
        if( self.modalView && self.maskView )
        {
            CGPoint maskCenter = CGPointMake(screenSize.width / 2, screenSize.height + (self.maskView.frame.size.height / 2));
            self.maskView.center = maskCenter;
            self.maskView.alpha = 0;
            [self addSubview:self.maskView];
            
            CGPoint modalCenter = CGPointMake(screenSize.width / 2, screenSize.height + (self.modalView.frame.size.height / 2));
            self.modalView.center = modalCenter;
            [self addSubview:self.modalView];
        }
    }
    return self;
}

-(void)showOnSuperview:(UIView *)superview
{
    if( !self.isVisible )
    {
        // NOTE: If the caller wants this modal only over the immediate
        //  portion of its window then it can pass itself in (or, if it's
        //  a ViewController, it's .view) but if it wants the modal over
        //  the *entire* screen it can pass it's .window.  For example,
        //  if the caller is a ViewController and wants the modal over
        //  just it's view it would call:
        //      [myModal showOnSuperview:self.view];
        //  But if the caller wants the modal over the entire window it
        //  would instead call:
        //      [myModal showOnSuperview:self.view.window];        
        [superview addSubview:self];   
        
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        
        CGPoint maskCenter = CGPointMake(screenSize.width / 2, screenSize.height / 2);
        self.maskView.center = maskCenter;
        
        CGPoint modalCenter = CGPointMake(screenSize.width / 2, screenSize.height / 3);
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        self.maskView.alpha = 0.5;
        self.modalView.center = modalCenter;
        [UIView commitAnimations];
        
        self.isVisible = YES;
        
        if([self.delegate respondsToSelector:@selector(modalUIViewDidShow:onSuperView:)]) 
        {
            [self.delegate modalUIViewDidShow:self onSuperView:superview];
        }
    }
}

-(void)hide
{
    if( self.isVisible )
    {
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.75];
        self.maskView.alpha = 0.0;
        CGPoint modalCenter = CGPointMake(screenSize.width / 2, screenSize.height + (self.modalView.frame.size.height / 2));
        self.modalView.center = modalCenter;
        [UIView commitAnimations];
        
        [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.75f];

        self.isVisible = NO;
        
        if([self.delegate respondsToSelector:@selector(modalUIViewDidHide:)]) 
        {
            [self.delegate modalUIViewDidHide:self];
        }
    }
}

- (IBAction)onTextField_EditingDidBegin:(id)sender 
{
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_findAndResignFirstResponder)];
    [self.tap setCancelsTouchesInView:NO];
    [self addGestureRecognizer:self.tap];
}

- (IBAction)onTextField_DidEndOnExit:(id)sender 
{
    [sender resignFirstResponder];
    
    [self removeGestureRecognizer:self.tap]; 
}

- (IBAction)onCancelButton_TouchUpInside:(id)sender 
{
    if([self.delegate respondsToSelector:@selector(modalUIView:wasDismissed:)]) 
    {
        [self.delegate modalUIView:self wasDismissed:ModalUIViewDelegate_Dismissal_Cancel];
    }
    // NOTE: Optionally it can hide itself.  JF
    //[self hide];
}

- (IBAction)onOkBUtton_TouchUpInside:(id)sender 
{
    if([self.delegate respondsToSelector:@selector(modalUIView:wasDismissed:)]) 
    {
        [self.delegate modalUIView:self wasDismissed:ModalUIViewDelegate_Dismissal_Ok];
    }
    // NOTE: Optionally it can hide itself.  JF
    //[self hide];
}

#pragma mark - Hidden Implementation
- (void)_findAndResignFirstResponder
{
    [self _findAndResignFirstResponder:self];
    /*
    if (self.isFirstResponder) 
    {
        [self resignFirstResponder];
    }
    for (UIView *subView in self.subviews) 
    {
        if( subView.isFirstResponder )
        {
            [subView resignFirstResponder];
        }
    }
    
    [self removeGestureRecognizer:self.tap];
    */
}

- (void)_findAndResignFirstResponder:(UIView *)view
{
    if (view.isFirstResponder) 
    {
        [view resignFirstResponder];
        [self removeGestureRecognizer:self.tap]; 
    }
    for (UIView *subView in view.subviews) 
    {
        [self _findAndResignFirstResponder:subView];
    }
}
@end
