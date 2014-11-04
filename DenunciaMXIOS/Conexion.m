//
//  Conexion.m
//  GeneralSeguros
//
//  Created by APSA Desarrollo on 30/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Conexion.h"
#import "Reachability.h"

@implementation Conexion

#pragma mark - General

+(BOOL)comprobarConexion
{
    Reachability * reach =nil;
    
    reach=[Reachability reachabilityForInternetConnection];
    if(![reach isReachable]) {
        NSLog(@"Problema con el Internet");
        return NO;
    }
    
    
    reach=[Reachability reachabilityForLocalWiFi];
    if(![reach isReachable]) {
        NSLog(@"Problema con el Wifi");
        return NO;
    }
    
    return YES;
}

@end
