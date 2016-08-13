//
//  UpView.m
//  ObjcSplines
//
//  Created by 于海涛 on 16/8/13.
//  Copyright © 2016年 于海涛. All rights reserved.
//

#import "UpView.h"

@interface UpView()

/** 选中按钮数组 */
@property (nonatomic, strong) NSMutableArray *selectBtnArray;

/** 当前手指的位置 */
@property (nonatomic, assign) CGPoint curP;

@end

@implementation UpView

//懒加载数组
- (NSMutableArray *)selectBtnArray
{
    if (_selectBtnArray == nil) {
        _selectBtnArray = [NSMutableArray array];
    }
    return _selectBtnArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //添加子控件
        [self setUp];
    }
    return self;
}


//添加子控件
- (void)setUp
{
    //添加9个按钮
    for (int i = 0; i < 9; i++) {
        //创建按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.userInteractionEnabled = NO;
        btn.tag = i;
        //设置按钮图片
        [btn setImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        //设置按钮选中的状态
        [btn setImage:[UIImage imageNamed:@"gesture_node_selected"] forState:UIControlStateSelected];
        //将按钮添加到父控件
        [self addSubview:btn];
    }
}

//布局子控件
- (void)layoutSubviews
{
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat WH = 74;
    
    int column = 3;
    
    int curColumn = 0;
    int curRow = 0;
    CGFloat margin = (self.frame.size.width - WH * 3) / (column + 1);
    
    for (int i = 0; i < self.subviews.count; i++) {
        //当前所在的列
        curColumn = i % column;
        //当前所在的行
        curRow = i / column;
        x = margin + (margin + WH) * curColumn;
        y = margin + (margin + WH) * curRow;
        
        //设置每一个按钮的frame
        self.subviews[i].frame = CGRectMake(x, y, WH, WH);
    }
    
    
}

//按功能模块抽取
//获取当前手指的点
- (CGPoint)getCurPoint:(NSSet *)touches
{
    UITouch *touch = [touches anyObject];
    CGPoint curP = [touch locationInView:self];
    return curP;
}

//给定一个点,判断这个点在不在按钮身上
//如果没有找到符合的条件,就返回nil(为什么不在这里直接修改按钮的状态,修改功能性代码最好不要写在抽取的方法中,不然下次需求改变时,还得修改)
- (UIButton *)btnContainsPoint:(CGPoint)point
{
    for (UIButton *btn in self.subviews) {
        if (CGRectContainsPoint(btn.frame, point)) {
            return btn;
        }
    }
    return nil;
}


//手指开始点击时
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //获取手指的点
    CGPoint curP = [self getCurPoint:touches];
    //判断当前点在不在按钮身上
    UIButton *btn = [self btnContainsPoint:curP];
    if (btn && btn.selected == NO) {  //如果按钮不为空
        btn.selected = YES;
        //保存选中的按钮
        [self.selectBtnArray addObject:btn];
    }
    
}

//手指移动时
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //获取手指的点
    CGPoint curP = [self getCurPoint:touches];
    
    //记录当前手指的位置
    self.curP = curP;
    
    //判断当前点在不在按钮身上
    UIButton *btn = [self btnContainsPoint:curP];
    if (btn && btn.selected == NO) {  //如果按钮不为空
        btn.selected = YES;
        //保存选中的按钮
        [self.selectBtnArray addObject:btn];
    }
    //重绘
    [self setNeedsDisplay];
}


//手指移开时
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //保存用户的手势解锁的顺序
    NSMutableString *str = [NSMutableString string];
    //所有选中按钮取消选中状态
    for (UIButton *btn in self.selectBtnArray) {
        btn.selected = NO;
        [str appendFormat:@"%ld", btn.tag];
    }
    
    NSLog(@"%@", str);
    
    [self.selectBtnArray removeAllObjects];
    
    [self setNeedsDisplay];
}

//绘制解锁
- (void)drawRect:(CGRect)rect
{
    if (self.selectBtnArray.count) {    //选中按钮数组有值使才绘制
        UIBezierPath *path = [UIBezierPath bezierPath];
        for (int i = 0; i < self.selectBtnArray.count; i++) {
            //取出按钮
            UIButton *btn = self.selectBtnArray[i];
            //如果说按钮是第一个,让按钮的中心点是路径的起点.
            if (i == 0) {
                [path moveToPoint:btn.center];
            } else {
                [path addLineToPoint:btn.center];
            }
        }
        
        //添加一根线到当前手指所在的点
        [path addLineToPoint:self.curP];
        
        //设置线的状态
        [path setLineWidth:5];
        [[UIColor greenColor] setStroke];
        path.lineCapStyle = kCGLineCapRound;
        path.lineJoinStyle = kCGLineJoinRound;
        [path stroke];
    }
}


@end
