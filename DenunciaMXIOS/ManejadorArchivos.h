//
//  ManejadorArchivos.h
//  GlobesEstMovilARC
//
//  Created by Carolina Franco on 04/09/12.
//  Copyright (c) 2012 Grupo Integra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ManejadorArchivos : NSObject

+(NSString *)generarGUID;
+(NSString *)crearCarpetaParaNuevaDenunciaConGUID:(NSString *)guid;
+ (BOOL)guardarImagen:(UIImage*)image enRuta:(NSString*)ruta;
+(NSString *)urlDeDenunciaConGUID:(NSString *)guid;

+ (void)borrarImage:(NSString*)fileName;
+ (UIImage*)cargarImagen:(NSString*)imageName;
+ (BOOL)crearCarpetaEnRuta:(NSString *)ruta;

+(BOOL)existeArchivo:(NSString *)ruta;
+(BOOL)guardarArchivo:(NSData *)datos en:(NSString *)ruta;
+(BOOL)eliminarArchivo:(NSString *)ruta;
@end
