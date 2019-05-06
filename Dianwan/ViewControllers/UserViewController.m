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
#import "cityModel.h"

#define ORIGINAL_MAX_WIDTH [UIScreen mainScreen].bounds.size.width
@interface UserViewController ()<YYImageClipDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSString *job_id;
    NSString *area_id;
    NSString *pic_url;
    NSArray *SelecttitleArr;
}
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
@property (strong, nonatomic) IBOutlet UIView *citySelectView;
@property (weak, nonatomic) IBOutlet UITableView *provinceTableview;
@property (strong, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet UIScrollView *titleScrollview;
@property(nonatomic,strong) NSString *province_id;
@property(nonatomic,strong) NSString *city_id;
@property(nonatomic,strong) NSString *aree_id;
@property(nonatomic,strong)NSString *oss_url;
@property(nonatomic,strong)NSString *location_url;
@property(nonatomic,strong)NSMutableArray<cityModel *> *provinceArr;
@property(nonatomic,strong)NSMutableArray<cityModel *> *cityArr;
@property(nonatomic,strong)NSMutableArray<cityModel *> *areaArr;
@property(nonatomic,assign)NSInteger index;
@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    [self requestUserinfo];
    self.index = 1;
    [self getCityData:@""];
    self.maskView.frame = ScreenBounds;
    self.maskView.hidden = YES;
    [self.view addSubview:_maskView];
    self.province_id=@"";
    self.city_id=@"";
    self.aree_id=@"";
    SelecttitleArr = @[@"请选择",@"请选择",@"请选择"];
    for(int i=0;i<SelecttitleArr.count;i++){
      UIButton *button =   [[UIButton alloc]init];
        button.frame = CGRectMake(i * _titleScrollview.width/3, 0, _titleScrollview.width/3, 45);
        button.tag = i+1;
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:RGB(254, 129, 10) forState:UIControlStateNormal];
        [button setTitle:SelecttitleArr[i]  forState:UIControlStateNormal];
        [_titleScrollview addSubview:button];
    }
    self.provinceTableview.dataSource =self;
    self.provinceTableview.delegate =self;
    [self setupForDismissKeyboard];//只要controller加上此方法，点击空白地方就能收起键盘
}


-(void)btnClick:(UIButton *)btn{
    
   
    if(self.index == btn.tag ||self.index < btn.tag ){
        //下一级
        return;
    }
     self.index =  btn.tag;
   
    if (self.index == 1) {
        [(UIButton *)_titleScrollview.subviews[self.index] setTitle:@"请选择" forState:UIControlStateNormal];
        [(UIButton *)_titleScrollview.subviews[self.index +1] setTitle:@"请选择" forState:UIControlStateNormal];
        self.city_id = @"";
        self.aree_id = @"";
    }else if(self.index == 2){
        [(UIButton *)_titleScrollview.subviews[self.index] setTitle:@"请选择" forState:UIControlStateNormal];
        self.city_id = @"";
    }
  
    [self.provinceTableview reloadData];
}
#pragma mark dalegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.index == 1) {
        return self.provinceArr.count;
    }else if(self.index == 2){
          return self.cityArr.count;
    }else{
          return self.areaArr.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellstr =@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellstr];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellstr];
    }
    cityModel *model;
    if(self.index == 1){
         model=self.provinceArr[indexPath.row];
    }else if(self.index == 2){
         model =self.cityArr[indexPath.row];
    } else{
        model =self.areaArr[indexPath.row];
    }
    cell.textLabel.textColor =RGB(51, 51, 51);
    cell.textLabel.text =model.area_name;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.index==1) {
        self.province_id  = [NSString stringWithFormat:@"%@",self.provinceArr[indexPath.row].area_id];
         [(UIButton *)_titleScrollview.subviews[self.index -1] setTitle:self.provinceArr[indexPath.row].area_name forState:UIControlStateNormal];
    }else if(self.index==2){
        self.city_id  = [NSString stringWithFormat:@"%@",self.cityArr[indexPath.row].area_id];
         [(UIButton *)_titleScrollview.subviews[self.index -1] setTitle:self.cityArr[indexPath.row].area_name forState:UIControlStateNormal];
    }else{
        self.aree_id  = [NSString stringWithFormat:@"%@",self.areaArr[indexPath.row].area_id];
         [(UIButton *)_titleScrollview.subviews[self.index -1] setTitle:self.areaArr[indexPath.row].area_name forState:UIControlStateNormal];
    }
    if (self.index == 3) {
        return;
    }
    self.index ++;
    cityModel *model;
    if (self.index == 2) {
        [self.cityArr removeAllObjects];
        model = self.provinceArr[indexPath.row];
    }else if(self.index == 3){
        [self.areaArr removeAllObjects];
        model = self.cityArr[indexPath.row];
    }
   
    [self getCityData:[NSString stringWithFormat:@"%@",model.area_id]];
}


