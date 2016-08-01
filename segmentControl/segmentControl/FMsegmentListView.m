//
//  FMsegmentListView.m
//  segmentControl
//
//  Created by qianjn on 16/8/1.
//  Copyright © 2016年 SF. All rights reserved.
//

#import "FMsegmentListView.h"
#import "UIView+Ext.h"

#define kTopBarHeight 40
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)

@interface FMsegmentListView()<UIScrollViewDelegate>
{
    UIScrollView   *_topBarScrollView;
    UIScrollView   *_bottomScrollow;
    NSMutableArray *_buttonList;
    NSMutableArray *_scrollowList; //底部scrollow中三个子UIView 循环利用
    UIView         *_sliderLine;
    NSInteger      _currentIndex;
    CGFloat        _kBtnWidth;
    BOOL           _isAnimating;
    NSMutableArray *_segmentViews;
    CGFloat        _lastOffsetX;
    
}
@end



@implementation FMsegmentListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpInit];
    }
    return self;
}


- (void)setUpInit
{
    _textColor = [UIColor whiteColor];
    _buttonList = [NSMutableArray array];
    _scrollowList = [NSMutableArray array];
    _segmentViews = [NSMutableArray array];
}


-(void)setSegmentList:(NSArray *)segmentList
{
    _segmentList = segmentList;
    for (int index = 0; index < segmentList.count; index++) {
        NSDictionary *param = segmentList[index];
        [_segmentViews addObject:[param valueForKey:@"view"]];
    }
    [self buildUI];
    
    [_scrollowList[0] addSubview:_segmentViews[0]];
    [_scrollowList[1] addSubview:_segmentViews[1]];
    [_scrollowList[2] addSubview:_segmentViews[2]];
}


#pragma mark - BuildUI
- (void)buildUI
{
    [self buildTopbar];
    [self buildSliderView];
    [self buildScrollow];
    [self layoutSubviews];
}


- (void)buildTopbar
{
    _topBarScrollView = [[UIScrollView alloc] init];
    _topBarScrollView.directionalLockEnabled = YES;
    _topBarScrollView.bounces = NO;
    _topBarScrollView.showsVerticalScrollIndicator = NO;
    _topBarScrollView.showsHorizontalScrollIndicator = NO;
    _topBarScrollView.backgroundColor = [UIColor orangeColor];
    [self addSubview:_topBarScrollView];
    
    CGFloat kMaxWidth = 0;
    
    for (int index = 0; index < _segmentList.count; index++) {
        NSDictionary *config = _segmentList[index];
        NSString *title = [config valueForKey:@"title"];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor redColor];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.tag = 500 + index;
        
        [btn addTarget:self action:@selector(selectItem:) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat tempWidth = [btn sizeThatFits:btn.bounds.size].width;
        if (tempWidth > kMaxWidth) {
            kMaxWidth = tempWidth;
        }
        [_topBarScrollView addSubview:btn];
        [_buttonList addObject:btn];
        
    }
    
    if (kMaxWidth * _buttonList.count < kScreenWidth) {
        kMaxWidth = kScreenWidth / _buttonList.count;
        for (UIButton *btn in _buttonList) {
            btn.size = CGSizeMake(kMaxWidth + 10, kTopBarHeight);
        }
    } else {
        for (UIButton *btn in _buttonList) {
            btn.size = CGSizeMake(kMaxWidth + 10, kTopBarHeight);
        }
    }
    _kBtnWidth = kMaxWidth + 10;
    _topBarScrollView.contentSize = CGSizeMake(_kBtnWidth * _buttonList.count, kTopBarHeight);

}

- (void)buildSliderView
{
    _sliderLine = [[UIView alloc] init];
    _sliderLine.backgroundColor = [UIColor whiteColor];
    [self setSliderLineAtIndex:0];
    [_topBarScrollView addSubview:_sliderLine];
}

