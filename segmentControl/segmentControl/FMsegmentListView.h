//
//  FMsegmentListView.h
//  segmentControl
//
//  Created by qianjn on 16/8/1.
//  Copyright © 2016年 SF. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    FMSegmentControlStyleWhite,
    FMSegmentControlStyleOrange,
} FMSegmentControlStyle;

@interface FMsegmentListView : UIView

@property(strong,nonatomic) NSArray *segmentList;
@property(strong,nonatomic) UIColor *textColor;

@property(assign,nonatomic) FMSegmentControlStyle style;

- (instancetype)initWithFrame:(CGRect)frame;


@end
