//
//  DenunciarController.m
//  DenunciaMXIOS
//
//  Created by Carolina Franco on 02/10/14.
//  Copyright (c) 2014 Carolina Franco. All rights reserved.
//

#import "DenunciarController.h"
#import "FormularioDenunciaController.h"
#import "EvidenciaController.h"
#import "UbicacionController.h"
#import "EnviadoController.h"
#import "ManejadorArchivos.h"
#import "Denuncia.h"
#import "DBManager.h"
#import "MisDenunciasController.h"
#import "Usuario.h"
#import "PerfilController.h"
#import "AmazonManager.h"
#import "StatusHistorial.h"
#import <QuartzCore/QuartzCore.h>

@interface DenunciarController ()

@end

@implementation DenunciarController

#pragma mark - Progreso Managment

-(void)configurarProgreso
{
    if (!self.fromDenuncias)
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(rutinaProgreso) userInfo:nil repeats:YES];
    }
}

-(void)rutinaProgreso
{
    NSArray *evidencias = [self.dbManager obtenerEvidenciasDeDenuncias:self.denuncia.idDenuncia];
    int noTotal = 0;
    int noEnvidas = 0;
    for (Evidencia *ev in evidencias)
    {
        noTotal++;
        if (ev.eviado.boolValue == YES)
            noEnvidas++;
    }
    
    int porcentajeAvanzado = (100*noEnvidas)/noTotal;
    int avanceVisual = (porcentajeAvanzado*300)/100;
    
    if (noTotal == noEnvidas)
    {
        self.denuncia.enviada = [NSNumber numberWithBool:YES];
        [self.dbManager saveContext];
    }
    
    dispatch_async(dispatch_get_main_queue(),
    ^{
        if (noTotal == noEnvidas)
        {
            [self.loader stopAnimating];
            [UIView animateWithDuration:.2 animations:
             ^{
                 [self.viewProceso setAlpha:0.0];
                 [self.viesStatus setAlpha:1.0];
             }];
            [self congigurarEnvioTerminado];
            [self.timer invalidate];
            self.timer = nil;
            [self setStatusActual];
            [self.lblDescripcionProgreso setText:@"Evidencia Enviada"];
        }
        else
        {
            [self.loader setHidden:NO];
            [self.loader startAnimating];
            [UIView animateWithDuration:.2 animations:
             ^{
                 CGRect frame = CGRectMake(0, 0, avanceVisual, 19);
                 [self.viewProgreso setFrame:frame];
             }];
            
            [self.lblPorcentaje setText:[NSString stringWithFormat:@"%d%%",porcentajeAvanzado]];
            [self.lblDescripcionProgreso setText:@"ADJUNTANDO EVIDENCIA..."];
        }
    });
}

-(void)congigurarEnvioTerminado
{
    //Congigurar puede empezar con el 10
    StatusHistorial *status = [self.dbManager statusHistorialManaged];
    status.idDenuncia = self.denuncia.idDenuncia;
    status.fecha = [NSDate date];
    status.mensaje = @"Se ha enviado correctamente la denuncia y su evidencia";
    status.idStatus = [NSNumber numberWithInt:10];
    status.leida = [NSNumber numberWithBool:NO];
    
    [self.dbManager saveContext];
}

-(void)setStatusActual
{
    NSArray *historial = [self.dbManager obtenerHistorialDeStatusDeDenuncia:self.denuncia.idDenuncia];

    for (StatusHistorial *status in historial)
    {
        UIImage *image;
        if (status.idStatus.intValue == 10)
        {
            image = [UIImage imageNamed:@"Barra_EstatusCheck1.png"];
            self.status1 = status;
            [self.btnStatus1 setEnabled:YES];
        }
        if (status.idStatus.intValue == 11)
        {
            image = [UIImage imageNamed:@"Barra_EstatusCheck2.png"];
            self.status2 = status;
            [self.btnStatus2 setEnabled:YES];
        }
        if (status.idStatus.intValue == 12)
        {
            image = [UIImage imageNamed:@"Barra_EstatusCheck3.png"];
            self.status3 = status;
            [self.btnStatus3 setEnabled:YES];
        }
        if (status.idStatus.intValue == 13)
        {
            image = [UIImage imageNamed:@"Barra_EstatusCheck4.png"];
            self.status4 = status;
            [self.btnStatus4 setEnabled:YES];
        }
        
        [self.barraStatus setImage:image];
        [self.txtMensaje setEditable:YES];
        [self.txtMensaje setTextColor:[UIColor whiteColor]];
        [self.txtMensaje setEditable:NO];
    }
    
}
- (IBAction)verStatus1:(id)sender
{
    [self.txtMensaje setText:self.status1.mensaje];
    self.status1.leida = [NSNumber numberWithBool:YES];
    [self.dbManager saveContext];
    [UIView animateWithDuration:.7
                     animations:^{
                         [self.viewMensajeStatus setAlpha:1.0];
                     }];
}

