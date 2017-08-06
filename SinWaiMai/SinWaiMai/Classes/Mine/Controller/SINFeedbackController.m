//
//  SINFeedbackController.m
//  SinWaiMai
//
//  Created by apple on 04/08/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//  意见反馈控制器

#import "SINFeedbackController.h"
#import "UILabel+Category.h"
#import "Masonry.h"
#import "SINPlaceholderTextView.h"

#define FeedbackViewHeight 100
#define LineHeight 0.5
#define DURATION 0.7

@interface SINFeedbackController () <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UIScrollView *groundView;
@property (nonatomic,strong) UILabel *contactLab;
@property (nonatomic,strong) UITextField *contactField;
@property (nonatomic,strong) UILabel *typeLabel;
@property (nonatomic,strong) UITextField *typeField;
@property (nonatomic,strong) UIImageView *downArrow;
@property (nonatomic,strong) UIButton *submitBtn;
@property (nonatomic,strong) SINPlaceholderTextView *feedbackView;
@property (nonatomic,strong) UIView *photoSelectView;
@property (nonatomic,strong) UITableView *typeView;
@property (nonatomic,strong) UIView *downdLine;
@property (nonatomic,strong) UIView *hud;

@property (nonatomic,strong) UITableViewCell *curSelectCell;
@end

@implementation SINFeedbackController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    [self layout];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.tabBarController.tabBar setHidden:NO];
}

#pragma mark - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

static NSString *ID = @"CELL";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *titles = @[@"帐号相关",@"界面及操作",@"订单，支付及退款",@"物流配送",@"商家及餐品质量"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.textLabel.text = titles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.typeField.text = cell.textLabel.text;
    if (self.curSelectCell) {
        self.curSelectCell.textLabel.textColor = [UIColor darkTextColor];
    }
    cell.textLabel.textColor = [UIColor redColor];
    self.curSelectCell = cell;
    // 显示填写反馈意见的textView
    [self.feedbackView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(FeedbackViewHeight));
    }];
    [self.downdLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(LineHeight));
    }];
    // 收起类型选择界面
    [self hideTypeView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark - UITextViewDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.typeField) {
        // 弹出选择类型界面
        [self.view endEditing:YES];
        [UIView animateWithDuration:DURATION animations:^{
            self.typeView.transform = CGAffineTransformMakeTranslation(0, -300);
            self.hud.hidden = NO;
        }];
        return NO;
    }
    return YES;
}

- (void)layout
{
    [self.view addSubview:self.groundView];
    [self.groundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view);
        make.width.equalTo(@(SINScreenW));
        make.height.equalTo(@(SINScreenH-64));
    }];
    
    [self.groundView addSubview:self.contactLab];
    [self.contactLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.groundView).offset(20);
        make.top.equalTo(self.groundView).offset(20);
        make.height.equalTo(@35);
    }];
    
    [self.groundView addSubview:self.contactField];
    [self.contactField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contactLab.mas_right).offset(20);
        make.centerY.equalTo(self.contactLab);
        make.height.equalTo(@35);
        make.right.equalTo(self.groundView);
//        make.width.equalTo(@(SINScreenW-40));
    }];
    
    UIView *upLine = [[UIView alloc] init];
    upLine.backgroundColor = [UIColor lightGrayColor];
    [self.groundView addSubview:upLine];
    [upLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contactLab);
        make.top.equalTo(self.contactLab.mas_bottom).offset(10);
        make.height.equalTo(@(LineHeight));
        make.width.equalTo(@(SINScreenW-20));
    }];
    
    [self.groundView addSubview:self.typeLabel];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(upLine);
        make.top.equalTo(upLine.mas_bottom).offset(10);
        make.height.equalTo(@35);
    }];
    
    [self.groundView addSubview:self.typeField];
    [self.typeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.typeLabel.mas_right).offset(20);
        make.bottom.equalTo(self.typeLabel);
        make.right.equalTo(self.contactField);
        make.height.equalTo(self.contactField);
    }];
    
    UIView *downLine = [[UIView alloc] init];
    downLine.backgroundColor = [UIColor lightGrayColor];
    [self.groundView addSubview:downLine];
    [downLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.typeLabel);
        make.top.equalTo(self.typeLabel.mas_bottom).offset(10);
        make.height.equalTo(@(LineHeight));
        make.width.equalTo(@(SINScreenW-20));
    }];
    
    [self.groundView addSubview:self.feedbackView];
    [self.feedbackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(downLine);
        make.right.equalTo(downLine).offset(-20);
        make.height.equalTo(@0);
        make.top.equalTo(downLine.mas_bottom).offset(10);
    }];
    
    [self.groundView addSubview:self.downdLine];
    [self.downdLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.feedbackView);
        make.top.equalTo(self.feedbackView.mas_bottom).offset(10);
        make.height.equalTo(@0);
        make.width.equalTo(@(SINScreenW-20));
    }];
    
    [self.view addSubview:self.submitBtn];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.groundView).offset(20);
        make.right.equalTo(self.groundView).offset(-20);
        make.height.equalTo(@40);
        make.top.equalTo(self.feedbackView.mas_bottom).offset(30);
    }];
    
    [self.view addSubview:self.hud];
    self.hud.frame = self.view.bounds;
    
    [self.view addSubview:self.typeView];
    [self.typeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(300);
        make.height.equalTo(@300);
    }];
}
     

