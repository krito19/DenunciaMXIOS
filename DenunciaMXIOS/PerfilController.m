//
//  PerfilController.m
//  DenunciaMXIOS
//
//  Created by Carolina Franco on 01/11/14.
//  Copyright (c) 2014 Carolina Franco. All rights reserved.
//

#import "PerfilController.h"
#import <QuartzCore/QuartzCore.h>
#import "JSONParser.h"
#import "WSManager.h"

@interface PerfilController ()

@end

@implementation PerfilController

#pragma mark - Delegate Fld y Txt

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqual:@"\n"])
    {
        if(textView.text.length == 0)
        {
            [self setPlaceHolder:textView];
        }
        [textView resignFirstResponder];
    }
    
    return YES;
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if ([[self getPlaceHolder:textView] isEqualToString:textView.text])
    {
        textView.text = @"";
        textView.textColor = [UIColor whiteColor];
    }
    
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if(textView.text.length == 0)
    {
        [self setPlaceHolder:textView];
    }
    
    return YES;
}

#pragma mark - Diseño UI

-(void)personalizarFields:(UITextField *)fld
{
    [fld.layer setBorderColor:[UIColor whiteColor].CGColor];
    [fld.layer setBorderWidth:.5];
    [fld setBorderStyle:UITextBorderStyleNone];
    [fld setTextColor:[UIColor whiteColor]];
    [fld setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:fld.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}]];
    [fld setDelegate:self];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, fld.frame.size.height)];
    fld.leftView = paddingView;
    fld.leftViewMode = UITextFieldViewModeAlways;
    [fld setAutocorrectionType:UITextAutocorrectionTypeNo];
    
}

-(void)setPlaceHolder:(UITextView *)txtView
{
    [txtView setText:[self getPlaceHolder:txtView]];
    [txtView setTextColor:[UIColor lightGrayColor]];
}

-(NSString *)getPlaceHolder:(UITextView *)txtView
{
    NSString *place = @"DIRECCION";
    return place;
}



-(void)personalizarTextView:(UITextView *)txt
{
    [txt.layer setBorderColor:[UIColor whiteColor].CGColor];
    [txt.layer setBorderWidth:.5];
    [txt setBackgroundColor:[UIColor clearColor]];
    [txt setTextColor:[UIColor whiteColor]];
    [txt setAutocorrectionType:UITextAutocorrectionTypeNo];
    [txt setDelegate:self];
    [self setPlaceHolder:txt];
}

#pragma mark - Funcionalidad

-(NSString *)validarCampo
{
    if (self.fldRNombre.text == nil || [self.fldRNombre.text isEqualToString:@""])
        return @"Se debe introducir el nombre";
    if (self.fldRCorreo.text == nil || [self.fldRCorreo.text isEqualToString:@""])
        return @"Se debe introducir el correo";
    if (self.txtRDireccion.text == nil || [self.txtRDireccion.text isEqualToString:@""])
        return @"Se debe introducir la dirección";
    
    return @"OK";
}

#pragma mark - IBActions

- (IBAction)denunciar:(id)sender
{
    if (self.fromDenunciar)
        return;
}

- (IBAction)goMenu:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)registrar:(id)sender
{
    NSString *men = [self validarCampo];
    if (![men isEqualToString:@"OK"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Aviso" message:men delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    self.usuario = [self.dbManger usuarioManaged];
    self.usuario.nombre = self.fldRNombre.text;
    self.usuario.correo = self.fldRCorreo.text;
    self.usuario.direccion = self.txtRDireccion.text;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.usuario.token = [defaults objectForKey:@"Token"];
    
    if ([self.dbManger saveContext])
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void)
        {
            dispatch_async(dispatch_get_main_queue(),
            ^{
                [UIView animateWithDuration:.5 animations:
                 ^{
                     [self.viewLoading setAlpha:1.0];
                } completion:nil];
                [self.loaer startAnimating];
            });
            
            NSString *content = [JSONParser JSONStringFromUsuario:self.usuario];
            NSDictionary *dic = [WSManager registrarUsuarioConContent:content];
            BOOL suc = [[dic objectForKey:@"success"] boolValue];
            self.usuario = [self.dbManger obtenerUsuario];
            NSString *men = [dic objectForKey:@"message"];
            
            dispatch_async(dispatch_get_main_queue(),
            ^{
                [self.loaer stopAnimating];
                [UIView animateWithDuration:.5 animations:
                 ^{
                     [self.viewLoading setAlpha:0.0];
                     [self.viewRegistro setAlpha:0.0];
                     [self.viewPerfil setAlpha:1.0];
                 } completion:nil];
                
                if (suc)
                {
                    [self.lblNombre setText:self.usuario.nombre];
                    [self.lblCorreo setText:self.usuario.correo];
                    [self.lblDireccion setText:self.usuario.direccion];
                }
            
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Aviso" message:men delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
                [alert show];
                
                [self performSelector:@selector(dismiss) withObject:nil afterDelay:1.3];

            });
            
            
        });
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Aviso" message:@"Ha ocurrido un erro al guardar los datos" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)dismiss
{
    [self.delegado didRegistred];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Default

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self personalizarFields:self.fldRCorreo];
    [self personalizarFields:self.fldRNombre];
    [self personalizarTextView:self.txtRDireccion];
    [self.fldRCorreo setDelegate:self];
    [self.fldRNombre setDelegate:self];
    [self.txtRDireccion setDelegate:self];
    
    [self.lblTitulo setBackgroundColor:[UIColor colorWithRed:7.0/255.0 green:182.0/255.0 blue:144.0/255.0 alpha:0.4]];
    [self.btnRegistrar setBackgroundColor:[UIColor colorWithRed:114.0/255.0 green:68.0/255.0 blue:145.0/255.0 alpha:1.0]];
    
    self.dbManger = [DBManager sharedDBManager];
    self.usuario = [self.dbManger obtenerUsuario];
    if (self.usuario != nil)
    {
        [self.viewRegistro setAlpha:0.0];
        [self.viewPerfil setAlpha:1.0];
        [self.lblNombre setText:self.usuario.nombre];
        [self.lblCorreo setText:self.usuario.correo];
        [self.lblDireccion setText:self.usuario.direccion];
    }
    else
    {
        [self.viewRegistro setAlpha:1.0];
        [self.viewPerfil setAlpha:0.0];
    }
    
    if (self.fromDenunciar)
    {
        [self.btnMenu setHidden:YES];
    }
    
    [self.viewLoading setAlpha:0.0];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
