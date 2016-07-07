//
//  ViewController.m
//  TestView
//
//  Created by leotao on 16/3/14.
//  Copyright © 2016年 ZS. All rights reserved.
//


#import "ViewController.h"
#import "Person.h"

#import "UIView+MyUIView.h"

#import <objc/runtime.h>

typedef struct objc_property *objc_property_t;

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate,UIViewControllerAnimatedTransitioning>

@property (nonatomic,strong) UIView *mainView;
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, assign) BOOL isDraging;
@property (nonatomic, strong) UITableView * tableView;

@end

@implementation ViewController



-(UITableView *)tableView{

    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        _tableView.backgroundColor = [UIColor grayColor];
        _tableView.delegate =self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _mainView = [[UIView alloc] initWithFrame:self.view.bounds];
    _mainView.backgroundColor = [UIColor redColor];
    
//    [self.view addSubview:_mainView];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 40)];
    [button setTitle:@"pop" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIView *view = [[UIView alloc] init];
    [view setMyViewName:@"haha"];
    NSLog(@"view name is :%@", [view myViewName]);
    
    [self.view addSubview:self.tableView];
    //    [self testRunTime];
    dispatch_queue_t queue = dispatch_queue_create("com.huangyibiao.helloworld", NULL);
    
    dispatch_async(queue, ^{
        NSLog(@"开启了一个异步任务，当前线程：%@", [NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"开启了一个同步任务，当前线程：%@", [NSThread currentThread]);
    });
    
    
    NSArray *tempObj = @[@"hello", @"erliangzi"];
    NSLog(@"tempObj:%@", tempObj);
    object_setClass(tempObj, [NSObject class]);
    NSLog(@"tempObj:%@", tempObj);
    
    // MRC下才能调用，对于ARC就不能添加这行代码了。
//    dispatch_release(queue);

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _tableView) {
        CGFloat sectionHeaderHeight = 0;
        
        NSLog(@"%f", scrollView.contentOffset.y);
        if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *identf = @"cell";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:identf forIndexPath:indexPath];
    cell.textLabel.text = @"niha";
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 40;
}

- (void)clicked{
    
    _leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, self.view.bounds.size.height)];
    _leftView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_leftView];
    
    [_leftView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];

}

// 当_leftView的frame属性改变的时候就会调用
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    //    NSLog(@"%@", NSStringFromCGRect(_mainView.frame));
    
    if (_leftView.frame.origin.x < 0) { // 往左移动
        
        if (_leftView.frame.origin.x < -20 ) {
            
            // 获取之前的frame
//            __block CGRect frame = _leftView.frame;
            
            [UIView animateWithDuration:2.0 animations:^{

                 _leftView.transform = CGAffineTransformMakeTranslation(-150, _leftView.frame.size.height);
                
            } completion:^(BOOL finished) {
                _leftView.hidden = YES;
            }];
            
        }
    }else if (_leftView.frame.origin.x > 0){ // 往右移动
       
        NSLog(@"frame.origin.x = %f",_leftView.frame.origin.x);
        
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    // 获取UITouch对象
    UITouch *touch = [touches anyObject];
    // 获取当前点
    CGPoint currentPoint = [touch locationInView:_leftView];
    
    // 获取上一个点
    CGPoint prePoint = [touch previousLocationInView:_leftView];
    
    // x轴偏移量：当手指移动一点的时候，x偏移多少
    CGFloat offsetX = currentPoint.x - prePoint.x;
    NSLog(@"%f, %f",currentPoint.x , prePoint.x);
    // 设置当前主视图的frame
    _leftView.frame = [self getCurrentFrameWithOffsetX:offsetX];
    _isDraging = YES;
}

#define HMMaxY 60
- (CGRect)getCurrentFrameWithOffsetX:(CGFloat)offsetX
{
    CGRect frame = _leftView.frame;

    frame.origin.x += offsetX;
    frame.size.height = frame.size.height ;
    frame.size.width = frame.size.width ;
    
    
    return frame;
    
    
}


