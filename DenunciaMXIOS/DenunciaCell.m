//
//  DenunciaCell.m
//  DenunciaMXIOS
//
//  Created by Carolina Franco on 07/10/14.
//  Copyright (c) 2014 Carolina Franco. All rights reserved.
//

#import "DenunciaCell.h"
#import "Denuncia.h"
#import "DBManager.h"
#import "StatusHistorial.h"

@implementation DenunciaCell

#pragma mark - Functionallity

-(NSString *)obtenerMes:(int)mes
{
    NSString *mesString;
    switch (mes)
    {
        case 1: mesString = @"ENE"; break;
        case 2: mesString = @"FEB"; break;
        case 3: mesString = @"MAR"; break;
        case 4: mesString = @"ABR"; break;
        case 5: mesString = @"MAY"; break;
        case 6: mesString = @"JUN"; break;
        case 7: mesString = @"JUL"; break;
        case 8: mesString = @"AGO"; break;
        case 9: mesString = @"SEP"; break;
        case 10: mesString = @"OCT"; break;
        case 11: mesString = @"NOV"; break;
        case 12: mesString = @"DIC"; break;
        default:
            break;
    }
    
    return mesString;
}

-(NSString *)obtenerDescripcionStatus:(int)idStatus
{
    NSString *statusString;
    switch (idStatus)
    {
        case 10: statusString = @"Denuncia Enviada"; break;
        case 11: statusString = @"Denuncia Recibida"; break;
        case 12: statusString = @"En Proceso"; break;
        case 13: statusString = @"Denuncia Resulta"; break;
            
        default:
            break;
    }
    
    return statusString;
}


-(void)configurarCeldaConDenuncia:(Denuncia *)den
{
    
    NSDateFormatter *formato = [[NSDateFormatter alloc] init];
    [formato setDateFormat:@"yyyy/MM/dd"];
    NSString *fechaString = [formato stringFromDate:den.fechaRegistro];
    NSArray *componentes = [fechaString componentsSeparatedByString:@"/"];
    NSString *statusString;
    
    DBManager *dbManager = [DBManager sharedDBManager];
    NSArray *historial = [dbManager obtenerHistorialDeStatusDeDenuncia:den.idDenuncia];
    if (historial == nil || historial.count < 1)
    {
        if (den.enviada.boolValue == NO)
        {
            if (den.terminada.boolValue == NO)
                statusString = @"Incompleta";
            else
                statusString = @"Enviando Evidencia";
        }
        else
        {
            statusString = @"Datos Enviados";
        }
    }
    else
    {
        StatusHistorial *status = [historial lastObject];
        statusString = [self obtenerDescripcionStatus:status.idStatus.intValue];
    }
    
    BOOL hasNotification = NO;
    for (StatusHistorial *s in historial)
    {
        if (s.leida.boolValue == NO)
            hasNotification = YES;
    }
    
    if (hasNotification)
        [self.imgNotificacion setHidden:NO];
    else
        [self.imgNotificacion setHidden:YES];

    [self.lblDia setText:[componentes objectAtIndex:2]];
    [self.lblMes setText:[self obtenerMes:[[componentes objectAtIndex:1] intValue]]];
    [self.lblAno setText:[componentes objectAtIndex:0]];
    [self.lblTitulo setText:den.titulo];
    [self.lblStatus setText:statusString];
    [self.lblFolio setText:den.idSFP];
    
    [self.lblTitulo setTextColor:[UIColor colorWithRed:60.0/255.0 green:132.0/255.0 blue:116.0/255.0 alpha:1.0]];
    [self.lblStatus setTextColor:[UIColor colorWithRed:221.0/255.0 green:183.0/255.0 blue:21.0/255 alpha:1]];

    [self.accessoryView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5]];
    [self setBackgroundColor:[UIColor clearColor]];
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    [super setSelected:NO animated:animated];
    
}

@end
