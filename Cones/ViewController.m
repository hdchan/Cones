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


@interface ViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSArray *locations;
@property (strong, nonatomic) CLLocationManager *locationManager;


@end
#define METERS_PER_MILE 1609.344
@implementation ViewController



- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //[self displayEiffelTower];
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    
    
    // Display current location and zoom once.
    CLLocation *location = [self.locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    MyAnnotation *myLocation = [[MyAnnotation alloc] init];
    myLocation.longitude = coordinate.longitude;
    myLocation.latitude = coordinate.latitude;
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:@[myLocation]];
    [self.mapView showAnnotations:@[myLocation] animated:YES];
    
    
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
- (void)displayEiffelTower {
    MyAnnotation *eiffleTower = [[MyAnnotation alloc] init];
    eiffleTower.longitude = 2.294481;
    eiffleTower.latitude = 48.85837;
    
    
    
    self.locations = @[eiffleTower];
    
    [self updateMapViewAnnotations];
}


// Wait for location callbacks
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{

    NSLog(@"%@", [locations lastObject]);
    
    
    CLLocation *location = [self.locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    MyAnnotation *myLocation = [[MyAnnotation alloc] init];
    myLocation.longitude = coordinate.longitude;
    myLocation.latitude = coordinate.latitude;
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:@[myLocation]];
   // [self.mapView showAnnotations:@[myLocation] animated:YES];
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CLLocationCoordinate2D zoomLocation;
    
    CLLocation *location = [self.locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    zoomLocation.latitude = coordinate.latitude;
    zoomLocation.longitude= coordinate.longitude;
    
    
    // 2
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    
    // 3
    //[_mapView setRegion:viewRegion animated:YES];
    
    
}
@end
