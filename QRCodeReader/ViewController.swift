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
    }


}