- (IBAction)verStatus2:(id)sender
{
    [self.txtMensaje setText:self.status2.mensaje];
    self.status2.leida = [NSNumber numberWithBool:YES];
    [self.dbManager saveContext];
    [UIView animateWithDuration:.7
                     animations:^{
                         [self.viewMensajeStatus setAlpha:1.0];
                     }];
}

- (IBAction)verStatus3:(id)sender
{
    [self.txtMensaje setText:self.status3.mensaje];
    self.status3.leida = [NSNumber numberWithBool:YES];
    [self.dbManager saveContext];
    [UIView animateWithDuration:.7
                     animations:^{
                         [self.viewMensajeStatus setAlpha:1.0];
                     }];
}

- (IBAction)verStatus4:(id)sender
{
    [self.txtMensaje setText:self.status4.mensaje];
    self.status4.leida = [NSNumber numberWithBool:YES];
    [self.dbManager saveContext];
    [UIView animateWithDuration:.7
                     animations:^{
                         [self.viewMensajeStatus setAlpha:1.0];
                     }];
}

#pragma mark - Alert Managment

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1 && alertView.tag == 1)
    {
        [UIView animateWithDuration:.3
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^(void)
         {
             CGRect frame = self.indicador.frame;
             frame.origin.x = self.btnEnviar.frame.origin.x;
             [self.indicador setFrame:frame];
         }
                         completion:nil];
        [self.scroll setContentOffset:CGPointMake(320*3, 0) animated:YES];
    }
    
    if (alertView.tag == 2 && buttonIndex == 1)
    {
        NSString *correo = [[alertView textFieldAtIndex:0] text];
        if ([correo isEqualToString:@""])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Aviso" message:@"No se ha ingresado el correo" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            self.denuncia.correo = correo;
            [self.dbManager saveContext];
        }
    }

    if (alertView.tag == 2 && buttonIndex == 0)
    {
        self.denuncia.correo = @"Sin Correo";
        [self.dbManager saveContext];
    }
    
    if (alertView.tag == 3)
    {
        if (buttonIndex == 0)
        {
            [self.formulario.comboSi seleccionar];
            [self.formulario.comboNo deseleccionar];
            self.denuncia.anonima = [NSNumber numberWithDouble:YES];
            [self.dbManager saveContext];
        }
        else
        {
            PerfilController *perfil = [self.storyboard instantiateViewControllerWithIdentifier:@"PerfilController"];
            perfil.fromDenunciar = YES;
            perfil.delegado = self;
            [self presentViewController:perfil animated:YES completion:nil];
        }
    }
}

