//
//  WSManager.h
//  DenunciaMXIOS
//
//  Created by Carolina Franco on 30/10/14.
//  Copyright (c) 2014 Carolina Franco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSManager : NSObject

+(void)showNetWorkActivity:(BOOL)active;

+(NSDictionary *)subirDenunciaConContent:(NSString *)content;
+(NSDictionary *)registrarDeviceConContent:(NSString *)content;
+(NSDictionary *)registrarUsuarioConContent:(NSString *)content;

+(NSDictionary *)getCoordenateFromAddress:(NSString *)address;


@end
