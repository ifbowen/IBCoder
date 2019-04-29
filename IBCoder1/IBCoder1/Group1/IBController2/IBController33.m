//
//  IBController33.m
//  IBCoder1
//
//  Created by Bowen on 2018/6/5.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBController33.h"

#import <WebKit/WebKit.h>
#import "UIView+Ext.h"

@interface IBController33 ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIScrollView *containerScrollView;

@property (nonatomic, strong) UIView    *contentView;

@end

@implementation IBController33{
    CGFloat _lastWebViewContentHeight;
    CGFloat _lastTableViewContentHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initValue];
    [self initView];
    [self addObservers];
    
    NSString *path = @"https://www.jianshu.com/p/f31e39d3ce41";
//    NSString *path2 = @"http://127.0.0.1/openItunes.html";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:path]];
    request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    [self.webView loadRequest:request];
}

- (void)dealloc{
    [self removeObservers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initValue{
    _lastWebViewContentHeight = 0;
    _lastTableViewContentHeight = 0;
}

- (void)initView{
    [self.contentView addSubview:self.webView];
    [self.contentView addSubview:self.tableView];
    
    [self.view addSubview:self.containerScrollView];
    [self.containerScrollView addSubview:self.contentView];
    
    self.contentView.frame = CGRectMake(0, 0, self.view.width, self.view.height * 2);
    self.webView.top = 0;
    self.webView.height = self.view.height;
    self.tableView.top = self.webView.bottom;
}


#pragma mark - Observers
- (void)addObservers{
    [self.webView addObserver:self forKeyPath:@"scrollView.contentSize" options:NSKeyValueObservingOptionNew context:nil];
    [self.tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObservers{
    [self.webView removeObserver:self forKeyPath:@"scrollView.contentSize"];
    [self.tableView removeObserver:self forKeyPath:@"contentSize"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (object == _webView) {
        if ([keyPath isEqualToString:@"scrollView.contentSize"]) {
            [self updateContainerScrollViewContentSize:0 webViewContentHeight:0];
        }
    }else if(object == _tableView) {
        if ([keyPath isEqualToString:@"contentSize"]) {
            [self updateContainerScrollViewContentSize:0 webViewContentHeight:0];
        }
    }
}

- (void)updateContainerScrollViewContentSize:(NSInteger)flag webViewContentHeight:(CGFloat)inWebViewContentHeight{
    
    CGFloat webViewContentHeight = flag==1 ?inWebViewContentHeight :self.webView.scrollView.contentSize.height;
    CGFloat tableViewContentHeight = self.tableView.contentSize.height;
    
    if (webViewContentHeight == _lastWebViewContentHeight && tableViewContentHeight == _lastTableViewContentHeight) {
        return;
    }
    
    _lastWebViewContentHeight = webViewContentHeight;
    _lastTableViewContentHeight = tableViewContentHeight;
    
    self.containerScrollView.contentSize = CGSizeMake(self.view.width, webViewContentHeight + tableViewContentHeight);
    
    CGFloat webViewHeight = (webViewContentHeight < self.view.height) ?webViewContentHeight :self.view.height ;
    CGFloat tableViewHeight = tableViewContentHeight < self.view.height ?tableViewContentHeight :self.view.height;
    self.webView.height = webViewHeight <= 0.1 ?0.1 :webViewHeight;
    self.contentView.height = webViewHeight + tableViewHeight;
    self.tableView.height = tableViewHeight;
    self.tableView.top = self.webView.bottom;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_containerScrollView != scrollView) {
        return;
    }
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    CGFloat webViewHeight = self.webView.height;
    CGFloat tableViewHeight = self.tableView.height;
    
    CGFloat webViewContentHeight = self.webView.scrollView.contentSize.height;
    CGFloat tableViewContentHeight = self.tableView.contentSize.height;
    
    if (offsetY <= 0) {
        self.contentView.top = 0;
        self.webView.scrollView.contentOffset = CGPointZero;
        self.tableView.contentOffset = CGPointZero;
    }else if(offsetY < webViewContentHeight - webViewHeight){
        self.contentView.top = offsetY;
        self.webView.scrollView.contentOffset = CGPointMake(0, offsetY);
        self.tableView.contentOffset = CGPointZero;
    }else if(offsetY < webViewContentHeight){
        self.contentView.top = webViewContentHeight - webViewHeight;
        self.webView.scrollView.contentOffset = CGPointMake(0, webViewContentHeight - webViewHeight);
        self.tableView.contentOffset = CGPointZero;
    }else if(offsetY < webViewContentHeight + tableViewContentHeight - tableViewHeight){
        self.contentView.top = offsetY - webViewHeight;
        self.tableView.contentOffset = CGPointMake(0, offsetY - webViewContentHeight);
        self.webView.scrollView.contentOffset = CGPointMake(0, webViewContentHeight - webViewHeight);
    }else if(offsetY <= webViewContentHeight + tableViewContentHeight ){
        self.contentView.top = self.containerScrollView.contentSize.height - self.contentView.height;
        self.webView.scrollView.contentOffset = CGPointMake(0, webViewContentHeight - webViewHeight);
        self.tableView.contentOffset = CGPointMake(0, tableViewContentHeight - tableViewHeight);
    }else {
        //do nothing
        NSLog(@"do nothing");
    }
}

#pragma mark - UITableViewDataSouce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.backgroundColor = [UIColor redColor];
    }
    
    cell.textLabel.text = @(indexPath.row).stringValue;
    return cell;
}

#pragma mark - private
- (WKWebView *)webView{
    if (_webView == nil) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
        _webView.scrollView.scrollEnabled = NO;
        _webView.navigationDelegate = self;
    }
    
    return _webView;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.scrollEnabled = NO;
        
    }
    return _tableView;
}