#pragma mark - Scroll

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint visible = self.scroll.contentOffset;
    if (visible.x < 320)
    {
        [UIView animateWithDuration:.3
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^(void)
         {
             CGRect frame = self.indicador.frame;
             frame.origin.x = self.btnCapturar.frame.origin.x;
             [self.indicador setFrame:frame];
         }
                         completion:nil];

    }
    
    if (visible.x >= 320 && visible.x < 640)
    {
        [UIView animateWithDuration:.3
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^(void)
         {
             CGRect frame = self.indicador.frame;
             frame.origin.x = self.btnUbicar.frame.origin.x;
             [self.indicador setFrame:frame];
         }
                         completion:nil];
    }
    
    if (visible.x >= 640 && visible.x < 320*3)
    {
        [UIView animateWithDuration:.3
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^(void)
         {
             CGRect frame = self.indicador.frame;
             frame.origin.x = self.btnEvidencia.frame.origin.x;
             [self.indicador setFrame:frame];
         }
                         completion:nil];
    }
    
    if (visible.x >=  320*3)
    {
        [UIView animateWithDuration:.3
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^(void)
         {
             CGRect frame = self.indicador.frame;
             frame.origin.x = self.btnEnviar.frame.origin.x;
             [self.indicador setFrame:frame];
         }
                         completion:nil];
        
        
        if (self.denuncia.terminada.boolValue == NO)
        {
            [self.enviado enviarDenuncia:self.denuncia withHandle:
             ^{
                 self.denuncia.idSFP = @"Pendiente";
                 self.denuncia.terminada = [NSNumber numberWithDouble:YES];
                 [self.dbManager saveContext];
                 [self.btnCapturar setEnabled:NO];
                 [self.btnUbicar setEnabled:NO];
                 [self.btnEvidencia setEnabled:NO];
                 [self.btnEnviar setEnabled:NO];
                 
                 
                 NSArray *es = [self.dbManager obtenerEvidenciasDeDenuncias:self.denuncia.idDenuncia];
                 for (Evidencia * ev in es)
                 {
                     AmazonManager *aManager = [AmazonManager sharedAManager];
                     
                     [aManager addRequestWithEvidencia:ev
                                         progressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend)
                                         {
                                             NSLog(@"Enviado %llu / %llu",ev.enviados.longLongValue,ev.totales.longLongValue);
                                             ev.enviados = [NSNumber numberWithLongLong:totalBytesSent];
                                             ev.totales = [NSNumber numberWithLongLong:totalBytesExpectedToSend];
                                             [self.dbManager saveContext];
                                         }
                                         finishedBlock:^id
                                         {
                                             NSLog(@"Se terminó de enviar");
                                             ev.enviados = ev.totales;
                                             ev.eviado = [NSNumber numberWithBool:YES];
                                             return nil;
                                         }];
                }
            }];
            [self configurarProgreso];
        }
        
    }
}

- (IBAction)cerrarMensaje:(id)sender
{
    [UIView animateWithDuration:.7 animations:^{
        [self.viewMensajeStatus setAlpha:0.0];
    }];
}



#pragma mark - IBActions

