//
//  IBController24.m
//  IBCoder1
//
//  Created by Bowen on 2018/5/18.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBController24.h"

@interface IBController24 ()



@end

@implementation IBController24

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
}

- (void)setupUI {
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}



@end

/*
 一、TCP连接
 在TCP/IP协议中，TCP协议提供可靠的面向连接的服务；三次握手（建立连接）和四次挥手（关闭连接）；使用滑动窗口机制进行流量控制；
 所谓三次握手(Three-way Handshake)，是指建立一个TCP连接时，需要客户端和服务器总共发送3个包
 1、三次握手建立TCP连接的各状态
 （1）第一次握手：建立连接时，客户端A发送SYN包[SYN=1,seq=x]到服务器B，并进入SYN_SEND状态，等待服务器B确认。
 （2）第二次握手：服务器B收到SYN包，必须确认客户A的SYN，同时自己也发送一个SYN包，即SYN+ACK包[SYN=1,ACK=1,seq=y,ack=x+1]，此时服务器B进入SYN_RECV状态。
 （3）第三次握手：客户端A收到服务器B的SYN＋ACK包，向服务器B发送确认包ACK[ACK=1,seq=x+1,ack=y+1]，此包发送完毕，客户端A和服务器B进入ESTABLISHED状态，完成三次握手。 完成三次握手，客户端与服务器开始传送数据。
 
 总之、 三次握手完成后，客户端和服务器就建立了TCP连接。这时可以调用accept函数获得此连接。三次握手的目的是连接服务器指定端口，建立TCP连接，
 并同步连接双方的序列号和确认号并交换TCP 窗口大小信息。在socket编程中，客户端执行connect()时，将会触发三次握手。
 
 2、四次挥手关闭TCP连接的各状态
 （1）首先A B端的TCP进程都处于established状态， 当A的应用程序传送完报文段，就会去主动关闭连接。A会停止发送报文段（但是还会接收），并向B发送[FIN = 1,seq=u]数据，之后进入FIN-WAIT-1状态；
 （2）B接收到A发送的请求之后，会通知应用进程，A已经不再发送数据，同时B会向A发送ACK确认数据[ACK=1,seq=v,ack=u+1 ]，B进入CLOSE-WAIT状态，A接收到B发送的数据之后，A进入FIN-WAIT-2状态；此时A到B方的连接已经关闭了（即半连接状态）。
 （3）当B的应用进程发现自己也没有数据需要传送，B应用进程就会发出被动关闭的请求，B此时向A发送[FIN=1,ACK=1,seq=w,ack=u+1]数据，并且进入LAST-ACK状态；
 （4）A接收到B发送的数据之后，向B发送ACK确认数据[ACK =1,seq=u+1,ack=w+1]，进入TIME-WAIT状态，等待2MSL之后正常关闭连接进入CLOSED状态；B接收到A发送的确认之后进入CLOSED状态。B到A方的连接关闭！至此，TCP连接才真正全部关闭！
 
 3、为什么建立连接协议是三次握手，而关闭连接却是四次握手呢？
   这是因为服务端的LISTEN状态下的SOCKET当收到客户端的SYN报文的建立连接请求后，它可以把ACK和SYN（ACK起应答作用，而SYN起同步作用）放在
 一个报文里来发送。但关闭连接时，当收到对方的FIN报文通知时，它仅仅表示对方没有数据发送给你了；但未必你所有的数据都全部发送给对方了，所以你
 可以未必会马上会关闭SOCKET，也即你可能还需要发送一些数据给对方之后，再发送FIN报文给对方来表示你同意现在可以关闭连接了，所以它这里的ACK报
 文和FIN报文多数情况下都是分开发送的。
 
 TCP：面向连接、传输可靠(保证数据正确性,保证数据顺序)、用于传输大量数据(流模式)、速度慢，建立连接需要开销较多(时间，系统资源)。
 UDP：面向非连接、传输不可靠、用于传输少量数据(数据包模式)、速度快。
 
 二、HTTP连接
    HTTP连接最显著的特点是客户端发送的每次请求都需要服务器回送响应，在请求结束后，会主动释放连接。
 从建立连接到关闭连接的过程称为“一次连接”。请求-响应是它的最大特点
 1、请求行2、请求头3、请求体4、响应状态行
 
 三、Socket
    socket（套接字）是通信的基石，是支持TCP/IP协议的网络通信的基本操作单元，包含进行网络通信必须的五种信息：连接使用的协议，本地主机的
 IP地址，本地进程的协议端口，远地主机的IP地址，远地进程的协议端口。
    建立Socket连接至少需要一对套接字，其中一个运行于客户端，称为ClientSocket，另一个运行于服务器端，称为ServerSocket。套接字之间的连
 接过程分为三个步骤：服务器监听，客户端请求，连接确认。
 Socket可以支持不同的传输层协议（TCP或UDP），当使用TCP协议进行连接时，该Socket连接就是一个TCP连接,UDP连接同理。

 四、TCP/IP五层模型的协议分为：应用层、传输层、网络层、数据链路层和物理层

 
四、彼此区别
 1、TCP连接与HTTP连接的区别
    HTTP是基于TCP的，客户端往服务端发送一个HTTP请求时第一步就是要建立与服务端的TCP连接，也就是先三次握手，“你好，你好，你好”。
 从HTTP 1.1开始支持持久连接，也就是一次TCP连接可以发送多次的HTTP请求。
 小总结：HTTP基于TCP
 
 2、TCP连接与Socket连接的区别
    socket层只是在TCP/UDP传输层上做的一个抽象接口层，因此一个socket连接可以基于连接，也有可能基于UDP。基于TCP协议的socket连接同样需
 要通过三次握手建立连接，是可靠的；基于UDP协议的socket连接不需要建立连接的过程，不过对方能不能收到都会发送过去，是不可靠的，大多数的即时
 通讯IM都是后者。
 小总结：Socket也基于TCP
 
 3、HTTP连接与Socket连接的区别
   通常情况下Socket连接就是TCP连接，因此Socket连接一旦建立，通信双方即可开始相互发送数据内容，直到双方连接断开。但在实际应用中，客户端到
 服务器之间的通信防火墙默认会关闭长时间处于非活跃状态的连接而导致 Socket 连接断连，因此需要通过轮询告诉网络，该连接处于活跃状态。
   而HTTP连接使用的是“请求—响应”的方式，不仅在请求时需要先建立连接，而且需要客户端向服务器发出请求后，服务器端才能回复数据。
 
 
 */
