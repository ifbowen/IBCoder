//
//  MBMmap.m
//  MBCoder
//
//  Created by Bowen on 2019/12/5.
//  Copyright © 2019 inke. All rights reserved.
//

#import "MBMmap.h"

// ReadFile  读操作

// Param:   inPathName      文件路径
//          outDataPtr      映射文件的起始位置
//          mapSize         映射的size
//          stat            文件信息
//          return value    返回值为0时，代表映射文件成功
//
int ReadFile( char * inPathName , void ** outDataPtr, struct stat * stat)
{
    size_t originLength;  // 原数据字节数
    int fd;               // 文件
    int outError;         // 错误信息
    
    // 打开文件
    fd = open( inPathName, O_RDWR | O_CREAT, 0 );
    
    if( fd < 0 ) {
        close( fd );
        outError = errno;
        return 1;
    }
    
    // 获取文件状态
    int fsta = fstat( fd, stat );
    if( fsta != 0 ) {
        close( fd );
        outError = errno;
        return 1;
    }
    
    // 需要映射的文件大小
    originLength = (* stat).st_size;
    size_t mapsize = originLength;
    
    // 文件映射到内存
    int result = MapFile(fd, outDataPtr, mapsize ,stat);
    
    // 文件映射成功
    if( result == 0 ) {
        // 关闭文件
        close( fd );
    } else {
        // 映射失败
        close( fd );
        outError = errno;
        return 1;
    }
    return 0;
}

// WriteFile  写操作

// Param:   inPathName      文件路径
//          string          需要写入的字符串
//          return value    返回值为0时，代表映射文件成功
//
int WriteFile( char * inPathName , char * string)
{
    size_t originLength;  // 原数据字节数
    size_t dataLength;    // 数据字节数
    void * dataPtr;       // 文件写入起始地址
    void * start;         // 文件起始地址
    struct stat statInfo; // 文件状态
    int fd;               // 文件
    int outError;         // 错误信息
    
    // 打开文件
    fd = open( inPathName, O_RDWR | O_CREAT, 0 );
    
    if( fd < 0 )
    {
        close(fd);
        outError = errno;
        return 1;
    }
    
    // 获取文件状态
    int fsta = fstat( fd, &statInfo );
    if( fsta != 0 )
    {
        close(fd);
        outError = errno;
        return 1;
    }
    
    // 需要映射的文件大小
    dataLength = strlen(string);
    originLength = statInfo.st_size;
    size_t mapsize = originLength + dataLength;
    
    
    // 文件映射到内存
    int result = MapFile(fd, &dataPtr, mapsize ,&statInfo);
    
    // 文件映射成功
    if( result == 0 ) {
        start = dataPtr;
        dataPtr = dataPtr + statInfo.st_size;
        memcpy(dataPtr, string, dataLength);
        // 关闭映射，将修改同步到磁盘上，可能会出现延迟
//        munmap(start, mapsize);
    }
    close(fd);
    
    return 0;
}

// MapFile 文件映射

// Param:   fd              代表文件
//          outDataPtr      映射文件的起始位置
//          mapSize         映射的size
//          stat            文件信息
//          return value    返回值为0时，代表映射文件成功
//
int MapFile( int fd, void ** outDataPtr, size_t mapSize , struct stat * stat)
{
    int outError;         // 错误信息
    struct stat statInfo; // 文件状态
    
    statInfo = * stat;
    
    outError = 0;
    *outDataPtr = NULL;
    
    *outDataPtr = mmap(NULL,
                       mapSize,
                       PROT_READ|PROT_WRITE,
                       MAP_FILE|MAP_SHARED,
                       fd,
                       0);
    
    if( *outDataPtr == MAP_FAILED ) {
        outError = errno;
    } else {
        // 调整文件的大小
        ftruncate(fd, mapSize);
        // 刷新文件
        fsync(fd);
    }
    return outError;
}