- (IBAction)regresar:(id)sender
{
    if (self.navigationController.navigationBar == nil)
        [self dismissViewControllerAnimated:YES completion:nil];
    else
    {
        [self.delegado setGoToMenu:YES];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (IBAction)atras:(id)sender
{
    if (self.navigationController.navigationBar == nil)
        [self dismissViewControllerAnimated:YES completion:nil];
    else
        [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)capturar:(id)sender
{
    [UIView animateWithDuration:.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^(void)
                                {
                                    CGRect frame = self.indicador.frame;
                                    frame.origin.x = self.btnCapturar.frame.origin.x;
                                    [self.indicador setFrame:frame];
                                }
                     completion:nil];
    [self.scroll setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (IBAction)tomarEvidencia:(id)sender
{
    NSString *men = [self.formulario validarCampos];
    if (![men isEqualToString:@"OK"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Aviso" message:men delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (!self.fromDenuncias || !self.denuncia.terminada.boolValue)
        [self guardarFormulario];
    
    if (CGPointEqualToPoint(self.ubicacion.ubicacionSeleccionada,CGPointZero))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Aviso" message:@"Se debe indicar en el mapa la ubicación de los hechos" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (!self.fromDenuncias || !self.denuncia.terminada.boolValue)
        [self guardarUbicacion];
    
    [UIView animateWithDuration:.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^(void)
     {
         CGRect frame = self.indicador.frame;
         frame.origin.x = self.btnEvidencia.frame.origin.x;
         [self.indicador setFrame:frame];
     }
                     completion:nil];
    [self.scroll setContentOffset:CGPointMake(320*2, 0) animated:YES];
}

- (IBAction)ubicar:(id)sender
{
    NSString *men = [self.formulario validarCampos];
    if (![men isEqualToString:@"OK"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Aviso" message:men delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (!self.fromDenuncias || !self.denuncia.terminada.boolValue)
        [self guardarFormulario];
    
    [UIView animateWithDuration:.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^(void)
     {
         CGRect frame = self.indicador.frame;
         frame.origin.x = self.btnUbicar.frame.origin.x;
         [self.indicador setFrame:frame];
     }
                     completion:nil];
    [self.scroll setContentOffset:CGPointMake(320, 0) animated:YES];
}

- (IBAction)enviar:(id)sender
{
    
    if (self.denuncia.terminada.boolValue == YES)
    {
        [UIView animateWithDuration:.3
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^(void)
         {
             CGRect frame = self.indicador.frame;
             frame.origin.x = self.btnEnviar.frame.origin.x;
             [self.indicador setFrame:frame];
         }
                         completion:nil];
        [self.scroll setContentOffset:CGPointMake(320*3, 0) animated:YES];
        return;
    }
    
    NSString *men = [self.formulario validarCampos];
    if (![men isEqualToString:@"OK"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Aviso" message:men delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (!self.fromDenuncias || !self.denuncia.terminada.boolValue)
        [self guardarFormulario];

    if (CGPointEqualToPoint(self.ubicacion.ubicacionSeleccionada,CGPointZero))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Aviso" message:@"Se debe indicar en el mapa la ubicación de los hechos" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (!self.fromDenuncias || !self.denuncia.terminada.boolValue)
        [self guardarUbicacion];
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirmación" message:@"¿Confirma que desea enviar la denuncia?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"SI", nil];
    alert.tag = 1;
    [alert show];
}

#pragma mark - Functionallity

-(void)guardarFormulario
{
    self.denuncia.anonima = [NSNumber numberWithBool:self.formulario.comboSi.seleccionado];
    self.denuncia.titulo = self.formulario.fldTitulo.text;
    self.denuncia.r1 = self.formulario.txtQuienes.text;
    self.denuncia.r2 = self.formulario.txtQue.text;
    self.denuncia.r3 = self.formulario.txtComo.text;
    self.denuncia.r4 = self.formulario.txtTramite.text;
    self.denuncia.r5 = self.formulario.txtDonde.text;
    self.denuncia.idDependencia = [NSNumber numberWithInt:self.formulario.depSeleccionada];
    self.denuncia.fechaRegistro = self.formulario.dataPicker.date;
    self.denuncia.idSFP = @"EMPTY";
    
    [self.dbManager saveContext];
    self.seGuardo = YES;
    
    if (self.denuncia.anonima.boolValue == YES  && (self.denuncia.correo == nil || [self.denuncia.correo isEqualToString:@""]))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Correo Opcional" message:@"Aun que la denuncia sea anónima se puede ingresar un correo para mantenerte informado. \n¿Deseas ingresar un correo?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"SI", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        alert.tag = 2;
        [alert show];
    }
    
    if (self.denuncia.anonima.boolValue == NO)
    {
        Usuario *usuario = [self.dbManager obtenerUsuario];
        if (usuario == nil)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Aviso" message:@"Aún no estas registrado, por favor registrate, para enviar la denuncia de manera no anónima" delegate:self cancelButtonTitle:@"Mandar Anónimamente" otherButtonTitles:@"Registrarme", nil];
            alert.tag = 3;
            [alert show];
        }
        else
        {
            self.denuncia.correo = usuario.correo;
            [self.dbManager saveContext];
        }
    }
}

-(void)didRegistred
{
    Usuario *usuario = [self.dbManager obtenerUsuario];
    self.denuncia.correo = usuario.correo;
    [self.dbManager saveContext];
}

-(void)guardarUbicacion
{
    self.denuncia.latitud = [NSNumber numberWithDouble:self.ubicacion.ubicacionSeleccionada.x];
    self.denuncia.longuitud = [NSNumber numberWithDouble:self.ubicacion.ubicacionSeleccionada.y];
    
    [self.dbManager saveContext];
    self.seGuardo = YES;
}

#pragma mark - Defaults

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.viewMensajeChico.layer setCornerRadius:7];
    [self.viewMensajeStatus setAlpha:0.0];
    
    self.seGuardo = NO;
    
    self.formulario = [[FormularioDenunciaController alloc] initWithNibName:@"FormularioDenunciaController" bundle:nil];
    [self.scroll addSubview:self.formulario.view];
    
    self.ubicacion = [[UbicacionController alloc] initWithNibName:@"UbicacionController" bundle:nil];
    CGRect frame = self.ubicacion.view.frame;
    frame.origin.x = 320;
    self.ubicacion.view.frame = frame;
    [self.scroll addSubview:self.ubicacion.view];
    
    self.evidencia = [[EvidenciaController alloc] initWithNibName:@"EvidenciaController" bundle:nil];
    frame = self.evidencia.view.frame;
    [self.evidencia setDelegate:self];
    frame.origin.x = 320*2;
    self.evidencia.view.frame = frame;
    [self.scroll addSubview:self.evidencia.view];
    [self.scroll setDelegate:self];
    
    self.enviado = [[EnviadoController alloc] initWithNibName:@"EnviadoController" bundle:nil];
    frame = self.enviado.view.frame;
    frame.origin.x = 320*3;
    self.enviado.view.frame = frame;
    [self.scroll addSubview:self.enviado.view];
    
    
    self.scroll.pagingEnabled = YES;
    [self.scroll setContentSize:CGSizeMake(320*4, self.scroll.frame.size.height)];
    
    [self.viewTop setBackgroundColor:[UIColor colorWithRed:60.0/255.0 green:132.0/255.0 blue:116.0/255.0 alpha:1.0]];
    [self.viewBack setBackgroundColor:[UIColor colorWithRed:60.0/255.0 green:132.0/255.0 blue:116.0/255.0 alpha:1.0]];
    
    self.formulario.fromDenuncias = self.fromDenuncias;
    
    if (self.fromDenuncias)
    {
        NSLog(@"ID: %@",self.denuncia.idDenuncia);
        self.guid = self.denuncia.idDenuncia;
        self.urlDenuncia = [ManejadorArchivos urlDeDenunciaConGUID:self.guid];
        self.evidencia.urlDenuncia = self.urlDenuncia;
        self.evidencia.guid = self.guid;
        [self.viewProceso setAlpha:0.0];
        self.dbManager = [DBManager sharedDBManager];
        
        [self.formulario llenarConDenuncia:self.denuncia editable:!self.denuncia.terminada.boolValue];
        [self.ubicacion setUbicacionLat:self.denuncia.latitud.doubleValue yLong:self.denuncia.longuitud.doubleValue editable:!self.denuncia.terminada.boolValue];
        [self.evidencia setEvidenciaConGuid:self.denuncia.idDenuncia editable:!self.denuncia.terminada.boolValue];
        
        NSArray *historial = [self.dbManager obtenerHistorialDeStatusDeDenuncia:self.denuncia.idDenuncia];
        
        if (historial == nil || historial.count == 0)
        {
            if (self.denuncia.terminada.boolValue == YES)
            {
                [self.viesStatus setAlpha:0.0];
                [self.viewProceso setAlpha:1.0];
                [self configurarProgreso];
            }
        }
        else
        {
            [self setStatusActual];
        }
        
        if (self.denuncia.terminada.boolValue == YES)
        {
            [self.enviado.viewGeneral setAlpha:1.0];
            [self.enviado.viewEnviando setAlpha:0.0];
            [self.btnEnviar setTitle:@"FOLIO" forState:UIControlStateNormal];
            [self.enviado.lblFolio setText:self.denuncia.idDenuncia];
            [self.enviado.lblFolio setAdjustsFontSizeToFitWidth:YES];
        }
    }
    else
    {
        self.guid = [ManejadorArchivos generarGUID];
        self.urlDenuncia = [ManejadorArchivos crearCarpetaParaNuevaDenunciaConGUID:self.guid];
        self.evidencia.urlDenuncia = self.urlDenuncia;
        self.evidencia.guid = self.guid;
        
        [self.viesStatus setAlpha:0.0];
        
        self.dbManager = [DBManager sharedDBManager];
        self.denuncia = [self.dbManager denunciaManagedWithGUID:self.guid];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.denuncia.token = [defaults objectForKey:@"Token"];
        [self.btnAtras setHidden:YES];
        self.denuncia.terminada = [NSNumber numberWithBool:NO];
        self.denuncia.enviada = [NSNumber numberWithBool:NO];
        [self.btnReanudar setHidden:YES];
        [self.loader setHidden:YES];
    }

    
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (self.seGuardo == NO && self.fromDenuncias == NO)
    {
        [self.dbManager saveContext];
        [self.dbManager borrarElemento:self.denuncia];
        NSLog(@"Denuncia Borrada");
    }
    else
    {
        [self guardarUbicacion];
        NSLog(@"No borra");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
