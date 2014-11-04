//
//  EmergenciasController.h
//  DenunciaMXIOS
//
//  Created by Carolina Franco on 07/10/14.
//  Copyright (c) 2014 Carolina Franco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmergenciasController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lblDireccion;

@property (nonatomic, strong) NSArray *telefonos;
@property (weak, nonatomic) IBOutlet UILabel *lblTitulo;

@end
