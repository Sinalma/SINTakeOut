//
//  SINFoodView.m
//  SinWaiMai
//
//  Created by apple on 31/01/2017.
//  Copyright © 2017 sinalma All rights reserved.
//  单个食物详情scrollView

#import "SINFoodView.h"
#import "Masonry.h"
#import "UILabel+Category.h"
#import "UIImageView+SINWebCache.h"

/** 顶部图片的高度 */
#define TopImgVHeight 200

@interface SINFoodView ()

/** 顶部图片控件 */
@property (nonatomic,strong) UIImageView *topImgView;

/** 食物名label */
@property (nonatomic,strong) UILabel *nameLabel;

/** 信息label */
@property (nonatomic,strong) UILabel *infoLabel;

/** 评价数label */
@property (nonatomic,strong) UILabel *commentCountLabel;

/** 价格label */
@property (nonatomic,strong) UILabel *priceLabel;

/** 加入购物车按钮 */
@property (nonatomic,strong) UIButton *addCarBtn;

/** 分割线 */
@property (nonatomic,strong) UIView *lineView;

/** 底部标题label */
@property (nonatomic,strong) UILabel *descTitleLabel;

/** 底部描述 */
@property (nonatomic,strong) UILabel *descLabel;

/** 顶部容器view */
@property (nonatomic,strong) UIView *containView;

/** 关闭按钮 */
@property (nonatomic,strong) UIButton *backBtn;

/** 分享按钮 */
@property (nonatomic,strong) UIButton *shareBtn;

@end

@implementation SINFoodView

- (instancetype)init
{
    if (self = [super init]) {
        
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setup];
    }
    return self;
}

- (void)setFood:(SINFood *)food
{
    _food = food;
    
    food.url = [[food.url componentsSeparatedByString:@"@"] firstObject];
    
    [self.topImgView sin_setImageWithURL:[NSURL URLWithString:food.url]];
    
    self.nameLabel.text = food.name;
    
    self.infoLabel.text = [NSString stringWithFormat:@"月售%@份 | 好评率%@",food.saled,food.good_comment_ratio];
    
    self.commentCountLabel.text = [NSString stringWithFormat:@"(共%@人评价)",food.total_comment_num];
    
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",food.current_price];
    
    self.descLabel.text = food.desc;
}

#pragma mark - 点击事件
- (void)gobackBtnClick
{
    self.goback();
}

- (void)sharedBtnClick
{
    self.shared();
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 布局所有子控件
    [self.topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        make.width.height.equalTo(@(SINScreenW));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self.topImgView.mas_bottom).offset(20);
        make.width.equalTo(@(SINScreenW - 20));
        make.height.equalTo(@(25));
    }];
    
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
    }];
    
    [self.commentCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.infoLabel.mas_right).offset(10);
        make.centerY.equalTo(self.infoLabel);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.infoLabel);
        make.top.equalTo(self.infoLabel.mas_bottom).offset(30);
    }];
    
    [self.addCarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-70);
        make.centerY.equalTo(self.priceLabel);
        make.width.equalTo(@75);
        make.height.equalTo(@35);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLabel);
        make.height.equalTo(@1);
        make.top.equalTo(self.priceLabel.mas_bottom).offset(30);
        make.width.equalTo(@(SINScreenW - 20));
    }];
    
    [self.descTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineView);
        make.top.equalTo(self.lineView.mas_bottom).offset(30);
    }];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.descTitleLabel);
        make.top.equalTo(self.descTitleLabel.mas_bottom).offset(5);
        make.width.equalTo(@(SINScreenW - 20));
    }];
    
    [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.top.equalTo(self).offset(20);
        make.width.equalTo(@(SINScreenW - 40));
        make.height.equalTo(@30);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.backBtn.superview);
        make.height.equalTo(self.backBtn.superview);
        make.width.equalTo(@50);
    }];
    
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.shareBtn.superview);
        make.top.equalTo(self.shareBtn.superview);
        make.height.equalTo(self.backBtn.superview);
        make.width.equalTo(@50);
    }];
}

/**
 * 初始化
 */
- (void)setup{
    
    UIImageView *imgV = [[UIImageView alloc] init];
    [self addSubview:imgV];
    self.topImgView = imgV;
    
    UILabel *nameLab = [UILabel createLabelWithFont:15 textColor:[UIColor blackColor]];
    nameLab.text = @"新奥尔良鸡肉披萨10寸";
    [self addSubview:nameLab];
    self.nameLabel = nameLab;
    
    UILabel *infoLab = [UILabel createLabelWithFont:12 textColor:[UIColor darkGrayColor]];
    infoLab.text = @"月售15份 | 好评率100%";
    [self addSubview:infoLab];
    self.infoLabel = infoLab;
    
    UILabel *commentCountLab = [UILabel createLabelWithFont:12 textColor:[UIColor lightGrayColor]];
    commentCountLab.text = @"(共11份)";
    [self addSubview:commentCountLab];
    self.commentCountLabel = commentCountLab;
    
    UILabel *priceLab = [UILabel createLabelWithFont:15 textColor:[UIColor redColor]];
    priceLab.text = @"¥39";
    [self addSubview:priceLab];
    self.priceLabel = priceLab;
    
    UIButton *addCarBtn = [[UIButton alloc] init];
    addCarBtn.backgroundColor = [UIColor redColor];
    addCarBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [addCarBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    [self addSubview:addCarBtn];
    self.addCarBtn = addCarBtn;
    
    // 分割线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor darkGrayColor];
    [self addSubview:lineView];
    self.lineView = lineView;
    
    // 描述标题
    UILabel *descTitleLab = [UILabel createLabelWithFont:12 textColor:[UIColor lightGrayColor]];
    descTitleLab.text = @"商品描述";
    [self addSubview:descTitleLab];
    self.descTitleLabel = descTitleLab;
    
    // 描述
    UILabel *descLab = [UILabel createLabelWithFont:12 textColor:[UIColor blackColor]];
    descLab.text = @"温馨提示:图片仅供参考，请以实物为准;高峰时段及恶劣天气，请提前下单。";
    descLab.numberOfLines = 0;
    [self addSubview:descLab];
    self.descLabel = descLab;
    
    // 顶部容器view
    UIView *containV = [[UIView alloc] init];
    containV.backgroundColor = [UIColor clearColor];
    [self addSubview:containV];
    self.containView = containV;
    
    // 返回按钮
    UIButton *backBtn = [[UIButton alloc] init];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn setBackgroundColor:[UIColor darkGrayColor]];
    [backBtn addTarget:self action:@selector(gobackBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [containV addSubview:backBtn];
    self.backBtn = backBtn;
    
    // 分享按钮
    UIButton *shareBtn = [[UIButton alloc] init];
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shareBtn setBackgroundColor:[UIColor darkGrayColor]];
    [shareBtn addTarget:self action:@selector(sharedBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [containV addSubview:shareBtn];
    self.shareBtn = shareBtn;
}

@end
