//
//  ComboBox.m
//  GeneralSeguros
//
//  Created by APSA Desarrollo on 14/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ComboBox.h"

@implementation ComboBox

@synthesize seleccionado = _seleccionado;
@synthesize delegado = _delegado;

#pragma mark - Acciones

-(void)seleccionar
{
    _seleccionado = 1;
    [self setImage:[UIImage imageNamed:@"CheckboxC.png"]];
}
-(void)deseleccionar
{
    _seleccionado = 0;
    self.image = [UIImage imageNamed:@"Checkbox.png"];
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.tocado = YES;
    if (_seleccionado == 0) 
    {
        _seleccionado = 1;
        self.image = [UIImage imageNamed:@"CheckboxC.png"];
    }
    else 
    {
        _seleccionado = 0;
        self.image = [UIImage imageNamed:@"Checkbox.png"];
    }
    
    [_delegado comboBoxDidSelected:self];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
