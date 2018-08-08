//
//  PicRotateView.m
//  ImageViewPlay
//
//  Created by wuzhiguang on 2018/8/2.
//  Copyright © 2018年 红爵科技. All rights reserved.
//

#import "PicRotateView.h"
//static int p = 0;
@interface PicRotateView()
{
//    UIImage * _currentImage;
    NSTimer * _animationTimer;
    NSDate * _currentTime;
    dispatch_queue_t   _defaultQueue;
    float    _lastX;
    int      _mTouchState;
    int      _mTouchSlop;
    int      TOUCH_MOVE;
    int      TOUCH_STAY;
}
@property (nonatomic, strong)UIImage * currentImage;
//-(void)startSpeedRot;
//-(void)startAutoRotTimer;
//-(void)stopAutoRotTimer;
@end

@implementation PicRotateView

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        [self setUserInteractionEnabled:YES];
        self.backgroundColor = [UIColor clearColor];
        _timerInterval = 0.04f;
        _currentIndex = -1;
        _defaultQueue = dispatch_get_main_queue();
        self.isNext = NO;
        TOUCH_MOVE = 1;
        TOUCH_STAY = -1;
        _lastX = -1;
        _mTouchSlop = 100;
        _mTouchState = TOUCH_STAY;
        UIPanGestureRecognizer * panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(stopAutoPic:)];
        [self addGestureRecognizer:panRecognizer];
    }
    return self;
}

- (void)setPicList:(NSArray *)picList
{
    _picList = picList;
}

- (void)drawCurrentImage:(NSInteger)index
{
    if (index ==-1)
    {
        _currentImage = nil;
    }
    else
    {
        NSInteger count = [self.picList count];
        if (index > -1 && index < count)
        {
           _currentImage = [self imageWithFilePath:[self.picList objectAtIndex:index]];
        }
        else
        {
            _currentImage = nil;
        }
    }
    _currentIndex = index;
    [self showCurrentImage];
}

- (void) showNext
{
    [self showNex:1];
}

- (void)showNex:(int)num
{
    NSInteger count = [self.picList count];
    if (count != 0)
    {
        NSInteger showIndex = _currentIndex;
        showIndex++;
        if (showIndex > count)
        {
            showIndex = 0;
        }
        [self drawCurrentImage:showIndex];
    }
    else
    {
        
    }
}
-(void)startRotPicture
{
    [self showNext];
}

- (void)showCurrentImage
{
    dispatch_async(_defaultQueue, ^{
        if (self.currentImage)
        {
            [self setImage:self.currentImage];
        }
        else
        {
            [self setImage:nil];
        }
    });
    [self performSelectorOnMainThread:@selector(nextShowPic:) withObject:nil waitUntilDone:YES];
}

- (void)nextShowPic:(id)time
{
    [self performSelector:@selector(startRotPicture) withObject:nil afterDelay:_timerInterval];
}

-(void)setTimerInterval:(NSTimeInterval)interval
{
    _timerInterval = interval;
}

- (UIImage *)imageWithFilePath:(NSString *)filePath
{
    NSURL *imageURL = [NSURL fileURLWithPath:filePath];
    NSDictionary *options = @{(__bridge id)kCGImageSourceShouldCache: @YES};
    CGImageSourceRef source = CGImageSourceCreateWithURL((__bridge CFURLRef)imageURL, NULL);
    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, 0,(__bridge CFDictionaryRef)options);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CFRelease(source);
//    UIImage * image = [UIImage imageWithContentsOfFile:filePath];
    return image;
}


- (void)showPreview:(int)num
{
    NSInteger count = [self.picList count];
    if (count != 0)
    {
        NSInteger showIndex = _currentIndex;
        showIndex = showIndex + (num);
        if (showIndex >= count)
        {
            showIndex = 0;
        }
        else if (showIndex < 0)
        {
            showIndex = count - 1;
        }
        [self drawPreviewImage:showIndex];
    }
}

- (void)drawPreviewImage:(NSInteger)index
{
    if (index ==-1)
    {
        _currentImage = nil;
    }
    else
    {
        NSInteger count = [self.picList count];
        if (index > -1 && index < count)
        {
            _currentImage = [self imageWithFilePath:[self.picList objectAtIndex:index]];
        }
        else
        {
            _currentImage = nil;
        }
    }
    _currentIndex = index;
//    NSLog(@"%ld",_currentIndex);
    [self showPreviewImage];
}

- (void)showPreviewImage
{
    dispatch_async(_defaultQueue, ^{
        if (self.currentImage)
        {
            [self setImage:self.currentImage];
        }
        else
        {
            [self setImage:nil];
        }
    });
}

- (void)stopAutoPic:(UIPanGestureRecognizer *)recognizer
{
    CGPoint velocity = [recognizer velocityInView:recognizer.view];
    CGPoint movePoint = [recognizer translationInView:recognizer.view];
    float x = movePoint.x;
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
//        NSLog(@"UIGestureRecognizerStateBegan");
        _lastX = x;
        _mTouchState = TOUCH_STAY;
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged)
    {
//         NSLog(@"UIGestureRecognizerStateChanged");
        int sDiff = (int)fabs(x-_lastX);
        BOOL xMoved = sDiff > _mTouchSlop;
        if (xMoved)
        {
            _mTouchState = TOUCH_MOVE;
        }
        if (_mTouchState == TOUCH_MOVE)
        {
            int deltaX = (int)fabs(_lastX - x);
            _lastX = x;
            int index = (deltaX/8);
            index = MAX(1, index);
            
            if (velocity.x > 0)
            {
                [self showPreview:-index];
            }
            else
            {
                [self showPreview:index];
            }
        }
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        NSLog(@"UIGestureRecognizerStateEnded");
        _mTouchState = TOUCH_STAY;
        [self performSelector:@selector(startRotPicture) withObject:nil afterDelay:3.0f];
        self.isNext = NO;
        
    }
   
//    CGPoint movePoint = [recognizer translationInView:recognizer.view];
//    NSLog(@"%f",movePoint.x);
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.isNext)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startRotPicture) object:nil];
//        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        self.isNext = !self.isNext;
//        NSLog(@"touchesEnded : %f",point.x);
    }
}


//-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    NSLog(@"touchesMoved");
//
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(nullable UIEvent *)event
//{
//    NSLog(@"touchesEnded");
//    [super touchesEnded:touches withEvent:event];
//    UITouch* touch = [touches anyObject];
//    CGPoint point  = [touch locationInView:self];
//    NSLog(@"touchesEnded : %f",point.x);
//}
//
//-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    NSLog(@"touchesCancelled");
////    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////        [self startRotPicture];
////        self.isNext = NO;
////    });
//
//    [self performSelector:@selector(startRotPicture) withObject:nil afterDelay:3.0f];
//    self.isNext = NO;
//}


@end
