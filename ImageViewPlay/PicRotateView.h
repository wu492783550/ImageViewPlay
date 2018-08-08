//
//  PicRotateView.h
//  ImageViewPlay
//
//  Created by wuzhiguang on 2018/8/2.
//  Copyright © 2018年 红爵科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PicRotateView :UIImageView
{
    CGPoint     _currentPoint;
    CGPoint     _startPoint;
    float       _rotSpeed;
    double       _timerInterval;
}

@property (nonatomic, strong) NSArray * picList;
@property (nonatomic, strong) NSDate  * oldTime;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) BOOL      isNext;

//-(void)setTimerInterval:(NSTimeInterval)interval;
//-(void)showPreview;
//-(void)showNext;
//-(void)showPreview:(int)num;
//-(void)showNext:(int)num;
-(void)startRotPicture;
//-(void)stopRotPicture;

@end
