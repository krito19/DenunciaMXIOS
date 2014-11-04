//
//  CFMAnnotation.m
//  DenunciaMXIOS
//
//  Created by Carolina Franco on 31/10/14.
//  Copyright (c) 2014 Carolina Franco. All rights reserved.
//

#import "CFMAnnotation.h"


@implementation CFMAnnotation

@synthesize coordinate;

- (NSString *)subtitle
{
    return nil;
}

-(NSString *)title
{
    if ([_name isKindOfClass:[NSNull class]])
        return @"Ubicación de los Hechos";
    else
        return _name;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D)coord andTitle:(NSString *)ti
{
    if ((self = [super init]))
    {
        _name = [ti copy];
        coordinate=coord;
    }
    return self;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D)coord
{
    coordinate=coord;
    return self;
}

-(CLLocationCoordinate2D)coord
{
    return coordinate;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    coordinate = newCoordinate;
}

@end
