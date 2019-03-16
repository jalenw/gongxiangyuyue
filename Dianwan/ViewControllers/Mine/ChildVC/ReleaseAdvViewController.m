//
//  ReleaseAdvViewController.m
//  Dianwan
//
//  Created by Yang on 2019/3/16.
//  Copyright © 2019 intexh. All rights reserved.
//

#import "ReleaseAdvViewController.h"
#import "ReaelseCollectionViewCell.h"
#import "YYImageClipViewController.h"


#define Str @"请在此输入广告详情"

#define MaxCount 50
#define cachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

@interface ReleaseAdvViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIPickerViewDelegate,UINavigationControllerDelegate,YYImageClipDelegate,UITextViewDelegate>
{
    BOOL isEditText;
  
}
@property (weak, nonatomic) IBOutlet UILabel *countLab;
@property (weak, nonatomic) IBOutlet UIView *advView;
@property(nonatomic,strong)NSMutableArray *imagesArr;
@property (weak, nonatomic) IBOutlet UICollectionView *imageCollectionView;
@property(nonatomic,strong)  UITextView *textview;
@end

@implementation ReleaseAdvViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"发布广告";
    self.remainingBtn.selected = YES;
    _imagesArr = [NSMutableArray arrayWithObjects:[UIImage imageNamed:@"add"], nil];
    [self setRightBarButtonWithTitle:@"发布"];
    
    [self addtestView];
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.advView addGestureRecognizer:tapGr];
    
    self.countLab.text = [NSString stringWithFormat:@"0/%ld",(long)MaxCount];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(40, 40);
    layout.sectionInset= UIEdgeInsetsMake(5, 5, 5, 5);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.imageCollectionView.collectionViewLayout = layout;
    self.imageCollectionView.delegate =self;
    self.imageCollectionView.dataSource  =self;
    self.imageCollectionView.showsHorizontalScrollIndicator =NO;
    [self.imageCollectionView registerNib:[UINib nibWithNibName:@"ReaelseCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ReaelseCollectionViewCell"];
    
}
#pragma mark - 隐藏键盘
-(void)viewTapped:(UITapGestureRecognizer*)tapGr {
    HIDE_KEY_BOARD
}

-(void)addtestView{
     self.textview = [[UITextView alloc] initWithFrame:CGRectMake(0, 44, self.advView.width, 112)];
    [self.advView addSubview:self.textview];
    self.textview.backgroundColor=[UIColor whiteColor]; //背景色
    self.textview.scrollEnabled = YES;    //当文字超过视图的边框时是否允许滑动，默认为“YES”
    self.textview.editable = YES;        //是否允许编辑内容，默认为“YES”
    self.textview.delegate = self;       //设置代理方法的实现类
    self.textview.showsVerticalScrollIndicator = NO;
    self.textview.font=[UIFont systemFontOfSize:14]; //设置字体名字和字体大小;
    self.textview.returnKeyType = UIReturnKeyDone;//return键的类型
    self.textview.keyboardType = UIKeyboardAppearanceDefault;//键盘类型
    self.textview.textAlignment = NSTextAlignmentLeft; //文本显示的位置默认为居左
    //    self.textview.dataDetectorTypes = UIDataDetectorTypeAll; //显示数据类型的连接模式（如电话号码、网址、地址等）
    self.textview.textColor = [UIColor blackColor];
    self.textview.text = Str;//设置显示的文本内容
    self.textview.textColor = [UIColor lightGrayColor];
    [self.advView bringSubviewToFront:self.countLab];
}

#pragma mark - TextView Delegate
//开始编辑
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([self.textview.text isEqualToString:Str]) {
        self.textview.text = @"";
    }
    self.textview.textColor = [UIColor blackColor];
    isEditText = YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if([text isEqualToString:@"\n"]){
        HIDE_KEY_BOARD
        return NO;
    }
    return YES;
}

- (void) textViewDidChange:(UITextView *)textView {
    self.countLab.text = [NSString stringWithFormat:@"%ld/%ld",textView.text.length,(long)MaxCount];
}

//结束编辑
- (void)textViewDidEndEditing:(UITextView *)textView{
    //该判断用于联想输入
    if (textView.text.length > MaxCount)
    {
        textView.text = [textView.text substringToIndex:MaxCount];
        self.countLab.text = [NSString stringWithFormat:@"%ld/%ld",(long)MaxCount,(long)MaxCount];
    }
    
    if ([self.textview.text isEqualToString:@""]) {
        self.textview.text = Str;
        self.textview.textColor = [UIColor lightGrayColor];
        isEditText = NO;
    }else{
        self.textview.textColor = [UIColor blackColor];
    }
}



//发布广告
-(void)rightbarButtonDidTap:(UIButton *)button{
//        是    string    支付密码
//        是    int    1 余额 0 金币 红包类型
//        是    string    内容
//        是    string    标题
//        是    int    每个红包价值
//    num
    NSDictionary *params=@{
                           @"imgs":@[@"http://www.public66.cn/uploads/home/common/default_user_portrait.gif"],//_imagesArr,
                           @"paypwd":@"222222",
                           @"pay_type":@(1),//1 余额 0 金币 红包类型
                           @"content":self.textview.text,
                           @"title":self.advTitleTF.text,
                           @"price":@(1), //红包个数
                           @"num":@(1)
                           };
    [[ServiceForUser manager] postMethodName:@"advertising/addAdv" params:params block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        if (status) {
             [AlertHelper showAlertWithTitle:@"红包广告发布成功"];
            
        }else
        {
            [AlertHelper showAlertWithTitle:error];
        }
                               
    }];
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _imagesArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
        ReaelseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ReaelseCollectionViewCell" forIndexPath:indexPath];
        cell.coverImage =self.imagesArr[indexPath.row];
        return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row !=_imagesArr.count-1) {
        //
    }else{
        if(_imagesArr.count == 4){
            [AlertHelper showAlertWithTitle:@"最多可上传3张封面图"];
        }else{
            [self editPortrait];
        }
    }
}







- (void)editPortrait {
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"相机", @"相册", nil];
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
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - YYImageCropperDelegate
- (void)imageCropper:(YYImageClipViewController *)cropperViewController didFinished:(UIImage *)editedImage {
        [_imagesArr insertObject:editedImage atIndex:0];
        [self.imageCollectionView reloadData];
        [cropperViewController dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imageCropperDidCancel:(YYImageClipViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ScreenWidth) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ScreenWidth;
        btWidth = sourceImage.size.width * (ScreenWidth / sourceImage.size.height);
    } else {
        btWidth = ScreenWidth;
        btHeight = sourceImage.size.height * (ScreenWidth / sourceImage.size.width);
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //显示f导航栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.navigationController.navigationBar setHidden:NO];
}


//- (BOOL)prefersStatusBarHidden {
//
//    return NO;
//
//}


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
- (IBAction)btnSelectAct:(UIButton *)sender {
    if (sender.tag == 101) {
        self.goldCoinBtn.selected = YES;
        self.remainingBtn.selected =NO;
    }else{
            self.goldCoinBtn.selected = NO;
            self.remainingBtn.selected =YES;
    }
}

@end
