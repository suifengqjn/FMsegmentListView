//
//  FMAdvertiseView.h
//  Pinnacle
//
//  Created by qianjianeng on 16/5/5.
//  Copyright © 2016年 5milesapp.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Ext)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize size;
/**
 设左上角坐标
 */
- (void)setLeft:(CGFloat)left top:(CGFloat)top;

/**
 设左下角坐标
 */
- (void)setLeft:(CGFloat)left bottom:(CGFloat)bottom;

/**
 设右上角坐标
 */
- (void)setRight:(CGFloat)right top:(CGFloat)top;

/**
 设右下角坐标
 */
- (void)setRight:(CGFloat)right bottom:(CGFloat)bottom;

- (void)removeAllSubviews;

@end