- (void)setup
{
    self.title = @"意见反馈";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_icon_white_nomal_24x24_"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self.view addGestureRecognizer:pan];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self.groundView addGestureRecognizer:tap];
}

- (void)hideTypeView
{
    [UIView animateWithDuration:DURATION animations:^{
        self.typeView.transform = CGAffineTransformIdentity;
        self.hud.hidden = YES;
    }];
}

- (void)hudClick
{
    [self hideTypeView];
}

- (void)submit
{
    if (self.contactField.text.length && self.feedbackView.text.length) {
        SINLog(@"Send feedback data to data service");
    }
}

- (void)tap:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}

- (void)pan:(UIPanGestureRecognizer *)pan
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - 懒加载
- (UIScrollView *)groundView{
    if (!_groundView) {
        _groundView = [[UIScrollView alloc] init];
        _groundView.contentSize = CGSizeMake(SINScreenW, SINScreenH+90);
    }
    return _groundView;
}

- (UILabel *)contactLab{
    if (!_contactLab) {
        _contactLab = [UILabel createLabelWithFont:16 textColor:[UIColor darkTextColor]];
        _contactLab.text = @"联系方式";
    }
    return _contactLab;
}

- (UITextField *)contactField{
    if (!_contactField) {
        _contactField = [[UITextField alloc] init];
        _contactField.placeholder = @"您的邮箱或手机号";
        _contactField.rightViewMode = UITextFieldViewModeAlways;
        _contactField.font = [UIFont systemFontOfSize:16];
    }
    return _contactField;
}

- (UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [UILabel createLabelWithFont:16 textColor:[UIColor darkTextColor]];
        _typeLabel.text = @"反馈类型";
    }
    return _typeLabel;
}

- (UITextField *)typeField
{
    if (!_typeField) {
        _typeField = [[UITextField alloc] init];
        _typeField.placeholder = @"请选择反馈内容";
        _typeField.rightViewMode = UITextFieldViewModeAlways;
        _typeField.font = [UIFont systemFontOfSize:16];
        _typeField.delegate = self;
    }
    return _typeField;
}

- (UIButton *)submitBtn
{
    if (!_submitBtn) {
        _submitBtn = [[UIButton alloc] init];
        _submitBtn.backgroundColor = [UIColor redColor];
        [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
        [_submitBtn setTintColor:[UIColor whiteColor]];
        [_submitBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}

- (SINPlaceholderTextView *)feedbackView
{
    if (!_feedbackView) {
        _feedbackView = [[SINPlaceholderTextView alloc] init];
        _feedbackView.placeholder = @"补充更多信息以便我们更快帮您处理(必填)";
        _feedbackView.placeholderColor = [UIColor lightGrayColor];
    }
    return _feedbackView;
}

- (UITableView *)typeView
{
    if (!_typeView) {
        _typeView = [[UITableView alloc] init];
        _typeView.dataSource = self;
        _typeView.delegate = self;
        _typeView.backgroundColor = [UIColor redColor];
        [_typeView setScrollEnabled:NO];
    }
    return _typeView;
}

- (UIView *)downdLine
{
    if (!_downdLine) {
        _downdLine = [[UIView alloc] init];
        _downdLine.backgroundColor = [UIColor lightGrayColor];
    }
    return _downdLine;
}

- (UIView *)hud
{
    if (!_hud) {
        _hud = [[UIView alloc] init];
        _hud.backgroundColor = [UIColor blackColor];
        _hud.alpha = 0.5;
        _hud.hidden = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hudClick)];
        [_hud addGestureRecognizer:tap];
    }
    return _hud;
}

@end
