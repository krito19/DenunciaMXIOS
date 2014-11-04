//
//  UbicacionController.m
//  DenunciaMXIOS
//
//  Created by Carolina Franco on 02/10/14.
//  Copyright (c) 2014 Carolina Franco. All rights reserved.
//

#import "UbicacionController.h"
#import <QuartzCore/QuartzCore.h>
#import "WSManager.h"
#import "CFMAnnotation.h"

@interface UbicacionController ()

@end

@implementation UbicacionController

#pragma mark - Map Manage

- (MKAnnotationView *) mapView: (MKMapView *) mapView viewForAnnotation: (id<MKAnnotation>) annotation
{
    CFMAnnotation *myPin = (CFMAnnotation *)annotation;
    MKPinAnnotationView *pin = (MKPinAnnotationView *) [self.map dequeueReusableAnnotationViewWithIdentifier: @"myPin"];
    if (pin == nil)
    {
        pin = [[MKPinAnnotationView alloc] initWithAnnotation:myPin reuseIdentifier: @"myPin"];
    }
    else
    {
        pin.annotation = annotation;
    }
    
    pin.animatesDrop = YES;
    pin.draggable = YES;
    pin.pinColor = MKPinAnnotationColorGreen;
    
    return pin;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState
{
    if (newState == MKAnnotationViewDragStateEnding)
    {
        CLLocationCoordinate2D droppedAt = annotationView.annotation.coordinate;
        NSLog(@"Pin dropped at %f,%f", droppedAt.latitude, droppedAt.longitude);
        self.ubicacionSeleccionada = CGPointMake(droppedAt.latitude, droppedAt.longitude);
    }
}

#pragma mark - Location Manage

-(void)requestAuthorization
{
    if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [_locationManager requestWhenInUseAuthorization];
    }
    else
    {
        CLAuthorizationStatus aut = [CLLocationManager authorizationStatus];
        
        if (aut != 3)
        {
            [_locationManager startUpdatingLocation];
            [_locationManager performSelector:@selector(stopUpdatingLocation) withObject:nil afterDelay:1];
        }
    }
}


-(void)gotLocation
{
}

-(void)errorLocating
{
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    _actualLocation = [locations lastObject];
    if (_actualLocation == nil)
    {
        self.errorMessage = @"No se puede obtener ubicación";
        [self errorLocating];
    }
    else
    {
        if (_actualLocation.horizontalAccuracy < 70)
        {
            [_locationManager stopUpdatingLocation];
            CLLocationCoordinate2D startCoord = CLLocationCoordinate2DMake(_actualLocation.coordinate.latitude,_actualLocation.coordinate.longitude);
            MKCoordinateRegion adjustedRegion = [self.map regionThatFits:MKCoordinateRegionMakeWithDistance(startCoord, 700, 700)];
            [self.map setRegion:adjustedRegion animated:YES];
            CFMAnnotation *myPin = [[CFMAnnotation alloc] initWithCoordinate:startCoord];
            [self.map addAnnotation:myPin];
            
            if (self.principio == NO)
                self.ubicacionSeleccionada = CGPointMake(_actualLocation.coordinate.latitude, _actualLocation.coordinate.longitude);
            [_locationManager stopUpdatingLocation];
        }
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    self.errorMessage = [error localizedDescription];
    [_locationManager stopUpdatingLocation];
    [self errorLocating];
}


#pragma mark - IBActions

- (IBAction)ubicacionActual:(id)sender
{
    self.principio = NO;
    [self.fldDireccion resignFirstResponder];
    [_locationManager startUpdatingLocation];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    [self buscarDireccion:nil];
    return YES;
}

- (IBAction)buscarDireccion:(id)sender
{
    [self.fldDireccion resignFirstResponder];
    if (self.fldDireccion.text == nil || [self.fldDireccion.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Aviso" message:@"Se debe ingresar una direccion" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void)
    {
        dispatch_async(dispatch_get_main_queue(), ^(void)
        {
            [UIView animateWithDuration:.7
                             animations:^(void)
            {
                [self.viewLoading setAlpha:1.0];
            }
                             completion:nil];
        });
        
        NSDictionary *dic = [WSManager getCoordenateFromAddress:self.fldDireccion.text];
        BOOL suc = [[dic objectForKey:@"success"] boolValue];
        
        
        dispatch_async(dispatch_get_main_queue(), ^(void)
                       {
                           [UIView animateWithDuration:.7
                                            animations:^(void)
                            {
                                [self.viewLoading setAlpha:0.0];
                            }
                                            completion:nil];
                           
                           if (suc)
                           {
                               NSArray *ans = [self.map annotations];
                               [self.map removeAnnotations:ans];
                                   
                               CGPoint coord = [[dic objectForKey:@"coords"] CGPointValue];
                               CLLocationCoordinate2D startCoord = CLLocationCoordinate2DMake(coord.x,coord.y);
                               MKCoordinateRegion adjustedRegion = [self.map regionThatFits:MKCoordinateRegionMakeWithDistance(startCoord, 700, 700)];
                               [self.map setRegion:adjustedRegion animated:YES];
                               CFMAnnotation *myPin = [[CFMAnnotation alloc] initWithCoordinate:startCoord];
                               [self.map addAnnotation:myPin];
                               self.ubicacionSeleccionada = CGPointMake(startCoord.latitude, startCoord.longitude);
                           }
                       });
    });
}

-(void)setUbicacionLat:(double)lat yLong:(double)lon editable:(BOOL)editable
{
    if (lat != 0.0 || lon != 0.0)
    {
        NSArray *ans = [self.map annotations];
        [self.map removeAnnotations:ans];
        
        CLLocationCoordinate2D startCoord = CLLocationCoordinate2DMake(lat,lon);
        MKCoordinateRegion adjustedRegion = [self.map regionThatFits:MKCoordinateRegionMakeWithDistance(startCoord, 700, 700)];
        [self.map setRegion:adjustedRegion animated:YES];
        CFMAnnotation *myPin = [[CFMAnnotation alloc] initWithCoordinate:startCoord];
        [self.map addAnnotation:myPin];
        self.ubicacionSeleccionada = CGPointMake(startCoord.latitude, startCoord.longitude);
    }
    
    if (!editable)
    {
        [self.btnActual setEnabled:NO];
        [self.fldDireccion setEnabled:NO];
        [self.btnBuscar setEnabled:NO];
    }
}

#pragma mark - Defaults

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.fldDireccion setReturnKeyType:UIReturnKeySearch];
    
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager setDelegate:self];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [_locationManager setDistanceFilter:10];
    _actualLocation = nil;
    [self requestAuthorization];
    
    self.principio = YES;
    self.ubicacionSeleccionada = CGPointZero;
    
    [self.viewLoading setAlpha:0.0];
    [self.viewGeneral setBackgroundColor:[UIColor clearColor]];
    [self.lblTitulo setBackgroundColor:[UIColor colorWithRed:7.0/255.0 green:182.0/255.0 blue:144.0/255.0 alpha:0.4]];
    [self.btnActual setBackgroundColor:[UIColor colorWithRed:7.0/255.0 green:182.0/255.0 blue:144.0/255.0 alpha:0.4]];
    //[self.viewDireccion.layer setBorderColor:[UIColor colorWithRed:7.0/255.0 green:182.0/255.0 blue:144.0/255.0 alpha:1].CGColor];
    //[self.viewDireccion.layer setBorderWidth:1.0];
    
    //self.map.showsUserLocation = YES;
    [self.map setDelegate:self];
    [self.fldDireccion setDelegate:self];
    //[_locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