- (UIScrollView *)containerScrollView{
    if (_containerScrollView == nil) {
        _containerScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _containerScrollView.delegate = self;
        _containerScrollView.alwaysBounceVertical = YES;
    }
    
    return _containerScrollView;
}

- (UIView *)contentView{
    if (_contentView == nil) {
        _contentView = [[UIView alloc] init];
    }
    
    return _contentView;
}

@end

/*
 作者：Mr_贱贱源源
 链接：https://www.jianshu.com/p/3721d736cf68
 來源：简书
 著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
 
 知识点1
 ScrollView的ContentOffset
 
 单个控件来看：
 
 WebView的ContentOffset.y取值范围是：0 ~ (WebView.contentSize.height - WebView.height)
 
 TableView的ContentOffset.y取值范围是：0 ~ (TableView.contentSize.height - TableView.Height)
 
 将WebView放在ScrollView上来看，WebView可滚动范围，即ScrollView.contentOffset.y取值范围：
 
 0 ~ (WebView.contentOffset.y - WebView.height)
 
 将TableView放在ScrollView上来看，TableView可滚动范围，即ScrollView.contentOffset.y取值范围：
 
 (ScrollView.contentSize.height - TableView.contentSize.Height) ~ (ScrollView.contentSize.height - TableView.height)
 
 即：
 
 (WebView.contentSize.height) ~ （WebView.contentSize.height + TableView.ContentSize.height - TableView.height)
 

 
 知识点2
 下面分区间说一下ContentView的top是如何计算得到的。
 
 offsetY：ScrollView的ContentOffset.y
 
 1区间段：（offsetY <= 0 )
 
 这时候是ScrollView的正常滚动效果，ContentView.top为0，WebView和TableView也不滚动，即它们的ContentOffset.y = 0。
 
 2区间段：（0 < offsetY < WebView.contentsize.height - WebView.height )
 
 因为webView.contentszie.height > webView.height , 说明webView是可以滚动的,这时候ScrollView的滚动应该是WebView的滚动,即webView.contentOffset.y = offsetY.
 
 因为这时候WebView要完全显示在窗口，ScrollView的（ContentOffset.y~ContentOffset.y+ScrollView.height)是可视范围，所以使WebView.top = ContentOffset.y即可让webView完全可视。（webView.contentszie.height > WebView.height，所以WebView.height = ScrollView.height, 上面已经说过）。
 
 TableView在此区间段不发生滚动。
 
 3区间段：（ WebView.contentsize.height - WebView.height < offsetY < WebView.contentsize.height)
 
 这个时候WebView已经滚动到底部（上面已经说过），不再滚动， 此时：WebView.contentOffset.y = WebView.contentsize.height - WebView.height;
 
 此时还没到TableView的可滚动范围，TableView也没滚动过，所以Table.contentOffset.y = 0。
 
 因为此时是正常的ScrollView滚动范围，界面的滚动效果就是ScrollView的滚动。在2区间段最后位置：WebView.top = WebView.contentOffset.y，保持即可，所以WebView.top = WebwebViewContentHeight - webViewHeight 。
 
 4区间段：（ WebView.contentsize.height < offsetY < WebView.contentsize.height + TebView.contentsize.height - TebView.height)
 
 此时TableView可以滚动,TableView.contentOffset.y = offsetY - WebView.contentsize.height 。
 
 TableView完全处于ScrollView可视位置, TableView.Top = offsetY，所以contentView.top = offsetY - WebView.height;
 
 此时WebView的内容以及滚动到最底部，保持WebView.contentOffset.y = WebView.contentsize.height - WebView.height即可;
 
 5区间段：（ WebView.contentsize.height + TebView.contentsize.height - TebView.height< offsetY < WebView.contentsize.height + TebView.contentsize.height)
 
 此时和3区间段一样，WebView和TableView的内容都以及滚动到最底部，他们也处于ScrollView的最底部。显而易见去设置他们的ContentOffset和Top。
 
 
 */

