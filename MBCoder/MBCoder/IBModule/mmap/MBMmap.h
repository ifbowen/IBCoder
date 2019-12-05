//
//  MBMmap.h
//  MBCoder
//
//  Created by Bowen on 2019/12/5.
//  Copyright © 2019 inke. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <sys/stat.h>
#include <sys/mman.h>

// MapFile 文件映射

// Param:    fd              代表文件
//           outDataPtr      映射文件的起始位置
//           mapSize         映射的size
//           stat            文件信息
//           return value    返回值为0时，代表映射文件成功
//
int MapFile( int fd , void ** outDataPtr, size_t mapSize , struct stat * stat);


// WriteFile  写操作

// Param:    inPathName      文件路径
//           string          需要写入的字符串
//           return value    返回值为0时，代表映射文件成功
//
int WriteFile( char * inPathName , char * string);


// ReadFile  读操作

// Param:    inPathName      文件路径
//           outDataPtr      映射文件的起始位置
//           mapSize         映射的size
//           stat            文件信息
//           return value    返回值为0时，代表映射文件成功
//
int ReadFile( char * inPathName , void ** outDataPtr, struct stat * stat);
