//
//  IBGroup2Controller18.m
//  MBCoder
//
//  Created by Bowen on 2019/11/18.
//  Copyright © 2019 inke. All rights reserved.
//

#import "IBGroup2Controller18.h"

@interface IBGroup2Controller18 ()

@end

@implementation IBGroup2Controller18

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

@end

/**
 一、命令行
 1.1 命令行介绍

 1.1.1 Git 设置
 
 全局设置
 $ git config --global user.name "knight"
 $ git config --global user.email "knight@126.com"
 项目设置
 $ git config user.name "knight"
 $ git config user.email "knight@126.com"
 
 1.1.2 创建一个新仓库（本地）

 $ git clone http://git.knight.cc/practice/git-exmple.git
 $ cd git-exmple
 $ touch README.md
 $ git add README.md
 $ git commit -m "add README"
 $ git push -u origin master

 1.1.3 在已存在的目录中创建仓库

 $ cd existing_folder
 $ git init
 $ git remote add origin http://git.knight.cc/practice/git-exmple.git
 $ git add .
 $ git commit -m "Initial commit"
 $ git push -u origin master

 1.1.4 将本地已存在的仓库推送到远程仓库

 $ cd existing_repo
 $ git remote rename origin old-origin
 $ git remote add origin http://git.knight.cc/practice/git-exmple.git
 $ git push -u origin --all
 $ git push -u origin --tags
 
 
 1.1.5 查看分支相关命令

 $ git branch -r; //查看远程分支
 $ git branch; //查看本地分支
 $ git branch -a; //查看所有分支
 
 1.1.6 拉取远程分支并创建本地分支
 
 $ git checkout -b dev1 origin/dev2;
 从远程分支dev2拉取到本地并且创建本地分支dev1，且俩者之间建立映射关系,同时当前分支会切换到dev1
 
 1.1.7 建立本地分支与远程分支的映射关系（或者为跟踪关系track）

 $ git branch -vv; //输出映射关系
 $ git branch -u origin/dev; //将当前本地分支与远程分支dev建立映射关系
 $ git branch --unset-upstream; //撤销当前本地分支与远程分支的映射关系
 
 1.1.8 切换当前本地分支

 $ git checkout dev; // dev为本地分支名
 
 1.1.9 拉取远程分支代码

 $ git pull; // 使用的前提是当前分支需要与远程分支之间建立映射关系
 
 1.1.10 推送本地分支代码到远程分支

 $ git push; // 使用的前提是当前分支需要与远程分支之间建立映射关系
 
 1.1.11
 使用一次新的commit，替代上一次提交，如果代码没有任何新变化，则用来改写上一次commit的提交信息
 $ git commit --amend -m [message]
 
 1.1.12
 $ git branch -d [branch-name] // 删除分支

 1.1.13
 $ git push origin --delete [branch-name] // 删除远程分支
 
 
 二、Gitflow总览
 1、分支
 master : 主分支，主要用来版本发布。
 develop: 日常开发分支，该分支正常保存了开发的最新代码。
 feature: 具体的功能开发分支，只与 develop 分支交互。
 release: release分支可以认为是 master 分支的未测试版。比如说某一期的功能全部开发完成，那么就将 develop 分支合并到 release 分支，测试没有问题并且到了发布日期就合并到master 分支，进行发布。
 hotfix: 线上 bug 修复分支。
 
 三、Git 分支管理
 
 1.1 合并分支间的修改 Merge
 1.1.1 直接合并(straight merge)：
 $ git checkout master
 $ git merge dev
 注意：没参数的情况下merge是fast-forward（快进式）的，
      即Git将master分支的指针直接移到dev的最前方。
 
 1.1.2 压合合并(squashed commits)：
 将一条分支上的若干个提交条目压合成一个提交条目，提交到另一条分支的末梢。
 $ git checkout master
 $ git merge --squash dev

 1.1.3 拣选合并(cherry-picking)：
 拣选另一条分支上的某个提交条目的改动带到当前分支上
 $ git checkout master
 $ git cherry-pick 321d76f
 
 要拣选多个提交，可以给git cherry-pick命令传递-n选项，比如：
 $ git cherry-pick –n 321d76f
 
 1.1.4 合并分支

 场景:现在有dev本地分支与远程分支，master本地分支与远程分支，现在将dev的分支代码合并到master主干上
 思路步骤:
 1.切换到本地分支dev上，并且pull拉取一下远程dev分支上的改动地方
 2.将所有本地修改进行commit并且push到远程dev分支上
 3.将当前本地分支切换到本地master上
 4.将本地分支dev合并到本地master上
 5.将本地已经合并了dev分支的master进行push到远程master上。
 注意: 在进行merge(合并)的时候需要禁用fast-forward模式
      命令：git merge --no-ff dev //dev为本地被合并的分支名字

 四、Git 版本回退
 1.1 git reset
 $ git reset --hard a0fvf8
 $ git push -f
 弊端：会使 HEAD 指针往回移动，从而会失去之后的提交信息
 
 1.2 git revert
 反做创建一个新的版本，这个版本的内容与我们要回退到的目标版本一样，但是HEAD指针是指向这个新生成的版本，而不是目标版本。
 
 五、命名规范
 版本号主要有3部分构成（由两个.分割成三部分）主版本、次版本、修订号：
 主版本：程序的主版本号，除非系统做整体重构，一般不变化
 次版本：功能版本号，一般为功能迭代的版本号，每次版本号为上一次正常按迭代计划发版的次版本 + 1;主版本发生变更，次版本需重置为0
 修订号：每次线上BUG修复，该版本号相对上次修订号+1 （前提：相同主版本以及次版本）;主版本和次版本发生变更，修订号需重置为0
 
 1.2 分支命名规范

 1.2.1 主分支：
 master：master 分支就叫 master 分支
 develop：develop 分支就叫 develop 分支

 1.2.2 辅助分支：

 1.2.2.1 Feature 分支
 feature/v1.16.0_xxx
 v1.16.0 表示当前迭代的版本号，xxx表示当前迭代的功能或业务单元的名称

 1.2.2.2 Release 分支
 release/v1.17.0
 v1.17.0 根据上线需求和系统上线计划，合理规划版本号，每个大版本号表示一次上线正常上线过程。

 1.2.2.3 Hotfix 分支
 hotfix/v1.17.1
 v1.17.1 表示v1.17.0 这个版本做了1次线上问题热修复。



 





 
 
 */
