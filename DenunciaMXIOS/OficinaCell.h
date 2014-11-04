//
//  OficinaCell.h
//  DenunciaMXIOS
//
//  Created by Carolina Franco on 03/11/14.
//  Copyright (c) 2014 Carolina Franco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Oficina.h"

@interface OficinaCell : UITableViewCell <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblNombre;
@property (weak, nonatomic) IBOutlet UILabel *lblDireccion;
@property (weak, nonatomic) IBOutlet UILabel *lblTelefono;

@property (nonatomic, strong) Oficina *oficina;

-(void)configurarCon:(Oficina *)oficina;

@end
