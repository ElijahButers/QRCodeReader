//
//  ViewController.swift
//  QRCodeReader
//
//  Created by User on 10/15/15.
//  Copyright © 2015 Elijah Buters. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var label: UILabel!
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeframeView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func scanMe(sender: UIButton) {
        
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeAudio)
        
        var error:NSError?
        let input:AnyObject!
        
        do {
            
            input = try AVCaptureDeviceInput(device: captureDevice)
            
        } catch let error1 as NSError {
            
            error = error1
            input = nil
        }
        
        if (error !== nil) {
            
            print("\(error?.localizedDescription)")
            return
        }
        
        captureSession = AVCaptureSession()
        
        captureSession?.addInput(input as! AVCaptureInput)
        
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        //Video Player
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        captureSession?.startRunning()
        
        view.bringSubviewToFront(label)
        
        //QR Code Frame View
        qrCodeframeView = UIView()
        qrCodeframeView?.layer.borderColor = UIColor.greenColor().CGColor
        qrCodeframeView?.layer.borderWidth = 2
        view.addSubview(qrCodeframeView!)
        view.bringSubviewToFront(qrCodeframeView!)
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        if metadataObjects == nil || metadataObjects.count == 0 {
        
        qrCodeframeView?.frame = CGRectZero
        label.text = "No QR code detected"
        return
    }
    
    let metadateObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadateObj.type == AVMetadataObjectTypeQRCode {
            
            let barcodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadateObj as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            qrCodeframeView?.frame = barcodeObject.bounds
            
            if metadateObj.stringValue != nil {
                label.text = metadateObj.stringValue
            }
        }

}
}