-(void)testRunTime{

    //    Person *p = [[Person alloc] init];
    //    for (NSString *properyise in p.allProperties) {
    //        NSLog(@"properyise is %@", properyise);
    //
    //    }
    
    //    for (NSString *varName in p.allMemberVariables) {
    //        NSLog(@"%@", varName);
    //    }
    
    //    [p allMethods];
    //    [p setName:@"haha"];
    //    NSDictionary *dict =  p.allPropertyNamesAndValues;
    //    NSLog(@"dict is :%@", dict);
    //    for (NSString *propertyName in dict.allKeys) {
    //        NSLog(@"propertyName: %@ propertyValue: %@", propertyName, dict[propertyName]);
    //    }

}

//#define HMRTarget 50
//#define HMLTarget -50
//// 定位
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    
//    
//    // 复位
//    if (_isDraging == NO && _mainView.frame.origin.x != 0) {
//        [UIView animateWithDuration:0.25 animations:^{
//            
//            _leftView.frame = self.view.bounds;
//        }];
//    }
//    
//    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
//    
//    CGFloat target = 0;
//    if (_leftView.frame.origin.x > screenW * 0.5) { // 定位到右边
//        target = HMRTarget;
//    }else if (CGRectGetMaxX(_leftView.frame) < screenW * 0.5) { // 定位到左边
//        target = HMLTarget;
//    }
//    
//    [UIView animateWithDuration:0.25 animations:^{
//        
//        if (target) { // 在需要定位左边或者右边
//            
//            // 获取x轴偏移量
//            CGFloat offsetX = target - _leftView.frame.origin.x;
//            
//            // 设置当前主视图的frame
//            _leftView.frame = [self getCurrentFrameWithOffsetX:offsetX];
//            
//        }else{ // 还原
//            _leftView.frame = self.view.bounds;
//        }
//    }];
//    
//    _isDraging = NO;
//    
//}


-(void)test{

    NSInvocationOperation *operation= [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downLoadImage:) object:@"url"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];

}

-(void)downLoadImage:(NSString *)url{

    NSURL *ursl = [NSURL URLWithString:url];
    NSData *data = [[NSData alloc] initWithContentsOfURL:ursl];
    
    UIImage *image = [UIImage imageWithData:data];
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        UIImageView *imageview = [[UIImageView alloc] init];
        imageview.image = image;
        
    });
    

}


-(void)nsblockOperation{

    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"main inner ");
        [NSThread currentThread];
        [NSThread isMainThread];
        [operation isAsynchronous];
    }];
    __weak typeof(operation) weakOperation = operation;
    
    [operation addExecutionBlock:^{
        NSLog(@"son thread ");
        [NSThread currentThread];
        [NSThread isMainThread];
        [weakOperation isAsynchronous];
    }];
    
    
}

-(void)gcdGroup{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
       
        //创建一个组
        dispatch_group_t group = dispatch_group_create();
        __block UIImage *image1 = nil;
        __block UIImage *image2 = nil;
        // 分别将任务添加到组中
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           
        });
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
        });
        
        //等待执行完毕回到主线程blcok回调 单任务是调用
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//        });
        
        //等待组中执行完毕后回到主线程blcok回调
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            
        });
        
    });
}

-(void)cgdCreate{

    //后台执行
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    });
    
    
    //主线程执行
    dispatch_async(dispatch_get_main_queue(), ^{
    });
    
    //一次执行
    static dispatch_once_t onceTocken;
    dispatch_once(&onceTocken, ^{
        
    });
    
    //延迟执行
    double delySeconds = 2.0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delySeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
    });
    
    
    //让后台两个想成合并执行
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //并行执行线程一
    });
    dispatch_group_async(dispatch_group_create(), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //并行执行线程二
    });
    
    dispatch_group_notify(dispatch_group_create(), dispatch_get_main_queue(), ^{
        //汇总执行的结果
    });
    
}



@end
