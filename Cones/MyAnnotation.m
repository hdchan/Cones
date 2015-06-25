//
//  MyAnnotation.m
//  Cones
//
//  Created by Henry Chan on 6/20/15.
//  Copyright (c) 2015 Henry Chan. All rights reserved.
//

#import "MyAnnotation.h"

@implementation MyAnnotation

- (CLLocationCoordinate2D)coordinate {
    
    CLLocationCoordinate2D coordinates;
    
    coordinates.latitude = self.latitude;
    coordinates.longitude = self.longitude;
    
    return coordinates;
}

-(instancetype)init{
    self = [super init];
    if (self){
      _title = @"Ice Cream Truck";
    }
    return self;
}



@end
