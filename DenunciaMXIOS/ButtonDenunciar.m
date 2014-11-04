//
//  ButtonDenunciar.m
//  DenunciaMXIOS
//
//  Created by Carolina Franco on 03/11/14.
//  Copyright (c) 2014 Carolina Franco. All rights reserved.
//

#import "ButtonDenunciar.h"

@implementation ButtonDenunciar


- (void)commonInit
{
    self.algo = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
    self.algo.image = [UIImage imageNamed:@"BotonDenunciarFondo.png"];
    [self addSubview:self.algo];
    UIImageView *algo2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    algo2.image = [UIImage imageNamed:@"BotonDenunciar2.png"];
    [self addSubview:algo2];
    
    [self animar];
}

-(void)animar
{
    [UIView animateWithDuration:.85
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:
                    ^{
                         CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
                        [self.algo setFrame:frame];
                     }
                     completion:^(BOOL finished) {
                         [self desanimar];
                     }];
}


-(void)desanimar
{
    [UIView animateWithDuration:.85
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:
     ^{
         CGRect frame = CGRectMake(10, 10, 60, 60);
         [self.algo setFrame:frame];
     }
                     completion:^(BOOL finished) {
                         [self animar];
                     }];
}

- (id)initWithFrame:(CGRect)aRect
{
    if ((self = [super initWithFrame:aRect])) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)coder
{
    if ((self = [super initWithCoder:coder])) {
        [self commonInit];
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
