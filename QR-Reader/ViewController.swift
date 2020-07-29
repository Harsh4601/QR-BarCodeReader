//
//  ViewController.swift
//  QR-Reader
//
//  Created by Harsh Londhekar on 27/07/20.
//  Copyright © 2020 Harsh Londhekar. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var avCaptureSession: AVCaptureSession!
    var avPreviewLayer: AVCaptureVideoPreviewLayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        avCaptureSession = AVCaptureSession()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            
            guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else{
                
                print("Your device is not cable of video processing")
                return
            }
            let videoInput : AVCaptureDeviceInput
            
            do{
                videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            } catch {
                print("Your device cannot give video input")
                return
            }
            
            if (self.avCaptureSession.canAddInput(videoInput)) {
                self.avCaptureSession.addInput(videoInput)
            } else{
                print("Your device cannot add input in capture session")
                return
            }
            
            
            let metadataOutput = AVCaptureMetadataOutput()
            
            if (self.avCaptureSession.canAddOutput(metadataOutput)) {
                self.avCaptureSession.addOutput(metadataOutput)
                
                
                metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417]
            }  else{
                return
            }
            
            self.avPreviewLayer = AVCaptureVideoPreviewLayer(session: self.avCaptureSession)
            self.avPreviewLayer.frame = self.view.layer.bounds
            self.avPreviewLayer.videoGravity = .resizeAspectFill
            self.view.layer.addSublayer(self.avPreviewLayer)
            print("running")
            
            self.avCaptureSession.startRunning()
        })
        


}

}

extension ViewController : AVCaptureMetadataOutputObjectsDelegate{
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let first = metadataObjects.first{
            guard let readableObject = first as? AVMetadataMachineReadableCodeObject else{
                return
                
            }
            guard let stringValue = readableObject.stringValue else{
                return
                
            }
            found(code: stringValue)
            
            }else
        {
            print("Not able to read the ccode , please try again or keep your device on barcode or QR code!")
        }
    }
    
    func found (code : String) {
        print(code)
    }
}
