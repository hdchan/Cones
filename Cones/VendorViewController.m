//
//  ViewController.m
//  Cones
//
//  Created by Henry Chan & Alan Scarpa on 6/19/15.
//  Copyright (c) 2015 Henry Chan & Alan Scarpa. All rights reserved.
//

#import "VendorViewController.h"
#import <MapKit/MapKit.h>
#import "MyAnnotation.h"
#import <Parse/Parse.h>


@interface VendorViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) BOOL isLocationSet;

@end
#define METERS_PER_MILE 1609.344
@implementation VendorViewController



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupLocationManager];
    
    //Show user location with that cool, blue dot.
    [self.mapView setShowsUserLocation:YES];
    
    
}




-(void)setupLocationManager {
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.isLocationSet = NO;
    
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    
}

- (void) setMapView:(MKMapView *)mapView {
    _mapView = mapView;
    self.mapView.delegate = self;
}


-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    // Zooms in on user location only the first time it receives the user location
    if (!self.isLocationSet){
        // 1
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







// Wait for CLLocationManager callbacks then send vendor location
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self sendVendorLocationToParse:locations];
}







-(void)sendVendorLocationToParse:(NSArray*)locations {
    
    // Usually just one location in this locations array, but if it gets
    // multiple locations quickly, the lastObject is the most recent.
    CLLocation *location = [locations lastObject];
    
    if (!location){
        NSLog(@"Location is nil.  Do not send to Parse.");
        return;
    }
    
    
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    PFQuery *query = [PFQuery queryWithClassName:@"VendorLocationHistory"];
    
    // *********** Change all AlansTruck strings to a property ***************
    [query whereKey:@"vendorName" equalTo:@"AlansTruck"];
    // *********** Change all AlansTruck strings to a property ***************
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
        if (error){
            NSLog(@"Error getting object: %@", error);
        }
        
        if (!object){
            PFObject *vendorLocation = [PFObject objectWithClassName:@"VendorLocationHistory"];
            vendorLocation[@"vendorName"] = @"AlansTruck";
            vendorLocation[@"geoPoint"] = [PFGeoPoint geoPointWithLatitude:coordinate.latitude longitude:coordinate.longitude];
            [vendorLocation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
             {
                 if (error){
                     NSLog(@"Error saving: %@", error);
                 } else {
                     [self updateAndDisplayVendorLocation:location];
                     NSLog(@"Saved location to Parse successfully!");
                 }
             }];
        } else {
            object[@"geoPoint"] = [PFGeoPoint geoPointWithLatitude:coordinate.latitude longitude:coordinate.longitude];
            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
             {
                 if (error){
                     NSLog(@"Error saving: %@", error);
                 } else {
                     [self updateAndDisplayVendorLocation:location];
                     NSLog(@"Updated location on Parse successfully!");
                 }
             }];
        }
    }];
}







-(void)updateAndDisplayVendorLocation:(CLLocation*)location{
    
    
    if (!location){
        NSLog(@"Location is nil.  Do not update.");
        return;
    }
    
    PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    PFQuery *query = [PFQuery queryWithClassName:@"VendorLocationHistory"];
    
    
    // Include the associated PFUser objects in the returned data
    // [query includeKey:@"vendorName"];
    
    // *********** Change all AlansTruck strings to a property ***************
    [query whereKey:@"vendorName" equalTo:@"AlansTruck"];
    // *********** Change all AlansTruck strings to a property ***************

    // Limit the number of objects returned to 20
    //query.limit = 20;
    
    // 3.21869 kM = 2 Miles
    [query whereKey:@"geoPoint" nearGeoPoint:point withinKilometers:3.21869];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        if (error){
            NSLog(@"There was an error:  %@", error);
        } else {
            // *********** Plot this location on map via annotation ***************
            PFGeoPoint *location = [object objectForKey:@"geoPoint"];
            // *********** Plot this location on map via annotation ***************
            NSLog(@"\nLatitude: %f\nLongitude: %f", location.latitude, location.longitude);

        }
        
    }];
}


@end
