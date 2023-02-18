//
//  Utils.swift
//  kkk
//
//  Created by Sirojiddinov Mirjalol on 12/03/22.
//

import UIKit
import AVFoundation
import AudioToolbox

public class Utils {
    static var audioPlayer = AVAudioPlayer()
    static func delay(seconds: Double, completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
    }
    
    static func lightVibrate() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    static func open(url: String) {
        if let newUrl = URL(string: url.trimmed) {
            if UIApplication.shared.canOpenURL(newUrl) {
                UIApplication.shared.open(newUrl, completionHandler: nil)
            }
        }
    }
    
    static func convertImageToBase64String (img: UIImage) -> String {
        return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }
    
    static func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
  
    
   
    
    static func clusterImage(_ clusterSize: UInt) -> UIImage {
        let scale = UIScreen.main.scale
        let text = (clusterSize as NSNumber).stringValue
        let font = UIFont.systemFont(ofSize: 20 * scale)
        let size = text.size(withAttributes: [NSAttributedString.Key.font: font])
        let textRadius = sqrt(size.height * size.height + size.width * size.width) / 2
        let internalRadius = textRadius + 3 * scale
        let externalRadius = internalRadius + 3 * scale
        let iconSize = CGSize(width: externalRadius * 2, height: externalRadius * 2)
        
        UIGraphicsBeginImageContext(iconSize)
        let ctx = UIGraphicsGetCurrentContext()!
        
        ctx.setFillColor(UIColor.red.cgColor)
        ctx.fillEllipse(in: CGRect(
            origin: .zero,
            size: CGSize(width: 2 * externalRadius, height: 2 * externalRadius)));
        
        ctx.setFillColor(UIColor.white.cgColor)
        ctx.fillEllipse(in: CGRect(
            origin: CGPoint(x: externalRadius - internalRadius, y: externalRadius - internalRadius),
            size: CGSize(width: 2 * internalRadius, height: 2 * internalRadius)));
        
        (text as NSString).draw(
            in: CGRect(
                origin: CGPoint(x: externalRadius - size.width / 2, y: externalRadius - size.height / 2),
                size: size),
            withAttributes: [
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.foregroundColor: UIColor.black])
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        return image
    }
    
    static func callNumber(phoneNumber:String) {
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    static func updateVersion(urlString: String){
        if let updateVerURL = URL(string: urlString.trimmed) {
            if UIApplication.shared.canOpenURL(updateVerURL) {
                UIApplication.shared.open(updateVerURL, completionHandler: nil)
            }
        }
    }
    
    static func playCarOpenSound() {
        let path = Bundle.main.path(forResource: "carSound.mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        } catch let error {
            print("Sound Play Error -> \(error)")
        }
    }
    
    static func numberToCurrency(number: Int) -> String {
        let formatter: NumberFormatter = NumberFormatter()

        formatter.numberStyle = .currency

        formatter.positiveSuffix = " \("sum".translate())"
        formatter.currencySymbol = ""
        formatter.maximumFractionDigits = 0
        formatter.currencyGroupingSeparator = " "
        formatter.usesGroupingSeparator = true
        return formatter.string(from: number as NSNumber)!
    }
    
    
    static func getTopView(color: UIColor) -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 2.5
        view.backgroundColor = color
        return view
    }
    
    static func removeSublayer(_ view: UIView, layerIndex index: Int) {
        guard let sublayers = view.layer.sublayers else {
            print("The view does not have any sublayers.")
            return
        }
        if sublayers.count > index {
            view.layer.sublayers!.remove(at: index)
        } else {
            print("There are not enough sublayers to remove that index.")
        }
    }
    
    
    static func toggleFlash() {
        if let device = AVCaptureDevice.default(for: AVMediaType.video) {
            if device.hasTorch {
                do {
                    try device.lockForConfiguration()
                    if device.torchMode == AVCaptureDevice.TorchMode.on {
                        device.torchMode = AVCaptureDevice.TorchMode.off
                    } else {
                        do {
                            try device.setTorchModeOn(level: 1.0)
                        } catch {
                            // do nothing
                        }
                    }
                    device.unlockForConfiguration()
                } catch {
                    // do nothing
                }
            }
        }
    }
    
}

class VerticalTopAlignLabel: UILabel {

    override func drawText(in rect:CGRect) {
        guard let labelText = text else {  return super.drawText(in: rect) }

        let attributedText = NSAttributedString(string: labelText, attributes: [NSAttributedString.Key.font: font])
        var newRect = rect
        newRect.size.height = attributedText.boundingRect(with: rect.size, options: .usesLineFragmentOrigin, context: nil).size.height

        if numberOfLines != 0 {
            newRect.size.height = min(newRect.size.height, CGFloat(numberOfLines) * font.lineHeight)
        }

        super.drawText(in: newRect)
    }

}