- (void)buildScrollow
{
    _bottomScrollow = [[UIScrollView alloc] init];
    _bottomScrollow.delegate = self;
    _bottomScrollow.pagingEnabled = YES;
    _bottomScrollow.backgroundColor = [UIColor darkGrayColor];
    [self addSubview:_bottomScrollow];
    
    for (int index = 0; index < 3; index++) {
        UIView *subView = [[UIView alloc] init];
        subView.tag = 1000 + index;
        [_bottomScrollow addSubview:subView];
        [_scrollowList addObject:subView];
        if (index == 1) {
            subView.backgroundColor = [UIColor greenColor];
        }
    }
    _bottomScrollow.contentSize = CGSizeMake(self.width * 3, self.height - kTopBarHeight);
    
}

#pragma mark - action

- (void)selectItem:(UIButton *)sender
{
    NSInteger index = [_buttonList indexOfObject:sender];
    [self setSliderLineAtIndex:index];
    
    _currentIndex = index;
    _isAnimating = YES;
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:0.4 animations:^{
        for (UIButton *btn in _buttonList) {
            btn.titleLabel.alpha = 0.8;
            btn.titleLabel.tag = 555;
        }
        
        UILabel* label = [sender viewWithTag:555];
        label.alpha = 1;

    } completion:^(BOOL ok){
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        _isAnimating = NO;
    }];
    
    [self clickTapToDealScrollow:_currentIndex];
    
    NSDictionary *config = _segmentList[_currentIndex];
    NSString *actionName = [NSString stringWithFormat:@"%@", [config valueForKey:@"action"]];
    [self currentIndexResponse:actionName];
    
}


- (void)currentIndexResponse:(NSString *)actionName
{
    SEL method = NSSelectorFromString(actionName);
    
    UIResponder *responder = [self nextResponder];
    while (responder) {
        if([responder respondsToSelector:method]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [responder performSelector:method withObject:@(_currentIndex)];
#pragma clang diagnostic pop
            break;
        }
        responder = responder.nextResponder;
    }
}


- (void)clickTapToDealScrollow:(NSInteger)index
{
    
    
    [_bottomScrollow setContentOffset:CGPointMake(kScreenWidth, 0)];
    for (int i = 0; i < _scrollowList.count; i++) {
        UIView *subView = _scrollowList[i];
        [subView removeAllSubviews];
    }
    
    if (index == 0) {
        [_scrollowList[0] addSubview:_segmentViews.lastObject];
        [_scrollowList[1] addSubview:_segmentViews.firstObject];
        [_scrollowList[2] addSubview:_segmentViews[index + 1]];
    }
    
    if (index == _segmentViews.count - 1) {
        
        [_scrollowList[0] addSubview:_segmentViews[_segmentViews.count - 2]];
        [_scrollowList[1] addSubview:_segmentViews.lastObject];
        [_scrollowList[2] addSubview:_segmentViews.firstObject];
    }
    
    if (index > 0 && index < _segmentViews.count - 1) {
        [_scrollowList[0] addSubview:_segmentViews[index - 1]];
        [_scrollowList[1] addSubview:_segmentViews[index]];
        [_scrollowList[2] addSubview:_segmentViews[index + 1]];
    }

    
    
}



