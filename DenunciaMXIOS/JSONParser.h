//
//  JSONParser.h
//  DenunciaMXIOS
//
//  Created by Carolina Franco on 30/10/14.
//  Copyright (c) 2014 Carolina Franco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Denuncia;
@class Usuario;
@class StatusHistorial;

@interface JSONParser : NSObject

+(NSString *)JSONStringFromDenuncia:(Denuncia *)denuncia;
+(NSString *)JSONStringFromUsuario:(Usuario *)us;
+(NSString *)JSONStringForDevice;

+(CGPoint)parserJSONForCoordinate:(NSString *)string;
+(StatusHistorial *)parserJSONForStatus:(NSDictionary *)dictionary;

@end
