//
//  IBGroup2Controller16.m
//  MBCoder
//
//  Created by Bowen on 2019/11/1.
//  Copyright © 2019 inke. All rights reserved.
//

#import "IBGroup2Controller16.h"
#import "SonicWebViewController.h"

@interface IBGroup2Controller16 ()

@property (nonatomic, strong) NSString *url;

@end

@implementation IBGroup2Controller16

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.url = @"http://mc.vip.qq.com/demo/indexv3";
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self sonicRequestAction];
}

- (void)normalRequestAction
{
    SonicWebViewController *webVC = [[SonicWebViewController alloc]initWithUrl:self.url useSonicMode:NO unStrictMode:NO];
    [self addChildViewController:webVC];
    [self.view addSubview:webVC.view];
}

- (void)sonicResourcePreloadAction
{
    SonicWebViewController *webVC = [[SonicWebViewController alloc]initWithUrl:@"http://www.kgc.cn/zhuanti/bigca.shtml?jump=1" useSonicMode:YES unStrictMode:YES];
    [self addChildViewController:webVC];
    [self.view addSubview:webVC.view];
}

- (void)sonicPreloadAction
{
    [[SonicEngine sharedEngine] createSessionWithUrl:self.url withWebDelegate:nil];
}

- (void)sonicRequestAction
{
    SonicWebViewController *webVC = [[SonicWebViewController alloc]initWithUrl:self.url useSonicMode:YES unStrictMode:NO];
    [self addChildViewController:webVC];
    [self.view addSubview:webVC.view];
}

- (void)unstrictModeSonicRequestAction
{
    SonicWebViewController *webVC = [[SonicWebViewController alloc]initWithUrl:@"http://www.kgc.cn/zhuanti/bigca.shtml?jump=1" useSonicMode:YES unStrictMode:YES];
    [self addChildViewController:webVC];
    [self.view addSubview:webVC.view];
}

- (void)loadWithOfflineFileAction
{
    SonicWebViewController *webVC = [[SonicWebViewController alloc]initWithUrl:@"http://mc.vip.qq.com/demo/indexv3?offline=1" useSonicMode:YES unStrictMode:NO];
    [self addChildViewController:webVC];
    [self.view addSubview:webVC.view];
}

- (void)clearAllCacheAction
{
    [[SonicEngine sharedEngine] clearAllCache];
}

@end

