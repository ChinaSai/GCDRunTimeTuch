//
//  UIView+MyUIView.h
//  TestView
//
//  Created by leotao on 16/3/16.
//  Copyright © 2016年 ZS. All rights reserved.
//

#import <UIKit/UIKit.h>
// 由于扩展不能扩展属性，因此我们这里在实现文件中需要利用运行时实现。
typedef void(^HYBCallBack)();

@interface UIView (MyUIView)
@property (nonatomic, copy) HYBCallBack callback;
@property (nonatomic, copy) NSString * myViewName;

@end
