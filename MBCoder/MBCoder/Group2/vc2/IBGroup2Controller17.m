//
//  IBGroup2Controller17.m
//  MBCoder
//
//  Created by Bowen on 2019/11/14.
//  Copyright © 2019 inke. All rights reserved.
//

#import "IBGroup2Controller17.h"
#import "MBPresenter.h"

//****************************Model*****************************//

@interface Person217 : NSObject

@property (nonatomic, readonly) NSString *firstName;
@property (nonatomic, readonly) NSString *lastName;

- (instancetype)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName;

@end

@implementation Person217

- (instancetype)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName {
    self = [super init];
    if (self) {
        _firstName = firstName;
        _lastName = lastName;
    }
    return self;
}

@end

//****************************Protocol*****************************//

@protocol PresenterProtocol <MBPresenterViewProtocol>

- (void)setNameText:(NSString *)nameText;

@end

@protocol PersonViewProtocol <NSObject>

- (void)onClickEvent;

@end


//****************************view*****************************//


@interface TestView : UIView <PresenterProtocol>

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, weak) id<PersonViewProtocol> presenter;

@end

@implementation TestView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.nameLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.nameLabel.textColor = UIColor.blackColor;
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.nameLabel];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.presenter onClickEvent];
}

- (void)setNameText:(NSString *)nameText
{
    self.nameLabel.text = nameText;
}

- (void)attachPresenter:(id)presenter
{
    self.presenter = presenter;
}

@end


//****************************Presenter*****************************//


@interface Presenter : MBPresenter

@property (nonatomic, strong) Person217 *person;
@property (nonatomic, weak) id<PresenterProtocol> attachView;

- (void)fetchData;

@end

@implementation Presenter
@dynamic attachView;

- (void)fetchData {
    self.person = [[Person217 alloc] initWithFirstName:@"赵丽颖" lastName:@"胡歌"];
    if (self.person.firstName.length > 0) {
        [self.attachView setNameText:self.person.firstName];
    } else {
        [self.attachView setNameText:self.person.lastName];
    }
}

static int i = 0;

- (void)onClickEvent
{
    if (i % 2 == 0) {
        [self.attachView setNameText:self.person.firstName];
    } else {
        [self.attachView setNameText:self.person.lastName];
    }
    i++;
}


@end

//****************************Controller*****************************//

@interface IBGroup2Controller17 ()<MBPresenterControllerProtocol>

@property (nonatomic, strong) TestView *testView;
@property (nonatomic, strong) Presenter *presenter;

@end

@implementation IBGroup2Controller17

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
    
    self.presenter = [Presenter setup:self];
    [self.presenter attachView:self.testView];
    [self.presenter fetchData];
}

- (void)setupViews {
    self.view.backgroundColor = [UIColor whiteColor];
    self.testView = [[TestView alloc] initWithFrame:CGRectMake(100, 100, CGRectGetWidth(self.view.bounds)-200, 50)];
    [self.view addSubview:self.testView];
    
}

@end
