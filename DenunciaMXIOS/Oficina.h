//
//  Oficina.h
//  DenunciaMXIOS
//
//  Created by Carolina Franco on 03/11/14.
//  Copyright (c) 2014 Carolina Franco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Oficina : NSObject

@property (nonatomic, strong) NSString *nombre;
@property (nonatomic, strong) NSString *direccion;
@property (nonatomic, strong) NSString *telefono;
@property (nonatomic, assign) double latitud;
@property (nonatomic, assign) double longuitud;

@end
