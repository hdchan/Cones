//
//  ViewController.m
//  Cones
//
//  Created by Henry Chan on 6/19/15.
//  Copyright (c) 2015 Henry Chan. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "MyAnnotation.h"
#import <Parse/Parse.h>


@interface ViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSArray *locations;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentUserLocation;
@property (nonatomic) BOOL isLocationSet;

@end
#define METERS_PER_MILE 1609.344
@implementation ViewController



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.isLocationSet = NO;
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    
    
   
    

    
}

- (void) setMapView:(MKMapView *)mapView {
    _mapView = mapView;
    self.mapView.delegate = self;
}

- (void) updateMapViewAnnotations {
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:self.locations];
    [self.mapView showAnnotations:self.locations animated:YES];
    
}


// Wait for location callbacks
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{

    [self updateAndDisplayCurrentUserLocation];
    [self sendVendorLocation];
    [self updateAndDisplayVendorLocation];
  
}




-(void)updateAndDisplayCurrentUserLocation {
    
    self.currentUserLocation = [self.locationManager location];
    CLLocationCoordinate2D coordinate = [self.currentUserLocation coordinate];
    
    
    MyAnnotation *myLocation = [[MyAnnotation alloc] init];
    myLocation.longitude = coordinate.longitude;
    myLocation.latitude = coordinate.latitude;
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:@[myLocation]];
    
    if (!self.isLocationSet){
        [self.mapView showAnnotations:@[myLocation] animated:YES];
        self.isLocationSet = YES;
    }
    
}


-(void)sendVendorLocation {
    
    CLLocation *location = [self.locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    PFObject *vendorLocation = [PFObject objectWithClassName:@"VendorLocationHistory"];
    vendorLocation[@"geoPoint"] = [PFGeoPoint geoPointWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    
    [vendorLocation saveInBackground];
    
    
    
}


-(void)updateAndDisplayVendorLocation{
    
    
    PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:self.currentUserLocation.coordinate.latitude longitude:self.currentUserLocation.coordinate.longitude];
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"VendorLocationHistory"];
    
    // Create a PFQuery asking for all wall posts 100km of the user
    // We won't be showing all of the posts returned, 100km is our buffer
    [query whereKey:@"geoPoint" nearGeoPoint:point withinMiles:5];
    
    // Include the associated PFUser objects in the returned data
    // [query includeKey:PAWParsePostUserKey];
    
    // Limit the number of wall posts returned to 20
    query.limit = 20;
    [query orderByDescending:@"createdAt"];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        PFGeoPoint *location = [object objectForKey:@"geoPoint"];
        NSLog(@"\nLatitude: %f\nLongitude: %f", location.latitude, location.longitude);
        
        if (error){
            NSLog(@"There was an error:  %@", error);
        }
        
    }];
    
    //    NSArray *resultsArray = [query findObjects];
    //    NSLog(@"The most recent location is: %@", [resultsArray lastObject]);
    //
}


//-(void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    
//    CLLocationCoordinate2D zoomLocation;
//    
//    CLLocation *location = [self.locationManager location];
//    CLLocationCoordinate2D coordinate = [location coordinate];
//    
//    zoomLocation.latitude = coordinate.latitude;
//    zoomLocation.longitude= coordinate.longitude;
//    
//    
//    // 2
//    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
//    
//    // 3
//    //[_mapView setRegion:viewRegion animated:YES];
//    
//    
//}
@end
