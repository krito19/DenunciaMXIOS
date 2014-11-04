//
//  Denuncia.h
//  DenunciaMXIOS
//
//  Created by Carolina Franco on 31/10/14.
//  Copyright (c) 2014 Carolina Franco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Evidencia, StatusHistorial;

@interface Denuncia : NSManagedObject

@property (nonatomic, retain) NSString * idDenuncia;
@property (nonatomic, retain) NSString * token;
@property (nonatomic, retain) NSNumber * anonima;
@property (nonatomic, retain) NSString * correo;
@property (nonatomic, retain) NSString * titulo;
@property (nonatomic, retain) NSNumber * idDependencia;
@property (nonatomic, retain) NSDate * fechaRegistro;
@property (nonatomic, retain) NSString * r1;
@property (nonatomic, retain) NSString * r2;
@property (nonatomic, retain) NSString * r3;
@property (nonatomic, retain) NSString * r4;
@property (nonatomic, retain) NSString * r5;
@property (nonatomic, retain) NSNumber * latitud;
@property (nonatomic, retain) NSNumber * longuitud;
@property (nonatomic, retain) NSString * idSFP;
@property (nonatomic, retain) NSNumber * terminada;
@property (nonatomic, retain) NSNumber * enviada;
@property (nonatomic, retain) NSSet *denunciaevidencia;
@property (nonatomic, retain) NSSet *denunciastatus;
@end

@interface Denuncia (CoreDataGeneratedAccessors)

- (void)addDenunciaevidenciaObject:(Evidencia *)value;
- (void)removeDenunciaevidenciaObject:(Evidencia *)value;
- (void)addDenunciaevidencia:(NSSet *)values;
- (void)removeDenunciaevidencia:(NSSet *)values;

- (void)addDenunciastatusObject:(StatusHistorial *)value;
- (void)removeDenunciastatusObject:(StatusHistorial *)value;
- (void)addDenunciastatus:(NSSet *)values;
- (void)removeDenunciastatus:(NSSet *)values;

@end
