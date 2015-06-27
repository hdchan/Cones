//
//  VendorSignUpViewController.m
//  Cones
//
//  Created by Alan Scarpa on 6/26/15.
//  Copyright (c) 2015 Henry Chan. All rights reserved.
//

#import "VendorSignUpViewController.h"
#import <Parse/Parse.h>

@interface VendorSignUpViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *truckNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation VendorSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.truckNameTextField.delegate = self;
    self.emailTextField.delegate = self;
    self.passwordTextField.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)signUpButtonClicked:(id)sender {
    
    
    PFUser *user = [PFUser user];
    user.username = self.emailTextField.text;
    user.password = self.passwordTextField.text;
    user.email = self.emailTextField.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {   // Hooray! Let them use the app now.
            
            PFObject *vendorInformation = [PFObject objectWithClassName:@"VendorInformation"];
            vendorInformation[@"truckName"] = self.truckNameTextField.text;
            vendorInformation[@"userId"] = user.objectId;
            [vendorInformation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                if (succeeded) {
                    [PFUser logInWithUsernameInBackground:self.emailTextField.text
                                                 password:self.passwordTextField.text
                                                    block:^(PFUser *user, NSError *error) {
                                                        if (user) {
                                                            // Do stuff after successful login.
                                                            NSLog(@"Logged in successfully!");
                                                            [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                                                            
                                                            [self dismissViewControllerAnimated:YES completion:nil];
                                                            
                                                        } else {
                                                            
                                                            NSLog(@"Error logging in after signup: %@", error);
                                                            
                                                        }
                                                    }];
                } else {
                    NSLog(@"Error saving vendor information:  %@", error);
                }
            }];
            
            
        } else {
            NSLog(@"Error when signing up:  %@", error);
            
        }
    }];

    
    
    
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
        [self signUpButtonClicked:nil];
    }
    return NO; // We do not want UITextField to insert line-breaks.
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
