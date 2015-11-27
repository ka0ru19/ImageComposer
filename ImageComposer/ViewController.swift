//
//  ViewController.swift
//  imagetest02
//
//  Created by 井上航 on 2015/11/26.
//  Copyright © 2015年 Wataru.I. All rights reserved.
//
//  カメラorアルバムから写真を取得しデバイスに表示
//  マスク画像を合成
//  デフォルトマスク素材DL元-> http://free-webdesigner.com/xmas-illust
//  (できたら文字も合成)
//  合成された写真をアルバムに保存
//  FB(,Twitter)にアップ
//


import UIKit
import Social

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // 写真表示用ImageView
    @IBOutlet weak var photoImageView: UIImageView!
    
    // 画像取得用
    var picker = UIImagePickerController()
    
    // SNS投稿用
    var myComposeView : SLComposeViewController!
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    //カメラボタンをタップ
    @IBAction func cameraButtonTapped(sender: AnyObject){
        let sourceType:UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.Camera
        //ライブラリが使用できるかどうか判定
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            picker.sourceType = sourceType
            picker.delegate = self
            self.presentViewController(picker, animated: true, completion: nil)
        }
    }
    
    //アルバムボタンをタップ
    @IBAction func albumButtonTapped(sender: AnyObject){
        let sourceType:UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.PhotoLibrary
        //ライブラリが使用できるかどうか判定
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)){
            picker.sourceType = sourceType
            picker.delegate = self
            //picker!.allowsEditing = false
            self.presentViewController(picker, animated: true, completion: nil)
        }
    }
    
    //写真が選択された時に呼び出されるメソッド
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismissViewControllerAnimated(true, completion: nil)
        
        // グラフィックスコンテキスト生成,編集を開始
        UIGraphicsBeginImageContextWithOptions(image.size, true, 0);
        // 読み込んだ写真を書き出す
        image.drawInRect(CGRectMake(0, 0, image.size.width, image.size.height))
        
        // マスク画像@Assets.xcassets
        let maskImage = UIImage(named:"santa")
        //        let faceRect = CGRectMake(5, 5, image.size.width - 5, image.size.height - 5)
        //        let faceRect = CGRectMake([左からのx座標]px, [上からのy座標]px, [縦の長さ]px, [横の長さ]px)
        // 元の写真の右下にマスク画像が来るよう任意の値を入れました
        let maskRect = CGRectMake(image.size.width - 1020, image.size.height - 820, 1000, 800)
        maskImage?.drawInRect(maskRect)
        
        // グラフィックスコンテキストの画像を取得
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        // グラフィックスコンテキストの編集を終了
        UIGraphicsEndImageContext();
        // 画像を出力
        photoImageView.image = outputImage
    }
    
    // 写真を保存
    @IBAction func saveButtonTapped(sender : AnyObject) {
        let image:UIImage! = photoImageView.image
        
        if image != nil {
            UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
            print("Save Succeeded !\n")
        }
        else{
            print("!!! Save Failed !!!\n")
        }
        
    }
    //Facebookに投稿
    // ボタンイベント.
    @IBAction func facebookButtonTapped(sender : UIButton) {
        
        // ServiceTypeをFacebookに指定.
        myComposeView = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        
        // 投稿するテキストを指定.
        myComposeView.setInitialText("Facebook Test")
        
        // 投稿する画像を指定.
        myComposeView.addImage(photoImageView.image)
        
        // myComposeViewの画面遷移.
        self.presentViewController(myComposeView, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
}
