//
//  VendorLoginViewController.m
//  Cones
//
//  Created by Henry Chan on 6/24/15.
//  Copyright (c) 2015 Henry Chan. All rights reserved.
//

#import "VendorLoginViewController.h"
#import <Parse/Parse.h>
#import "MBProgressHUD.h"

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

- (void) loginUser {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES]; // start progres hud
    hud.labelText = @"Logging In";
    
    
    [PFUser logInWithUsernameInBackground:self.emailTextField.text
                                 password:self.passwordTextFIeld.text
                                    block:^(PFUser *user, NSError *error) {
                                        
                                        [MBProgressHUD hideHUDForView:self.view animated:YES]; // stop progress hud
                                        
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


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    
    if (![[touch view] isKindOfClass:[UITextField class]]) {
        [self.view endEditing:YES];
    }
    [super touchesBegan:touches withEvent:event];
}

@end
