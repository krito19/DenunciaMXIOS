//
//  PerfilController.h
//  DenunciaMXIOS
//
//  Created by Carolina Franco on 01/11/14.
//  Copyright (c) 2014 Carolina Franco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "Usuario.h"
#import "DenunciarController.h"

@interface PerfilController : UIViewController<UITextViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewLoading;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loaer;
@property (weak, nonatomic) IBOutlet UILabel *lblTitulo;
@property (weak, nonatomic) IBOutlet UIButton *btnDenunciar;
@property (weak, nonatomic) IBOutlet UIButton *btnMenu;
@property (weak, nonatomic) IBOutlet UIButton *btnRegistrar;
@property (weak, nonatomic) IBOutlet UIView *viewPerfil;

@property (weak, nonatomic) IBOutlet UIView *viewRegistro;
@property (weak, nonatomic) IBOutlet UITextField *fldRNombre;
@property (weak, nonatomic) IBOutlet UITextField *fldRCorreo;
@property (weak, nonatomic) IBOutlet UITextView *txtRDireccion;

@property (weak, nonatomic) IBOutlet UIImageView *imgPerfil;

@property (weak, nonatomic) IBOutlet UILabel *lblDenunciasEnviadas;
@property (weak, nonatomic) IBOutlet UILabel *lblDenunciasProceso;
@property (weak, nonatomic) IBOutlet UILabel *lblDenunciasResultas;

@property (weak, nonatomic) IBOutlet UILabel *lblNombre;
@property (weak, nonatomic) IBOutlet UILabel *lblCorreo;
@property (weak, nonatomic) IBOutlet UILabel *lblTelefono;
@property (weak, nonatomic) IBOutlet UILabel *lblDireccion;

@property (nonatomic, strong) DBManager *dbManger;
@property (nonatomic, strong) Usuario *usuario;
@property (nonatomic, assign) BOOL fromDenunciar;
@property (nonatomic, strong) DenunciarController *delegado;

@end
