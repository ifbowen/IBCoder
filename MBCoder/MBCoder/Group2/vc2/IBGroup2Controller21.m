//
//  IBGroup2Controller21.m
//  MBCoder
//
//  Created by Bowen on 2019/12/3.
//  Copyright © 2019 inke. All rights reserved.
//

#import "IBGroup2Controller21.h"

@interface IBGroup2Controller21 ()

@end

@implementation IBGroup2Controller21

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

/**
 
 概述
 
 大概的原理，它是将所有的依赖库都放到另一个名为 Pods 项目中，然后让主项目依赖 Pods 项目，这样，源码管理工作都从主项目移到了 Pods 项目中。
 1、Pods 项目最终会编译成一个名为 libPods.a 的文件，主项目只需要依赖这个 .a 文件即可。(这里纠正下,也有可能是.framework文件)
 2、对于资源文件，CocoaPods 提供了一个名为 Pods-resources.sh 的 bash 脚本，该脚本在每次项目编译的时候都会执行，将第三方库的各种资源文件复制到目标目录中。
 3、CocoaPods 通过一个名为 Pods.xcconfig 的文件来在编译时设置所有的依赖和参数。

 一、Podfile
 
 1、主配置
 install! 这个命令是cocoapods声明的一个安装命令，用于安装引入Podfile里面的依赖库。
 
 install! 'cocoapods',
       :generate_multiple_pod_projects => true,
       :incremental_installation => true

2、Dependencies（依赖项）
 pod指定特定的依赖库
 > 0.1 高于0.1版本（不包含0.1版本）的任意一个版本
 >= 0.1 高于0.1版本（包含0.1版本）的任意一个版本
 < 0.1 低于0.1版本（不包含0.1版本）的任意一个
 <= 0.1低于0.1版本（包含0.1版本）的任意一个
 ~> 0.1.0 版本 0.1.0的版本到0.2 ，不包括0.2。
 
3、Build configurations（编译配置）
 
 3.1下面写法指明只有在Debug和Beta模式下才有启用配置
 pod 'YYKit', :configurations => ['Debug', 'Beta']
 
 3.2可以弄白名单只指定一个build configurations。
 pod 'PonyDebugger', :configuration => 'Debug'

 4、Subspecs
 一般情况我们会通过依赖库的名称来引入，cocoapods会默认安装依赖库的所有内容。
 
 4.1我们也可以指定安装具体依赖库的某个子模块，例如：
 
 # 仅安装QueryKit库下的Attribute模块
 pod 'QueryKit/Attribute'

 # 仅安装QueryKit下的Attribute和QuerySet模块
 pod 'QueryKit', :subspecs => ['Attribute', 'QuerySet']

 5、Using the files from a local path (使用本地文件)
 pod 'AFNetworking', :path => '~/Documents/AFNetworking'
 
 6、From a podspec in the root of a library repository (引用仓库根目录的podspec)

 6.1引入master分支（默认）
 pod 'AFNetworking', :git => 'https://github.com/gowalla/AFNetworking.git'

 6.2引入指定的分支
 pod 'AFNetworking', :git => 'https://github.com/gowalla/AFNetworking.git', :branch => 'dev'

 6.3引入某个节点的代码
 pod 'AFNetworking', :git => 'https://github.com/gowalla/AFNetworking.git', :tag => '0.7.0'

 6.4引入某个特殊的提交节点
 pod 'AFNetworking', :git => 'https://github.com/gowalla/AFNetworking.git', :commit => '082f8319af'

 7、从外部引入podspec引入
 pod 'JSONKit', :podspec => 'https://example.com/JSONKit.podspec'

 8、target
 在给定的块内定义pod的target（Xcode工程中的target）和指定依赖的范围。一个target应该与Xcode工程的target有关联。
 默认情况下，target会包含定义在块外的依赖，除非指定不使用inherit!来继承（说的是嵌套的块里的继承问题）
 target 'ZipApp' do
   pod 'SSZipArchive'
 end
 
 9、project
 如果没有显示的project被指定，那么会默认使用target的父target指定的project作为目标。如果如果没有任何一个target指定目标，
 那么就会使用和Podefile在同一目录下的project。同样也能够指定是否这些设置在release或者debug模式下生效。
 为了做到这一点，你必须指定一个名字和:release/:debuge关联起来
 
 10、inhibit_all_warnings!（强迫症者的福音）
 inhibit_all_warnings! 屏蔽所有来自于cocoapods依赖库的警告

 11、use_frameworks!
 通过指定use_frameworks!要求生成的是framework而不是静态库。
 如果使用use_frameworks!命令会在Pods工程下的Frameworks目录下生成依赖库的framework
 如果不使用use_frameworks!命令会在Pods工程下的Products目录下生成.a的静态库
 
 12、Workspace
 默认情况下，我们不需要指定，直接使用与Podfile所在目录的工程名一样就可以了。如果要指定另外的名称，而不是使用工程的名称，可以这样指定：
 workspace 'MyWorkspace'
 
 13、def
 我们还可以通过def命令来声明一个pod集：
 def 'CustomPods'
    pod 'IQKeyboardManagerSwift'
 end
 
 14、Source
 source是指定pod的来源
 source 'https://github.com/artsy/Specs.git'

 二、搭建私有库
 
 1、创建podspec
 pod spec create projectName
 
 2、Use Git
 git init
 git commit -m "first commit"
 git remote add origin https://github.com/c/test.git
 git push -u origin master
 
 3、Create tag
 git tag 0.0.1
 git push origin 0.0.1
 
 4、Edit podspec file
 
 5、Verify Component Project
 pod lib lint --allow-warnings --no-clean

 6、Push To CocoaPods
 pod repo add GMHttpDNS git@gitee.com:IBCoder/HTTPDNS.git
 pod repo push IBSpec GMHttpDNS.podspec --allow-warnings

 三、spec文件
 
 1、文件匹配
 1）*匹配所有文件
 2）c*匹配以名字C开头的文件
 3）*c匹配以名字c结尾的文件
 4）*c*匹配所有名字包含c的文件
 5）**文件夹以及递归子文件夹
 6）?任意一个字符(注意是一个字符)
 7）[set] 匹配多个字符,支持取反
 8）{p,q} 匹配名字包括p 或者 q的文件
 
 Pod::Spec.new do |spec|
 
 spec.name         = "GMHttpDNS"
 spec.version      = "0.0.1"
 spec.homepage     = "git@gitee.com:IBCoder/HTTPDNS.git"
 spec.license      = { :type => "MIT", :file => "LICENSE" }
 spec.platform     = :ios, "9.0"
 spec.author       = { "正北飞" => "1214569257@qq.com" }
 spec.source       = { :git => "git@gitee.com:IBCoder/HTTPDNS.git", :tag => "#{spec.version}" }
 spec.summary      = "A short description of GMHttpDNS."
 spec.description  = <<-DESC
                     GMHttpDNS
                     DESC

 spec.source_files  = 'GMHttpDNSModule/\**\/\*.{h,m}'
 spec.public_header_files = 'GMHttpDNSModule/\**\/\*.h'

 spec.frameworks = 'CoreTelephony','SystemConfiguration'
 spec.libraries = 'sqlite3.0', 'resolv'
 spec.vendored_frameworks = 'GMHttpDNSModule/Frameworks/\*.framework'
 spec.vendored_libraries =  'GMHttpDNSModule/lib/\*.a'
 spec.resource_bundles = {'GMHttpDNS' => ['**\/GMHttpDNSModule/Resources/\**\/\*.{png,jpg}', '**\/GMHttpDNSModule/\**\/\*.{xib,storyboard}']}

 */

@end


/// 获取资源
@interface GMHttpDNSResource : NSObject

+ (NSBundle *)mainBundle;

+ (UIImage *)imageNamed:(NSString *)imageName;

@end

@implementation GMHttpDNSResource

static NSBundle *GMBundle;

+ (NSBundle *)mainBundle
{
    if (!GMBundle) {
        GMBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"GMBundle" ofType:@"bundle"]];
    }
    return GMBundle;
}

+ (UIImage *)imageNamed:(NSString *)imageName {
    NSString *path = [NSString stringWithFormat:@"GMBundle.bundle/%@",imageName];
    UIImage *image = [UIImage imageNamed:path];
    if (!image) {
        image = [UIImage imageNamed:imageName];
    }
    return image;
}

@end

