//
//  SwipeableCell.m
//  swipeToPeep
//
//  Created by mark on 25/08/2014.
//  Copyright (c) 2014 itchingpixels. All rights reserved.
//

#import "SwipeToPeepCell.h"
#define MCANIMATE_SHORTHAND
#import <POP+MCAnimate.h>
#import "CircleProfileImageView.h"

#define horizontalSensitivy 0.7

@interface SwipeToPeepCell ()

@property (nonatomic) UIView *interactiveBackground;

@end

@implementation SwipeToPeepCell


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.nameLabel.textColor = [UIColor whiteColor];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        
        self.previewLabel.textColor = [UIColor whiteColor];
        self.previewLabel.backgroundColor = [UIColor clearColor];
        

        
    }
    return self;

}



- (void)configureSwipeableCell {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    pan.delegate = self;
    [self addGestureRecognizer:pan];
}


- (void)pan:(UIPanGestureRecognizer*)gestureRecognizer {
    
    CGPoint touchLocation = [gestureRecognizer locationInView:nil];
    CGPoint touchVelocity = [gestureRecognizer velocityInView:nil];
    float progress = 1- (touchLocation.x / self.frame.size.width);
        
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self changeBackgroundColorBasedOnProgress:1];
        [self.delegate swipeableCellDidStartSwiping:self];
        NSLog(@"cell: UIGestureRecognizerStateBegan");
    } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        [self changeBackgroundColorBasedOnProgress:progress];
        [self.delegate swipeableCell:self didSwipeWithHorizontalPosition:touchLocation.x progress:progress];
    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"cell: UIGestureRecognizerStateEnded");
        [self changeBackgroundColorBasedOnProgress:0];
        if (progress >= horizontalSensitivy || touchVelocity.x < -300) {
            [self.delegate swipeableCellCompletedSwiping:self];
        } else {
            [self.delegate swipeableCellCancelledSwiping:self];
        }
    }
}



#pragma mark GestureRecognizer magic
         
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer class] == [UIPanGestureRecognizer class]) {
        CGPoint point = [gestureRecognizer velocityInView:nil];
        
        if (point.x > 0) {
            return NO;
        }
        
        if (fabsf(point.x) > fabsf(point.y) ) {
            return YES;
        }
        
        return NO;
    }
    return YES;

}

#pragma mark Private methods

- (void)changeBackgroundColorBasedOnProgress:(float)progress {
    
    self.interactiveBackground.alpha = progress;

}


- (void)didMoveToSuperview {
    self.interactiveBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,  self.bounds.size.height)];
    self.interactiveBackground.backgroundColor = [UIColor flatGrayColor];
    self.interactiveBackground.alpha = 0;
    [self insertSubview:self.interactiveBackground atIndex:0];
}


@end
