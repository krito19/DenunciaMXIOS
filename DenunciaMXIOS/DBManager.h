//
//  DBManager.h
//  DenunciaMXIOS
//
//  Created by Carolina Franco on 31/10/14.
//  Copyright (c) 2014 Carolina Franco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "Denuncia.h"
#import "Usuario.h"
#import "StatusHistorial.h"
#import "Evidencia.h"

@interface DBManager : NSObject

@property (strong, nonatomic) NSManagedObjectContext *context;

+(id)sharedDBManager;

-(Denuncia *)denunciaManagedWithGUID:(NSString *)guid;
-(Usuario *)usuarioManaged;
-(StatusHistorial *)statusHistorialManaged;
-(Evidencia *)evidenciaManaged;
-(Denuncia *)obtenerDenunciaConID:(NSString *)idDen;

-(void)borrarElemento:(NSManagedObject *)object;
- (BOOL)saveContext;

-(NSArray *)obtenerTodasLasDenuncias;
-(NSArray *)obtenerEvidenciasDeDenuncias:(NSString *)idDenuncia;
-(NSArray *)obtenerEvidenciaDeDenuncia:(NSString *)idDenuncia conTipo:(int)tipo;
-(NSArray *)obtenerHistorialDeStatusDeDenuncia:(NSString *)idDenuncia;
-(Usuario *)obtenerUsuario;

@end
