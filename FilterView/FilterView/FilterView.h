//
//  FilterView.h
//  FilterView
//
//  Created by wangjian on 16/5/12.
//  Copyright © 2016年 qhfax. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,ContentViewType) {

    ContentViewType_ScratchableLatex,//九宫格
    ContentViewType_List,//列表

};//内容视图类型


@class FilterView;
@protocol FilterViewDelegate <NSObject>



/**
 *  选择筛选视图的索引
 *
 *  @param index 索引
 *  @param view  筛选视图
 */
- (void)filterViewDidSelectIndex:(long)index
                      filterView:(FilterView *)view;

@end

@interface FilterView : UIView<UITableViewDelegate,UITableViewDataSource>
{

    UITableView *_tableView;

}
@property (nonatomic,weak)id <FilterViewDelegate> delegate;
@property (nonatomic,retain)NSArray *itemsArray;//项目数组
@property (nonatomic,retain)NSMutableArray *buttonsArray;//按钮数组
@property (nonatomic,assign)float contentHeight;//内容高度
@property (nonatomic,assign)long selectIndex;//选中索引
@property (nonatomic,assign)ContentViewType contentViewType;//内容视图类型

- (instancetype)initWithFrame:(CGRect)frame;

- (instancetype)initWithFrame:(CGRect)frame contentViewType:(ContentViewType)viewType;

/**
 *  显示
 *
 *  @param animated 是否动画显示
 */
- (void)showAnimated:(BOOL)animated;

/**
 *  隐藏
 *
 *  @param animated 是否动画隐藏
 */
- (void)hideAnimated:(BOOL)animated;

@end
