//
//  ViewController.m
//  GPSequenceDemo
//
//  Created by Liyanwei on 2018/8/20.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import "ViewController.h"
#import <GrapeSequence/GrapeSequence.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    {
        GPSArray<NSNumber*>* arr = [[GPSArray alloc] init];
        NSAssert(arr.count == 0, @"ss");
    }
    
    {
        NSArray* tmp = @[@1 , @2 , @3];
        GPSArray<NSNumber*>* arr = [[GPSArray alloc] initWithNSArray:tmp];
        NSAssert(arr.count == 3, @"ss");
       
        NSAssert([arr isEqual:tmp], @"ss");
    }
    
}

@end
