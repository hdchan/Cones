//
//  VendorLoginViewController.m
//  Cones
//
//  Created by Henry Chan on 6/24/15.
//  Copyright (c) 2015 Henry Chan. All rights reserved.
//

#import "VendorLoginViewController.h"
#import <Parse/Parse.h>
@interface VendorLoginViewController() <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextFIeld;
@property (nonatomic, strong) UINavigationController *navController;

@end

@implementation VendorLoginViewController

-(void)viewDidLoad {
    
    [super viewDidLoad];
    self.emailTextField.delegate = self;
    self.passwordTextFIeld.delegate = self;
   
}

//- (void) registerUser {
//   
//        
//    
//    PFUser *user = [PFUser user];
//    user.username = self.emailTextField.text;
//    user.password = self.passwordTextFIeld.text;
//    user.email = self.emailTextField.text;
//    
//    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (!error) {   // Hooray! Let them use the app now.
//            
//            [self dismissViewControllerAnimated:YES completion:nil];
//            
//        } else {
//            
//            //NSString *errorString = [error userInfo][@"error"];   // Show the errorString somewhere and let the user try again.
//        
//        }
//    }];
//  
//}

- (void) loginUser {
    
    [PFUser logInWithUsernameInBackground:self.emailTextField.text
                                 password:self.passwordTextFIeld.text
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            // Do stuff after successful login.
                                            
                                            [self dismissViewControllerAnimated:YES completion:nil];
                                            
                                        } else {
                                            
                                            NSLog(@"Error loggin in: %@", error);
                                            
                                        }
                                    }];
    
    
    
}

- (IBAction)loginTapped:(id)sender {
    
    [self loginUser];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
         [self loginUser];
    }
    return NO; // We do not want UITextField to insert line-breaks.
    
}

- (IBAction)cancelButtonTouched:(id)sender {
    self.navController = (UINavigationController*)self.presentingViewController;
    [self.navController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    
    if (![[touch view] isKindOfClass:[UITextField class]]) {
        [self.view endEditing:YES];
    }
    [super touchesBegan:touches withEvent:event];
}

@end
