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


@end

@implementation VendorLoginViewController

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
}

- (void) registerUser {
    
    PFUser *user = [PFUser user];
    user.username = self.emailTextField.text;
    user.password = self.passwordTextFIeld.text;
    user.email = self.emailTextField.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {   // Hooray! Let them use the app now.
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        } else {
            
            //NSString *errorString = [error userInfo][@"error"];   // Show the errorString somewhere and let the user try again.
        
        }
    }];
    
}

- (void) loginUser {
    
    [PFUser logInWithUsernameInBackground:self.emailTextField.text
                                 password:self.passwordTextFIeld.text
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            // Do stuff after successful login.
                                            
                                            [self dismissViewControllerAnimated:YES completion:nil];
                                            
                                        } else {
                                            
                                            [self registerUser];
                                            
                                        }
                                    }];
    
    
    
}

- (IBAction)loginTapped:(id)sender {
    
    [self loginUser];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField.accessibilityLabel isEqualToString:@"password"]) {
        
        [textField resignFirstResponder];
        
    } else {
        
        [self.passwordTextFIeld becomeFirstResponder];
        
    }
    
    return YES;
    
}

@end
