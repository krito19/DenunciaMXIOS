//
//  CFMAnnotation.h
//  DenunciaMXIOS
//
//  Created by Carolina Franco on 31/10/14.
//  Copyright (c) 2014 Carolina Franco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CFMAnnotation : NSObject <MKAnnotation>
{
    CLLocationCoordinate2D coordinate;
    NSString *_name;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D)coord andTitle:(NSString *)ti;
- (id)initWithCoordinate:(CLLocationCoordinate2D)coord;
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

- (NSString *)title;

@end
