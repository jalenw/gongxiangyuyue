//
//  AddLineViewController.m
//  Dianwan
//
//  Created by 黄哲麟 on 2019/3/19.
//  Copyright © 2019年 intexh. All rights reserved.
//

#import "AddLineViewController.h"
#import "LivePlayerViewController.h"
@interface AddLineViewController ()
{
    NSString *pic_url;
    NSInteger type;
}
@end

@implementation AddLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupForDismissKeyboard];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (IBAction)addImgAct:(UIButton *)sender {
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"相机", @"从手机相册选择", nil];
    [choiceSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照，&& [self doesCameraSupportTakingPhotos] 支持c相机
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {//设置后摄像头
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
        if ([UIImagePickerController isSourceTypeAvailable:
             UIImagePickerControllerSourceTypePhotoLibrary]) {
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
    NSData *imgData = UIImageJPEGRepresentation(portraitImg, 1);
    [SVProgressHUD show];
    [[ServiceForUser manager] postFileWithActionOp:@"common/upload_header_img" andData:imgData andUploadFileName:[Tooles getUploadImageName] andUploadKeyName:@"img" and:@"image/jpeg" params:@{} progress:^(NSProgress *uploadProgress) {
        NSLog(@"%f",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } block:^(NSDictionary *responseObject, NSString *error, BOOL status, NSError *requestFailed) {
        [SVProgressHUD dismiss];
        if (status) {
            pic_url = [[responseObject safeDictionaryForKey:@"result"] safeStringForKey:@"img_name"];
            [self dismissViewControllerAnimated:YES completion:^{
                [self.img sd_setImageWithURL:[NSURL URLWithString:pic_url]];
            }];
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)backAct:(UIButton *)sender {
    [super back];
}

- (IBAction)menuAct:(UIButton *)sender {
    [self.bts enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = false;
        obj.backgroundColor = RGBA(255, 255, 255, 0.5);
    }];
    sender.selected = true;
    type = sender.tag;
    sender.backgroundColor = ThemeColor;
    if (sender.tag==0) {
        self.bottomView.top = 367;
        self.costView.hidden = true;
    }
    else
    {
        self.costView.hidden = false;
        self.bottomView.top = self.costView.bottom + 8;
    }
}

- (IBAction)liveProtocol:(UIButton *)sender {
    CommonUIWebViewController *commonweb =[[CommonUIWebViewController alloc]init];
    commonweb.address =[NSString stringWithFormat:@"%@%@",web_url,@"wap/member/document.html?type=live"];
    commonweb.showNav = NO;
    [self.navigationController pushViewController:commonweb animated:YES];
}


- (IBAction)doneAct:(UIButton *)sender {
    if (pic_url.length==0) {
        [AlertHelper showAlertWithTitle:@"请上传封面图片"];
        return;
    }
    if (self.nameTf.text.length==0) {
        [AlertHelper showAlertWithTitle:@"请输入标题"];
        return;
    }
    if (type!=0&&self.priceTf.text.length==0) {
        [AlertHelper showAlertWithTitle:@"请输入开播费用"];
        return;
    }
    if (type!=0&&self.costTf.text.length==0) {
        [AlertHelper showAlertWithTitle:@"请输入成本价格"];
        return;
    }
    [SVProgressHUD show];
    [[ServiceForUser manager] postMethodName:@"channels/startLive" params:@{@"title":self.nameTf.text,@"cover":pic_url,@"channel_type":@(type+1),@"channel_price":self.priceTf.text,@"cost_price":self.costTf.text} block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        [SVProgressHUD dismiss];
        if (status) {
            LivePlayerViewController *vc = [[LivePlayerViewController alloc]init];
            vc.forPush = true;
            vc.url = [[data safeDictionaryForKey:@"result"]safeStringForKey:@"push_rtmp"];
            vc.dict = [data safeDictionaryForKey:@"result"];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [AlertHelper showAlertWithTitle:error];
        }
    }];
}
@end
