//
//  DenunciaCell.h
//  DenunciaMXIOS
//
//  Created by Carolina Franco on 07/10/14.
//  Copyright (c) 2014 Carolina Franco. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Denuncia;

@interface DenunciaCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblTitulo;
@property (weak, nonatomic) IBOutlet UILabel *lblDia;
@property (weak, nonatomic) IBOutlet UILabel *lblMes;
@property (weak, nonatomic) IBOutlet UILabel *lblAno;
@property (weak, nonatomic) IBOutlet UILabel *lblFolio;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UIImageView *imgNotificacion;

-(void)configurarCeldaConDenuncia:(Denuncia *)den;

@end
