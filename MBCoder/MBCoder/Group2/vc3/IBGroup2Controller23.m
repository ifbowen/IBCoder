//
//  IBGroup2Controller23.m
//  MBCoder
//
//  Created by Bowen on 2019/12/5.
//  Copyright © 2019 inke. All rights reserved.
//

#import "IBGroup2Controller23.h"
#import "MBMmap.h"
#import <MMKV.h>

@interface IBGroup2Controller23 () <MMKVHandler>

@end

@implementation IBGroup2Controller23

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [self write];
    [self mmkv];
}

- (void)mmkv
{
    // 进阶-日志
//    [MMKV registerHandler:self];
    // 关闭日志
    [MMKV setLogLevel:MMKVLogNone];

    // MMKV 提供一个全局的实例
    [[MMKV defaultMMKV] setString:@"bowen" forKey:@"string"];
    NSLog(@"%@", [[MMKV defaultMMKV] getStringForKey:@"string"]);
    
    // 如果不同业务需要区别存储
    MMKV *kv = [MMKV mmkvWithID:@"uid"];
    [kv setObject:@{@"key":@"value"} forKey:@"dict"];
    NSLog(@"%@", [kv getObjectOfClass:NSDictionary.class forKey:@"dict"]);
    
    // NSUserDefaults 迁移
    MMKV *userKV = [MMKV mmkvWithID:@"userDefault"];
    [userKV migrateFromUserDefaults:[NSUserDefaults standardUserDefaults]];
    
    // 加密
    NSData *cryptKey = [@"My-Encrypt-Key" dataUsingEncoding:NSUTF8StringEncoding];
    MMKV *cryptMmkv = [MMKV mmkvWithID:@"MyID" cryptKey:cryptKey];
    // 修改秘钥
    NSData *key_1 = [@"Key_seq_1" dataUsingEncoding:NSUTF8StringEncoding];
    [cryptMmkv reKey:key_1];
    
}

#pragma mark - 日志

- (void)mmkvLogWithLevel:(MMKVLogLevel)level file:(const char *)file line:(int)line func:(const char *)funcname message:(NSString *)message {
    const char *levelDesc = NULL;
    switch (level) {
        case MMKVLogDebug:
            levelDesc = "D";
            break;
            case MMKVLogInfo:
            levelDesc = "I";
            break;
        case MMKVLogWarning:
            levelDesc = "W";
            break;
        case MMKVLogError:
            levelDesc = "E";
            break;
        default:
            levelDesc = "N";
            break;
    }
    NSLog(@"[%s] <%s:%d::%s> %@", levelDesc, file, line, funcname, message);
}

#pragma mark - 数据恢复

- (MMKVRecoverStrategic)onMMKVCRCCheckFail:(NSString *)mmapID {
    return MMKVOnErrorRecover;
}

- (MMKVRecoverStrategic)onMMKVFileLengthError:(NSString *)mmapID {
    return MMKVOnErrorRecover;
}

