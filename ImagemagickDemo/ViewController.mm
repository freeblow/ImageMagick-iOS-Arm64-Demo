//
//  ViewController.m
//  ImagemagickDemo
//
//  Created by freeblow on 2025/8/24.
//

#import "ViewController.h"

#import "ImageCompressor.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *originalImageView;
@property (weak, nonatomic) IBOutlet UITextField *extensionTextField;
@property (weak, nonatomic) IBOutlet UIButton *convertBtn;
@property (weak, nonatomic) IBOutlet UIImageView *resultImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [ImageCompressor formatCheck];
    
    [ImageCompressor printSupportedFormats];
}
- (IBAction)convertClick:(id)sender {
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString *sourceImagePath = [[NSBundle mainBundle] pathForResource:@"IMG_5013.HEIC" ofType:@""];
    self.originalImageView.image = [UIImage imageWithContentsOfFile:sourceImagePath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:sourceImagePath]){
        NSLog(@"文件: %@ 存在", sourceImagePath);
    }else{
        NSLog(@"文件: %@ 不存在", sourceImagePath);
        return;
    }
    
    NSString *outputFormat = @"jpg";
    if(self.extensionTextField.text && [self.extensionTextField.text length]){
        outputFormat = self.extensionTextField.text;
    }
    
    NSError *error = nil;
    NSString *outputPath = [NSString stringWithFormat:@"%@/compress_result_%f.%@", documentPath, [[NSDate date] timeIntervalSince1970],outputFormat];
    
//    [ImageCompressor compress_image:sourceImagePath output:outputPath quality:75];
    
    
    [ImageCompressor compressImageAtPath:sourceImagePath
                                  toPath:outputPath
                                maxWidth:0
                               maxHeight:0
                                 quality:75
                                   error:&error];
    
    self.resultImageView.image = [UIImage imageWithContentsOfFile:outputPath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:outputPath]){
        NSLog(@"压缩后的文件: %@ 存在", outputPath);
    }else{
        NSLog(@"压缩后的文件: %@ 不存在（错误: %@）", outputPath, error.localizedDescription);
        return;
    }
}


@end
