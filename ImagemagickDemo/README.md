#  ImageMagicK iOS Demo


### 注意事项

1. 在测试的时候，工程内部嵌入的.png文件会被压缩，所以必须在Building Settings 中设置 Compress PNG Files 为 No,同时在Xcode 16.4需要设置 STRIP_PNG_TEXT = NO
2. 如果使用cocoapods集成，请确保使用use_frameworks!，否则会报错找不到模块
3. 工程中使用了Imagemagick的C++ API，所以需要在Build Settings 中设置 C++ Standard Library 为 libc++
4. 工程中使用了Imagemagick的C API，所以需要在Build Settings 中设置 Enable C++ Exceptions 为 Yes
5. 如果遇到找不到头文件的问题，请检查 Header Search Paths 和 Library Search Paths 是否正确设置，同时检查是否勾选了 Recursive
6. 需要把Use Header Map (USE_HEADERMAP = NO
)设置为NO, 否则会报错：file not found with <angled> include; use "quotes" instead。同时，会有其他的问题，比如UIKit,CoreText,CoreGraphics等系统库需要自己添加;
7. 需要把Always Search User Paths (ALWAYS_SEARCH_USER_PATHS = NO)设置为NO, 否则会报错: library not found for -lstdc++
8. 需要加入libz和libiconv依赖库;
9. 需要在Build Settings 中在Preprocessor Macros 中添加预处理宏
    - MAGICKCORE_HDRI_ENABLE = YES
    - MAGICKCORE_QUANTUM_DEPTH = 16 //这个我目前媒添加，后面看情况如果需要再添加;


