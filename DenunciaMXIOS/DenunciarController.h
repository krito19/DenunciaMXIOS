//
//  DenunciarController.h
//  DenunciaMXIOS
//
//  Created by Carolina Franco on 02/10/14.
//  Copyright (c) 2014 Carolina Franco. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FormularioDenunciaController;
@class EvidenciaController;
@class UbicacionController;
@class EnviadoController;
@class Denuncia;
@class DBManager;
@class MisDenunciasController;
@class StatusHistorial;

@interface DenunciarController : UIViewController <UIScrollViewDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewTop;
@property (weak, nonatomic) IBOutlet UIButton *btnAtras;
@property (weak, nonatomic) IBOutlet UIView *viewTab;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UIView *viewBack;
@property (weak, nonatomic) IBOutlet UIImageView *indicador;
@property (weak, nonatomic) IBOutlet UIButton *btnCapturar;
@property (weak, nonatomic) IBOutlet UIButton *btnEvidencia;
@property (weak, nonatomic) IBOutlet UIButton *btnUbicar;
@property (weak, nonatomic) IBOutlet UIButton *btnEnviar;
@property (weak, nonatomic) IBOutlet UIView *viesStatus;
@property (weak, nonatomic) IBOutlet UIView *viewProceso;
@property (weak, nonatomic) IBOutlet UIButton *btnReanudar;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loader;
@property (weak, nonatomic) IBOutlet UILabel *lblDescripcionProgreso;
@property (weak, nonatomic) IBOutlet UIView *viewProgreso;
@property (weak, nonatomic) IBOutlet UILabel *lblPorcentaje;
@property (weak, nonatomic) IBOutlet UIButton *btnStatus1;
@property (weak, nonatomic) IBOutlet UIButton *btnStatus2;
@property (weak, nonatomic) IBOutlet UIButton *btnStatus3;
@property (weak, nonatomic) IBOutlet UIButton *btnStatus4;
@property (weak, nonatomic) IBOutlet UIImageView *barraStatus;
@property (weak, nonatomic) IBOutlet UIView *viewMensajeStatus;
@property (weak, nonatomic) IBOutlet UIView *viewMensajeChico;
@property (weak, nonatomic) IBOutlet UITextView *txtMensaje;

@property (nonatomic, strong) FormularioDenunciaController *formulario;
@property (nonatomic, strong) EvidenciaController *evidencia;
@property (nonatomic, strong) UbicacionController *ubicacion;
@property (nonatomic, strong) EnviadoController *enviado;

@property (nonatomic, strong) NSString *urlDenuncia;
@property (nonatomic, strong) NSString *guid;
@property (nonatomic, strong) Denuncia *denuncia;
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) MisDenunciasController *delegado;
@property (nonatomic, assign) BOOL seGuardo;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) StatusHistorial *status1;
@property (nonatomic, strong) StatusHistorial *status2;
@property (nonatomic, strong) StatusHistorial *status3;
@property (nonatomic, strong) StatusHistorial *status4;
@property (nonatomic, assign) BOOL fromDenuncias;

-(void)didRegistred;

@end
