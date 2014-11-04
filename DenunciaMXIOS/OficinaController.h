//
//  OficinaController.h
//  DenunciaMXIOS
//
//  Created by Carolina Franco on 03/11/14.
//  Copyright (c) 2014 Carolina Franco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Oficina.h"

@interface OficinaController : UIViewController <UIAlertViewDelegate,MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapa;
@property (weak, nonatomic) IBOutlet UILabel *lblNombre;
@property (weak, nonatomic) IBOutlet UILabel *lblDireccion;
@property (weak, nonatomic) IBOutlet UILabel *lblTelefono;

@property (nonatomic, strong) Oficina *oficina;

@end
