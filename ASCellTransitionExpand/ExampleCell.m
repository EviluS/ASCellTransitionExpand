//
//  ExampleCell.m
//  ASCellTransitionExpand
//
//  Created by George Petrov on 7/19/17.
//  Copyright © 2017 Apps Collider. All rights reserved.
//

#import "ExampleCell.h"

NSInteger const kExampleCellPreviewNumberOfLines = 4;
NSTimeInterval const kExampleCellAnimationDuration = 0.24;

@interface ExampleCell ()

@property (nonatomic, readonly) ASTextNode *titleTextNode;
@property (nonatomic, readonly) ASTextNode *descriptionTextNode;
@property (nonatomic, readonly) ASButtonNode *expandControlNode;

- (void)_intializeCellNodesInNode:(ASDisplayNode *)node;
- (void)_controlAction:(ASButtonNode *)sender;

- (NSAttributedString *)_attributedStringWithText:(NSString *)text font:(UIFont *)font andColor:(UIColor *)color;

@end

@implementation ExampleCell

#pragma mark - Initialization

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [self _intializeCellNodesInNode:self];
    }
    return self;
}

#pragma mark - Override

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    CGFloat space = 14;
    
    ASStackLayoutSpec *stackSpec = [ASStackLayoutSpec verticalStackLayoutSpec];
    stackSpec.spacing = space;
    stackSpec.children = @[_titleTextNode, _descriptionTextNode, _expandControlNode];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(10, 14, 10, 14);
    ASInsetLayoutSpec *insetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:insets
                                                                          child:stackSpec];
    
    return insetSpec;
}

- (void)animateLayoutTransition:(id<ASContextTransitioning>)context
{
    if (!context.isAnimated) {
        [super animateLayoutTransition:context];
        
        return;
    }
    
    [UIView animateWithDuration:self.defaultLayoutTransitionDuration animations:^ {
        CGRect controlRect = [context finalFrameForNode:_expandControlNode];
        [_expandControlNode setFrame:controlRect];
    } completion:^(BOOL finished) {
        [context completeTransition:finished];
    }];
}

#pragma mark - Private Methods

- (void)_intializeCellNodesInNode:(ASDisplayNode *)node
{
    node.automaticallyManagesSubnodes = YES;
    
    _titleTextNode = [[ASTextNode alloc] init];
    _titleTextNode.maximumNumberOfLines = 1;
    
    _descriptionTextNode = [[ASTextNode alloc] init];
    _descriptionTextNode.maximumNumberOfLines = kExampleCellPreviewNumberOfLines;
    _descriptionTextNode.truncationMode = NSLineBreakByTruncatingTail;
    
    UIFont *buttonFont = [UIFont fontWithName:@"HelveticaNeue" size:18];
    UIColor *buttonFontColor = [UIColor blueColor];
    
    _expandControlNode = [[ASButtonNode alloc] init];
    _expandControlNode.contentHorizontalAlignment = ASHorizontalAlignmentLeft;
    [_expandControlNode setTitle:@"Expand Description"
                        withFont:buttonFont
                       withColor:buttonFontColor
                        forState:UIControlStateNormal];
    [_expandControlNode setTitle:@"Close"
                        withFont:buttonFont
                       withColor:buttonFontColor
                        forState:UIControlStateSelected];
    [_expandControlNode addTarget:self
                           action:@selector(_controlAction:)
                 forControlEvents:ASControlNodeEventTouchUpInside];
}

- (void)_controlAction:(ASButtonNode *)sender
{
    sender.selected = !sender.isSelected;
    
    _descriptionTextNode.maximumNumberOfLines = (sender.isSelected ? 0 : kExampleCellPreviewNumberOfLines);
    
//    [self setNeedsLayout];
    
    self.defaultLayoutTransitionDuration = kExampleCellAnimationDuration;
    [self transitionLayoutWithAnimation:YES shouldMeasureAsync:YES measurementCompletion:nil];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    
    [self.layer addAnimation:transition forKey:@"ExpandTransition"];
}

- (NSAttributedString *)_attributedStringWithText:(NSString *)text font:(UIFont *)font andColor:(UIColor *)color
{
    if (!text) {
        return nil;
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [paragraphStyle setAlignment:NSTextAlignmentLeft];
    
    NSDictionary *attrs = @{NSFontAttributeName : font,
                            NSForegroundColorAttributeName : color,
                            NSParagraphStyleAttributeName : paragraphStyle};
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:text attributes:attrs];
    
    return attrString;
}

#pragma mark - Public Methods

#pragma mark - Delegate

#pragma mark - Properties

- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    
    NSAttributedString *attrString = [self _attributedStringWithText:_title.uppercaseString
                                                                font:[UIFont fontWithName:@"HelveticaNeue" size:18]
                                                            andColor:[UIColor blackColor]];
    _titleTextNode.attributedText = attrString;
}

- (void)setInfo:(NSString *)info
{
    _info = [info copy];
    
    NSAttributedString *attrString = [self _attributedStringWithText:_info
                                                                font:[UIFont fontWithName:@"HelveticaNeue" size:14]
                                                            andColor:[UIColor blackColor]];
    
    _descriptionTextNode.attributedText = attrString;
}

@end
