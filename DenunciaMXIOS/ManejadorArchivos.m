//
//  ManejadorArchivos.m
//  GlobesEstMovilARC
//
//  Created by Carolina Franco on 04/09/12.
//  Copyright (c) 2012 Grupo Integra. All rights reserved.
//

#import "ManejadorArchivos.h"

@implementation ManejadorArchivos

+(NSString *)generarGUID
{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    return (NSString *)CFBridgingRelease(uuidStringRef);
}

+(NSString *)crearCarpetaParaNuevaDenunciaConGUID:(NSString *)guid
{
    NSArray *dirPaths;
    NSString *docsDir;
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    NSString *fullPath = [docsDir stringByAppendingFormat:@"/%@",guid];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    BOOL exito = [fileManager createDirectoryAtPath:fullPath withIntermediateDirectories:YES attributes:nil error:&error];
    if (error)
        NSLog(@"Error al crear carpeta para denuncia:%@",error.localizedDescription);
    if (exito)
        return fullPath;
    else
        return @"";
}


+(NSString *)urlDeDenunciaConGUID:(NSString *)guid
{
    NSArray *dirPaths;
    NSString *docsDir;
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    NSString *fullPath = [docsDir stringByAppendingFormat:@"/%@",guid];
    return fullPath;
}


+(BOOL)guardarImagen:(UIImage *)image enRuta:(NSString*)ruta
{
    NSData* imageData = UIImageJPEGRepresentation(image, 0.5);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    return [fileManager createFileAtPath:ruta contents:imageData attributes:nil];
    
}

+ (BOOL)crearCarpetaEnRuta:(NSString *)ruta
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *unError = nil;
    
    BOOL exito = [fileManager createDirectoryAtPath:ruta withIntermediateDirectories:YES attributes:nil error:&unError];
    
    
    if (unError)
        NSLog(@"%@",unError.description);
    
    return exito;
}




+ (void)borrarImage:(NSString*)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", fileName]];
    
    [fileManager removeItemAtPath: fullPath error:NULL];
}

+ (UIImage*)cargarImagen:(NSString*)imageName
{
    return [UIImage imageWithContentsOfFile:imageName];
}

+(BOOL)existeArchivo:(NSString *)ruta
{
    return [[NSFileManager defaultManager] fileExistsAtPath:ruta];
}

+ (BOOL)guardarArchivo:(NSData *)datos en:(NSString *)ruta
{
    NSFileManager *fM = [NSFileManager defaultManager];
    
    [fM createFileAtPath:ruta contents:datos attributes:nil]; 
    
    BOOL existe;
    existe = [ManejadorArchivos existeArchivo:ruta];
    
    return existe;
}

+(BOOL)eliminarArchivo:(NSString *)ruta
{
    NSFileManager *fM = [NSFileManager defaultManager];
    
    [fM removeItemAtPath:ruta error:NULL];
    
    NSLog(@"image removed");
    
    if ([ManejadorArchivos existeArchivo:ruta])
        return NO;
    else
        return YES;
}


@end
