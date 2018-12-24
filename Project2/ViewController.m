//
//  ViewController.m
//  Project2
//
//  Created by 김규성 on 21/12/2018.
//  Copyright © 2018 김규성. All rights reserved.
//

#import "ViewController.h"
#import "GPUImage.h"
#import <AssetsLibrary/ALAssetsLibrary.h>


@class GPUImageStillCamera;

@interface ViewController () {
    
    __weak IBOutlet GPUImageView *m_caremaView;
    
    GPUImageStillCamera *m_stillCamera;
    
    GPUImageiOSBlurFilter *m_blurFilter;
    
    GPUImageCropFilter *m_cropFilter;
    
}
- (IBAction)ChangeLevel:(id)sender;
- (IBAction)shotBtnAction:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
-(void)initCamera{
    // 카메라 생성 및 세팅
    m_stillCamera = [[GPUImageStillCamera alloc] init];
    m_stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
    // 필터 생성 및 카메라에 필터 추가
    m_blurFilter = [[GPUImageiOSBlurFilter alloc] init];
    [m_stillCamera addTarget:m_blurFilter];
    
    // 카메라 뷰에 필터 추가
    [m_blurFilter addTarget:m_caremaView];
    
    
    // view 크기에 맞게 꽉차게
    m_caremaView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    
    // 카메라 캡쳐 시작
    [m_stillCamera startCameraCapture];
}
- (IBAction)ChangeLevel:(id)sender {
    
    UISlider *slider =(UISlider*)sender;
    
    if (slider.tag ==0)
    {
        m_blurFilter.blurRadiusInPixels =slider.value;
    }
    else if (slider.tag ==1)
    {
        m_blurFilter.saturation =slider.value;
        
    }
    else if (slider.tag ==2)
    {
        m_blurFilter.downsampling =slider.value;
    }
    else
    {
        m_blurFilter.rangeReductionFactor =slider.value;
    }
}

- (IBAction)shotBtnAction:(id)sender {
    [m_stillCamera capturePhotoAsImageProcessedUpToFilter:m_blurFilter withCompletionHandler:^(UIImage *processedImage, NSError *error)
     {
         
         [m_stillCamera pauseCameraCapture];
         
         UIImageWriteToSavedPhotosAlbum(processedImage,self,
                                        @selector(image:didFinishSavingWithError:contextInfo:),
                                        nil);
     }];
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo: (void *)contextInfo
{
    if (error != nil)
    {
        NSLog(@"Image Can not be saved");
    }
    else
    {
        NSLog(@"Successfully saved Image");
    }
}
@end
