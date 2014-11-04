//
//  WSManager.m
//  DenunciaMXIOS
//
//  Created by Carolina Franco on 30/10/14.
//  Copyright (c) 2014 Carolina Franco. All rights reserved.
//

#import "WSManager.h"
#import "Conexion.h"
#import <UIKit/UIKit.h>
#import "JSONParser.h"

@implementation WSManager

+(void)showNetWorkActivity:(BOOL)active
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:active];
}

+(NSDictionary *)getCoordenateFromAddress:(NSString *)address
{
    if (![Conexion comprobarConexion])
    {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithBool:NO],@"Sin conexion a internet"] forKeys:@[@"success",@"message"]];
        return dic;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true",address];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSString *locationString = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding error:&error];
    
    CGPoint coord = CGPointZero;
    
    NSLog(@"IDA coordinate from adrres:%@",urlString);
    
    if (error)
    {
        NSLog(@"ERROR:%@",[error localizedDescription]);
        NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithBool:NO],[error localizedDescription]] forKeys:@[@"success",@"message"]];
        return dic;
    }
    else
    {
        if ([locationString isEqualToString:@""])
        {
            NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithBool:NO],@"Error de conexión"] forKeys:@[@"success",@"message"]];
            return dic;
            
        }
        
        NSLog(@"Regreso: %@",locationString);
        coord = [JSONParser parserJSONForCoordinate:locationString];
        NSLog(@"Coord:%f %f",coord.x,coord.y);
        NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithBool:YES],@"",[NSValue valueWithCGPoint:coord]] forKeys:@[@"success",@"message",@"coords"]];
        return dic;
    }
}

+(NSDictionary *)subirDenunciaConContent:(NSString *)content
{
    if (![Conexion comprobarConexion])
    {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithBool:NO],@"Sin conexion a internet"] forKeys:@[@"success",@"message"]];
        return dic;
    }
    
    [WSManager showNetWorkActivity:YES];
    
    NSURL* url = [NSURL URLWithString:@"http://denunciamx-env.elasticbeanstalk.com/denuncia"];
    if ([url respondsToSelector:@selector(removeAllCachedResourceValues)])
        [url removeAllCachedResourceValues];
    
    NSMutableURLRequest* urlRequest=[[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
    
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPBody:[content dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"IDA DENUNCIA:%@",content);
    
    NSData *urlData;
    NSURLResponse *response;
    NSError *error=nil;
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    if(error)
    {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithBool:NO],[error localizedDescription]] forKeys:@[@"success",@"message"]];
        NSLog(@"Error en Request: %@",error.description);
        [WSManager showNetWorkActivity:NO];
        return dic;
    }
    
    [WSManager showNetWorkActivity:NO];
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int code = (int)[httpResponse statusCode];
    
    NSString *regreso = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
    NSLog(@"Regreso  Denunciar:%@",regreso);
    NSLog(@"Code: %d",code);
    
    if (code == 201)
    {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithBool:YES],@"Denuncia Recibida correctamente, se enviará la evidencia"] forKeys:@[@"success",@"message"]];
        return dic;
    }
    
    if (urlData == nil || regreso == nil || [regreso isEqualToString:@""])
    {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithBool:NO],@"Ha ocurrido un error al obtener los datos"] forKeys:@[@"success",@"message"]];
        return dic;
    }
    
    
    
    return nil;
}


+(NSDictionary *)registrarDeviceConContent:(NSString *)content
{
    if (![Conexion comprobarConexion])
    {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithBool:NO],@"Sin conexion a internet"] forKeys:@[@"success",@"message"]];
        return dic;
    }
    
    [WSManager showNetWorkActivity:YES];
    
    NSURL* url = [NSURL URLWithString:@"http://denunciamx-env.elasticbeanstalk.com/dispositivo"];
    if ([url respondsToSelector:@selector(removeAllCachedResourceValues)])
        [url removeAllCachedResourceValues];
    
    NSMutableURLRequest* urlRequest=[[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
    
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPBody:[content dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"IDA REGISTRO DEVICE:%@",content);
    
    NSData *urlData;
    NSURLResponse *response;
    NSError *error=nil;
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    if(error)
    {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithBool:NO],[error localizedDescription]] forKeys:@[@"success",@"message"]];
        NSLog(@"Error en Request: %@",error.description);
        [WSManager showNetWorkActivity:NO];
        return dic;
    }
    
    [WSManager showNetWorkActivity:NO];
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int code = (int)[httpResponse statusCode];
    
    NSString *regreso = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
    NSLog(@"Regreso  RegistroDevice:%@",regreso);
    NSLog(@"Code: %d",code);
    
    if (code == 201)
    {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithBool:YES],@"Dispositivo Registrdo Correctamente"] forKeys:@[@"success",@"message"]];
        return dic;
    }
    
    if (urlData == nil || regreso == nil || [regreso isEqualToString:@""])
    {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithBool:NO],@"Ha ocurrido un error al obtener los datos"] forKeys:@[@"success",@"message"]];
        return dic;
    }
    
    
    
    return nil;
}

+(NSDictionary *)registrarUsuarioConContent:(NSString *)content
{
    if (![Conexion comprobarConexion])
    {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithBool:NO],@"Sin conexion a internet"] forKeys:@[@"success",@"message"]];
        return dic;
    }
    
    [WSManager showNetWorkActivity:YES];
    
    NSURL* url = [NSURL URLWithString:@"http://denunciamx-env.elasticbeanstalk.com/usuario"];
    if ([url respondsToSelector:@selector(removeAllCachedResourceValues)])
        [url removeAllCachedResourceValues];
    
    NSMutableURLRequest* urlRequest=[[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
    
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPBody:[content dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"IDA REGISTRO USUARIO:%@",content);
    
    NSData *urlData;
    NSURLResponse *response;
    NSError *error=nil;
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    if(error)
    {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithBool:NO],[error localizedDescription]] forKeys:@[@"success",@"message"]];
        NSLog(@"Error en Request: %@",error.description);
        [WSManager showNetWorkActivity:NO];
        return dic;
    }
    
    [WSManager showNetWorkActivity:NO];
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int code = (int)[httpResponse statusCode];
    
    NSString *regreso = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
    NSLog(@"Regreso  RegistroUsuario:%@",regreso);
    NSLog(@"Code: %d",code);
    
    if (code == 201)
    {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithBool:YES],@"Usuario Registrdo Correctamente"] forKeys:@[@"success",@"message"]];
        return dic;
    }
    
    if (urlData == nil || regreso == nil || [regreso isEqualToString:@""])
    {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithBool:NO],@"Ha ocurrido un error al obtener los datos"] forKeys:@[@"success",@"message"]];
        return dic;
    }
    
    
    
    return nil;
}


@end
