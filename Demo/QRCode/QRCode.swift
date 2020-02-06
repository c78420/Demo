//
//  QRCode.swift
//  Demo
//
//  Created by 黃崇漢 on 2019/9/19.
//  Copyright © 2019 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit
import AVFoundation

class QRCode: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var createButton: UIButton!
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    var qrcodeImage: CIImage!
    var imgQRCode: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // 取得 AVCaptureDevice 類別的實體來初始化一個device物件，並提供video
        // 作為媒體型態參數
        
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        
        // 使用前面的 device 物件取得 AVCaptureDeviceInput 類別的實體
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        
        // 初始化 captureSession 物件
        let captureSession = AVCaptureSession()
        self.captureSession = captureSession
        
        // 在capture session 設定輸入裝置
        captureSession.addInput(input)
        
        // 初始化 AVCaptureMetadataOutput 物件並將其設定作為擷取session的輸出裝置
        
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(captureMetadataOutput)
        
        // 設定代理並使用預設的調度佇列來執行回呼（call back）
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        // 初始化影像預覽層，並將其加為 viewPreview 視圖層的子層
        let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer)
        self.videoPreviewLayer = videoPreviewLayer
        
        // 開始影像擷取
        captureSession.startRunning()
        
        // 將訊息標籤移到最上層視圖
        view.bringSubviewToFront(messageLabel)
        view.bringSubviewToFront(createButton)
        
        // 初始化 QR Code Frame 來突顯 QR code
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.green.cgColor
        qrCodeFrameView?.layer.borderWidth = 2
        view.addSubview(qrCodeFrameView!)
        view.bringSubviewToFront(qrCodeFrameView!)
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // 檢查 metadataObjects 陣列是否為非空值，它至少需包含一個物件
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = .zero
            messageLabel.text = "No QR code is detected"
            return
        }
        
        // 取得元資料（metadata）物件
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            
            //倘若發現的原資料與 QR code 原資料相同，便更新狀態標籤的文字並設定邊界
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj as
                AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            qrCodeFrameView?.frame = barCodeObject.bounds;
            if metadataObj.stringValue != nil {
                messageLabel.text = metadataObj.stringValue
            }
        }
    }

    @IBAction func createClick(_ sender: Any) {
        let data = messageLabel.text?.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
        
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        // inputMessage：這是要轉換成 QR Code 圖片的初始資料。事實上，此參數必須是 NSData 物件，所以請確定你所使用的字串或其他物件都已轉換成這種資料類型。
        filter?.setValue(data, forKey: "inputMessage")
        // inputCorrectionLevel：這裡表示有多少額外的錯誤更正資料要被附加到輸出的 QR Code 圖片中。其數值是 4 種字串之一： L 、 M 、 Q 、 H ，分別對應到不同的錯誤復原能力，依序為 7% 、 15% 、 25% 、 30% 。數值越大，輸出的 QR Code 圖片也就越大。
        filter?.setValue("Q", forKey: "inputCorrectionLevel")
        
        qrcodeImage = filter?.outputImage
        
        imgQRCode = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        imgQRCode.center = self.view.center
        self.view.addSubview(imgQRCode)
        
        displayQRCodeImage()
    }
    
    func displayQRCodeImage() {
        let scaleX = imgQRCode.frame.size.width / qrcodeImage.extent.size.width
        let scaleY = imgQRCode.frame.size.height / qrcodeImage.extent.size.height
        
        let transformedImage = qrcodeImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
        
        imgQRCode.image = UIImage(ciImage: transformedImage)
    }
}
