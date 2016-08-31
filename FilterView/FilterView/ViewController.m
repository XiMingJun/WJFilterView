//
//  ViewController.m
//  FilterView
//
//  Created by wangjian on 16/5/12.
//  Copyright © 2016年 qhfax. All rights reserved.
//

#import "ViewController.h"
#import "FilterView.h"
@interface ViewController ()<FilterViewDelegate>
{
    
}
@property(nonatomic,retain)UIImageView *customImageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor brownColor];
    
}
- (IBAction)addFilterView:(UIButton *)sender {
    
    FilterView *filterView = [[FilterView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 160)
                                               contentViewType:(sender.tag == 0) ? ContentViewType_List : ContentViewType_ScratchableLatex];
    filterView.delegate    = self;
    filterView.itemsArray  = @[@"全部",@"投资",@"回款",@"充值",@"提现",@"其他"];
    [filterView showAnimated:YES];
}
- (void)hide:(FilterView *)view{

    [view hideAnimated:YES];

}
- (void)filterViewDidSelectIndex:(long)index filterView:(FilterView *)view{
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
