//
//  FormularioDenunciaController.m
//  DenunciaMXIOS
//
//  Created by Carolina Franco on 02/10/14.
//  Copyright (c) 2014 Carolina Franco. All rights reserved.
//

#import "FormularioDenunciaController.h"
#import <QuartzCore/QuartzCore.h>
#import "Denuncia.h"

@interface FormularioDenunciaController ()

@end

@implementation FormularioDenunciaController


#pragma mark - Manage Combo

-(void)comboBoxDidSelected:(ComboBox *)comboBox
{
    if ([comboBox isEqual:self.comboNo])
        [self.comboSi deseleccionar];
    if ([comboBox isEqual:self.comboSi])
    {
        [self.comboNo deseleccionar];
    }
}



#pragma mark - Table Managment

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dependencias.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableCatalogo dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    
    [cell.textLabel setText:[self.dependencias objectAtIndex:indexPath.row]];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.depSeleccionada = (int)indexPath.row+1;
    [self.fldDependencia setText:[self.dependencias objectAtIndex:indexPath.row]];
    [self.fldDependencia setTextColor:[UIColor lightGrayColor]];
    
    [UIView animateWithDuration:.7
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^(void)
    {
        CGRect frame = [self.viewCatalogo frame];
        frame.origin.y = 352;
        [self.viewCatalogo setFrame:frame];
    }
                     completion:nil];
}

#pragma mark - Keyboard Manage

-(void) keyboardDidShow: (NSNotification *)notif
{
    CGRect frame = self.scroll.frame;
    frame.size.height -= 180;
    self.scroll.frame = frame;
}

-(void) keyboardDidHide: (NSNotification *)notif
{
    CGRect frame = self.scroll.frame;
    frame.size.height += 180;
    self.scroll.frame = frame;
}

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
    
    CGPoint scrollPoint = CGPointMake(0.0, textView.frame.origin.y);
    [self.scroll setContentOffset:scrollPoint animated:YES];
    
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
    NSString *place;
    switch (txtView.tag)
    {
        case 1: place = @"¿Qué fue lo que pasó?"; break;
        case 2: place = @"Dirección donde ocurrieron los hechos"; break;
        case 3: place = @"¿Cómo sucedió?"; break;
        case 4: place = @"¿Como se llevaron a cabo?"; break;
        case 5: place = @"Nombre del Funcionario"; break;
        case 6: place = @"¿Qué trámite o servicio estaba realizando?"; break;
        default: place = @"";
            break;
    }
    
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

-(void)personalizarCapturadoTextView:(UITextView *)txt
{
    [txt.layer setBorderColor:[UIColor whiteColor].CGColor];
    [txt.layer setBorderWidth:.5];
    [txt setBackgroundColor:[UIColor clearColor]];
    [txt setTextColor:[UIColor grayColor]];
    [txt setAutocorrectionType:UITextAutocorrectionTypeNo];
    [txt setDelegate:self];
    [txt setEditable:NO];
}

-(void)personalizarCapturadoFields:(UITextField *)fld
{
    [fld.layer setBorderColor:[UIColor whiteColor].CGColor];
    [fld.layer setBorderWidth:.5];
    [fld setBorderStyle:UITextBorderStyleNone];
    [fld setTextColor:[UIColor grayColor]];
    [fld setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:fld.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}]];
    [fld setDelegate:self];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, fld.frame.size.height)];
    fld.leftView = paddingView;
    fld.leftViewMode = UITextFieldViewModeAlways;
    [fld setAutocorrectionType:UITextAutocorrectionTypeNo];
    [fld setEnabled:NO];
}


#pragma mark - IBActions


- (IBAction)showPickerDate:(id)sender
{
    [self resingFromALL];
    [UIView animateWithDuration:.7
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^(void)
     {
         CGRect frame = [self.viewPicker frame];
         frame.origin.y -= frame.size.height;
         [self.viewPicker setFrame:frame];
     }
                     completion:nil];
}

