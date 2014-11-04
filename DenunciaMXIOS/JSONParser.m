//
//  JSONParser.m
//  DenunciaMXIOS
//
//  Created by Carolina Franco on 30/10/14.
//  Copyright (c) 2014 Carolina Franco. All rights reserved.
//

#import "JSONParser.h"
#import "Denuncia.h"
#import "Usuario.h"
#import "DBManager.h"


@implementation JSONParser


#pragma mark - To JSON

+(NSString *)JSONStringFromDenuncia:(Denuncia *)denuncia
{
    NSDateFormatter *formato = [[NSDateFormatter alloc] init];
    [formato setDateFormat:@"yyyy/MM/dd HH:mm"];
    DBManager *dao = [DBManager sharedDBManager];
    NSMutableString *json = [NSMutableString stringWithFormat:@"{\"id\":\"%@\",",denuncia.idDenuncia];
    
    
    [json appendFormat:@"\"idDenunciaSPF\":\"%@\",",denuncia.idSFP];
    [json appendFormat:@"\"token\":\"%@\",",denuncia.token];
    [json appendFormat:@"\"mail\":\"%@\",",denuncia.correo];
    [json appendFormat:@"\"titulo\":\"%@\",",denuncia.titulo];
    [json appendFormat:@"\"idDependencia\":%d,",denuncia.idDependencia.intValue];
    [json appendFormat:@"\"idEstadoDenuncia\":%d,",0];
    [json appendFormat:@"\"fechaRegistro\":\"%@\",",[formato stringFromDate:denuncia.fechaRegistro]];
    [json appendFormat:@"\"anonima\":%d,",denuncia.anonima.boolValue];
    
    [json appendString:@"\"preguntas\":["];
    [json appendFormat:@"{\"idPregunta\":1,\"respuesta\":\"%@\"},",denuncia.r1];
    [json appendFormat:@"{\"idPregunta\":2,\"respuesta\":\"%@\"},",denuncia.r2];
    [json appendFormat:@"{\"idPregunta\":3,\"respuesta\":\"%@\"},",denuncia.r3];
    [json appendFormat:@"{\"idPregunta\":4,\"respuesta\":\"%@\"},",denuncia.r4];
    [json appendFormat:@"{\"idPregunta\":5,\"respuesta\":\"%@\"}",denuncia.r5];
    [json appendString:@"],"];
    
    [json appendString:@"\"ubicacion\":{"];
    [json appendFormat:@"\"coordLat\":%f,",denuncia.latitud.doubleValue];
    [json appendFormat:@"\"coordLong\":%f",denuncia.longuitud.doubleValue];
    [json appendString:@"},"];
    
    
    [json appendString:@"\"evidencia\":{"];
    
    NSArray *evidencias = [dao obtenerEvidenciaDeDenuncia:denuncia.idDenuncia conTipo:1];
    [json appendString:@"\"fotos\":"];
    
    if (evidencias != nil && evidencias.count > 0)
    {
        [json appendString:@"["];
        for (Evidencia *ev in evidencias)
            [json appendFormat:@"{\"nombre\":\"%@\",\"key\":\"%@\"},",ev.nombre,ev.ruta];
        json = [NSMutableString stringWithString:[json substringToIndex:[json length]-1]];
        [json appendString:@"],"];
    }
    else
        [json appendString:@"null,"];
    
    
    evidencias = [dao obtenerEvidenciaDeDenuncia:denuncia.idDenuncia conTipo:3];
    [json appendString:@"\"audios\":"];
    
    if (evidencias != nil && evidencias.count > 0)
    {
        [json appendString:@"["];
        for (Evidencia *ev in evidencias)
            [json appendFormat:@"{\"nombre\":\"%@\",\"key\":\"%@\"},",ev.nombre,ev.ruta];
        json = [NSMutableString stringWithString:[json substringToIndex:[json length]-1]];
        [json appendString:@"],"];
    }
    else
        [json appendString:@"null,"];
    
    
    evidencias = [dao obtenerEvidenciaDeDenuncia:denuncia.idDenuncia conTipo:2];
    [json appendString:@"\"videos\":"];
    
    if (evidencias != nil && evidencias.count > 0)
    {
        [json appendString:@"["];
        for (Evidencia *ev in evidencias)
            [json appendFormat:@"{\"nombre\":\"%@\",\"key\":\"%@\"},",ev.nombre,ev.ruta];
        json = [NSMutableString stringWithString:[json substringToIndex:[json length]-1]];
        [json appendString:@"]"];
    }
    else
        [json appendString:@"null"];

    
    
    [json appendString:@"}"];
    
    
    [json appendString:@"}"];
    
    return json;
}

+(NSString *)JSONStringFromUsuario:(Usuario *)us
{
    NSMutableString *json = [NSMutableString stringWithString:@"{"];
    [json appendFormat:@"\"token\":\"%@\",",us.token];
    [json appendFormat:@"\"nombre\":\"%@\",",us.nombre];
    [json appendFormat:@"\"correo\":\"%@\",",us.correo];
    [json appendFormat:@"\"direccion\":\"%@\"",us.direccion];
    [json appendString:@"}"];
    
    return json;
}

+(NSString *)JSONStringForDevice
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableString *json = [NSMutableString stringWithString:@"{"];
    [json appendFormat:@"\"token\":\"%@\",",[defaults objectForKey:@"Token"]];
    [json appendString:@"\"os\":1"];
    [json appendString:@"}"];
    
    return json;
}

#pragma mark - To Custom

+(CGPoint)parserJSONForCoordinate:(NSString *)string
{
    NSError *error;
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    
    if (error)
    {
        NSLog(@"%@",[error localizedDescription]);
        return CGPointZero;
    }
    else
    {
        NSArray *results = [dictionary objectForKey:@"results"];
        NSDictionary *components = [results objectAtIndex:0];
        
        NSDictionary *geoArray = [components objectForKey:@"geometry"];
        NSDictionary *geoComponents = [geoArray objectForKey:@"location"];
        
        CGFloat lat,lng;
        
        NSString *latString = [geoComponents objectForKey:@"lat"];
        NSString *lngString = [geoComponents objectForKey:@"lng"];
        
        lat = latString.floatValue;
        lng = lngString.floatValue;
        
        return CGPointMake(lat, lng);
    }
}

+(StatusHistorial *)parserJSONForStatus:(NSDictionary *)dictionary
{
        NSDictionary *dic = [dictionary objectForKey:@"denuncia"];
        
        DBManager *db = [DBManager sharedDBManager];
        StatusHistorial *status = [db statusHistorialManaged];
        
        status.idDenuncia = [dic objectForKey:@"id"];
        status.fecha = [NSDate date];
        status.mensaje = [dic objectForKey:@"mensaje"];
        status.idStatus = [NSNumber numberWithInt:[[dic objectForKey:@"id_status"] intValue]];
        status.leida = [NSNumber numberWithBool:NO];
        
        
        return status;
}

@end
