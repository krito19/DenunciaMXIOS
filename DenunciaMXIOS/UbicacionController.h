//
//  UbicacionController.h
//  DenunciaMXIOS
//
//  Created by Carolina Franco on 02/10/14.
//  Copyright (c) 2014 Carolina Franco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface UbicacionController : UIViewController <MKMapViewDelegate,UITextFieldDelegate,CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
    CLLocation *_actualLocation;
}

@property (weak, nonatomic) IBOutlet UIView *viewGeneral;
@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (weak, nonatomic) IBOutlet UIButton *btnActual;
@property (weak, nonatomic) IBOutlet UITextField *fldDireccion;
@property (weak, nonatomic) IBOutlet UILabel *lblTitulo;
@property (weak, nonatomic) IBOutlet UIView *viewDireccion;
@property (weak, nonatomic) IBOutlet UIView *viewLoading;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loader;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnBuscar;

@property (nonatomic, strong) NSString *urlDenuncia;
@property (nonatomic, strong) NSString *errorMessage;
@property (nonatomic, assign) CGPoint ubicacionSeleccionada;
@property (nonatomic, assign) BOOL principio;
@property (nonatomic, assign) BOOL fromDenuncias;

-(void)setUbicacionLat:(double)lat yLong:(double)lon;
-(void)setUbicacionLat:(double)lat yLong:(double)lon editable:(BOOL)editable;

@end
