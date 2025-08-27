//
//  ImageCompressor.h
//  ImagemagickDemo
//
//  Created by freeblow on 2025/8/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageCompressor : NSObject

+ (void)printSupportedFormats;

+ (void)formatCheck;

+(int) compress_image:(NSString *)inputPath output:(NSString *)outputPath quality:(NSInteger)quality;

/// 压缩图片
/// @param sourcePath 图片原始路径（NSString）
/// @param targetPath 压缩后输出路径（NSString）
/// @param maxWidth 最大宽度（<=0 表示不缩放）
/// @param maxHeight 最大高度（<=0 表示不缩放）
/// @param quality 压缩质量 0~100
+ (BOOL)compressImageAtPath:(NSString *)sourcePath
                 toPath:(NSString *)targetPath
               maxWidth:(int)maxWidth
              maxHeight:(int)maxHeight
                quality:(int)quality
                  error:(NSError **)error;
@end

NS_ASSUME_NONNULL_END