- (IBAction)showCatalogo:(id)sender
{
    [self resingFromALL];
    [UIView animateWithDuration:.7
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^(void)
     {
         CGRect frame = [self.viewCatalogo frame];
         frame.origin.y -= frame.size.height;
         [self.viewCatalogo setFrame:frame];
     }
                     completion:nil];
}
- (IBAction)cancelarCatalogo:(id)sender
{
    [UIView animateWithDuration:.7
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^(void)
     {
         CGRect frame = [self.viewCatalogo frame];
         frame.origin.y = 352;
         [self.viewCatalogo setFrame:frame];
     }
                     completion:nil];

}

- (IBAction)cancelarPicker:(id)sender
{
    [UIView animateWithDuration:.7
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^(void)
     {
         CGRect frame = [self.viewPicker frame];
         frame.origin.y = 352;
         [self.viewPicker setFrame:frame];
     }
                     completion:nil];

}

- (IBAction)aceptarDatePicker:(id)sender
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy HH:mm"];
    NSString *fechaString = [formatter stringFromDate:self.dataPicker.date];
    [self.fldFecha setText:fechaString];
    [self.fldFecha setTextColor:[UIColor lightGrayColor]];
    
    [UIView animateWithDuration:.7
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^(void)
     {
         CGRect frame = [self.viewPicker frame];
         frame.origin.y = 352;
         [self.viewPicker setFrame:frame];
     }
                     completion:nil];
}

-(void)resingFromALL
{
    [self.fldDependencia resignFirstResponder];
    [self.fldFecha resignFirstResponder];
    [self.fldTitulo resignFirstResponder];
    [self.txtComo resignFirstResponder];
    [self.txtDonde resignFirstResponder];
    [self.txtQue resignFirstResponder];
    [self.txtQuienes resignFirstResponder];
    [self.txtTramite resignFirstResponder];
}


-(NSString *)validarCampos
{
    if (self.comboNo.seleccionado == 0 && self.comboSi.seleccionado == 0)
        return @"Se debe indicar si la denuncia será anónima";
    if (self.fldTitulo.text == nil || [self.fldTitulo.text isEqualToString:@""])
        return @"Se debe indicar el título de la denuncia";
    if (self.txtQuienes.text == nil || [self.txtQuienes.text isEqualToString:[self getPlaceHolder:self.txtQuienes]])
        return @"Se debe capturar el nombre del funcionario";
    if (self.depSeleccionada == -1)
        return @"Se debe indicar en donde trabaja el funcionario a denunciar";
    if (self.fldFecha.text == nil || [self.fldFecha.text isEqualToString:@""])
        return @"Se debe indicar la fecha en que ocurrieron los hechos";
    if (self.txtQue.text == nil || [self.txtQue.text isEqualToString:[self getPlaceHolder:self.txtQue]])
        return @"Se debe capturar que fue lo que pasó";
    if (self.txtComo.text == nil || [self.txtComo.text isEqualToString:[self getPlaceHolder:self.txtComo]])
        return @"Se debe narrar que sucedió";
    if (self.txtTramite.text == nil || [self.txtTramite.text isEqualToString:[self getPlaceHolder:self.txtTramite]])
        return @"Se debe indicar que trámite se estaba realizando";
    if (self.txtDonde.text == nil || [self.txtDonde.text isEqualToString:[self getPlaceHolder:self.txtDonde]])
        return @"Se debe indicar la dirección donde ocurrieron los hechos";
    
    
    return @"OK";
}

