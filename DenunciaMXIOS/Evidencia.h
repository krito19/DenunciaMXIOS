//
//  Evidencia.h
//  DenunciaMXIOS
//
//  Created by Carolina Franco on 02/11/14.
//  Copyright (c) 2014 Carolina Franco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Denuncia;

@interface Evidencia : NSManagedObject

@property (nonatomic, retain) NSString * idDenuncia;
@property (nonatomic, retain) NSString * nombre;
@property (nonatomic, retain) NSString * ruta;
@property (nonatomic, retain) NSNumber * tipo;
@property (nonatomic, retain) NSNumber * enviados;
@property (nonatomic, retain) NSNumber * totales;
@property (nonatomic, retain) NSNumber * eviado;
@property (nonatomic, retain) Denuncia *evidenciadenuncia;

@end
