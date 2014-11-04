//
//  EnviadoController.h
//  DenunciaMXIOS
//
//  Created by Carolina Franco on 02/10/14.
//  Copyright (c) 2014 Carolina Franco. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Denuncia;

@interface EnviadoController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *viewGeneral;
@property (weak, nonatomic) IBOutlet UIView *viewEnviando;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loader;
@property (weak, nonatomic) IBOutlet UILabel *lblFolio;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;

-(void)enviarDenuncia:(Denuncia *)denuncia withHandle:(void(^)(void))someBlock;

-(void)setEnviado:(NSString *)folio;

@end