-(void)llenarConDenuncia:(Denuncia *)d editable:(BOOL)editable
{
    NSDateFormatter *formato = [[NSDateFormatter alloc] init];
    [formato setDateFormat:@"yyyy/MM/dd HH:mm"];
    
    self.depSeleccionada = d.idDependencia.intValue;
    [self.fldFecha setText:[formato stringFromDate:d.fechaRegistro]];
    [self.fldDependencia setText:[self.dependencias objectAtIndex:self.depSeleccionada]];
    [self.txtQuienes setText:d.r1];
    [self.txtQue setText:d.r2];
    [self.txtComo setText:d.r3];
    [self.txtTramite setText:d.r4];
    [self.txtDonde setText:d.r5];
    [self.fldTitulo setText:d.titulo];
    if (d.anonima.boolValue)
        [self.comboSi seleccionar];
    else
        [self.comboNo seleccionar];
    
    
    if (!editable)
    {
        [self personalizarCapturadoFields:self.fldFecha];
        [self personalizarCapturadoFields:self.fldDependencia];
        [self personalizarCapturadoTextView:self.txtComo];
        [self personalizarCapturadoTextView:self.txtDonde];
        [self personalizarCapturadoTextView:self.txtQue];
        [self personalizarCapturadoTextView:self.txtQuienes];
        [self personalizarCapturadoTextView:self.txtTramite];
        [self personalizarCapturadoFields:self.fldTitulo];
        [self.comboNo setUserInteractionEnabled:NO];
        [self.comboSi setUserInteractionEnabled:NO];
        [self.btnDependencia setEnabled:NO];
        [self.btnFecha setEnabled:NO];
    }
}

#pragma mark - Defaults

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.scroll setContentSize:CGSizeMake(self.view.frame.size.width, 951)];
    [self.scroll setBackgroundColor:[UIColor clearColor]];
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    [self.lblTitulo1 setBackgroundColor:[UIColor colorWithRed:7.0/255.0 green:182.0/255.0 blue:144.0/255.0 alpha:0.4]];
    
    self.dependencias = [NSArray arrayWithObjects:@"AEROPUERTOS Y SERVICIOS AUXILIARES (ASA)",@"CAMINOS Y PUENTES FEDERALES DE INGRESOS Y SERVICIOS CONEXOS",@"PEMEX EXPLORACION Y PRODUCCION",@"COMISIóN NACIONAL DE PROTECCIóN SOCIAL EN SALUD",@"DICONSA. S.A. DE C.V",@"INSTITUTO POLITECNICO NACIONAL",@"SECRETARIA DE TURISMO",@"SERVICIO DE ADMINISTRACION TRIBUTARIA",@"SECRETARIA DEL TRABAJO Y PREVISION SOCIAL",@"POLICIA FEDERAL",@"COMISION NACIONAL DEL AGUA",@"INSTITUTO MEXICANO DEL SEGURO SOCIAL (IMSS)",@"INSTITUTO DE SEGURIDAD Y SERVICIOS SOCIALES DE LOS TRABAJADORES",@"SERVICIO POSTAL MEXICANO (SPN)",@"SECRETARIA DE DESARROLLO SOCIAL",nil];
    [self.tableCatalogo setDelegate:self];
    [self.tableCatalogo setDataSource:self];
    
    [self.tableCatalogo setBackgroundColor:[UIColor clearColor]];
    [self.viewCatalogo setBackgroundColor:[UIColor colorWithRed:60.0/255.0 green:132.0/255.0 blue:116.0/255.0 alpha:0.95]];
    
    
    [self.viewPicker setBackgroundColor:[UIColor colorWithRed:60.0/255.0 green:132.0/255.0 blue:116.0/255.0 alpha:0.95]];
    [self.dataPicker setBackgroundColor:[UIColor clearColor]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardDidShow:) name: UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardDidHide:) name: UIKeyboardWillHideNotification object:nil];
    
    
    self.depSeleccionada = -1;
    
    [self personalizarFields:self.fldFecha];
    [self personalizarFields:self.fldDependencia];
    [self personalizarTextView:self.txtComo];
    [self personalizarTextView:self.txtDonde];
    [self personalizarTextView:self.txtQue];
    [self personalizarTextView:self.txtQuienes];
    [self personalizarTextView:self.txtTramite];
    [self personalizarFields:self.fldTitulo];
    [self.comboNo setDelegado:self];
    [self.comboSi setDelegado:self];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
