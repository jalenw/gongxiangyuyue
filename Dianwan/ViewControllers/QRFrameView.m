//
//  QRFrameView.m
//  WebServer
//
//  Created by 黄哲麟 on 2018/3/19.
//  Copyright © 2018年 黄哲麟. All rights reserved.
//

#import "QRFrameView.h"

@implementation QRFrameView

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 2.0);
    const CGFloat *components = CGColorGetComponents(self.color.CGColor);
    CGContextSetRGBStrokeColor(context, components[0],components[1],components[2],1);
    CGContextMoveToPoint(context, 0, 20);
    CGContextAddLineToPoint(context,
                            0, 0);
    CGContextAddLineToPoint(context,
                            20, 0);
    
    CGContextMoveToPoint(context, rect.size.width-20, 0);
    CGContextAddLineToPoint(context,
                            rect.size.width, 0);
    CGContextAddLineToPoint(context,
                            rect.size.width, 20);
    
    CGContextMoveToPoint(context, rect.size.width, rect.size.height-20);
    CGContextAddLineToPoint(context,
                            rect.size.width, rect.size.height);
    CGContextAddLineToPoint(context,
                            rect.size.width-20, rect.size.height);
    
    CGContextMoveToPoint(context, 20, rect.size.height);
    CGContextAddLineToPoint(context,
                            0, rect.size.height);
    CGContextAddLineToPoint(context,
                            0, rect.size.height-20);
    
    CGContextDrawPath(context, kCGPathStroke);
}
@end
