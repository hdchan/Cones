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

@interface UserViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) MKUserLocation *currentUserLocation;

@end
#define METERS_PER_MILE 1609.344
@implementation UserViewController



- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.mapView.delegate = self;
    
    self.mapView.showsUserLocation = YES;
    
    
    
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    NSLog(@"%@: %f, %f", NSStringFromSelector(_cmd), userLocation.coordinate.latitude, userLocation.coordinate.longitude);
    
    if (!self.currentUserLocation) {
        
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
        
        [_mapView setRegion:viewRegion animated:YES];
        
        NSLog(@"Zooming into user's location");
        
    
    }
    
    self.currentUserLocation = userLocation;
    
    [self getVendorsAroundUserLocation:userLocation];
    
    
    
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
