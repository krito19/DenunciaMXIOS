//
//  DBManager.m
//  DenunciaMXIOS
//
//  Created by Carolina Franco on 31/10/14.
//  Copyright (c) 2014 Carolina Franco. All rights reserved.
//

#import "DBManager.h"
#import "AppDelegate.h"


@implementation DBManager


#pragma mark - Singleton Managment

+(id)sharedDBManager
{
    static DBManager *dbManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^(void)
                  {
                      dbManager = [[self alloc] init];
                      dbManager.context =  [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
                  });
    return dbManager;
}

#pragma mark - Initializations

-(Denuncia *)denunciaManagedWithGUID:(NSString *)guid
{
    Denuncia *den = [NSEntityDescription insertNewObjectForEntityForName:@"Denuncia" inManagedObjectContext:self.context];
    den.idDenuncia = guid;
    return den;
}

-(Usuario *)usuarioManaged
{
    Usuario *us = [NSEntityDescription insertNewObjectForEntityForName:@"Usuario" inManagedObjectContext:self.context];
    return us;
}

-(StatusHistorial *)statusHistorialManaged
{
    StatusHistorial *status = [NSEntityDescription insertNewObjectForEntityForName:@"StatusHistorial" inManagedObjectContext:self.context];
    return status;
}

-(Evidencia *)evidenciaManaged
{
    Evidencia *evi = [NSEntityDescription insertNewObjectForEntityForName:@"Evidencia" inManagedObjectContext:self.context];
    return evi;
}

#pragma mark - Eliminación

-(void)borrarElemento:(NSManagedObject *)object
{
    [self.context deleteObject:object];
}

#pragma mark - Guardar

- (BOOL)saveContext
{
    NSError *error = nil;
    if (self.context != nil)
    {
        if ([self.context hasChanges] && ![self.context save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            return NO;
        }
        else
        {
            NSLog(@"Contexto guardado");
            return YES;
        }
    }
    
    return YES;
}

#pragma mark - SELECTS

-(NSArray *)obtenerTodasLasDenuncias
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *denuncia = [NSEntityDescription entityForName:@"Denuncia" inManagedObjectContext:self.context];
    NSSortDescriptor *ordenador = [[NSSortDescriptor alloc] initWithKey:@"fechaRegistro" ascending:NO];
    [request setEntity:denuncia];
    [request setSortDescriptors:@[ordenador]];
    
    NSError *error;
    NSArray * denuncias = [self.context executeFetchRequest:request error:&error];
    
    if (error)
    {
        NSLog(@"Error la Obtener Denuncias: %@",error.localizedDescription);
        return nil;
    }
    
    return denuncias;
}

-(Denuncia *)obtenerDenunciaConID:(NSString *)idDen
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *denuncia = [NSEntityDescription entityForName:@"Denuncia" inManagedObjectContext:self.context];
    NSSortDescriptor *ordenador = [[NSSortDescriptor alloc] initWithKey:@"fechaRegistro" ascending:NO];
    NSPredicate *condicion = [NSPredicate predicateWithFormat:@"idDenuncia == %@",idDen];
    [request setEntity:denuncia];
    [request setSortDescriptors:@[ordenador]];
    [request setPredicate:condicion];
    
    NSError *error;
    NSArray * denuncias = [self.context executeFetchRequest:request error:&error];
    
    if (error)
    {
        NSLog(@"Error la Obtener DenunciaConID: %@",error.localizedDescription);
        return nil;
    }
    
    if (denuncias != nil && denuncias.count > 0)
        return [denuncias objectAtIndex:0];
    else
        return nil;
}

-(NSArray *)obtenerEvidenciasDeDenuncias:(NSString *)idDenuncia
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *evidencia = [NSEntityDescription entityForName:@"Evidencia" inManagedObjectContext:self.context];
    NSPredicate *condicion = [NSPredicate predicateWithFormat:@"idDenuncia == %@",idDenuncia];
    [request setEntity:evidencia];
    [request setPredicate:condicion];
    
    NSError *error;
    NSArray *evidencias = [self.context executeFetchRequest:request error:&error];
    if (error)
    {
        NSLog(@"Error al obtener las evidencias: Descripcion:%@ \n Por:%@",error.localizedDescription,error.localizedFailureReason);
        return nil;
    }
    
    return evidencias;
}

-(NSArray *)obtenerEvidenciaDeDenuncia:(NSString *)idDenuncia conTipo:(int)tipo
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *evidencia = [NSEntityDescription entityForName:@"Evidencia" inManagedObjectContext:self.context];
    NSPredicate *condicion = [NSPredicate predicateWithFormat:@"idDenuncia == %@ AND tipo == %d",idDenuncia,tipo];
    [request setEntity:evidencia];
    [request setPredicate:condicion];
    
    NSError *error;
    NSArray *evidencias = [self.context executeFetchRequest:request error:&error];
    if (error)
    {
        NSLog(@"Error al obtener las evidencias: Descripcion:%@ \n Por:%@",error.localizedDescription,error.localizedFailureReason);
        return nil;
    }
    
    return evidencias;
}



-(NSArray *)obtenerHistorialDeStatusDeDenuncia:(NSString *)idDenuncia
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *estado = [NSEntityDescription entityForName:@"StatusHistorial" inManagedObjectContext:self.context];
    NSSortDescriptor *ordenador = [[NSSortDescriptor alloc] initWithKey:@"idStatus" ascending:YES];
    NSPredicate *condicion = [NSPredicate predicateWithFormat:@"idDenuncia == %@",idDenuncia];
    
    [request setEntity:estado];
    [request setPredicate:condicion];
    [request setSortDescriptors:@[ordenador]];
    
    NSError *error;
    NSArray *status = [self.context executeFetchRequest:request error:&error];
    if (error)
    {
        NSLog(@"Error al obtener las evidencias: Descripcion:%@ \n Por:%@",error.localizedDescription,error.localizedFailureReason);
        return nil;

    }
    
    return status;
}

-(Usuario *)obtenerUsuario
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *us = [NSEntityDescription entityForName:@"Usuario" inManagedObjectContext:self.context];
    [request setEntity:us];
    
    NSError *error;
    NSArray * usuarios = [self.context executeFetchRequest:request error:&error];
    
    if (error)
    {
        NSLog(@"Error la Obtener Denuncias: %@",error.localizedDescription);
        return nil;
    }
    
    if (usuarios != nil && usuarios.count > 0)
        return [usuarios objectAtIndex:0];
    else
        return nil;
}

@end
