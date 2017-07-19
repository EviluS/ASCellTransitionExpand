//
//  ViewController.m
//  ASCellTransitionExpand
//
//  Created by George Petrov on 7/19/17.
//  Copyright © 2017 Apps Collider. All rights reserved.
//

#import "ViewController.h"
#import "ExampleNode.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - Initialization

- (instancetype)init {
    ExampleNode *node = [[ExampleNode alloc] init];
    self = [super initWithNode:node];
    if (self) {
        [node setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

#pragma mark - Override

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

#pragma mark - Public Methods

#pragma mark - Delegate

#pragma mark - Properties

@end
