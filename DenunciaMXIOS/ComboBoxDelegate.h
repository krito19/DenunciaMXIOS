//
//  ComboBoxDelegate.h
//  GeneralSeguros
//
//  Created by Carolina Franco on 25/06/12.
//  Copyright (c) 2012 Grupo Integra. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ComboBox;

@protocol ComboBoxDelegate <NSObject>

@optional
-(void)comboBoxDidSelected:(ComboBox *)comboBox;

@end
