//
//  VendorSignUpViewController.m
//  Cones
//
//  Created by Alan Scarpa on 6/26/15.
//  Copyright (c) 2015 Henry Chan. All rights reserved.
//

#import "VendorSignUpViewController.h"
#import <Parse/Parse.h>
#import "MBProgressHUD.h"

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
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES]; // start progres hud
    hud.labelText = @"Signing Up";
    
    
    PFUser *user = [PFUser user];
    user.username = self.emailTextField.text;
    user.password = self.passwordTextField.text;
    user.email = self.emailTextField.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
            
        if (succeeded) {
            
            [PFUser logInWithUsernameInBackground:self.emailTextField.text
                                         password:self.passwordTextField.text
                                            block:^(PFUser *user, NSError *error) {
                                                
                                                [MBProgressHUD hideHUDForView:self.view animated:YES]; // stop progress hud
                                                
                                                if (user) {
                                                    // Do stuff after successful login.
                                                    NSLog(@"Logged in successfully!");
                                                    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                                                    
                                                    [self dismissViewControllerAnimated:YES completion:nil];
                                                    
                                                } else {
                                                    
                                                    NSLog(@"Error logging in after signup: %@", error);
                                                    
                                                    
                                                    
                                                }
                                                
                                            }];
            
        
            
            
            PFObject *vendorInformation = [PFObject objectWithClassName:@"VendorInformation"];
            vendorInformation[@"truckName"] = self.truckNameTextField.text;
            vendorInformation[@"userId"] = user.objectId;
            [vendorInformation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                NSLog(@"Error saving vendor information:  %@", error);
            }];

            
        } else {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES]; // stop progress hud
            
            NSLog(@"Error signing up: %@", error);
            NSLog(@"%ld",(long)error.code); // maybe we can detect the code to be specific about the error
            
            if ([UIAlertController class]) { // iOS 8 and up
                
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Failed attempt"
                                                                               message:@"The email or password you entered are not valid."
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Try again" style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action) {}];
                
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
                
            } else { // deprecated for iOS 8
                
                UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Failed attempt"
                                                                 message:@"The email or password you entered are not valid."
                                                                delegate:self
                                                       cancelButtonTitle:@"Try again"
                                                       otherButtonTitles: nil];
                
                [alert show];
                
            }

            
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


- (IBAction)cancelButtonPressed:(id)sender {
    
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
