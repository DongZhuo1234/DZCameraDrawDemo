# DZCameraDrawDemo
##自定义相机画板

![效果](https://github.com/DongZhuo1234/DZCameraDrawDemo/blob/master/demoGIF.gif)

##使用示例
把demo中的``DZCameraDraw``文件夹拖到自己的项目中,在使用的地方导入``#import "DZCameraViewController.h"``,添加下面代码就能实现上面的效果了.
```
DZCameraViewController *cameraVC = [[DZCameraViewController alloc] init];
/*
cameraVC.lineColor = [UIColor blackColor];///线条默认红色
cameraVC.lineWidth = 5;///线条默认宽3
*/ 

cameraVC.completeImage = ^(UIImage *image){
//image:最后拿到的图片
};
    
[self presentViewController:cameraVC animated:YES completion:nil];
```