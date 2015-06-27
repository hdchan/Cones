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
    [self.view sendSubviewToBack:self.backgroundImage];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
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
