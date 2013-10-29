//
//  ViewController.m
//  PlayBall
//
//  Created by Shi Lin on 10/28/13.
//  Copyright (c) 2013 Forrest Shi. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()<UICollisionBehaviorDelegate>

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIPushBehavior *pusher;
@property (nonatomic, strong) UICollisionBehavior *collider;
@property (nonatomic, strong) UIDynamicItemBehavior *paddleDynamicProperties;
@property (nonatomic, strong) UIDynamicItemBehavior *ballDynamicProperties;
@property (nonatomic, strong) UIAttachmentBehavior *attacher;


@end

@implementation ViewController

- (void)initBehaviors
{
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    // Start ball off with a push
    self.pusher = [[UIPushBehavior alloc] initWithItems:@[self.ball]
                                                   mode:UIPushBehaviorModeInstantaneous];
    self.pusher.pushDirection = CGVectorMake(0.5, 1.0);
    self.pusher.active = YES; // Because push is instantaneous, it will only happen once
    [self.animator addBehavior:self.pusher];
    
    // Step 1: Add collisions
    self.collider = [[UICollisionBehavior alloc] initWithItems:@[self.ball, self.paddle]];
    self.collider.collisionDelegate = self;
    self.collider.collisionMode = UICollisionBehaviorModeEverything;
    self.collider.translatesReferenceBoundsIntoBoundary = YES;
    [self.animator addBehavior:self.collider];
    
    // Step 2: Remove rotation
    self.ballDynamicProperties = [[UIDynamicItemBehavior alloc]
                                  initWithItems:@[self.ball]];
    self.ballDynamicProperties.allowsRotation = NO;
    [self.animator addBehavior:self.ballDynamicProperties];
    
    self.paddleDynamicProperties = [[UIDynamicItemBehavior alloc]
                                    initWithItems:@[self.paddle]];
    self.paddleDynamicProperties.allowsRotation = NO;
    [self.animator addBehavior:self.paddleDynamicProperties];
    
    // Step 3: Heavy paddle
    self.paddleDynamicProperties.density = 1000.0f;
    
    // Step 4: Better collisions, no friction
    self.ballDynamicProperties.elasticity = 1.0;
    self.ballDynamicProperties.friction = 0.0;
    self.ballDynamicProperties.resistance = 0.0;
    
    // Step 5: Move paddle
    self.attacher =
    [[UIAttachmentBehavior alloc]
     initWithItem:self.paddle
     attachedToAnchor:CGPointMake(CGRectGetMidX(self.paddle.frame),
                                  CGRectGetMidY(self.paddle.frame))];
    [self.animator addBehavior:self.attacher];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self initBehaviors];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    self.animator = nil;
    self.collider = nil;
    self.pusher = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.ball.layer.cornerRadius = self.ball.bounds.size.width/2;
    
    self.paddle.backgroundColor = [UIColor purpleColor];

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    [self.view addGestureRecognizer:pan];
}

- (void)onPan:(UIPanGestureRecognizer*)gesture{

    CGPoint location = [gesture locationInView:self.view];
    
    float moveX = location.x;
    if (moveX < 0.5 ) {
        moveX = 0.;
    }else if (moveX > self.view.bounds.size.width - 0.5 ){
        moveX = self.view.bounds.size.width;
    }
    self.attacher.anchorPoint = CGPointMake(moveX , self.attacher.anchorPoint.y);

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

#pragma mark - Collision delegate 

- (void)collisionBehavior:(UICollisionBehavior*)behavior beganContactForItem:(id <UIDynamicItem>)item1 withItem:(id <UIDynamicItem>)item2 atPoint:(CGPoint)p{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    [[AudioUtility sharedInstance] playSound:@"add" withType:@"wav"];
}
- (void)collisionBehavior:(UICollisionBehavior*)behavior endedContactForItem:(id <UIDynamicItem>)item1 withItem:(id <UIDynamicItem>)item2{
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

// The identifier of a boundary created with translatesReferenceBoundsIntoBoundary or setTranslatesReferenceBoundsIntoBoundaryWithInsets is nil
- (void)collisionBehavior:(UICollisionBehavior*)behavior beganContactForItem:(id <UIDynamicItem>)item withBoundaryIdentifier:(id <NSCopying>)identifier atPoint:(CGPoint)p{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    [[AudioUtility sharedInstance] playSound:@"count" withType:@"wav"];
}
- (void)collisionBehavior:(UICollisionBehavior*)behavior endedContactForItem:(id <UIDynamicItem>)item withBoundaryIdentifier:(id <NSCopying>)identifier{
    NSLog(@"%s",__PRETTY_FUNCTION__);
}
@end
