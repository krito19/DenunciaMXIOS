//
//  ComboBox.h
//  GeneralSeguros
//
//  Created by APSA Desarrollo on 14/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComboBoxDelegate.h"

@interface ComboBox : UIImageView

@property (nonatomic,assign) int seleccionado;
@property (nonatomic,strong) NSObject<ComboBoxDelegate> *delegado;
@property (nonatomic, assign) BOOL tocado;

-(void)seleccionar;
-(void)deseleccionar;

@end
