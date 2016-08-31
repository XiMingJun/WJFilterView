//
//  FilterView.m
//  FilterView
//
//  Created by wangjian on 16/5/12.
//  Copyright © 2016年 qhfax. All rights reserved.
//

#import "FilterView.h"
# define FilterButtonTag 1000
# define ButtonColor_Normal [UIColor greenColor]
# define ButtonColor_Select [UIColor yellowColor]
#define Cell_Height 44
@implementation FilterView
@synthesize itemsArray,buttonsArray;
@synthesize contentHeight,selectIndex,contentViewType;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame{

   self = [super initWithFrame:frame];
    if (self) {
        
        [self commonInit];
        self.contentViewType = ContentViewType_ScratchableLatex;
        
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame contentViewType:(ContentViewType)viewType{

    self = [super initWithFrame:frame];
    if (self) {
        
        [self commonInit];
        self.contentViewType = viewType;

    }
    return self;
}
/**公共属性设置*/
- (void)commonInit{

    self.backgroundColor        = [UIColor whiteColor];
    self.clipsToBounds          = YES;
    selectIndex                 = 0;
    contentHeight               = self.frame.size.height;
    self.userInteractionEnabled = YES;

}
/**
 *  显示
 *
 *  @param animated 是否动画显示
 */
- (void)showAnimated:(BOOL)animated{

    UIWindow *keyWindow = [self keyWindow];
    if (animated) {
        CGRect rect = self.frame;
        rect.size.height = 0;
        self.frame = rect;
        [keyWindow addSubview:self];
        __weak FilterView *weakSelf = self;
        [UIView animateWithDuration:0.5f
                         animations:^{
                             
                             CGRect rect = weakSelf.frame;
                             rect.size.height = contentHeight;
                             weakSelf.frame = rect;
                         }
                         completion:^(BOOL finished) {
                             
                         }];
        
    }
    else{
        [keyWindow addSubview:self];
    }
}
/**
 *  隐藏
 *
 *  @param animated 是否动画隐藏
 */
- (void)hideAnimated:(BOOL)animated{

    
    if (animated) {
        __weak FilterView *weakSelf = self;
        [UIView animateWithDuration:0.35f
                         animations:^{
                             CGRect rect = weakSelf.frame;
                             rect.size.height = 0;
                             weakSelf.frame = rect;
                         }
                         completion:^(BOOL finished) {
                             [weakSelf removeFromSuperview];
                         }];
    }
    else{
        [self removeFromSuperview];
    }

}
- (void)buttonAction:(UIButton *)sender{

    long index = sender.tag - FilterButtonTag;
    selectIndex = index;
    for (UIButton *button in buttonsArray) {
        
        if ((button.tag - FilterButtonTag) == selectIndex) {
         
            [button setBackgroundColor:ButtonColor_Select];
        }
        else{
            [button setBackgroundColor:ButtonColor_Normal];
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(filterViewDidSelectIndex:filterView:)]) {
        [self.delegate filterViewDidSelectIndex:selectIndex
                                     filterView:self];
    }
    [self hideAnimated:YES];
}
- (UIWindow *)keyWindow
{
    NSArray *windows = [[UIApplication sharedApplication] windows];
    for(UIWindow *window in [windows reverseObjectEnumerator]) {
        
        if ([window isKindOfClass:[UIWindow class]] &&
            window.windowLevel == UIWindowLevelNormal &&
            CGRectEqualToRect(window.bounds, [UIScreen mainScreen].bounds))
            return window;
    }
    return [UIApplication sharedApplication].keyWindow;
}
- (void)setItemsArray:(NSArray *)titlesArr{
    if (titlesArr.count <= 0) {
        return;
    }
    itemsArray = titlesArr;
    switch (contentViewType) {
        case ContentViewType_ScratchableLatex: {
            [self buildScratchableLatexView];
            break;
        }
        case ContentViewType_List: {
            [self buildTableView];
            break;
        }
    }

}
/**创建九宫格视图*/
- (void)buildScratchableLatexView{

    
    int colum = 3;//列数
    int row = (int)((itemsArray.count % colum > 0) ? (itemsArray.count / colum + 1) : (itemsArray.count / colum)); //行数
    float buttonWidth = 80;
    float buttonHeight = 40;
    float rowInteger = 20;
    contentHeight = buttonHeight * row + rowInteger*(row + 1);
    float columInteger = (self.frame.size.width - colum * buttonWidth) / (colum + 1);
    for (int i = 0; i < itemsArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect buttonRect;
        buttonRect.origin.x = columInteger * (i % colum + 1) + buttonWidth * (i % colum);
        buttonRect.origin.y = rowInteger * (i / colum + 1) + buttonHeight * (i / colum);
        buttonRect.size.width = buttonWidth;
        buttonRect.size.height = buttonHeight;
        button.frame = buttonRect;
        button.tag = FilterButtonTag + i;
        [button addTarget:self
                   action:@selector(buttonAction:)
         forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:itemsArray[i] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor greenColor]];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:button];
        [buttonsArray addObject:button];
        if (selectIndex == i) {
            [button setBackgroundColor:ButtonColor_Select];
        }
    }

}
/**创建列表视图*/
- (void)buildTableView{
    
    contentHeight = itemsArray.count * Cell_Height;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width,contentHeight)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self addSubview:_tableView];

}

# pragma mark----UITableView Delegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return itemsArray.count;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return Cell_Height;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *identifer = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        
    }
    cell.textLabel.text = itemsArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    selectIndex = indexPath.row;
    if (self.delegate && [self.delegate respondsToSelector:@selector(filterViewDidSelectIndex:filterView:)]) {
        [self.delegate filterViewDidSelectIndex:selectIndex
                                     filterView:self];
    }
    [self hideAnimated:YES];
    
}

# pragma mark----Setter & Getter
- (void)setContentHeight:(float)height{

    if (height < 0) {
        return;
    }
    contentHeight = height;
}
- (void)setSelectIndex:(long)index{

    if (index <= 0) {
        return;
    }
    selectIndex = index;

}
- (void)setButtonsArray:(NSMutableArray *)buttonsArr{

    if (buttonsArr.count <= 0) {
        return;
    }
    buttonsArray = buttonsArr;
}
- (void)setContentViewType:(ContentViewType)viewType{

    contentViewType = viewType;
    switch (contentViewType) {
        case ContentViewType_ScratchableLatex: {
            
            buttonsArray                = [[NSMutableArray alloc] init];

            break;
        }
        case ContentViewType_List: {
            
            break;
        }
    }
}
@end
