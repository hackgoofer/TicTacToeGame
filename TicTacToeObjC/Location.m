//
//  Location.m
//  TicTacToeObjC
//
//  Created by Sasha Sheng on 5/14/15.
//  Copyright (c) 2015 Sasha Sheng. All rights reserved.
//

#import "Location.h"

@implementation Location
- (void)setPawnType:(NSInteger)pawnType
{
    _pawnType = pawnType;
    if (_pawnType == 1) {
        [self drawCross];
    } else if (_pawnType == 2) {
        [self drawCircle];
    } else {
        for (CALayer *layer in self.layer.sublayers) {
            [layer removeFromSuperlayer];
        }
    }
}

- (void)drawCross
{
    UIBezierPath *crossPath = [UIBezierPath bezierPath];
    crossPath.lineWidth = 2.0;
    
    CGFloat x0 = 8.0;
    CGFloat y0 = 8.0;
    CGFloat x1 = self.frame.size.width - 8.0;
    CGFloat y1 = self.frame.size.height - 8.0;
    
    [crossPath moveToPoint:CGPointMake(x0, y0)];
    [crossPath addLineToPoint:CGPointMake(x1, y1)];
    
    [crossPath moveToPoint:CGPointMake(x1, y0)];
    [crossPath addLineToPoint:CGPointMake(x0, y1)];
    
    CAShapeLayer *crossLayer = [CAShapeLayer layer];
    crossLayer.path = crossPath.CGPath;
    crossLayer.fillColor = [UIColor clearColor].CGColor;
    crossLayer.strokeColor = [UIColor redColor].CGColor;
    crossLayer.lineWidth = 2.0;
    
    [self.layer addSublayer:crossLayer];
}

- (void)drawCircle
{
    CGFloat radius = self.bounds.size.width/2-8.0;
    CGPoint center = self.center;
    center.x -= self.frame.origin.x;
    center.y -= self.frame.origin.y;
    UIBezierPath *circle = [UIBezierPath bezierPathWithArcCenter:center
                                                          radius:radius
                                                      startAngle:0
                                                        endAngle:2.0*M_PI
                                                       clockwise:YES];
    
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.path   = circle.CGPath;
    circleLayer.strokeColor = [UIColor whiteColor].CGColor;
    circleLayer.fillColor = [UIColor clearColor].CGColor;
    circleLayer.lineWidth   = 2.0;
    [self.layer addSublayer:circleLayer];
}
@end
