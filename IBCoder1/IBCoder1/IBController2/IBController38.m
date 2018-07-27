//
//  IBController38.m
//  IBCoder1
//
//  Created by Bowen on 2018/7/27.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBController38.h"

@interface IBController38 ()

@end

@implementation IBController38

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 MVC:
 View 传送指令到 Controller
 Controller 完成业务逻辑后，要求 Model 改变状态
 Model 将新的数据发送到 View，用户得到反馈
 
 Controller可以和Model通信，也可以和View进行通信。继续看Controller和Model的关系，绿色的箭头
 代表Controller可以直接进行对Model进行访问，也就是说Model对于Controller来说就是透明的。但是
 Model并不知道Controller是谁。如果Model发生了变化，那么就通过Notification和KVO的方式传递给
 Controller。同样的Controller和View之间也是这种关系，View对Controller来说就是 透明的。
 Controller可以直接根据Model决定View的展示。View如果接受响应事件则通过delegate，target-action，
 block等方式告诉Controller的状态变化。Controller进行业务的处理，然后再控制View的展示。
 到这里你会发现Model和View并不能直接的进行通信，都必须通过Controller。那这样Model和View就是相互独立的。
 View只负责页面的展示，Model只是数据的存储，那么也就达到了解耦和重用的目的。
 

 MVVM作为一种新型的架构模式,在使用时应该有哪些地方值得我们注意呢?
 1.view 可以引用viewModel,但反过来却是不行
 2.viewModel 可以引用model,但是反过来也不行
 3.如果我们违背了上述规则,那么我们将会无法正常使用MVVM
 
    MVVM的提出就是为了减轻view controller和view的负担的，view model将上面提到的获取数据，行高计算，
 数据加工逻辑从view controller和view中剥离出来，同时把view controller/view和model隔开。viewModel
 从必要的资源(数据库，网络请求等)中获取原始数据，根据视图的展示逻辑，并处理成 view (controller)的展示数据。
 它(通常通过属性)暴露给视图控制器需要知道的仅关于显示视图工作的信息(理想地你不会暴漏你的 data-model对象)。
 
    view和view controller拥有view model，view model拥有model，相比较MVC的区别在于view和view controller
 是通过view model来间接操作数据的。这样做的意义在于，对于一些比较复杂的操作逻辑，可以写到view model里面，从而简化
 view和view controller，view和view controller只干展示数据和接受交互事件就好了；反过来model的update，驱动
 view model的update，然后再驱动view和view controller变化，这个中间的加工逻辑也可以写在view model中。

 MVVM 可以兼容你当下使用的MVC架构。
 MVVM 增加你的应用的可测试性。
 MVVM 配合一个绑定机制效果最好（PS：ReactiveCocoa你值得拥有）。
 viewController 尽量不涉及业务逻辑，让 viewModel 去做这些事情。
 viewController 只是一个中间人，接收 view 的事件、调用  viewModel 的方法、响应 viewModel 的变化。
 viewModel 绝对不能包含视图 view（UIKit.h），不然就跟 view 产生了耦合，不方便复用和测试。
 viewModel之间可以有依赖。
 viewModel避免过于臃肿，否则重蹈Controller的覆辙，变得难以维护。
 
 
   【视图模型】MVVM模式的核心，它是连接view和model的桥梁。它有两个方向：一是将【模型】转化成【视图】，
 即将后端传递的数据转化成所看到的页面。实现的方式是：数据绑定。二是将【视图】转化成【模型】，即将所看
 到的页面转化成后端的数据。实现的方式是：DOM 事件监听。这两个方向都实现的，我们称之为数据的双向绑定。
 总结：在MVVM的框架下视图和模型是不能直接通信的。它们通过ViewModel来通信，ViewModel通常要实现一个
 observer观察者，当数据发生变化，ViewModel能够监听到数据的这种变化，然后通知到对应的视图做自动更新，
 而当用户操作视图，ViewModel也能监听到视图的变化，然后通知数据做改动，这实际上就实现了数据的双向绑定。
 并且MVVM中的View 和 ViewModel可以互相通信

*/



@end
