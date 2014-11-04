//
//  ListaOficinasController.h
//  DenunciaMXIOS
//
//  Created by Carolina Franco on 03/11/14.
//  Copyright (c) 2014 Carolina Franco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ListaOficinasController : UIViewController <UITableViewDataSource,UITableViewDelegate,MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnDenunciar;
@property (weak, nonatomic) IBOutlet MKMapView *mapa;
@property (weak, nonatomic) IBOutlet UITableView *table;

@property (nonatomic, strong) NSArray *oficinas;
@property (nonatomic, assign) CLLocationCoordinate2D coordSelec;

@end
