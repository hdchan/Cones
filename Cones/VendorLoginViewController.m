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
                                            
                                            [self.view endEditing:YES];
                                            
                                            [self dismissViewControllerAnimated:YES completion:nil];
                                            
                                        } else {
                                            
                                            NSLog(@"Error loggin in: %@", error);
                                            
                                            if ([UIAlertController class]) { // iOS 8 and up
                                                
                                                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Failed attempt"
                                                                                                               message:@"The email and password you entered don't match."
                                                                                                        preferredStyle:UIAlertControllerStyleAlert];
                                                
                                                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Try again" style:UIAlertActionStyleDefault
                                                                                                      handler:^(UIAlertAction * action) {}];
                                                
                                                [alert addAction:defaultAction];
                                                [self presentViewController:alert animated:YES completion:nil];
                                                
                                            } else { // deprecated for iOS 8
                                                
                                                UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Failed attempt"
                                                                                                 message:@"The email and password you entered don't match."
                                                                                                delegate:self
                                                                                       cancelButtonTitle:@"Try again"
                                                                                       otherButtonTitles: nil];
                                                
                                                [alert show];
                                                
                                            }
                          
                                            
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

@end
