//
//  OficinaController.m
//  DenunciaMXIOS
//
//  Created by Carolina Franco on 03/11/14.
//  Copyright (c) 2014 Carolina Franco. All rights reserved.
//

#import "OficinaController.h"
#import "CFMAnnotation.h"

@interface OficinaController ()

@end

@implementation OficinaController

#pragma mark - Mapa Management


-(void)setPinsOnMap
{
    CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(self.oficina.latitud,self.oficina.longuitud);
    CFMAnnotation *myPin = [[CFMAnnotation alloc] initWithCoordinate:coords andTitle:self.oficina.nombre];
    [self.mapa addAnnotation:myPin];
    
    MKCoordinateRegion adjustedRegion = [self.mapa regionThatFits:MKCoordinateRegionMakeWithDistance(coords, 500, 500)];
    [self.mapa setRegion:adjustedRegion animated:YES];
}

- (MKAnnotationView *) mapView: (MKMapView *) mapView viewForAnnotation: (id<MKAnnotation>) annotation
{
    CFMAnnotation *myPin = (CFMAnnotation *)annotation;
    MKAnnotationView *pin = (MKPinAnnotationView *) [self.mapa dequeueReusableAnnotationViewWithIdentifier: @"myPin"];
    if (pin == nil)
    {
        pin = [[MKAnnotationView alloc] initWithAnnotation:myPin reuseIdentifier: @"myPin"];
    }
    else
    {
        pin.annotation = annotation;
    }
    
    pin.canShowCallout = YES;
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    pin.draggable = NO;
    
    
    UIImage *image = [UIImage imageNamed:@"BotonPin.png"];
    pin.image = image;
    
    CGRect frame = pin.frame;
    frame.size = CGSizeMake(40, 40);
    [pin setFrame:frame];
    
    return pin;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirmación" message:@"¿Desea obtener indicaciones para llegar a esta oficina?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Si", nil];
    [alert show];
}


#pragma mark - IBActions

- (IBAction)atrasç:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)mostrarIndicaicones:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirmación" message:@"¿Desea obtener indicaciones para llegar a esta oficina?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Si", nil];
    [alert show];
}

- (IBAction)llamar:(id)sender
{
    NSArray *comp = [self.oficina.telefono componentsSeparatedByString:@":"];
    NSString *tel = [comp objectAtIndex:1];
    tel = [tel stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@",tel]]];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        CLLocationCoordinate2D coordSelec = CLLocationCoordinate2DMake(self.oficina.latitud, self.oficina.longuitud);
        MKPlacemark *place = [[MKPlacemark alloc] initWithCoordinate:coordSelec addressDictionary:nil];
        MKMapItem *dItem = [[MKMapItem alloc] initWithPlacemark:place];
        dItem.name = self.oficina.nombre;
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsDirectionsModeKey,nil];
        [MKMapItem openMapsWithItems:@[dItem] launchOptions:options];
        
    }
}

#pragma mark - Defaults

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.lblNombre setText:self.oficina.nombre];
    [self.lblDireccion setText:self.oficina.direccion];
    [self.lblTelefono setText:self.oficina.telefono];
    
    [self.mapa setDelegate:self];
    [self setPinsOnMap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
