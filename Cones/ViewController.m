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
@interface ViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSArray *locations;

@end
#define METERS_PER_MILE 1609.344
@implementation ViewController

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
- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //[self displayEiffelTower];
    
    
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 39.281516;
    zoomLocation.longitude= -76.580806;
    
    // 2
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    
    // 3
    [_mapView setRegion:viewRegion animated:YES];
}
@end
