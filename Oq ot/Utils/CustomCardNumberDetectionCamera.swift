//
//  CustomPassportDetectionCamera.swift
//  ClickEvolution_iOS
//
//  Created by Sirojiddinov Mirjalol on 23/06/22.
//  Copyright © 2022 Click LLC. All rights reserved.
//


import UIKit
import AVFoundation
import Vision

class CustomCardNumberDetectionCamera: BaseViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    lazy var captureSession = AVCaptureSession()
    var previewLayer = AVCaptureVideoPreviewLayer()
    lazy var videoOutput = AVCaptureVideoDataOutput()
    var videoInput: AVCaptureDeviceInput?
    var cardNumber: String?
    var didFoundCardNumber: (([String]) -> Void)?
    
    lazy var flashLightButton: UIButton = {
        let b = UIButton()
        b.setTitle("", for: .normal)
        b.layer.cornerRadius = 50 * RatioCoeff.width / 2
        b.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        b.setImage(UIImage.init(named: "FlashLightButton")?.tint(with: Theme.current.imageTintColor), for: .normal)
        b.addTarget(self, action: #selector(flashLightButtonTapped), for: .touchUpInside)
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cardNumber = nil
        configureDevice()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.previewLayer.frame = view.bounds
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopRunningSession()
    }
    
    private func stopRunningSession() {
        DispatchQueue.main.async {
            self.captureSession.removeOutput(self.videoOutput)
            self.captureSession.removeInput(self.videoInput!)
            self.captureSession.stopRunning()
        }
    }
        
    private func setupView() {
        view.layer.addSublayer(previewLayer)
        
        let blurView = UIVisualEffectView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        blurView.effect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let superlayerPath = UIBezierPath.init(rect: blurView.frame)
        
        let scanRect = CGRect.init(x: (view.frame.width/2) - (view.frame.width * 0.45), y:(view.frame.height/2) - (view.frame.height*0.125), width: view.frame.width * 0.9, height: view.frame.height*0.25)
        let outerPath = UIBezierPath(rect: scanRect)
        outerPath.usesEvenOddFillRule = true
        outerPath.append(superlayerPath)
        
        let scanLayer = CAShapeLayer()
        scanLayer.path = outerPath.cgPath
        scanLayer.fillRule = CAShapeLayerFillRule.evenOdd
        scanLayer.fillColor = UIColor.black.cgColor
        view.addSubview(blurView)
        blurView.layer.mask = scanLayer
        
        let descriptionLabel = UILabel()
        descriptionLabel.numberOfLines = 0
        descriptionLabel.attributedText = NSAttributedString.getAttrTextWith(14, "Oтсканируй свою карту")
        blurView.contentView.addSubview(descriptionLabel)
        blurView.contentView.addSubview(flashLightButton)
        descriptionLabel.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor,
                                padding: UIEdgeInsets(top: 0, left: 20 * RatioCoeff.width, bottom: 40 * RatioCoeff.width, right: 20 * RatioCoeff.width), size: CGSize(width: 0, height: 50 * RatioCoeff.height))
        flashLightButton.anchor(top: nil, leading: nil, bottom: descriptionLabel.topAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0), size: CGSize(width: 50*RatioCoeff.width, height: 50*RatioCoeff.width))
        flashLightButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    @objc func flashLightButtonTapped(_ sender: Any) {
        Utils.toggleFlash()
    }
    
    private func getDevice() -> AVCaptureDevice? {
        let discoverSession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera, .builtInTelephotoCamera, .builtInWideAngleCamera], mediaType: .video, position: .back)
        return discoverSession.devices.first
    }
    
    private func recogniseText(image: UIImage?) {
        guard let cgImage = image?.cgImage else {return}
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        if #available(iOS 13.0, *) {
            let request = VNRecognizeTextRequest { [weak self] request, _ in
                guard let self = self else {return}
                guard let observations = request.results as? [VNRecognizedTextObservation] else {return}

                observations.forEach { observation in
                    if let foundString = observation.topCandidates(1).first?.string.replacingOccurrences(of: " ", with: "") {
                        print(foundString)
                        if foundString.count == 16 {
                            if foundString.toNSNumber?.intValue != nil {
                                    self.cardNumber = foundString
                                }
                            
                        }
                        
                        if foundString.count == 5 && foundString.contains("/") {
                                Utils.delay(seconds: 0) {
                                        if self.cardNumber != nil {
                                            self.didFoundCardNumber?([String(self.cardNumber ?? ""), foundString])
                                        }
                                        self.stopRunningSession()
                                    self.navigationController?.popViewController(animated: true)
                                }
                        }
                        
                    }
                }
            }
            do {
                try handler.perform([request])
            } catch {
                print("error occured")
            }
        } else {
            // Fallback on earlier versions not iOS 13.0
        }
        
       
    }
    
    private func configureDevice() {
        if let device = getDevice() {
            do {
                try device.lockForConfiguration()
                if device.isFocusModeSupported(.continuousAutoFocus) {
                    device.focusMode = .continuousAutoFocus
                }
                device.unlockForConfiguration()
            } catch { print("failed to lock config") }
            
            do {
                if captureSession.inputs.count == 0 {
                    videoInput = try AVCaptureDeviceInput(device: device)
                    captureSession.addInput(videoInput!)
                }
                
            } catch { print("failed to create AVCaptureDeviceInput") }
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.session = captureSession
            captureSession.startRunning()
            
            videoOutput.videoSettings = [String(kCVPixelBufferPixelFormatTypeKey): Int(kCVPixelFormatType_32BGRA)]
            videoOutput.alwaysDiscardsLateVideoFrames = true
            videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: .utility))
            
            if captureSession.canAddOutput(videoOutput) && captureSession.outputs.count == 0 {
                captureSession.addOutput(videoOutput)
            }
        }
    }
    
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let maxSize = CGSize(width: 1024, height: 1024)
            if let image = UIImage(sampleBuffer: sampleBuffer)?.imageWithAspectFit(size: maxSize) {
                self.recogniseText(image: image)
            }
        }
}






