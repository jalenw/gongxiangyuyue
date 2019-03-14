//
//  UserViewController.m
//  Dianwan
//
//  Created by 黄哲麟 on 2018/7/19.
//  Copyright © 2018年 intexh. All rights reserved.
//

#import "UserViewController.h"
#import "TZImagePickerController.h"
#import "LZHAreaPickerView.h"
#import "LZHDatePickerView.h"
#import "NSDate+Helper.h"
#import "LZHActionSheetView.h"
#import "YYImageClipViewController.h"

#define ORIGINAL_MAX_WIDTH [UIScreen mainScreen].bounds.size.width
@interface UserViewController ()<YYImageClipDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    NSString *job_id;
    NSString *area_id;
    NSString *pic_url;
}
@property(nonatomic,strong)NSString *oss_url;
@property(nonatomic,strong)NSString *location_url;
@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    [self requestUserinfo];
    [self setupForDismissKeyboard];//只要controller加上此方法，点击空白地方就能收起键盘
}

-(void)rightbarButtonDidTap:(UIButton *)button
{
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)avatarAct:(UIButton *)sender {
    [self editPortrait];
}

- (IBAction)jobAct:(UIButton *)sender {
    NSArray *array = @[@{@"profession":@"护士",@"id":@"1"},@{@"profession":@"医生",@"id":@"2"},@{@"profession":@"律师",@"id":@"3"},@{@"profession":@"程序员",@"id":@"4"}];
    LZHAreaPickerView *picker = [[LZHAreaPickerView alloc] initWithFrame:ScreenBounds];
    picker.array = array;
    picker.name = @"profession";//对应字典里的KEY就会显示出来
    [picker setBlock:^(NSDictionary *dict) {
        job_id = [dict safeStringForKey:@"id"];
        [sender setTitle:[dict safeStringForKey:@"profession"] forState:UIControlStateNormal];
    }];
    [picker showPicker];
}

- (IBAction)cityAct:(UIButton *)sender {
    //同职业
}

- (IBAction)dateAct:(UIButton *)sender {
    LZHDatePickerView *datePicker = [[LZHDatePickerView alloc] initWithFrame:ScreenBounds];
    datePicker.datePicker.maximumDate = [NSDate date];
    [datePicker setBlock:^(NSDate *date) {
        [self.birthday setTitle:[NSString stringWithFormat:@"%@",[NSDate dateYearStringOfInterval:date.timeIntervalSince1970*1000]] forState:UIControlStateNormal];
    }];
    [datePicker showPicker];
}

- (IBAction)sexAct:(UIButton *)sender {
    LZHActionSheetView *actionSheet = [LZHActionSheetView createWithTitleArray:@[@"女",@"男"]];
    [actionSheet setBlock:^(NSInteger index, NSString *title) {
        if (index == 0) {
            [sender setTitle:@"女" forState:UIControlStateNormal];
        }else if (index == 1){
            [sender setTitle:@"男" forState:UIControlStateNormal];
        }
    }];
    [actionSheet show];
}


- (void)editPortrait {
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"相机", @"从手机相册选择", nil];
    [choiceSheet showInView:self.view];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照，&& [self doesCameraSupportTakingPhotos] 支持c相机
        if ([self isCameraAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {//设置后摄像头
                controller.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
        
    } else if (buttonIndex == 1) {
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
    }
}

#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    YYImageClipViewController *imgCropperVC = [[YYImageClipViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
    imgCropperVC.delegate = self;
    [picker pushViewController:imgCropperVC animated:NO];
    //    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - YYImageCropperDelegate
- (void)imageCropper:(YYImageClipViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    
    [self.avatar setImage:editedImage];
    NSData *imgData = UIImageJPEGRepresentation(editedImage, 1);
    [SVProgressHUD show];
    [[ServiceForUser manager] postFileWithActionOp:@"/mobile/common/upload_header_img" andData:imgData andUploadFileName:[Tooles getUploadImageName] andUploadKeyName:@"name" and:@"image/jpeg" params:@{} progress:^(NSProgress *uploadProgress) {
        NSLog(@"%f",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } block:^(NSDictionary *responseObject, NSString *error, BOOL status, NSError *requestFailed) {
        [SVProgressHUD dismiss];
        if (status) {
            pic_url = [[responseObject safeDictionaryForKey:@"result"] safeStringForKey:@"datas"];
            [self dismissViewControllerAnimated:YES completion:^{
                [self.avatar sd_setImageWithURL:[NSURL URLWithString:pic_url]];
            }];
        }
    }];
}

- (void)imageCropperDidCancel:(YYImageClipViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

#pragma mark - camera utility
- (BOOL)isCameraAvailable {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL)isRearCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL)isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL)doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL)isPhotoLibraryAvailable {
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL)canUserPickVideosFromPhotoLibrary {
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL)canUserPickPhotosFromPhotoLibrary {
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL)cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType {
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

//提交用户资料
- (IBAction)submitAction:(UIButton *)sender {
    
    NSDictionary *param =@{
                           @"avatar":pic_url,
                           @"name":self.name.text,
                           @"member_areaid":@"",
                           @"member_cityid":@"",
                           @"member_provinceid":@""
                           };
    [SVProgressHUD show];
    [[ServiceForUser manager]postMethodName:@"/mobile/member/save_info" params:param block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        [SVProgressHUD dismiss];
        if (status) {
            
        }else{
            [AlertHelper showAlertWithTitle:error];
        }
    }];
}


//获取个人信息
-(void)requestUserinfo{
    [[ServiceForUser manager] postMethodName:@"/mobile/member/get_user_info" params:nil block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        if (status) {
            //设置UI
            self.oss_url = [data safeStringForKey:@"oss_url"];
            self.location_url = [data safeStringForKey:@"location_url"];
            NSDictionary *result = [data safeDictionaryForKey:@"result"];
            AppDelegateInstance.defaultUser.avatar = [result safeStringForKey:@"member_avatar"];
            AppDelegateInstance.defaultUser.phone =[result safeStringForKey:@"member_mobile"];
            AppDelegateInstance.defaultUser.nickname =[result safeStringForKey:@"member_name"];
            
                [self.avatar sd_setImageWithURL:[NSURL URLWithString:AppDelegateInstance.defaultUser.avatar]];
                self.name.text = AppDelegateInstance.defaultUser.nickname;
            [self.realName setTitle:AppDelegateInstance.defaultUser.nickname forState:UIControlStateNormal];
            [self.phone setTitle:AppDelegateInstance.defaultUser.phone forState:UIControlStateNormal];
            [self.city setTitle:AppDelegateInstance.defaultUser.member_cityid forState:UIControlStateNormal];
        }else{
            [AlertHelper showAlertWithTitle:error];
        }
    }];
    
}


@end