- (void)write
{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *directory = [path stringByAppendingPathComponent:@"bowen"];
    NSString *filePath = [NSString stringWithFormat:@"%@/text.txt", directory];
    
    NSFileManager *manager = [NSFileManager defaultManager];

    BOOL isDir = NO;
    BOOL existed = [manager fileExistsAtPath:directory isDirectory:&isDir];
    if (!(isDir && existed)){
        [manager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if (![manager fileExistsAtPath:filePath]) {
        [manager createFileAtPath:filePath contents:nil attributes:nil];
    }
    
    NSString *str = @"AAA";
    int write = WriteFile((char * )[filePath UTF8String], (char * )[str UTF8String]);
    if (!write) {
        NSLog(@"写入成功");
    } else {
        NSLog(@"写入失败");
    }
    char * outData;
    struct stat statInfo;;
    int read = ReadFile((char * )[filePath UTF8String], (void *)&outData, &statInfo);
    if (read == 0) {
        NSLog(@"读取成功 数据：%@", [NSString stringWithCString:outData encoding:NSUTF8StringEncoding]);
    } else {
        NSLog(@"读取失败");
    }
    
    NSData *data = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:nil];
    NSLog(@"NSData数据: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
}

@end


/**
 iOS的文件内存映射——mmap
 mmap是一种内存映射文件的方法，即将一个文件或者其它对象映射到进程的地址空间，实现文件磁盘地址和进程虚拟地址空间中一段虚拟地址的一一对映关系。
 实现这样的映射关系后，进程就可以采用指针的方式读写操作这一段内存，
 而系统会自动回写脏页面到对应的文件磁盘上，即完成了对文件的操作而不必再调用read,write等系统调用函数。
 相反，内核空间对这段区域的修改也直接反映用户空间，从而可以实现不同进程间的文件共享
 
 一、正常读写和mmap读写
 1、常规文件操作
 常规文件操作为了提高读写效率和保护磁盘，使用了页缓存机制。这样造成读文件时需要先将文件页从磁盘拷贝到页缓存中，
 由于页缓存处在内核空间，不能被用户进程直接寻址，所以还需要将页缓存中数据页再次拷贝到内存对应的用户空间中。
 这样，通过了两次数据拷贝过程，才能完成进程对文件内容的获取任务。写操作也是一样，待写入的buffer在内核空间不能直接访问，
 必须要先拷贝至内核空间对应的主存，再写回磁盘中（延迟写回），也是需要两次数据拷贝。

 2、mmap读取
 mmap操作文件中，创建新的虚拟内存区域和建立文件磁盘地址和虚拟内存区域映射这两步，没有任何文件拷贝操作。
 而之后访问数据时发现内存中并无数据而发起的缺页异常过程，可以通过已经建立好的映射关系，只使用一次数据拷贝，
 就从磁盘中将数据传入内存的用户空间中，供进程使用。
 注意事项：
 1）牺牲较大的虚拟内存，映射区域有多大就需要虚拟内存有多大；（故而太大的文件不适合映射整个文件，32位虚拟内存最大是4GB，可以只映射部分）
 2）因为映射有额外的性能消耗，所以适用于频繁读操作的场景；（单次使用的场景不建议使用）
 3）因为每次操作内存会同步到磁盘，所以不适用于移动磁盘或者网络磁盘上的文件；
 4）变长文件不适用；
 
 总而言之，常规文件操作需要从磁盘到页缓存再到用户主存的两次数据拷贝。而mmap操控文件，只需要从磁盘到用户主存的一次数据拷贝过程。
 说白了，mmap的关键点是实现了用户空间和内核空间的数据直接交互而省去了空间不同数据不通的繁琐过程。因此mmap效率更高。

 二、NSData与mmap
 
 NSData是我们常用类，有一个静态方法和mmap有关系
 + (id)dataWithContentsOfFile:(NSString *)path options:(NSDataReadingOptions)readOptionsMask error:(NSError **)errorPtr;
 
 NSDataReadingOptions三个参数具体的意思：
 NSDataReadingUncached : 不要缓存，如果该文件只会读取一次，这个设置可以提高性能；
 NSDataReadingMappedIfSafe : 在保证安全的前提下使用mmap；
 NSDataReadingMappedAlways : 使用mmap；
 
 如果使用mmap，则在NSData的生命周期内，都不能删除对应的文件。
 如果文件是在固定磁盘，非可移动磁盘、网络磁盘，则满足NSDataReadingMappedIfSafe。
 对iOS而言，这个NSDataReadingMappedIfSafe=NSDataReadingMappedAlways。
 
 那什么情况下应该用对应的参数？
 如果文件很大，直接使用dataWithContentsOfFile方法，会导致load整个文件，出现内存占用过多的情况；
 此时用NSDataReadingMappedIfSafe，则会使用mmap建立文件映射，减少内存的占用。
 使用场景举例——视频加载，视频文件通常比较大，但是使用的过程中不会同时读取整个视频文件的内容，可以使用mmap优化。
 
 三、MMKV和mmap
 NSUserDefault是常见的缓存工具，但是数据的同步有时会不及时，比如说在crash前保存的值很容易出现保存失败的情况，在App重新启动之后读取不到保存的值。
 MMKV很好的解决了NSUserDefault的局限，具体的好处见：https://github.com/Tencent/MMKV/wiki/design
 
 但是同样由于其独特设计，在数据量较大、操作频繁的场景下，会产生性能问题。
 这里的使用给出两个建议：
 1)不要全部用defaultMMKV，根据业务大的类型做聚合，避免某一个MMKV数据过大，
 特别是对于某些只会出现一次的新手引导、红点之类的逻辑，尽可能按业务聚合，使用多个MMKV的对象；
 2)对于需要频繁读写的数据，可以在内存持有一份数据缓存，必要时再更新到MMKV；
 
 四、总结
 mmap就是文件的内存映射，通常读取文件是将文件读取到内存，会占用真正的物理内存；而mmap是用进程的内存虚拟地址空间去映射实际的文件中，这个过程由操作系统处理。
 mmap不会为文件分配物理内存，而是相当于将内存地址指向文件的磁盘地址，后续对这些内存进行的读写操作，会由操作系统同步到磁盘上的文件
 
 */