-(void)getCityData:(NSString *)area_id{
    [SVProgressHUD show];
    [[ServiceForUser manager]postMethodName:@"area/area_list" params:(self.index==1?nil: @{@"area_id":area_id}) block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        [SVProgressHUD dismiss];
        if (status) {
            NSDictionary *result= [data safeDictionaryForKey:@"result"];
            NSArray *area_list  = [result objectForKey:@"area_list"];
            for (int i=0; i<area_list.count;i++) {
                cityModel *model =[[cityModel alloc]init];
                model.area_id = [area_list[i] safeNumberForKey:@"area_id"];
                model.area_name = [area_list[i] safeStringForKey:@"area_name"];
                if(self.index==1){
                    [self.provinceArr addObject:model];
                    
                }else if(self.index==2){
                    [self.cityArr addObject:model];
                    
                }else{
                      [self.areaArr addObject:model];
                }
            }
            [self.provinceTableview reloadData];
        }else{
            [AlertHelper showAlertWithTitle:error];
        }
    }];
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


- (IBAction)cityAct:(UIButton *)sender {
    self.maskView.hidden = NO;
}

- (IBAction)dateAct:(UIButton *)sender {
    LZHDatePickerView *datePicker = [[LZHDatePickerView alloc] initWithFrame:ScreenBounds];
    datePicker.datePicker.maximumDate = [NSDate date];
    [datePicker setBlock:^(NSDate *date) {
        [self.birthday setTitle:[NSString stringWithFormat:@"%@",[NSDate dateYearStringOfInterval:date.timeIntervalSince1970*1000]] forState:UIControlStateNormal];
    }];
    [datePicker showPicker];
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
    [[ServiceForUser manager] postFileWithActionOp:@"common/upload_header_img" andData:imgData andUploadFileName:[Tooles getUploadImageName] andUploadKeyName:@"img" and:@"image/jpeg" params:@{} progress:^(NSProgress *uploadProgress) {
        NSLog(@"%f",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } block:^(NSDictionary *responseObject, NSString *error, BOOL status, NSError *requestFailed) {
        [SVProgressHUD dismiss];
        if (status) {
            pic_url = [[responseObject safeDictionaryForKey:@"result"] safeStringForKey:@"img_name"];
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
//    if([self.cityBtn.titleLabel.text isEqualToString:AppDelegateInstance.defaultUser.area] ){
//        [AlertHelper showAlertWithTitle:@"请修改地址信息"];
//        return;
//    }
    if(self.cityBtn.titleLabel.text.length==0){
        [AlertHelper showAlertWithTitle:@"请输入地址信息"];
                return;
    }
    NSDictionary *param =@{
                           @"avatar":pic_url.length>0?pic_url:AppDelegateInstance.defaultUser.avatar,
                           @"name":self.name.text,
                           @"member_areaid":self.aree_id,
                           @"member_cityid":self.city_id,
                           @"member_provinceid":self.province_id
                           };
    [SVProgressHUD show];
    [[ServiceForUser manager]postMethodName:@"member/save_info" params:param block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        [SVProgressHUD dismiss];
        if (status) {
            AppDelegateInstance.defaultUser.avatar = pic_url.length>0?pic_url:AppDelegateInstance.defaultUser.avatar,
            AppDelegateInstance.defaultUser.nickname =self.name.text;
            [AlertHelper showAlertWithTitle:@"个人信息修改成功" duration:2];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [AlertHelper showAlertWithTitle:error];
        }
    }];
}


//获取个人信息
-(void)requestUserinfo{
    [[ServiceForUser manager] postMethodName:@"member/get_user_info" params:nil block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        if (status) {
            //设置UI
            self.oss_url = [data safeStringForKey:@"oss_url"];
            self.location_url = [data safeStringForKey:@"location_url"];
            NSDictionary *result = [data safeDictionaryForKey:@"result"];
            AppDelegateInstance.defaultUser.avatar = [result safeStringForKey:@"member_avatar"];
            AppDelegateInstance.defaultUser.phone =[result safeStringForKey:@"member_mobile"];
            AppDelegateInstance.defaultUser.nickname =[result safeStringForKey:@"member_name"];
            AppDelegateInstance.defaultUser.viptype = [result safeIntForKey:@"viptype"];
            AppDelegateInstance.defaultUser.area =[result safeStringForKey:@"area"].length>0?[result safeStringForKey:@"area"]:AppDelegateInstance.defaultUser.area;
            [AppDelegateInstance saveContext];
            [self.avatar sd_setImageWithURL:[NSURL URLWithString:AppDelegateInstance.defaultUser.avatar]];
            self.name.text = AppDelegateInstance.defaultUser.nickname;
            self.realName.text=AppDelegateInstance.defaultUser.nickname;
            self.phone.text=AppDelegateInstance.defaultUser.phone;
            NSLog(@"%@",AppDelegateInstance.defaultUser.area);
            [self.cityBtn setTitle:AppDelegateInstance.defaultUser.area forState:UIControlStateNormal];
         
        }else{
            [AlertHelper showAlertWithTitle:error];
        }
    }];
    
}
- (IBAction)hiddSelectViewACT:(UIButton *)sender {
    NSMutableString *areaStr = [[NSMutableString alloc]init];
    if( ![((UIButton*)_titleScrollview.subviews[0]).titleLabel.text containsString:@"请选择"] ){
        [areaStr appendString:((UIButton*)_titleScrollview.subviews[0]).titleLabel.text ];
    }
    if(![((UIButton*)_titleScrollview.subviews[1]).titleLabel.text containsString:@"请选择"] ){
          [areaStr appendString:((UIButton*)_titleScrollview.subviews[1]).titleLabel.text ];
    }
    if(![((UIButton*)_titleScrollview.subviews[2]).titleLabel.text containsString:@"请选择"]){
        [areaStr appendString:((UIButton*)_titleScrollview.subviews[2]).titleLabel.text ];
     }
    if(![self.cityBtn.titleLabel.text isEqualToString:areaStr] && areaStr.length!=0){
         [self.cityBtn setTitle:areaStr forState:UIControlStateNormal];
    }else{
         [self.cityBtn setTitle:AppDelegateInstance.defaultUser.area forState:UIControlStateNormal];
    }
    self.maskView.hidden = YES;
}


-(NSMutableArray *)provinceArr{
    if (!_provinceArr) {
        _provinceArr = [NSMutableArray array];
    }
    return _provinceArr;
}

-(NSMutableArray *)cityArr{
    if (!_cityArr) {
        _cityArr = [NSMutableArray array];
    }
    return _cityArr;
}

-(NSMutableArray *)areaArr{
    if (!_areaArr) {
        _areaArr = [NSMutableArray array];
    }
    return _areaArr;
}

@end
