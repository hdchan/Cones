//
//  Vendor.h
//  Cones
//
//  Created by Henry Chan on 6/23/15.
//  Copyright (c) 2015 Henry Chan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <MapKit/MapKit.h>

@interface Vendor : NSObject <MKAnnotation>

@property (nonatomic) double longitude;
@property (nonatomic) double latitude;

- (instancetype) initWithLongitude:(CLLocationDegrees) longitude latitude:(CLLocationDegrees) latitude;

@end
