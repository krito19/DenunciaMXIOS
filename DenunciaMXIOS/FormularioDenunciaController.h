//
//  FormularioDenunciaController.h
//  DenunciaMXIOS
//
//  Created by Carolina Franco on 02/10/14.
//  Copyright (c) 2014 Carolina Franco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComboBoxDelegate.h"
#import "ComboBox.h"

@class Denuncia;

@interface FormularioDenunciaController : UIViewController <UITextViewDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate,UIPickerViewDelegate,ComboBoxDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblTitulo1;
@property (weak, nonatomic) IBOutlet UITextField *fldFecha;
@property (weak, nonatomic) IBOutlet UITextField *fldDependencia;
@property (weak, nonatomic) IBOutlet UITextView *txtQue;
@property (weak, nonatomic) IBOutlet UITextView *txtDonde;
@property (weak, nonatomic) IBOutlet UITextView *txtComo;
@property (weak, nonatomic) IBOutlet UITextView *txtQuienes;
@property (weak, nonatomic) IBOutlet UITextView *txtTramite;
@property (weak, nonatomic) IBOutlet UITextField *fldTitulo;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet ComboBox *comboSi;
@property (weak, nonatomic) IBOutlet ComboBox *comboNo;
@property (weak, nonatomic) IBOutlet UIButton *btnDependencia;
@property (weak, nonatomic) IBOutlet UIButton *btnFecha;

@property (weak, nonatomic) IBOutlet UIView *viewCatalogo;
@property (weak, nonatomic) IBOutlet UITableView *tableCatalogo;
@property (weak, nonatomic) IBOutlet UIButton *btnAceptarCat;
@property (weak, nonatomic) IBOutlet UIButton *btnCancelarCat;

@property (weak, nonatomic) IBOutlet UIView *viewPicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *dataPicker;
@property (weak, nonatomic) IBOutlet UIButton *btnCancelCat;

@property (nonatomic, strong) NSArray *dependencias;
@property (nonatomic, assign) int depSeleccionada;

@property (nonatomic, strong) NSString *urlDenuncia;
@property (nonatomic, assign) BOOL fromDenuncias;

-(NSString *)validarCampos;
-(void)llenarConDenuncia:(Denuncia *)d editable:(BOOL)editable;


@end
