//
//  IBGroup2Controller19.m
//  MBCoder
//
//  Created by BowenCoder on 2019/11/26.
//  Copyright © 2019 inke. All rights reserved.
//

#import "IBGroup2Controller19.h"

@interface IBGroup2Controller19 ()

@end

@implementation IBGroup2Controller19

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

/*
 一、设计模式六大原则
 1、单一职责原则（Single Responsibility Principle，简称SRP）
    核心思想: 应该有且仅有一个原因引起类的变更
    问题描述：假如有类Class1完成职责T1，T2，当职责T1有变更需要修改时，有可能影响到该类的T2职责正常工作。
       好处：类的复杂度降低、可读性提高、可维护性提高、扩展性提高、降低了变更引起的风险。
     需注意：单一职责原则提出了一个编写程序的标准，用“职责”或“变化原因”来衡量接口或类设计得是否优良，但是“职责”和“变化原因”都是不可以度量的，因项目和环境而异。

 2、里氏替换原则（Liskov Substitution Principle，简称LSP）
    核心思想：在使用基类的的地方可以任意使用其子类，能保证子类完美替换基类。
    通俗来讲：只要父类能出现的地方子类就能出现。反之，父类则未必能胜任。
       好处：提高代码的可重用性，增强程序的健壮性，即使增加了子类，原有的子类还可以继续运行。
       缺点：继承是入侵性的，拥有父类的属性和方法；降低代码的灵活性，必须拥有父类的属性和方法；增强耦合性，父类属性或方法改变，需要考虑子类。
     需注意：如果子类不能完整地实现父类的方法，或者父类的某些方法在子类中已经发生“畸变”，则建议断开父子继承关系 采用依赖、聚合、组合等关系代替继承。

 3、依赖倒置原则（Dependence Inversion Principle，简称DIP）
    核心思想：高层模块不应该依赖底层模块，二者都该依赖其抽象；抽象不应该依赖细节；细节应该依赖抽象；简言之，面向接口编程
       说明：高层模块就是调用端，低层模块就是具体实现类。抽象就是指接口或抽象类。细节就是实现类。
    通俗来讲：依赖倒置原则的本质就是通过抽象（接口或抽象类）使个各类或模块的实现彼此独立，互不影响，实现模块间的松耦合。
    问题描述：类A直接依赖类B，假如要将类A改为依赖类C，则必须通过修改类A的代码来达成。这种场景下，类A一般是高层模块，负责复杂的业务逻辑；
            类B和类C是低层模块，负责基本的原子操作；假如修改类A，会给程序带来不必要的风险。
    解决方案：将类A修改为依赖接口interface，类B和类C各自实现接口interface，类A通过接口interface间接与类B或者类C发生联系，则会大大降低修改类A的几率。
       好处：依赖倒置的好处在小型项目中很难体现出来。但在大中型项目中可以减少需求变化引起的工作量。使并行开发更友好。

 4、接口隔离原则（Interface Segregation Principle，简称ISP）
    核心思想：类间的依赖关系应该建立在最小的接口上
    通俗来讲：建立单一接口，不要建立庞大臃肿的接口，尽量细化接口，接口中的方法尽量少。
            也就是说，我们要为各个类建立专用的接口，而不要试图去建立一个很庞大的接口供所有依赖它的类去调用。
    问题描述：类A通过接口interface依赖类B，类C通过接口interface依赖类D，如果接口interface对于类A和类B来说不是最小接口，
            则类B和类D必须去实现他们不需要的方法。
     需注意：接口尽量小，但是要有限度。对接口进行细化可以提高程序设计灵活性，但是如果过小，则会造成接口数量过多，使设计复杂化，所以一定要适度。
            提高内聚，减少对外交互。使接口用最少的方法去完成最多的事情
            为依赖接口的类定制服务。只暴露给调用的类它需要的方法，它不需要的方法则隐藏起来。只有专注地为一个模块提供定制服务，才能建立最小的依赖关系。

 5、迪米特法则（Law of Demeter，简称LoD）
    核心思想：类间解耦。
    通俗来讲：一个类对自己依赖的类知道的越少越好。低耦合，高内聚。
    
 6、开放封闭原则（Open Close Principle,简称OCP）
    核心思想：尽量通过扩展软件实体来解决需求变化，而不是通过修改已有的代码来完成变化
    通俗来讲：一个软件产品在生命周期内，都会发生变化，既然变化是一个既定的事实，我们就应该在设计的时候尽量适应这些变化，以提高项目的稳定性和灵活性。
       优点：具有灵活性，通过拓展一个功能模块即可实现功能的扩充，不需修改内部代码。具有稳定性，表现在基本功能类不允许被修改，使得被破坏的程度大大下降。

 概括:
 1）单一职责原则告诉我们实现类要职责单一；
 2）里氏替换原则告诉我们不要破坏继承体系；
 3）依赖倒置原则告诉我们要面向接口编程；
 4）接口隔离原则告诉我们在设计接口的时候要精简单一；
 5）迪米特法则告诉我们要降低耦合。
 6）开闭原则是总纲，他告诉我们要对扩展开放，对修改关闭。
 
 
 二、例子：
 
 1、单一职责原则（Single Responsibility Principle，简称SRP）

 class OrderList: NSObject { // 订单列表
     var waitPayList: WaitPayList? // 待支付
     var waitGoodsList: WaitGoodsList? // 待收货
     var receivedGoodsList: ReceivedGoodsList? // 已收货
 }
 class WaitPayList: NSObject {

 }
 class WaitGoodsList: NSObject {

 }
 class ReceivedGoodsList: NSObject {

 }
 
 2、里氏替换原则（Liskov Substitution Principle，简称LSP）

 修改之前

 class Car {
     func run() {
         print("汽车跑起来了")
     }
 }

 class BaoMaCar: Car {
     override func run() {
         super.run()
         print("当前行驶速度是80Km/h")
     }
 }
 
 可以看到我们重写了run方法，增加了汽车行驶速度的逻辑，这样是不满足的里氏替换原则的。因为所有基类Car替换成子类BaoMaCar，run方法的行为跟以前不是一模一样了。

 修改之后

 class Car {
     func run() {
         print("汽车跑起来了")
     }
 }

 class BaoMaCar: Car {
     func showSpeed() {
         print("当前行驶速度是80Km/h")
     }
 }
 
 3、依赖倒置原则（Dependence Inversion Principle，简称DIP）

 修改之前

 class Car {
     func refuel(_ gaso: Gasoline90) {
         print("加90号汽油")
     }
     func refuel(_ gaso: Gasoline93) {
         print("加93号汽油")
     }
 }

 class Gasoline90 {

 }

 class Gasoline93 {

 }
 
 上面这段代码有什么问题，可以看到Car高层模块依赖了底层模块Gasoline90和Gasoline93，这样写是不符合依赖倒置原则的。

 修改之后

 class Car {
     func refuel(_ gaso: IGasoline) {
         print("加\(gaso.name)汽油")
     }
 }

 protocol IGasoline {
     var name: String { get }
 }

 class Gasoline90: IGasoline {
     var name: String = "90号"
 }

 class Gasoline93: IGasoline {
     var name: String = "93号"
 }
 
 修改之后我们高层模块Car依赖了抽象IGasoline，底层模块Gasoline90和Gasoline93也依赖了抽象IGasoline，这种设计是符合依赖倒置原则的。

 4、接口隔离原则（Interface Segregation Principle，简称ISP）

 修改之前

 protocol ICar {
     func run()
     func showSpeed()
     func playMusic()
 }

 class Car: ICar {
     func run() {
         print("汽车跑起来了")
     }

     func showSpeed() {
         print("当前行驶速度是80Km/h")
     }

     func playMusic() {
         print("播放音乐")
     }
 }
 
 可以看到我们定义Car实现了ICar的接口，但是并不是每个车都有播放音乐的功能的，这样对于一般的低端车没有这个功能，对于他们来说，这个接口的设计就是冗余的。

 修改之后

 protocol IProfessionalCar {//具备一般功能的车
     func run()
     func showSpeed()
 }

 protocol IEntertainingCar {//具备娱乐功能的车
     func run()
     func showSpeed()
     func playMusic()
 }

 class SangTaNaCar: IProfessionalCar {//桑塔纳轿车
     func run() {
         print("汽车跑起来了")
     }

     func showSpeed() {
         print("当前行驶速度是80Km/h")
     }
 }

 class BaoMaCar: IEntertainingCar {//宝马轿车
     func run() {
         print("汽车跑起来了")
     }

     func showSpeed() {
         print("当前行驶速度是80Km/h")
     }

     func playMusic() {
         print("播放音乐")
     }
 }

 
 5、迪米特法则（Law of Demeter，简称LoD）
 
 例子：实现一个给汽车加油的设计，使的我们可以随时保证加油的质量过关。

 修改之前

 class Person {
     var car: Car?

     func refuel(_ gaso: IGasoline) {
         if gaso.isQuality == true {//如果汽油质量过关，我们就给汽车加油
             car?.refuel(gaso)
         }
     }
 }

 class Car {
     func refuel(_ gaso: IGasoline) {
         print("加\(gaso.name)汽油")
     }
 }

 protocol IGasoline {
     var name: String { get }
     var isQuality: Bool { get }
 }

 class Gasoline90: IGasoline {
     var name: String = "90号"
     var isQuality: Bool = false
 }

 class Gasoline93: IGasoline {
     var name: String = "93号"
     var isQuality: Bool = true
 }
 
 可以看到上面有个问题，我们怎么知道汽油的质量是否过关呢，即时我们知道，加油判断油的质量这个事情也不应该由我们来做。

 修改之后

 import Foundation

 class Person {//给车加油的人
     var car: Car?

     func refuel(_ worker: WorkerInPetrolStation, _ gaso: IGasoline) {
         guard let car = car else {return}

         worker.refuel(car, gaso)
     }
 }

 class WorkerInPetrolStation {//加油站工作人员
     func refuel(_ car: Car, _ gaso: IGasoline) {
         if gaso.isQuality == true {//如果汽油质量过关，我们就给汽车加油
             car.refuel(gaso)
         }
     }
 }

 class Car {
     func refuel(_ gaso: IGasoline) {
         print("加\(gaso.name)汽油")
     }
 }

 protocol IGasoline {
     var name: String { get }
     var isQuality: Bool { get }
 }

 class Gasoline90: IGasoline {
     var name: String = "90号"
     var isQuality: Bool = false
 }

 class Gasoline93: IGasoline {
     var name: String = "93号"
     var isQuality: Bool = true
 }
 
 6、开放封闭原则（Open Close Principle,简称OCP）

 修改之前代码

 class PayHelper {
     func pay(send: PaySendModel) {
         if send.type == 0 {
             //支付宝支付
         }
         else if send.type == 1 {
             //微信支付
         }
     }
 }

 class PaySendModel {
     var type: Int = 0
     var info: [String: AnyHashable]?
 }
 
 修改之后

 class PayHelper {
     var processors: [Int: PayProcessor]?

     func pay(send: PaySendModel)  {
         guard let processors = processors else {return}
         guard let payProcessor: PayProcessor = processors[send.type] else {return}

         payProcessor.handle(send: send)//支付
     }
 }

 class PaySendModel {
     var type: Int = 0
     var info: [String: AnyHashable]?
 }

 protocol PayProcessor {
     func handle(send: PaySendModel)
 }

 class AliPayProcessor: PayProcessor {
     func handle(send: PaySendModel) {

     }
 }

 class WeChatPayProcessor: PayProcessor {
     func handle(send: PaySendModel) {

     }
 }

*/

@end
