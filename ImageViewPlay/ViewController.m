//
//  ViewController.m
//  ImageViewPlay
//
//  Created by wuzhiguang on 2018/8/2.
//  Copyright © 2018年 红爵科技. All rights reserved.
//

#import "ViewController.h"
#import "PicRotateView.h"

@interface ViewController ()
{
    PicRotateView * picRotateView;
}
@property (weak, nonatomic) IBOutlet UIView *rotaryBgview;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    picRotateView = [[PicRotateView alloc] initWithFrame:CGRectZero];
    [self.rotaryBgview addSubview:picRotateView];
    
    NSBundle * mainBundle = [NSBundle mainBundle];
    NSMutableArray * picList = [NSMutableArray array];
    for(int i = 0; i< 100; i++)
    {
        NSString * imagePath = [mainBundle pathForResource:[NSString stringWithFormat:@"1_%d",i] ofType:@"png"];
        [picList addObject:imagePath];
    }
    picRotateView.picList = picList;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    picRotateView.frame = self.rotaryBgview.bounds;
    picRotateView.image = [UIImage imageNamed:@"1_0"];
    [self startView];
}

- (void)startView
{
    [picRotateView startRotPicture];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
