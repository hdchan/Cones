//
//  ViewController.m
//  Cones
//
//  Created by Henry Chan & Alan Scarpa on 6/19/15.
//  Copyright (c) 2015 Henry Chan & Alan Scarpa. All rights reserved.
//

#import "VendorViewController.h"
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import <CoreLocation/CoreLocation.h>


@interface VendorViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) BOOL currentVendorLocationSet;
@property (nonatomic, strong) PFObject *currentVendorLocationData;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) PFUser *currentUser;


@end

#define METERS_PER_MILE 1609.344

@implementation VendorViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.currentUser = [PFUser currentUser];
  
    if(!self.currentUser) {
        [self performSegueWithIdentifier:@"LoginUser" sender:self];
    }
    
    [PFSession getCurrentSessionInBackgroundWithBlock:^(PFSession *session, NSError *error){
    //  NSLog(@"This is the session: %@",session);
        [self setupVendorLocationData];
    
    }];
    
    // NSLog(@"%@",[PFSession getCurrentSessionInBackground]);
    
    /*if ([]){
     
    }
    
    [self setupVendorLocationData];*/
    
}

/*- (void) setCurrentUser:(PFUser *)currentUser {
    NSLog(@"%@",currentUser);
    if (!currentUser) {
        
        
        
        NSLog(@"User info %@",self.currentUser);
        
    }
    
    _currentUser = currentUser;
    
}*/

- (void) setupVendorLocationData {
    
    NSString *userId = self.currentUser.objectId;
    
    NSString *queryClassName = @"VendorLocation";
    
    PFQuery *query = [PFQuery queryWithClassName:queryClassName];
    
    [query whereKey:@"userId" equalTo:userId];
    
    
    // Retrieving user data here
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *vendorData, NSError *error){
        
        if (vendorData){ // If an entry exists
            
            self.currentVendorLocationData = vendorData; // Set our instance variable
            
            [self setupLocationUpdating];
            
            
        } else {
            
            if (error) {
                
                NSLog(@"Error getting object: %@", error); // create new object
                
            }
            
            // Other wise we'll set up a new object to contain our new user data
            self.currentVendorLocationData = [PFObject objectWithClassName:queryClassName];
            
            self.currentVendorLocationData[@"userId"] = userId;
            
            [self.currentVendorLocationData saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                if (succeeded) {
                    
                    [self setupLocationUpdating];
                    
                }
                
            }];
            
        }
        
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
}

#pragma mark 

- (void) setupLocationUpdating {
    
//    CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
//    
//    if (authorizationStatus == kCLAuthorizationStatusAuthorized ||
//        authorizationStatus == kCLAuthorizationStatusAuthorizedAlways ||
//        authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
    
        self.mapView.delegate = self; // Setting map view delegate
        
        self.mapView.showsUserLocation = YES;
        
        
        self.locationManager = [CLLocationManager new];
        
        self.locationManager.delegate = self;
    
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.locationManager requestAlwaysAuthorization];
        }
        
        [self.locationManager startUpdatingLocation];
        
//    }
    
    
}

-(void)sendVendorLocationToParse:(CLLocation*)vendorLocation {
    
    NSLog(@"%@: %f, %f", NSStringFromSelector(_cmd), vendorLocation.coordinate.latitude, vendorLocation.coordinate.longitude);
    
    self.currentVendorLocationData[@"geoPoint"] = [PFGeoPoint geoPointWithLatitude:vendorLocation.coordinate.latitude longitude:vendorLocation.coordinate.longitude];
    
    [self.currentVendorLocationData saveInBackground];
    
    
}

#pragma mark - MKMapViewDelegate methods

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)vendorLocation{
    
     NSLog(@"%@: %f, %f", NSStringFromSelector(_cmd), vendorLocation.coordinate.latitude, vendorLocation.coordinate.longitude);
    
    if (!self.currentVendorLocationSet) {
        
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(vendorLocation.location.coordinate, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
        
        [_mapView setRegion:viewRegion animated:YES];
        
        NSLog(@"Zooming into vendor's location");
        
        self.currentVendorLocationSet = YES;
    }
    
}

#pragma mark - CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    CLLocation *location = [locations lastObject];
    
    [self sendVendorLocationToParse:location];
    
}

@end
