//
//  ViewController.m
//  Cones
//
//  Created by Henry Chan & Alan Scarpa on 6/19/15.
//  Copyright (c) 2015 Henry Chan & Alan Scarpa. All rights reserved.
//

#import "UserViewController.h"
#import <MapKit/MapKit.h>
#import "MyAnnotation.h"
#import <Parse/Parse.h>
#import "Vendor.h"

@interface UserViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) MKUserLocation *currentUserLocation;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end
#define METERS_PER_MILE 1609.344
@implementation UserViewController



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    
    // if pfuser exists, then it means the vendor is logged in
    // so either log him out automatically, or prompt to logout
    
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;

    CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
    
  //  NSLog(@"%i", authorizationStatus);
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) { // These permissions were added in iOS 8, so we need a check
        
        if (authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse || authorizationStatus == kCLAuthorizationStatusAuthorizedAlways){
            self.mapView.showsUserLocation = YES;
            
        } else {
            
            [self.locationManager requestWhenInUseAuthorization];
        }

    } else { // Anything prior to iOS 8 didn't not require a manual permissions check, it did it automatically
        self.mapView.showsUserLocation = YES;
    }
    
}

-(void)setupNavbar{
    
    
    
    // set back button font
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIFont fontWithName:@"Sofia Pro" size:16.0f], NSFontAttributeName,
                                                          nil] forState:UIControlStateNormal];
    
    // unhide navbar
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    
    // set navbar background color
 //   [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:255.0/255 green:227.0/255 blue:193.0/255 alpha:1]];
    
  
    
    // set title color and title font
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: [UIFont fontWithName:@"Sofia Pro" size:16.0]};
    
    // set title
    self.navigationItem.title = @"Nearby Ice Cream";

    

    //set back button arrow color
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self setupNavbar];
    
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        
    //    NSLog(@"Status changed %i", status);
        
        
        if (status == kCLAuthorizationStatusAuthorizedWhenInUse){
         //   NSLog(@"Authorized!");
            self.mapView.showsUserLocation = YES;
        } else {
            // send to setting or something
         //   NSLog(@"Not authorized!");
        }
    }
    
    
    
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    NSLog(@"%@: %f, %f", NSStringFromSelector(_cmd), userLocation.coordinate.latitude, userLocation.coordinate.longitude);
    
    if (!self.currentUserLocation) {
        
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
        
        [_mapView setRegion:viewRegion animated:YES];
    
    }
    
    self.currentUserLocation = userLocation;
    
    [self getVendorsAroundUserLocation:userLocation];
    
    
    
}

// if user scrolls to a new area, we need to show the ice cream trucks in that area.
-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    if (self.currentUserLocation){
        [self getVendorsAroundNewMapLocation:mapView.centerCoordinate];
    }
}



- (void) getVendorsAroundNewMapLocation:(CLLocationCoordinate2D)newMapCenterCoordinate {
    
    NSString *queryClassName = @"VendorLocation";
    
    PFQuery *query = [PFQuery queryWithClassName:queryClassName];
    
    CLLocation *newLocation = [[CLLocation alloc]initWithLatitude:newMapCenterCoordinate.latitude longitude:newMapCenterCoordinate.longitude];
    
    [query whereKey:@"geoPoint" nearGeoPoint:[PFGeoPoint geoPointWithLocation:newLocation] withinMiles:5.0];
    
    // Retrieving user data here
    [query findObjectsInBackgroundWithBlock:^(NSArray *vendors, NSError *error){
        
        [self updateMapWithVendors:vendors];
        
    }];
    
    
}

- (void) updateMapWithVendors: (NSArray*)vendorsArray {
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    for (PFObject *vendorData in vendorsArray) {
        
        PFGeoPoint *geoPoint = [vendorData objectForKey:@"geoPoint"];
        
        Vendor *vendorLocation = [[Vendor alloc] initWithLongitude:geoPoint.longitude latitude:geoPoint.latitude ];
        
        [self.mapView addAnnotation:vendorLocation];
        
    }
    
    //[self.mapView showAnnotations:self.mapView.annotations animated:NO];
    
    
    
}

-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]){
        
        return nil;
    }
   // NSLog(@"%@", annotation);
    
    MKAnnotationView *pinView = nil;

        static NSString *defaultPinID = @"com.cones";
        pinView = (MKAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
//    if ( pinView == nil ){
            pinView = [[MKAnnotationView alloc]
                       initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        
        //pinView.pinColor = MKPinAnnotationColorGreen;
        pinView.canShowCallout = NO;
        //pinView.animatesDrop = YES;
    
        pinView.image = [UIImage imageNamed:@"smallTruck"];
   // }
    return pinView;
}

- (void) getVendorsAroundUserLocation:(MKUserLocation*)userLocation {
    
    NSString *queryClassName = @"VendorLocation";
    
    PFQuery *query = [PFQuery queryWithClassName:queryClassName];
    
    CLLocation *userCoord = userLocation.location;
    
    [query whereKey:@"geoPoint" nearGeoPoint:[PFGeoPoint geoPointWithLocation:userCoord] withinMiles:5.0];
    
    
    // Retrieving user data here
    [query findObjectsInBackgroundWithBlock:^(NSArray *vendors, NSError *error){
        
        [self updateMapWithVendors:vendors];
        
    }];
    
    
}


@end
