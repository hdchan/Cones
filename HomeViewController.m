//
//  HomeViewController.m
//  Cones
//
//  Created by Alan Scarpa on 6/26/15.
//  Copyright (c) 2015 Henry Chan. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *userButton;
@property (weak, nonatomic) IBOutlet UIButton *vendorButton;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    
        
    [self setupButtons];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}


-(void)setupButtons {
    self.userButton.layer.cornerRadius = 8;
    self.vendorButton.layer.cornerRadius = 15;

}

@end
