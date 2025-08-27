//
//  ImageCompressor.m
//  ImagemagickDemo
//
//  Created by freeblow on 2025/8/24.
//
//#define MAGICKCORE_HEIC_DELEGATE 1

#import "ImageCompressor.h"
#import <Magick++.h>
#import <MagickCore/MagickCore.h>
#import <iostream>
#import <libde265/de265.h>
#import <libheif/heif.h>

#import <libheif/heif_library.h>



//#import <MagickWand/MagickWand.h>
//#import <MagickWand/magick-image.h>
extern "C" void RegisterStaticModules(void);

@implementation ImageCompressor

//+(int) compress_image:(NSString *)inputPath output:(NSString *)outputPath quality:(NSInteger)quality {
//    // 初始化 MagickWand 环境
//    MagickWandGenesis();
//    
//    MagickWand *magick_wand = NULL;
//    MagickBooleanType status;
//    
//    // 创建一个新的 wand
//    magick_wand = NewMagickWand();
//    if (magick_wand == NULL) {
//        MagickWandTerminus();
//        return 1;
//    }
//    
//    // 读取输入的图片
//    status = MagickReadImage(magick_wand, [inputPath UTF8String]);
//    if (status == MagickFalse) {
//        DestroyMagickWand(magick_wand);
//        MagickWandTerminus();
//        return 2;
//    }
//    
//    // 移除所有附加的 profile 信息（如 EXIF），减小文件大小
//    MagickStripImage(magick_wand);
//    
//    // 设置压缩格式和质量
//    // 对于 JPEG, quality 范围是 1 (最低) 到 100 (最高)
//    status = MagickSetImageCompressionQuality(magick_wand, quality);
//    if (status == MagickFalse) {
//        DestroyMagickWand(magick_wand);
//        MagickWandTerminus();
//        return 3;
//    }
//    
//    // 写入压缩后的图片到输出路径
//    status = MagickWriteImage(magick_wand, [outputPath UTF8String]);
//    if (status == MagickFalse) {
//        DestroyMagickWand(magick_wand);
//        MagickWandTerminus();
//        return 4;
//    }
//    
//    // 清理并释放资源
//    DestroyMagickWand(magick_wand);
//    MagickWandTerminus();
//    
//    return 0; // 成功
//}


+ (BOOL)compressImageAtPath:(NSString *)sourcePath
                   toPath:(NSString *)targetPath
                 maxWidth:(int)maxWidth
                maxHeight:(int)maxHeight
                  quality:(int)quality
                    error:(NSError **)error
{
    try {
        // 1. 初始化 ImageMagick
        static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                // 手动注册 HEIC 编码器。
                Magick::InitializeMagick(NULL);
//                MagickCore::RegisterHEICImage();
            });
        
        
        // 2. 读取图片
        std::string srcPath = std::string([sourcePath UTF8String]);
        Magick::Image image(srcPath);

        // 3. 调整尺寸（如果 maxWidth/maxHeight > 0）
        int width = image.columns();
        int height = image.rows();

        if (maxWidth > 0 && maxHeight > 0 && (width > maxWidth || height > maxHeight)) {
            double scaleX = (double)maxWidth / width;
            double scaleY = (double)maxHeight / height;
            double scale = std::min(scaleX, scaleY);
            int newWidth = static_cast<int>(width * scale);
            int newHeight = static_cast<int>(height * scale);
            image.resize(Magick::Geometry(newWidth, newHeight));
        }
        
        image.strip();
        // 4. 设置压缩质量（主要针对 JPEG）
        if (quality > 0 && quality <= 100) {
            image.quality(quality);
        }

        
        // 5. 写入输出路径
        std::string dstPath = std::string([targetPath UTF8String]);
        image.write(dstPath);

        return YES;
    } catch (Magick::Exception &e) {
        if (error) {
            *error = [NSError errorWithDomain:@"ImageMagickError"
                                         code:1
                                     userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithUTF8String:e.what()]}];
        }
        return NO;
    }
}

+ (void)printSupportedFormats {
    MagickCore::MagickWandGenesis(); // 初始化

    size_t number_formats;
    char **formats = MagickCore::MagickQueryFormats("*", &number_formats);

    NSLog(@"支持的格式数量: %zu", number_formats);
    for (size_t i = 0; i < number_formats; i++) {
        NSLog(@"%@", [NSString stringWithUTF8String:formats[i]]);
    }

    MagickCore::MagickRelinquishMemory(formats); // 释放
    MagickCore::MagickWandTerminus(); // 清理
}
+ (void)formatCheck{
    Magick::CoderInfo info("HEIC");
    std::cout << info.name() << ": (" << info.description() << ") : ";
    std::cout << "Readable = ";
    if ( info.isReadable() )
        std::cout << "true";
    else
        std::cout << "false";
    std::cout << ", ";
    std::cout << "Writable = ";
    if ( info.isWritable() )
        std::cout << "true";
    else
        std::cout << "false";
    std::cout << ", ";
    std::cout << "Multiframe = ";
    if ( info.isMultiFrame() )
        std::cout << "true";
    else
        std::cout << "false";
    std::cout << std::endl;
}


@end
