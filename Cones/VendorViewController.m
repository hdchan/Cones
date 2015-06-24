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
@property (nonatomic, strong) PFObject *currentVendorLocationParseData;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

#define METERS_PER_MILE 1609.344

@implementation VendorViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSString *vendorName = @"HenrysTruck";
    
    NSString *queryClassName = @"VendorLocationHistory";
    
    PFQuery *query = [PFQuery queryWithClassName:queryClassName];
    
    [query whereKey:@"vendorName" equalTo:vendorName];
    
    
    // Retrieving user data here
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *vendorData, NSError *error){
        
        if (vendorData){ // If an entry exists
            
            self.currentVendorLocationParseData = vendorData; // Set our instance variable
            
            [self startUpdatingLocation];
            
            
        } else {
            
            if (error) {
                
                NSLog(@"Error getting object: %@", error); // create new object
                
            }
            
            // Other wise we'll set up a new object to contain our new user data
            self.currentVendorLocationParseData = [PFObject objectWithClassName:queryClassName];
            
            self.currentVendorLocationParseData[@"vendorName"] = vendorName;
            
            [self.currentVendorLocationParseData saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                if (succeeded) {
                    
                    [self startUpdatingLocation];
                    
                }
                 
            }];
            
        }

    }];
    
}

- (void) fetchVendorLocationData {
    
}

#pragma mark 

- (void) startUpdatingLocation {
    
//    CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
//    
//    if (authorizationStatus == kCLAuthorizationStatusAuthorized ||
//        authorizationStatus == kCLAuthorizationStatusAuthorizedAlways ||
//        authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
    
        self.mapView.delegate = self; // Setting map view delegate
        
        self.mapView.showsUserLocation = YES;
        
        
        self.locationManager = [CLLocationManager new];
        
        self.locationManager.delegate = self;
        
        [self.locationManager startUpdatingLocation];
        
//    }
    
    
}

-(void)sendVendorLocationToParse:(CLLocation*)vendorLocation {
    
    NSLog(@"%@: %f, %f", NSStringFromSelector(_cmd), vendorLocation.coordinate.latitude, vendorLocation.coordinate.longitude);
    
    self.currentVendorLocationParseData[@"geoPoint"] = [PFGeoPoint geoPointWithLatitude:vendorLocation.coordinate.latitude longitude:vendorLocation.coordinate.longitude];
    
    [self.currentVendorLocationParseData saveInBackground];
    
    
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
