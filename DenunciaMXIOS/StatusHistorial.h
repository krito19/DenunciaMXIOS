//
//  StatusHistorial.h
//  DenunciaMXIOS
//
//  Created by Carolina Franco on 31/10/14.
//  Copyright (c) 2014 Carolina Franco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Denuncia;

@interface StatusHistorial : NSManagedObject

@property (nonatomic, retain) NSString * idDenuncia;
@property (nonatomic, retain) NSDate * fecha;
@property (nonatomic, retain) NSString * mensaje;
@property (nonatomic, retain) NSNumber * idStatus;
@property (nonatomic, retain) NSNumber * leida;
@property (nonatomic, retain) Denuncia *statusdenuncia;

@end
