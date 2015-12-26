//
//  WBComposeController.m
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/7/12.
//  Copyright (c) 2015年 J.Beyond. All rights reserved.
//

#import "WBComposeController.h"
#import "WBAccountTool.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "WBComposeToolbar.h"
#import "WBComposePhotosView.h"
#import "EmotionKeyboard.h"
#import "Emotion.h"
#import "EmotionTextView.h"

@interface WBComposeController()<UITextViewDelegate,WBComposeToolbarDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,weak)EmotionTextView *textView;
@property(nonatomic,weak)WBComposeToolbar *toolbar;
@property(nonatomic,weak)WBComposePhotosView *photosView;
@property(nonatomic,assign)BOOL switchingKeyboard;
@property(nonatomic,assign)double emotionKeyboardH;
@property(nonatomic,strong)EmotionKeyboard *emotionKeyboard;

//@property(nonatomic,assign)BOOL isPicking;

@end
@implementation WBComposeController


- (EmotionKeyboard *)emotionKeyboard
{
    if (!_emotionKeyboard) {
        self.emotionKeyboard = [[EmotionKeyboard alloc]init];
        self.emotionKeyboard.width = self.view.width;
        self.emotionKeyboard.height = self.emotionKeyboardH;
    }
    return _emotionKeyboard;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNav];
    [self setupTextView];
    [self setupToolbar];
    [self setupPhotosView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //调出键盘（成为第一响应者）
    [self.textView becomeFirstResponder];
}



/**
 *  添加相册
 */
-(void)setupPhotosView
{
    WBComposePhotosView *photosView = [[WBComposePhotosView alloc]init];
    photosView.width = self.view.height;
    photosView.height = self.view.height;
    photosView.y = 100;
    photosView.x = 10;
    [self.textView addSubview:photosView];
    self.photosView = photosView;
}

-(void)setupToolbar
{
    WBComposeToolbar *toolbar = [[WBComposeToolbar alloc]init];
    toolbar.width = self.view.width;
    toolbar.height = 44;
    toolbar.y = self.view.height - toolbar.height;
    toolbar.delegate = self;
    [self.view addSubview:toolbar];
    self.toolbar = toolbar;
    //inputView设置键盘
//    self.textView.inputView = [UIButton buttonWithType:UIButtonTypeContactAdd];
    //设置显示在键盘顶部的内容
//    self.textView.inputAccessoryView = toolbar;
}

/**
 *  设置输入控件
 */
-(void)setupTextView
{
//    UITextField//只能输入一行
    //在这个控制器中textView的contentInset默认为64
    EmotionTextView*textView = [[EmotionTextView alloc]init];
    textView.frame = self.view.bounds;
    textView.delegate = self;
    //垂直方向永远可以拖拽（有弹簧效果 ）
    textView.alwaysBounceVertical = YES;
    textView.placeHolder = @"分享新鲜事...";
    textView.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:textView];
    
    self.textView = textView;
    
    //监听文字改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification object:textView];
    //监听键盘通知
    //键盘的Frame发生改变时发出的通知
//    UIKeyboardWillChangeFrameNotification;
//    UIKeyboardDidChangeFrameNotification;
    
    //键盘显示时发出的通知
//    UIKeyboardWillShowNotification;
//    UIKeyboardDidShowNotification
    
    //键盘隐藏时发出的通知
//    UIKeyboardWillHideNotification;
//    UIKeyboardDidHideNotification
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(emotionSelected:) name:EmotionDidSelectNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(emotionDelete) name:EmotionDidDeleteNotification object:nil];
    
}

-(void)emotionDelete
{
    [self.textView deleteBackward];
    
}

-(void)emotionSelected:(NSNotification *)notication{
    Emotion *emotion = notication.userInfo[SelectEmotionKey];
    NSLog(@"%@表情选中了",emotion.chs);
    [self.textView insertEmotion:emotion];
    
}

/**
 *  键盘的Frame发生改变的时候调用
 */
