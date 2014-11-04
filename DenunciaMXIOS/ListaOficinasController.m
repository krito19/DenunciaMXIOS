//
//  ListaOficinasController.m
//  DenunciaMXIOS
//
//  Created by Carolina Franco on 03/11/14.
//  Copyright (c) 2014 Carolina Franco. All rights reserved.
//

#import "ListaOficinasController.h"
#import "Oficina.h"
#import "OficinaCell.h"
#import "CFMAnnotation.h"
#import "OficinaController.h"

@interface ListaOficinasController ()

@end

@implementation ListaOficinasController

#pragma mark - Mapa Management


-(void)setPinsOnMap
{
    
    for (Oficina *of in self.oficinas)
    {
        CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(of.latitud,of.longuitud);
        CFMAnnotation *myPin = [[CFMAnnotation alloc] initWithCoordinate:coords andTitle:of.nombre];
        [self.mapa addAnnotation:myPin];
    }
    
    CLLocationCoordinate2D startCoord = CLLocationCoordinate2DMake(19.503765,-99.127714);
    MKCoordinateRegion adjustedRegion = [self.mapa regionThatFits:MKCoordinateRegionMakeWithDistance(startCoord, 2800, 1800)];
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
    CFMAnnotation *pin = (CFMAnnotation *)view.annotation;
    self.coordSelec = pin.coordinate;
    
    NSLog(@"Elegido:%f,%f",pin.coordinate.latitude,pin.coordinate.longitude);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirmación" message:@"¿Desea obtener indicaciones para llegar a esta oficina?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Si", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        MKPlacemark *place = [[MKPlacemark alloc] initWithCoordinate:self.coordSelec addressDictionary:nil];
        MKMapItem *dItem = [[MKMapItem alloc] initWithPlacemark:place];
        dItem.name = @"Oficina SFP";
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsDirectionsModeKey,nil];
        [MKMapItem openMapsWithItems:@[dItem] launchOptions:options];
        
    }
}


#pragma mark - Table Managment

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.oficinas.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OficinaCell *cell = [self.table dequeueReusableCellWithIdentifier:@"OficinaCell"];
    [cell configurarCon:[self.oficinas objectAtIndex:indexPath.row]];
    [cell setBackgroundColor:[UIColor clearColor]];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OficinaController *ofController = [self.storyboard instantiateViewControllerWithIdentifier:@"OficinaController"];
    [ofController setOficina:[self.oficinas objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:ofController animated:YES];
}

#pragma mark - IBActions

- (IBAction)denunciar:(id)sender
{
}

- (IBAction)irMenu:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Defaults

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    Oficina *o1 = [[Oficina alloc] init];
    o1.nombre = @"Oficina del C. Secretario";
    o1.direccion = @"INSURGENTES SUR 1700 CON GUADALUPE INN DELG. ALVARO OBREGON, DISTRITO FEDERAL";
    o1.telefono = @"TELEFONO: 01 800 55 12345678";
    o1.latitud = 19.500599;
    o1.longuitud = -99.116621;
    
    Oficina *o2 = [[Oficina alloc] init];
    o2.nombre = @"Subsecretaría de Control y Auditoría de la Gestión Pública";
    o2.direccion = @"INSURGENTES SUR 1800 CON GUADALUPE INN DELG. ALVARO OBREGON, DISTRITO FEDERAL";
    o2.telefono = @"TELEFONO: 01 800 55 09876543";
    o2.latitud = 19.505591;
    o2.longuitud = -99.126046;
    
    Oficina *o3 = [[Oficina alloc] init];
    o3.nombre = @"Subsecretaría de Responsabilidades Administrativas y Contrataciones Públicas";
    o3.direccion = @"INSURGENTES SUR 1900 CON GUADALUPE INN DELG. ALVARO OBREGON, DISTRITO FEDERAL";
    o3.telefono = @"TELEFONO: 01 800 55 14235467";
    o3.latitud = 19.509202;
    o3.longuitud = -99.128686;
    
    Oficina *o4 = [[Oficina alloc] init];
    o4.nombre = @"Subcrecretaría de la Función Pública";
    o4.direccion = @"INSURGENTES SUR 1300 CON GUADALUPE INN DELG. ALVARO OBREGON, DISTRITO FEDERAL";
    o4.telefono = @"TELEFONO: 01 800 55 07869646";
    o4.latitud = 19.500678;
    o4.longuitud = -99.128991;
    
    Oficina *o5 = [[Oficina alloc] init];
    o5.nombre = @"Oficialía Mayor";
    o5.direccion = @"INSURGENTES SUR 1500 CON GUADALUPE INN DELG. ALVARO OBREGON, DISTRITO FEDERAL";
    o5.telefono = @"TELEFONO: 01 800 55 17235892";
    o5.latitud = 19.493997;
    o5.longuitud = -99.132778;
    
    self.oficinas = @[o1,o2,o3,o4,o5];
    [self.table setDelegate:self];
    [self.table setDataSource:self];
    
    [self.table setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:.4]];
    [self.mapa setDelegate:self];
    [self setPinsOnMap];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