/**
 链接：https://github.com/Tencent/VasSonic/wiki
      https://dequan1331.github.io/
 
 iOS中Web相关优化策略
 
 1、Web维度的优化
 1）通用Web优化
 对于Web的通用优化方案，
 在网络层面，可以通过DNS和CDN技术减少网络延迟、通过各种HTTP缓存技术减少网络请求次数、通过资源压缩和合并减少请求内容等。
 在渲染层面，可以通过精简和优化业务代码、按需加载、防止阻塞、调整加载顺序优化等等。
 对于这个老生常谈的问题，业内已经有十分成熟和完整的总结，例如《Best Practices for Speeding Up Your Web Site》
 https://developer.yahoo.com/performance/rules.html
 
 2）其他
 脱离较为通用的优化，在对代码侵入宽容度较高的场景中，开发者对Web优化有着更为激进的做法。
 例如在VasSonic中，除了Web容器复用、数据模板分离、预拉取和通用的优化方式外，
 还通过自定义VasSonic标签将HTML页面进行划分，分段进行缓存控制，以达到更高的优化效果。

 2、Native维度的优化
 1）容器复用和预热
 WKWebView虽然JIT大幅优化了JS的执行速度，但是单纯的加载渲染HTML，WKWebView比UIWebView慢了很多
 预热即时在App启动时创建一个WKWebView，使其内部部分逻辑预热已提升加载速度。
 复用较为Triky的办法就是常驻一个空WKWebView在内存。
 
 2）Native并行资源请求 & 离线包
 由于Web页面内请求流程不可控以及网络环境的影响，对于Web的加载来说，网络请求一直是优化的重点。
 开发者较为常用的做法是使用Native并行代理数据请求，替代Web内核的资源加载。
 在客户端初始化页面的同时，并行开始网络请求数据；当Web页面渲染时向Native获取其代理请求的数据。

 而将并行加载和预加载做到极致的优化，就是离线包的使用。将常用的需要下载资源（HTML模板、JS文件、CSS文件、占位图片）打包，
 App选择合适的时机全部下载到本地，当Web页面渲染时向Native获取其数据。

 通过离线包的使用，Web页面可以并行（提前）加载页面资源，同时摆脱了网络的影响，提高了页面的加载速度和成功率。
 当然离线包作为资源动态更新的一个方式，合理的下载时机、增量更新、加密和校验等方面都是需要进行设计和思考的方向，后文会简单介绍。

 3）复杂Dom节点Native化实现
 当并行请求资源，客户端代理数据请求的技术方案逐渐成熟时，由于WKWebView的限制，开发者不得不面对业务调整和适配。
 其中保留原有代理逻辑、采用LocalServer的方式最为普遍。
 但是由于WKWebView的进程间通信、LocalServer Socket建立与连接、资源的重复编解码都影响了代理请求的效率。

 所以对于一些资讯类App，通常采用Dom节点占位、Native渲染实现的方式进行优化，如图片、地图、音视频等模块。
 这样不但能减少通信和请求的建立、提供更加友好的交互、也能并行的进行View的渲染和处理，同时减少Web页面的业务逻辑。
 
 
 一、web传统模式的加载流程
 
 1、用户点击后，经过终端一系列初始化流程，比如进程启动、Runtime初始化、创建WebView等等。
 2、完成初始化后，WebView开始去CDN上面请求Html加载页面。
 3、页面发起CGI请求对应的数据或者通过localStorage获取数据，数据回来后再对DOM进行操作更新
    （通用网关接口（Common Gateway Interface/CGI）是一种重要的互联网技术，可以让一个客户端，
     从网页浏览器向执行在网络服务器上的程序请求数据。CGI描述了服务器和请求处理程序之间传输数据的一种标准。)
 存在问题：
 1、终端初始化耗时长，期间网络完全处于空闲状态，因此webView请求资源时机慢
 2、页面的资源和数据完全依赖于网络，弱网页面白屏时间长
 3、页面数据动态拉取，加载完页面之后进行数据更新，DOM更新，性能开销大
 
 二、VasSonic的诞生
 
 1、并行加载
 默认模式：串行，WebView要等终端初始化完成之后，才发起请求。
 并行模式：WebView要等终端初始化的同时请求数据。
 问题：终端初始化比较快，但数据没有完成返回，这意味着内核在空等。
 解决：因为内核是支持边加载边渲染的，所以采用流式拦截（使用中间层来桥接内核和数据）。
 1）启动子线程请求页面主资源，子线程中不断讲网络数据读取到内存中，也就是网络流和内存流之间的转换；
 2）当WebView初始化完成的时候，提供一个中间层BridgeStream来连接WebView和数据流；
 3）当WebView读取数据的时候，中间层BridgeStream会先把内存的数据读取返回后，再继续读取网络的数据。
 
 2、动态缓存
 1)资源读取的中间层BridgeStream缓存内容。
 2)页面中经常变化的数据我们称为数据块，除了数据块之外的数据称为模板。
 
 3、页面分离
 1、动静分离思想：页面html通过VasSonic标签进行划分，包裹在标签中的内容为data，标签外的内容为模版。
 2、扩展新字段实现增量更新
    1）html内容扩展：通过代码注释的方式，增加了“sonicdiff-xxx”来标注一个数据块的开始与结束，而模板就是将数据块抠掉之后的Html
    2）协议头部扩展：etag，页面内容的唯一标识(哈希值)；template-tag，模版唯一标识(哈希值)，客户端使用本地校验 或 服务端使用判断是模板有变更
 
 4、模式介绍
 1）首次加载，本地没有缓存，即第一次加载页面。etag为空值或template_tag为空值
 2）完全缓存，本地有缓存，且缓存内容跟服务器内容完全一样。etag一致
 3）数据更新，本地有缓存，本地模版内容跟服务器模版内容一样，但数据块有变化。etag不一致 且 template_tag一致
 4）模版更新，本地有缓存，缓存的模版内容跟服务器的模版内容不一样，etag不一致 且 template_tag不一致
 
 三、实现原理
 Sonic框架使用终端应用层原生传输通道取代系统浏览器内核自身资源传输通道来请求页面主资源，在移动终端初始化的同时并行请求页面主资源并做到流式拦截，
 减少传统方案上终端初始化耗时长导致页面主资源发起请求时机慢或传统并行方案下必须等待主资源完成下载才能交给内核加载的影响。
 另外通过客户端和服务器端双方遵守Sonic格式规范(通过在html内增加注释代码区分模板和数据)，该框架能做到智能地对页面内容进行动态缓存和增量更新，
 减少对网络的依赖，节省用户流量，加快页面打开速度。
 
 1、Sonic主要实现思路
 基于后端渲染直出的页面拆分成(模版)＋(数据)＝(网页)的模式，在不同场景下，针对(模版)和(数据)分别做更新；
 
 2、主要功能模块构成
 1）SonicSession
 单个页面主资源加载所使用的会话，负责当次链接的完整状态流程。会在创建的sonic线程完成网络的加载。
 2）SonicClient
 负责管理所有的Session,通过传入Url，创建对应的session
 3）SonicURLProtocol
 负责拦截WebView产生的主资源请求，将SonicSession发起的网络流桥接给WebKit
 4）SonicCache
 负责为SonicSession提供缓存处理和缓存的返回，建立内存的缓存，会在这里做模板的更新与拆分。
 5）SonicConnection
 可以继承此基类，提供针对特定的URL完成所需的资源加载，比如离线资源，可以通过这个方式加载到WebKit。
 
 FAQ：
 1、目前Sonic使用的是UIWebView，暂时没有支持WKWebView，原因如下：
 1）WKWebView没法做NSURLProtocol拦截，而且WKWebView的回调都是IPC跨进程的，渲染也比UIWebView慢；
 2）WKWebView目前不支持NSURLProtocol拦截是最大的问题，网上流传的私有接口拦截有一个大问题就是Post请求会丢失掉body；
 3）iOS11虽然又提供了拦截注册，但是不允许注册http和https这种系统默认的schema。
 
 2、关于WKWebView的实现思路
 1）使用GCDWebServer做本地代理，替换NSURLProtocol实现请求的拦截和操作，进而支持WK这种不支持NSURLProtocol的请求。
 2）使用LoadHTML方法来加载缓存，这样的坏处是首次加载的时候会浪费一次页面的全量请求
 
 四、WKWebView常见问题
 
 使用WKWebView带来的另外一个好处，就是我们可以通过源码理解部分加载逻辑，为Crash提供一些思路，或者使用一些私有方法处理复杂业务逻辑。
 1、NSURLProtocol
 1）WKWebView最为显著的改变，就是不支持NSURLProtocol。为了兼容旧的业务逻辑，
 一部分App通过WKBrowsingContextController中的非公开方法（registerSchemeForCustomProtocol:）实现了NSURLProtocol。
 2）在iOS11中，系统增加了 setURLSchemeHandler函数用来拦截自定义的Scheme。
   但是不同于UIWebView，新的函数只能拦截自定义的Scheme(SchemeRegistry.cpp)，对使用最多的HTTP/HTTPS依然不能有效的拦截。
 
 2、白屏
 通常WKWebView白屏的原因主要分两种：
 一种是由于Web的进程Crash（多见于内部进程通信）；
 一种就是WebView渲染时的错误（Debug一切正常只是没有对应的内容）。
 对于白屏的检测，前者在iOS9之后系统提供了对应Crash的回调函数，同时业界也有通过判断URL/Title是否为空的方式作为辅助；
 后者业界通过视图树对比，判断SubView是否包含WKCompsitingView，以及通过随机点截图等方式作为白屏判断的依据。

 3、其他WKWebView的系统级问题如Cookie、POST参数、异步Javascript等等一系列的问题，可以通过业务逻辑的调整重新适配

 4、由于WebKit源码等开放性，我们也可以利用私有方法来简化代码逻辑、实现复杂的产品需求。
 例如在WKWebViewPrivate中可以获得各种页面信息、直接取到UserAgent、 在WKBackForwardListPrivate中可以清理掉全部的跳转历史、
 以及在WKContentViewInteraction中替换方法实现自定义的MenuItem等等。
 
 五、App中的应用场景
 
 WKWebView系统提供了四个用于加载渲染Web的函数。这四个函数从加载的类型上可以分为两类：加载URL & 加载HTML\Data。
 所以基于此也延伸出两种不同的业务场景：加载URL的页面直出类和加载数据的模板渲染类，同时两种类型各自也有不同的优化重点及方向。
 
 1、页面直出类
 //根据URL直接展示Web页面
 - (nullable WKNavigation *)loadRequest:(NSURLRequest *)request;
 通常各类App中的Web页面加载都是通过加载URL方式，比如嵌入的运营活动页面、广告页面等等。
 
 2、模板渲染类
 //根据模板&数据渲染Web页面
 - (nullable WKNavigation *)loadHTMLString:(NSString *)string baseURL:(nullable NSURL *)baseURL;
 需要使用WebView展示，且交互逻辑较多的页面，最常见的就是资讯类App的内容展示页。
 
 

 
 */