-(void)keyboardWillChangeFrame:(NSNotification *)notification
{
//    if ([self isPicking]) return;
    if(self.switchingKeyboard) return;
    
    NSDictionary *userInfoDict = notification.userInfo;
    Log(@"%@",userInfoDict);
    //键盘发生形变过程的时间
    double duration = [userInfoDict[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //键盘改变后的Frame
    CGRect keyboardEndF = [userInfoDict[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect keyboardBeginF = [userInfoDict[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    self.emotionKeyboardH =  fabs(keyboardBeginF.origin.y - keyboardEndF.origin.y);
   
    //将工具条产生位移动画
    [UIView animateWithDuration:duration animations:^{
        //工具条的Y值 = 键盘的Y值 - 工具条的高度
        if (keyboardEndF.origin.y > self.view.height) {
            self.toolbar.y = self.view.height - self.toolbar.height;
        }else{
            self.toolbar.y = keyboardEndF.origin.y - self.toolbar.height;
        }
    }];
}

/**
 *  监听文字改变
 */
-(void)textChange
{
    self.navigationItem.rightBarButtonItem.enabled = self.textView.hasText;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  设置导航栏
 */
-(void)setupNav
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(publish)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [self setupTitle];
}

/**
 *  设置导航栏上的Title
 */
-(void)setupTitle
{
    NSString *name = [WBAccountTool account].name;
    NSString *prefixStr = @"发微博";
    if (name) {
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.width = 200;
        titleLabel.height = 44;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.numberOfLines = 0;
        
        NSString *name = [WBAccountTool account].name;
        NSString *str = [NSString stringWithFormat:@"%@\n%@",prefixStr,name];
        //创建一个带有属性的字符串（颜色属性、字体属性）
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:str];
        
        //添加属性
        [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:[str rangeOfString:prefixStr]];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:[str rangeOfString:name]];
        
        titleLabel.attributedText = attrStr;
        
        self.navigationItem.titleView = titleLabel;
    }else{
        self.title = prefixStr;
    }
    
}

-(void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)publish
{
    if (self.photosView.photos.count) {
        [self sendWithImage];
    }else{
        [self sendWithoutImage];
    }
    // 4.dismiss
    [self dismissViewControllerAnimated:YES completion:nil];

}
-(void)sendWithImage
{
    // URL: https://api.weibo.com/2/statuses/upload.json
    // 参数:
    /**	status true string 要发布的微博文本内容，必须做URLencode，内容不超过140个汉字。*/
    /**	access_token true string*/
    /** pic true binary 微薄的配图 */
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [WBAccountTool account].access_token;
    params[@"status"] = self.textView.fullText;
    
    // 3.发送请求
    [mgr POST:@"https://api.weibo.com/2/statuses/upload.json" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //拼接文件数据
        UIImage *image= [self.photosView.photos firstObject];
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        [formData appendPartWithFileData:data name:@"pic" fileName:@"test.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        [MBProgressHUD showSuccess:@"发送成功"];
        Log(@"%@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"发送失败"];
    }];

}
-(void)sendWithoutImage
{
    // URL: https://api.weibo.com/2/statuses/update.json
    // 参数:
    /**	status true string 要发布的微博文本内容，必须做URLencode，内容不超过140个汉字。*/
    /**	access_token true string*/
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [WBAccountTool account].access_token;
    params[@"status"] = self.textView.fullText;
    
    // 3.发送请求
    [mgr POST:@"https://api.weibo.com/2/statuses/update.json" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        [MBProgressHUD showSuccess:@"发送成功"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"发送失败"];
    }];

}

#pragma mark - UITextViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //向下拖拽时隐藏键盘
    [self.view endEditing:YES];
}


#pragma mark - WBComposeToolbarDelegate
- (void)composeToolbar:(WBComposeToolbar *)toolbar didClickButton:(WBComposeToolbarType)type
{
    switch (type) {
        case WBComposeToolbarTypeCarema://拍照
            [self openCarema];
            break;
        case WBComposeToolbarTypePicture://相册
            [self openAlbum];
            break;
        case WBComposeToolbarTypeMention://@
            
            break;
        case WBComposeToolbarTypeTrend://#
            
            break;
        case WBComposeToolbarTypeEmotion://表情\键盘
            [self switchKeyboard];
            break;
        default:
            break;
    }
}

/**
 *  切换键盘
 */
-(void)switchKeyboard
{
    //self.textView.inputView == nil：使用的是系统自带的键盘
    if (self.textView.inputView == nil) {//切换为自定义的表情键盘
        self.textView.inputView = self.emotionKeyboard;
        //工具条显示键盘图标
        self.toolbar.showKeyboardButton = YES;
    }else{
        self.textView.inputView = nil;
        //工具条显示表情图标
        self.toolbar.showKeyboardButton = NO;
    }
    //标示开启切换键盘
    self.switchingKeyboard = YES;
    
    //退出键盘
    [self.view endEditing:YES];
    
    //标识结束切换键盘
    self.switchingKeyboard = NO;
    
    //隔0.1s后弹出键盘
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //弹出键盘
        [self.textView becomeFirstResponder];
    });
    
    
}
#pragma mark - 逻辑方法
-(void)openCarema
{
//    self.isPicking = YES;
    [self openImagePickerWithType:UIImagePickerControllerSourceTypeCamera];
}

-(void)openAlbum
{
//    self.isPicking = YES;
    //
    [self openImagePickerWithType:UIImagePickerControllerSourceTypePhotoLibrary];
}

-(void)openImagePickerWithType:(UIImagePickerControllerSourceType)type
{
    if (![UIImagePickerController isSourceTypeAvailable:type]) return;
    UIImagePickerController *ipc = [[UIImagePickerController alloc]init];
    ipc.sourceType = type;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    Log(@"----%@",info);
    /**
     UIImagePickerControllerOriginalImage = <UIImage: 0x7fb15d36e1f0> size {1500, 1001} orientation 0 scale 1.000000,
     UIImagePickerControllerMediaType = public.image,
     UIImagePickerControllerReferenceURL = assets-library://asset/asset.JPG?id=BC204EF1-3542-4B89-9FD2-421C44B8792F&ext=JPG
     */
    //获取到选择的照片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    //将Image添加到PhotosView
    [self.photosView addPhoto:image];
    [picker dismissViewControllerAnimated:YES completion:nil];
//    self.isPicking = NO;
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
//    self.isPicking = NO;
}



@end
