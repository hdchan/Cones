//
//  Vendor.m
//  Cones
//
//  Created by Henry Chan on 6/23/15.
//  Copyright (c) 2015 Henry Chan. All rights reserved.
//

#import "Vendor.h"


@implementation Vendor

- (CLLocationCoordinate2D)coordinate {
    
    CLLocationCoordinate2D coordinates;
    
    coordinates.latitude = self.latitude;
    coordinates.longitude = self.longitude;
    
    return coordinates;
}

- (instancetype) initWithLongitude:(CLLocationDegrees) longitude latitude:(CLLocationDegrees) latitude {
    
    if (self = [super init]) {
        
        _latitude = latitude;
        _longitude = longitude;
    }
    
    return self;
    
}

@end
