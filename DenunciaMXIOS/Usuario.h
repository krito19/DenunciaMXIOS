//
//  Usuario.h
//  DenunciaMXIOS
//
//  Created by Carolina Franco on 31/10/14.
//  Copyright (c) 2014 Carolina Franco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Usuario : NSManagedObject

@property (nonatomic, retain) NSString * token;
@property (nonatomic, retain) NSString * nombre;
@property (nonatomic, retain) NSString * direccion;
@property (nonatomic, retain) NSString * correo;

@end