- (void)scrollowToDealTopBarScrollow
{
    if (_currentIndex == 0) {
        [_scrollowList[0] addSubview:_segmentViews.lastObject];
        [_scrollowList[1] addSubview:_segmentViews[0]];
        [_scrollowList[2] addSubview:_segmentViews[1]];
    }
    
    if (_currentIndex == _buttonList.count - 1) {
        
        [_scrollowList[0] addSubview:_segmentViews[_segmentViews.count - 2]];
        [_scrollowList[1] addSubview:_segmentViews.lastObject];
        [_scrollowList[2] addSubview:_segmentViews.firstObject];
    }
    
    if (_currentIndex  > 0 && _currentIndex < _segmentViews.count - 1) {
        [_scrollowList[0] addSubview:_segmentViews[_currentIndex - 1]];
        [_scrollowList[1] addSubview:_segmentViews[_currentIndex]];
        [_scrollowList[2] addSubview:_segmentViews[_currentIndex + 1]];
    }
    
    if (_currentIndex > 0 && _currentIndex > _segmentViews.count - 1) { //滚到最后一张再往右滚动回到第一张
        
        [_scrollowList[0] addSubview:_segmentViews.lastObject];
        [_scrollowList[1] addSubview:_segmentViews[0]];
        [_scrollowList[2] addSubview:_segmentViews[1]];
        _currentIndex = 0;
    }
    
    if (_currentIndex < 0) { //第0张得时候再往左滑动 滚动最后一张
        [_scrollowList[0] addSubview:_segmentViews[_segmentViews.count - 2]];
        [_scrollowList[1] addSubview:_segmentViews.lastObject];
        [_scrollowList[2] addSubview:_segmentViews.firstObject];
        _currentIndex = _segmentViews.count - 1;
    }

    [self setSliderLineAtIndex:_currentIndex];
    
    NSDictionary *config = _segmentList[_currentIndex];
    NSString *actionName = [NSString stringWithFormat:@"%@", [config valueForKey:@"action"]];
    [self currentIndexResponse:actionName];
}


#pragma mark - layout & frame

- (void)layoutSubviews
{
    [super layoutSubviews];
    _topBarScrollView.frame = CGRectMake(0, 0, self.width, kTopBarHeight);
    _bottomScrollow.frame = CGRectMake(0, kTopBarHeight, self.width, self.height - kTopBarHeight);
    for (int index = 0; index < _buttonList.count; index++) {
        UIButton *btn = _buttonList[index];
        btn.frame = CGRectMake(index * btn.width, 0, btn.width, btn.height);
    }
    
    for (int index = 0; index < _scrollowList.count; index++) {
        UIView *subView = _scrollowList[index];
        subView.frame = CGRectMake(index * self.width, 0, self.width, self.height - kTopBarHeight);
    }
    
    _topBarScrollView.contentInset = UIEdgeInsetsZero;
    _bottomScrollow.contentInset = UIEdgeInsetsZero;
    
}

- (void)setSliderLineAtIndex:(NSInteger)index
{
    [UIView animateWithDuration:0.5 animations:^{
        _sliderLine.frame = CGRectMake(index * _kBtnWidth, kTopBarHeight - 3, _kBtnWidth, 3);
    }];
    
    if (_topBarScrollView.contentSize.width > kScreenWidth) {
        [self dealWithTopBarScrollViewContentOffset:index];
    }
}

- (void)dealWithTopBarScrollViewContentOffset:(NSInteger)index
{
    CGFloat centerX = _kBtnWidth * index + _kBtnWidth/2;
    //当前的按钮处于可居中的范围
    if (centerX > kScreenWidth /2 && centerX < (_topBarScrollView.contentSize.width - _kBtnWidth)) {
        
        CGFloat span = (kScreenWidth - _kBtnWidth)/2;
        CGFloat concentX = index * _kBtnWidth - span;
        
        if (concentX > (_topBarScrollView.contentSize.width - kScreenWidth)) {
            concentX = _topBarScrollView.contentSize.width - kScreenWidth;
        }
        [_topBarScrollView setContentOffset:CGPointMake(concentX, 0) animated:YES];
        
    } else if (index < _buttonList.count / 2){ //左半部分
        _topBarScrollView.contentOffset = CGPointZero;
    } else {  //右半部分
        _topBarScrollView.contentOffset = CGPointMake(_topBarScrollView.contentSize.width - kScreenWidth, 0);
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _lastOffsetX  = scrollView.contentOffset.x;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if (scrollView.contentOffset.x > _lastOffsetX) { //向右
        
        _currentIndex = _currentIndex + 1;
    } else {                                         //向左
        _currentIndex = _currentIndex - 1;
        
    }
    
    [_bottomScrollow setContentOffset:CGPointMake(kScreenWidth, 0)];
    for (int i = 0; i < _scrollowList.count; i++) {
        UIView *subView = _scrollowList[i];
        [subView removeAllSubviews];
    }
    
    [self scrollowToDealTopBarScrollow];
    
}
@end
