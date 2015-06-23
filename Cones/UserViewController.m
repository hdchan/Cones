//
//  ViewController.m
//  Cones
//
//  Created by Henry Chan on 6/19/15.
//  Copyright (c) 2015 Henry Chan. All rights reserved.
//

#import "UserViewController.h"
#import <MapKit/MapKit.h>
#import "MyAnnotation.h"
#import <Parse/Parse.h>


@interface UserViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSArray *locations;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentUserLocation;
@property (nonatomic) BOOL isLocationSet;
@property (nonatomic, strong) NSString *objectID;

@end
#define METERS_PER_MILE 1609.344
@implementation UserViewController



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.isLocationSet = NO;
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    
    //Show user location with that cool, blue dot.
    [self.mapView setShowsUserLocation:YES];
    
   
    

    
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

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    if (!self.isLocationSet){

    CLLocationCoordinate2D zoomLocation;
    
    CLLocation *location = userLocation.location;
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    zoomLocation.latitude = coordinate.latitude;
    zoomLocation.longitude= coordinate.longitude;
    
    
    // 2
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    
    // 3
    [_mapView setRegion:viewRegion animated:YES];
        
    self.isLocationSet = YES;
        
    }
    
}


// Wait for location callbacks
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{

   // [self updateAndDisplayCurrentUserLocation];
    [self sendVendorLocation];
}



//Unused, but has some good methods and ideas.
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
    
    CLLocation *location = [self.mapView userLocation].location;
    
    if (!location){
        NSLog(@"Location is nil.  Do not send to Parse.");
        return;
    }
    
    
    CLLocationCoordinate2D coordinate = [location coordinate];
 
    
    PFQuery *query = [PFQuery queryWithClassName:@"VendorLocationHistory"];
    [query whereKey:@"vendorName" equalTo:@"AlansTruck"];

    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
        if (error){
            NSLog(@"Error upsert: %@", error);
        }
        
        
        if (!object){
            NSLog(@"OBJECT WAS NIL! Let's make a new one!");
            PFObject *vendorLocation = [PFObject objectWithClassName:@"VendorLocationHistory"];
            vendorLocation[@"vendorName"] = @"AlansTruck";
            vendorLocation[@"geoPoint"] = [PFGeoPoint geoPointWithLatitude:coordinate.latitude longitude:coordinate.longitude];
            [vendorLocation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
             {
                 NSLog(@"The save attempt was: %i", succeeded);
                 if (error){
                     NSLog(@"Error saving: %@", error);
                 } else {
                    // self.objectID = [vendorLocation objectId];
                    [self updateAndDisplayVendorLocation];
                     NSLog(@"Saved location to Parse successfully!");
                 }
                 
             }];

        } else {
            object[@"geoPoint"] = [PFGeoPoint geoPointWithLatitude:coordinate.latitude longitude:coordinate.longitude];
            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
            {
                NSLog(@"The save attempt was: %i", succeeded);
                if (error){
                    NSLog(@"Error saving: %@", error);
                } else {
                    [self updateAndDisplayVendorLocation];
                     NSLog(@"Saved location to Parse successfully!");
                }
            }];
           

        }
        
       
    
    }];
    
    
    
    
   

    
    
}


-(void)updateAndDisplayVendorLocation{
    
    CLLocation *location = [self.mapView userLocation].location;

    
    if (!location){
        NSLog(@"Location is nil.  Do not update.");
        return;
    }
    
    PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    PFQuery *query = [PFQuery queryWithClassName:@"VendorLocationHistory"];
    
    
    // Include the associated PFUser objects in the returned data
    // [query includeKey:@"vendorName"];
    
    [query whereKey:@"vendorName" equalTo:@"AlansTruck"];
    // Limit the number of wall posts returned to 20
    //query.limit = 20;
    
   // [query orderByAscending:@"createdAt"];
   // [query whereKey:@"geoPoint" nearGeoPoint:point withinMiles:2];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        if (error){
            NSLog(@"There was an error:  %@", error);
        } else {
            PFGeoPoint *location = [object objectForKey:@"geoPoint"];
            NSLog(@"\nLatitude: %f\nLongitude: %f", location.latitude, location.longitude);
        }
        
        
        
        
    }];
    
    //    NSArray *resultsArray = [query findObjects];
    //    NSLog(@"The most recent location is: %@", [resultsArray lastObject]);
    //
}

//
//-(void)viewWillAppear:(BOOL)animated {
//    
//    [super viewWillAppear:animated];
//    
//    CLLocationCoordinate2D zoomLocation;
//    
//    CLLocation *location = [self.mapView userLocation].location;
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