//
//  ExampleNode.m
//  ASCellTransitionExpand
//
//  Created by George Petrov on 7/19/17.
//  Copyright © 2017 Apps Collider. All rights reserved.
//

#import "ExampleNode.h"
#import "ExampleCell.h"

@interface ExampleNode () <ASTableDelegate, ASTableDataSource>

@property (nonatomic, readonly, strong) ASDisplayNode *contentNode;
@property (nonatomic, readonly, strong) ASTableNode *tableNode;

- (void)_initializeNodesInNode:(ASDisplayNode *)node;

@end

@implementation ExampleNode

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        [self _initializeNodesInNode:self];
    }
    return self;
}

#pragma mark - Override

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    self.contentNode.style.flexShrink = 1.0;
    self.contentNode.style.flexGrow = 1.0;
    self.contentNode.style.spacingBefore = 20;
    
    ASStackLayoutSpec *stackSpec = [ASStackLayoutSpec verticalStackLayoutSpec];
    stackSpec.child = self.tableNode;
    
    return stackSpec;
}

#pragma mark - Private Methods

- (void)_initializeNodesInNode:(ASDisplayNode *)node {
    node.automaticallyManagesSubnodes = YES;
    
    __weak __typeof(self)weakSelf = self;
    
    _contentNode = [[ASDisplayNode alloc] init];
    _contentNode.automaticallyManagesSubnodes = YES;
    _contentNode.layoutSpecBlock = ^ASLayoutSpec * _Nonnull(__kindof ASDisplayNode * _Nonnull node, ASSizeRange constrainedSize) {
        weakSelf.tableNode.style.flexShrink = 1.0;
        weakSelf.tableNode.style.flexGrow = 1.0;
        
        ASStackLayoutSpec *stackSpec = [ASStackLayoutSpec verticalStackLayoutSpec];
        stackSpec.child = weakSelf.tableNode;
        
        return stackSpec;
    };
    
    _tableNode = [[ASTableNode alloc] initWithStyle:UITableViewStylePlain];
    _tableNode.delegate = self;
    _tableNode.dataSource = self;
}

#pragma mark - Public Methods

#pragma mark - Delegate
#pragma ASTableDelegate

- (NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode {
    return 1;
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *titleString = [NSString stringWithFormat:@"%li Cell Title", indexPath.row + 1];
    NSString *infoString = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
    
    return ^ASCellNode * {
        ExampleCell *cell = [[ExampleCell alloc] init];
        
        cell.title = titleString;
        cell.info = infoString;
        
        return cell;
    };
}

#pragma mark - Properties

@end
