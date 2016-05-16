//
//  ViewController.m
//  UIGestureRecognizer
//
//  Created by Karma on 16/5/16.
//  Copyright © 2016年 陈昆涛. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic,strong)NSMutableArray *imageList;
@property (weak, nonatomic) IBOutlet UILabel *longPressLable;
@property (nonatomic,assign)NSInteger imageIndex;
@end

@implementation ViewController
//把照片存入数组
-(UIImageView *)imageList{
    if (_imageList == nil) {
        _imageList = [NSMutableArray array];
        for (int i = 1; i < 4; i++) {
            NSString *imageName = [NSString stringWithFormat:@"%d", i];
            UIImage *image = [UIImage imageNamed:imageName];
            [_imageList addObject:image];
        }
        
    }
    return _imageList;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.imageIndex = 1;
    //初始化手势对象
    //开启用户交互，否则无法识别手势
    self.imageView.userInteractionEnabled = YES;
    //单击，单手指
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    //单击
    singleTap.numberOfTapsRequired = 1;
    //单手指
    singleTap.numberOfTouchesRequired = 1;
    //添加到imageView
    [self.imageView addGestureRecognizer:singleTap];
    UITapGestureRecognizer * doubleTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.numberOfTapsRequired=1;
    doubleTap.numberOfTouchesRequired=2;
    [self.imageView addGestureRecognizer:doubleTap];
    //捏合手势+图片变大变小+旋转
    UIPinchGestureRecognizer *pinchScale=[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchScale:)];
    [self.imageView addGestureRecognizer:pinchScale];
    UIRotationGestureRecognizer *rotation=[[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotation:)];
    [self.imageView addGestureRecognizer:rotation];
    //默认情况滑动为右边
    UISwipeGestureRecognizer *right = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipe:)];
    UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipe:)];
    left.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.imageView addGestureRecognizer:right];
    [self.imageView addGestureRecognizer:left];
    //拖动手势
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.imageView addGestureRecognizer:panGesture];
    //长按手势
    UILongPressGestureRecognizer *longPressGesture=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longpress:)];
    [self.imageView addGestureRecognizer:longPressGesture];
    
}
-(void) singleTap:(UIGestureRecognizer *) gesture {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"单击+单手指" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
-(void)doubleTap:(UIGestureRecognizer *)gesture{
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"单击+双手指" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action =[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}
-(void)pinchScale:(UIPinchGestureRecognizer *)gesture{
    CGFloat scale = gesture.scale;
    self.imageView.transform = CGAffineTransformScale(gesture.view.transform, scale, scale);
    //一定要把scale的值重置为1，否则会影响缩放效果，即缩放比例会在上一次基础上进行缩小/放大
    gesture.scale = 1;
}
-(void)rotation:(UIRotationGestureRecognizer *)gesture{
    CGFloat rotation = gesture.rotation;
    self.imageView.transform = CGAffineTransformRotate(gesture.view.transform, rotation);
    //一定要把rotation的值重置为0，否则会影响旋转效果
    gesture.rotation = 0;
}
-(void) swipe: (UISwipeGestureRecognizer *) gesture {
    int totalCount = self.imageList.count;
    
    if (gesture.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (self.imageIndex >= totalCount -1) return;
        self.imageView.image = self.imageList[++self.imageIndex];
    }else if (gesture.direction == UISwipeGestureRecognizerDirectionRight) {
        if (self.imageIndex <= 0) return;
        self.imageView.image = self.imageList[--self.imageIndex];
    }
}
-(void) pan: (UIPanGestureRecognizer *) gesture {
    //获取位置变化量translation
    CGPoint translation = [gesture translationInView:self.view];
    gesture.view.center = CGPointMake(gesture.view.center.x + translation.x, gesture.view.center.y + translation.y);
    [gesture setTranslation:CGPointZero inView:self.view];
}
-(void)longpress:(UILongPressGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"长按开始");
        self.longPressLable.text = @"长按开始";
    }else if (gesture.state == UIGestureRecognizerStateEnded){
        NSLog(@"长按结束");
        self.longPressLable.text = @"长按结束";
    }
    else {
        NSLog(@"长按中");
        self.longPressLable.text = @"长按中";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
