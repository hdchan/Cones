//
//  MyAnnotation.h
//  Cones
//
//  Created by Henry Chan on 6/20/15.
//  Copyright (c) 2015 Henry Chan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyAnnotation : NSObject<MKAnnotation> {
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic) double longitude;
@property (nonatomic) double latitude;
// add an init method so you can set the coordinate property on startup

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;
@end