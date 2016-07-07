//
//  UIView+MyUIView.m
//  TestView
//
//  Created by leotao on 16/3/16.
//  Copyright © 2016年 ZS. All rights reserved.
//

#import "UIView+MyUIView.h"
#import <objc/runtime.h>

@implementation UIView (MyUIView)

const void *s_HYBCallbackKey = "s_HYBCallbackKey";
const void *my_name = "my_name";

- (void)setCallback:(HYBCallBack)callback {
    objc_setAssociatedObject(self, s_HYBCallbackKey, callback, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (HYBCallBack)callback {
    return objc_getAssociatedObject(self, s_HYBCallbackKey);
}

-(void)setMyViewName:(NSString *)myViewName{

    objc_setAssociatedObject(self, my_name, myViewName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(NSString *)myViewName{

    return objc_getAssociatedObject(self, my_name);
}



@end
