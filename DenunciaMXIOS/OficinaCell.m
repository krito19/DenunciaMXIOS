//
//  OficinaCell.m
//  DenunciaMXIOS
//
//  Created by Carolina Franco on 03/11/14.
//  Copyright (c) 2014 Carolina Franco. All rights reserved.
//

#import "OficinaCell.h"
#import <MapKit/MapKit.h>

@implementation OficinaCell


#pragma mark - IBActions

- (IBAction)getDirecctions:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirmación" message:@"¿Desea obtener indicaciones para llegar a esta oficina?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Si", nil];
    [alert show];
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


- (IBAction)call:(id)sender
{
    NSArray *comp = [self.oficina.telefono componentsSeparatedByString:@":"];
    NSString *tel = [comp objectAtIndex:1];
    tel = [tel stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@",tel]]];
}

-(void)configurarCon:(Oficina *)oficina
{
    self.oficina = oficina;
    
    [self.lblNombre setText:self.oficina.nombre];
    [self.lblDireccion setText:self.oficina.direccion];
    [self.lblTelefono setText:self.oficina.telefono];
}

#pragma mark - Defaults

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];
    // Configure the view for the selected state
}

@end
