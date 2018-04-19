//
//  ScannerStyleKit.swift
//  SplitScreenScanner
//
//  Created by Sean Machen on 4/9/18.
//  Copyright © 2018 Clutter Inc. All rights reserved.
//
//  Generated by PaintCode
//  http://www.paintcodeapp.com
//



import UIKit

public class ScannerStyleKit : NSObject {

    //// Cache

    private struct Cache {
        static let clutterTeal: UIColor = UIColor(red: 0.000, green: 0.631, blue: 0.604, alpha: 1.000)
        static let clutterYellow: UIColor = UIColor(red: 1.000, green: 0.722, blue: 0.098, alpha: 1.000)
        static let clutterRed: UIColor = UIColor(red: 1.000, green: 0.275, blue: 0.071, alpha: 1.000)
        static let historyCellBackgroundGrey: UIColor = UIColor(red: 0.082, green: 0.082, blue: 0.082, alpha: 1.000)
    }

    //// Colors

    @objc dynamic public class var clutterTeal: UIColor { return Cache.clutterTeal }
    @objc dynamic public class var clutterYellow: UIColor { return Cache.clutterYellow }
    @objc dynamic public class var clutterRed: UIColor { return Cache.clutterRed }
    @objc dynamic public class var historyCellBackgroundGrey: UIColor { return Cache.historyCellBackgroundGrey }

    //// Drawing Methods

    @objc dynamic public class func drawTorchSymbol(frame: CGRect = CGRect(x: 0, y: 0, width: 15, height: 24), isTorchOn: Bool = false) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!


        //// Variable Declarations
        let isTorchOff = isTorchOn == false

        if (isTorchOn) {
            //// Symbol Yellow Drawing
            let symbolYellowRect = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: frame.height)
            context.saveGState()
            context.clip(to: symbolYellowRect)
            context.translateBy(x: symbolYellowRect.minX, y: symbolYellowRect.minY)

            ScannerStyleKit.drawTorchGlyphYellow(frame: CGRect(origin: .zero, size: symbolYellowRect.size), resizing: .stretch)
            context.restoreGState()
        }


        if (isTorchOff) {
            //// Symbol Teal Drawing
            let symbolTealRect = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: frame.height)
            context.saveGState()
            context.clip(to: symbolTealRect)
            context.translateBy(x: symbolTealRect.minX, y: symbolTealRect.minY)

            ScannerStyleKit.drawTorchGlyphTeal(frame: CGRect(origin: .zero, size: symbolTealRect.size), resizing: .stretch)
            context.restoreGState()
        }
    }

    @objc dynamic public class func drawCheckMarkSymbol(frame: CGRect = CGRect(x: 0, y: 0, width: 56, height: 56)) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!

        //// Symbol Teal Drawing
        let symbolTealRect = CGRect(x: frame.minX + 4, y: frame.minY + 4, width: frame.width - 8, height: frame.height - 8)
        context.saveGState()
        context.clip(to: symbolTealRect)
        context.translateBy(x: symbolTealRect.minX, y: symbolTealRect.minY)

        ScannerStyleKit.drawCheckMarkGlyphTeal(frame: CGRect(origin: .zero, size: symbolTealRect.size), resizing: .stretch)
        context.restoreGState()
    }

    @objc dynamic public class func drawExclamationTriangleSymbol(frame: CGRect = CGRect(x: 0, y: 0, width: 56, height: 56), isError: Bool = false) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!


        //// Variable Declarations
        let isWarning = isError == false

        if (isError) {
            //// Symbol Red Drawing
            let symbolRedRect = CGRect(x: frame.minX, y: frame.minY + 3, width: frame.width, height: frame.height - 6)
            context.saveGState()
            context.clip(to: symbolRedRect)
            context.translateBy(x: symbolRedRect.minX, y: symbolRedRect.minY)

            ScannerStyleKit.drawExclamationTriangleGlyphRed(frame: CGRect(origin: .zero, size: symbolRedRect.size), resizing: .stretch)
            context.restoreGState()
        }


        if (isWarning) {
            //// Symbol Yellow Drawing
            let symbolYellowRect = CGRect(x: frame.minX, y: frame.minY + 3, width: frame.width, height: frame.height - 6)
            context.saveGState()
            context.clip(to: symbolYellowRect)
            context.translateBy(x: symbolYellowRect.minX, y: symbolYellowRect.minY)

            ScannerStyleKit.drawExclamationTriangleGlyphYellow(frame: CGRect(origin: .zero, size: symbolYellowRect.size), resizing: .stretch)
            context.restoreGState()
        }
    }

    @objc dynamic public class func drawTorchGlyphTeal(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 320, height: 512), resizing: ResizingBehavior = .aspectFit) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 320, height: 512), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 320, y: resizedFrame.height / 512)


        //// Torch Teal Drawing
        let torchTealPath = UIBezierPath()
        torchTealPath.move(to: CGPoint(x: 295.97, y: 160))
        torchTealPath.addLine(to: CGPoint(x: 180.57, y: 160))
        torchTealPath.addLine(to: CGPoint(x: 215.19, y: 30.18))
        torchTealPath.addCurve(to: CGPoint(x: 192, y: 0), controlPoint1: CGPoint(x: 219.25, y: 14.96), controlPoint2: CGPoint(x: 207.76, y: 0))
        torchTealPath.addLine(to: CGPoint(x: 56, y: 0))
        torchTealPath.addCurve(to: CGPoint(x: 32.21, y: 20.83), controlPoint1: CGPoint(x: 43.97, y: 0), controlPoint2: CGPoint(x: 33.8, y: 8.9))
        torchTealPath.addLine(to: CGPoint(x: 0.21, y: 260.83))
        torchTealPath.addCurve(to: CGPoint(x: 24, y: 288), controlPoint1: CGPoint(x: -1.7, y: 275.22), controlPoint2: CGPoint(x: 9.5, y: 288))
        torchTealPath.addLine(to: CGPoint(x: 142.7, y: 288))
        torchTealPath.addLine(to: CGPoint(x: 96.65, y: 482.47))
        torchTealPath.addCurve(to: CGPoint(x: 119.99, y: 512), controlPoint1: CGPoint(x: 93.05, y: 497.65), controlPoint2: CGPoint(x: 104.66, y: 512))
        torchTealPath.addCurve(to: CGPoint(x: 140.77, y: 500.02), controlPoint1: CGPoint(x: 128.34, y: 512), controlPoint2: CGPoint(x: 136.37, y: 507.63))
        torchTealPath.addLine(to: CGPoint(x: 316.74, y: 196.02))
        torchTealPath.addCurve(to: CGPoint(x: 295.97, y: 160), controlPoint1: CGPoint(x: 325.99, y: 180.06), controlPoint2: CGPoint(x: 314.45, y: 160))
        torchTealPath.close()
        ScannerStyleKit.clutterTeal.setFill()
        torchTealPath.fill()
        
        context.restoreGState()

    }

    @objc dynamic public class func drawTorchGlyphYellow(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 320, height: 512), resizing: ResizingBehavior = .aspectFit) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 320, height: 512), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 320, y: resizedFrame.height / 512)


        //// Torch Yellow Drawing
        let torchYellowPath = UIBezierPath()
        torchYellowPath.move(to: CGPoint(x: 295.97, y: 160))
        torchYellowPath.addLine(to: CGPoint(x: 180.57, y: 160))
        torchYellowPath.addLine(to: CGPoint(x: 215.19, y: 30.18))
        torchYellowPath.addCurve(to: CGPoint(x: 192, y: 0), controlPoint1: CGPoint(x: 219.25, y: 14.96), controlPoint2: CGPoint(x: 207.76, y: 0))
        torchYellowPath.addLine(to: CGPoint(x: 56, y: 0))
        torchYellowPath.addCurve(to: CGPoint(x: 32.21, y: 20.83), controlPoint1: CGPoint(x: 43.97, y: 0), controlPoint2: CGPoint(x: 33.8, y: 8.9))
        torchYellowPath.addLine(to: CGPoint(x: 0.21, y: 260.83))
        torchYellowPath.addCurve(to: CGPoint(x: 24, y: 288), controlPoint1: CGPoint(x: -1.7, y: 275.22), controlPoint2: CGPoint(x: 9.5, y: 288))
        torchYellowPath.addLine(to: CGPoint(x: 142.7, y: 288))
        torchYellowPath.addLine(to: CGPoint(x: 96.65, y: 482.47))
        torchYellowPath.addCurve(to: CGPoint(x: 119.99, y: 512), controlPoint1: CGPoint(x: 93.05, y: 497.65), controlPoint2: CGPoint(x: 104.66, y: 512))
        torchYellowPath.addCurve(to: CGPoint(x: 140.77, y: 500.02), controlPoint1: CGPoint(x: 128.34, y: 512), controlPoint2: CGPoint(x: 136.37, y: 507.63))
        torchYellowPath.addLine(to: CGPoint(x: 316.74, y: 196.02))
        torchYellowPath.addCurve(to: CGPoint(x: 295.97, y: 160), controlPoint1: CGPoint(x: 325.99, y: 180.06), controlPoint2: CGPoint(x: 314.45, y: 160))
        torchYellowPath.close()
        ScannerStyleKit.clutterYellow.setFill()
        torchYellowPath.fill()
        
        context.restoreGState()

    }

    @objc dynamic public class func drawCheckMarkGlyphTeal(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 512, height: 512), resizing: ResizingBehavior = .aspectFit) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 512, height: 512), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 512, y: resizedFrame.height / 512)


        //// Check Mark Teal Drawing
        let checkMarkTealPath = UIBezierPath()
        checkMarkTealPath.move(to: CGPoint(x: 173.9, y: 439.4))
        checkMarkTealPath.addLine(to: CGPoint(x: 7.5, y: 273))
        checkMarkTealPath.addCurve(to: CGPoint(x: 7.5, y: 236.8), controlPoint1: CGPoint(x: -2.5, y: 263.01), controlPoint2: CGPoint(x: -2.5, y: 246.8))
        checkMarkTealPath.addLine(to: CGPoint(x: 43.7, y: 200.6))
        checkMarkTealPath.addCurve(to: CGPoint(x: 79.91, y: 200.6), controlPoint1: CGPoint(x: 53.7, y: 190.6), controlPoint2: CGPoint(x: 69.91, y: 190.6))
        checkMarkTealPath.addLine(to: CGPoint(x: 192, y: 312.69))
        checkMarkTealPath.addLine(to: CGPoint(x: 432.1, y: 72.6))
        checkMarkTealPath.addCurve(to: CGPoint(x: 468.3, y: 72.6), controlPoint1: CGPoint(x: 442.09, y: 62.6), controlPoint2: CGPoint(x: 458.3, y: 62.6))
        checkMarkTealPath.addLine(to: CGPoint(x: 504.5, y: 108.8))
        checkMarkTealPath.addCurve(to: CGPoint(x: 504.5, y: 145), controlPoint1: CGPoint(x: 514.5, y: 118.8), controlPoint2: CGPoint(x: 514.5, y: 135.01))
        checkMarkTealPath.addLine(to: CGPoint(x: 210.1, y: 439.41))
        checkMarkTealPath.addCurve(to: CGPoint(x: 173.9, y: 439.4), controlPoint1: CGPoint(x: 200.1, y: 449.4), controlPoint2: CGPoint(x: 183.9, y: 449.4))
        checkMarkTealPath.close()
        ScannerStyleKit.clutterTeal.setFill()
        checkMarkTealPath.fill()
        
        context.restoreGState()

    }

    @objc dynamic public class func drawExclamationTriangleGlyphYellow(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 576, height: 512), resizing: ResizingBehavior = .aspectFit) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 576, height: 512), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 576, y: resizedFrame.height / 512)


        //// Exclamation Triangle Yellow Drawing
        let exclamationTriangleYellowPath = UIBezierPath()
        exclamationTriangleYellowPath.move(to: CGPoint(x: 569.52, y: 440.01))
        exclamationTriangleYellowPath.addCurve(to: CGPoint(x: 527.94, y: 512), controlPoint1: CGPoint(x: 587.98, y: 472.01), controlPoint2: CGPoint(x: 564.81, y: 512))
        exclamationTriangleYellowPath.addLine(to: CGPoint(x: 48.05, y: 512))
        exclamationTriangleYellowPath.addCurve(to: CGPoint(x: 6.48, y: 440.01), controlPoint1: CGPoint(x: 11.12, y: 512), controlPoint2: CGPoint(x: -11.95, y: 471.95))
        exclamationTriangleYellowPath.addLine(to: CGPoint(x: 246.42, y: 23.99))
        exclamationTriangleYellowPath.addCurve(to: CGPoint(x: 329.58, y: 23.99), controlPoint1: CGPoint(x: 264.89, y: -8.02), controlPoint2: CGPoint(x: 311.14, y: -7.97))
        exclamationTriangleYellowPath.addLine(to: CGPoint(x: 569.52, y: 440.01))
        exclamationTriangleYellowPath.close()
        exclamationTriangleYellowPath.move(to: CGPoint(x: 288, y: 354))
        exclamationTriangleYellowPath.addCurve(to: CGPoint(x: 242, y: 400), controlPoint1: CGPoint(x: 262.6, y: 354), controlPoint2: CGPoint(x: 242, y: 374.6))
        exclamationTriangleYellowPath.addCurve(to: CGPoint(x: 288, y: 446), controlPoint1: CGPoint(x: 242, y: 425.41), controlPoint2: CGPoint(x: 262.6, y: 446))
        exclamationTriangleYellowPath.addCurve(to: CGPoint(x: 334, y: 400), controlPoint1: CGPoint(x: 313.4, y: 446), controlPoint2: CGPoint(x: 334, y: 425.41))
        exclamationTriangleYellowPath.addCurve(to: CGPoint(x: 288, y: 354), controlPoint1: CGPoint(x: 334, y: 374.6), controlPoint2: CGPoint(x: 313.4, y: 354))
        exclamationTriangleYellowPath.close()
        exclamationTriangleYellowPath.move(to: CGPoint(x: 244.33, y: 188.65))
        exclamationTriangleYellowPath.addLine(to: CGPoint(x: 251.75, y: 324.65))
        exclamationTriangleYellowPath.addCurve(to: CGPoint(x: 263.73, y: 336), controlPoint1: CGPoint(x: 252.09, y: 331.02), controlPoint2: CGPoint(x: 257.35, y: 336))
        exclamationTriangleYellowPath.addLine(to: CGPoint(x: 312.27, y: 336))
        exclamationTriangleYellowPath.addCurve(to: CGPoint(x: 324.25, y: 324.65), controlPoint1: CGPoint(x: 318.65, y: 336), controlPoint2: CGPoint(x: 323.91, y: 331.02))
        exclamationTriangleYellowPath.addLine(to: CGPoint(x: 331.67, y: 188.65))
        exclamationTriangleYellowPath.addCurve(to: CGPoint(x: 319.69, y: 176), controlPoint1: CGPoint(x: 332.05, y: 181.78), controlPoint2: CGPoint(x: 326.57, y: 176))
        exclamationTriangleYellowPath.addLine(to: CGPoint(x: 256.31, y: 176))
        exclamationTriangleYellowPath.addCurve(to: CGPoint(x: 244.33, y: 188.65), controlPoint1: CGPoint(x: 249.42, y: 176), controlPoint2: CGPoint(x: 243.95, y: 181.78))
        exclamationTriangleYellowPath.close()
        ScannerStyleKit.clutterYellow.setFill()
        exclamationTriangleYellowPath.fill()
        
        context.restoreGState()

    }

    @objc dynamic public class func drawExclamationTriangleGlyphRed(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 576, height: 512), resizing: ResizingBehavior = .aspectFit) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 576, height: 512), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 576, y: resizedFrame.height / 512)


        //// Exclamation Triangle Red Drawing
        let exclamationTriangleRedPath = UIBezierPath()
        exclamationTriangleRedPath.move(to: CGPoint(x: 569.52, y: 440.01))
        exclamationTriangleRedPath.addCurve(to: CGPoint(x: 527.94, y: 512), controlPoint1: CGPoint(x: 587.98, y: 472.01), controlPoint2: CGPoint(x: 564.81, y: 512))
        exclamationTriangleRedPath.addLine(to: CGPoint(x: 48.05, y: 512))
        exclamationTriangleRedPath.addCurve(to: CGPoint(x: 6.48, y: 440.01), controlPoint1: CGPoint(x: 11.12, y: 512), controlPoint2: CGPoint(x: -11.95, y: 471.95))
        exclamationTriangleRedPath.addLine(to: CGPoint(x: 246.42, y: 23.99))
        exclamationTriangleRedPath.addCurve(to: CGPoint(x: 329.58, y: 23.99), controlPoint1: CGPoint(x: 264.89, y: -8.02), controlPoint2: CGPoint(x: 311.14, y: -7.97))
        exclamationTriangleRedPath.addLine(to: CGPoint(x: 569.52, y: 440.01))
        exclamationTriangleRedPath.close()
        exclamationTriangleRedPath.move(to: CGPoint(x: 288, y: 354))
        exclamationTriangleRedPath.addCurve(to: CGPoint(x: 242, y: 400), controlPoint1: CGPoint(x: 262.6, y: 354), controlPoint2: CGPoint(x: 242, y: 374.6))
        exclamationTriangleRedPath.addCurve(to: CGPoint(x: 288, y: 446), controlPoint1: CGPoint(x: 242, y: 425.41), controlPoint2: CGPoint(x: 262.6, y: 446))
        exclamationTriangleRedPath.addCurve(to: CGPoint(x: 334, y: 400), controlPoint1: CGPoint(x: 313.4, y: 446), controlPoint2: CGPoint(x: 334, y: 425.41))
        exclamationTriangleRedPath.addCurve(to: CGPoint(x: 288, y: 354), controlPoint1: CGPoint(x: 334, y: 374.6), controlPoint2: CGPoint(x: 313.4, y: 354))
        exclamationTriangleRedPath.close()
        exclamationTriangleRedPath.move(to: CGPoint(x: 244.33, y: 188.65))
        exclamationTriangleRedPath.addLine(to: CGPoint(x: 251.75, y: 324.65))
        exclamationTriangleRedPath.addCurve(to: CGPoint(x: 263.73, y: 336), controlPoint1: CGPoint(x: 252.09, y: 331.02), controlPoint2: CGPoint(x: 257.35, y: 336))
        exclamationTriangleRedPath.addLine(to: CGPoint(x: 312.27, y: 336))
        exclamationTriangleRedPath.addCurve(to: CGPoint(x: 324.25, y: 324.65), controlPoint1: CGPoint(x: 318.65, y: 336), controlPoint2: CGPoint(x: 323.91, y: 331.02))
        exclamationTriangleRedPath.addLine(to: CGPoint(x: 331.67, y: 188.65))
        exclamationTriangleRedPath.addCurve(to: CGPoint(x: 319.69, y: 176), controlPoint1: CGPoint(x: 332.05, y: 181.78), controlPoint2: CGPoint(x: 326.57, y: 176))
        exclamationTriangleRedPath.addLine(to: CGPoint(x: 256.31, y: 176))
        exclamationTriangleRedPath.addCurve(to: CGPoint(x: 244.33, y: 188.65), controlPoint1: CGPoint(x: 249.42, y: 176), controlPoint2: CGPoint(x: 243.95, y: 181.78))
        exclamationTriangleRedPath.close()
        ScannerStyleKit.clutterRed.setFill()
        exclamationTriangleRedPath.fill()
        
        context.restoreGState()

    }

    //// Generated Images

    @objc dynamic public class func imageOfTorchSymbol(imageSize: CGSize = CGSize(width: 15, height: 24), isTorchOn: Bool = false) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
            ScannerStyleKit.drawTorchSymbol(frame: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height), isTorchOn: isTorchOn)

        let imageOfTorchSymbol = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return imageOfTorchSymbol
    }

    @objc dynamic public class func imageOfCheckMarkSymbol(imageSize: CGSize = CGSize(width: 56, height: 56)) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
            ScannerStyleKit.drawCheckMarkSymbol(frame: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))

        let imageOfCheckMarkSymbol = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return imageOfCheckMarkSymbol
    }

    @objc dynamic public class func imageOfExclamationTriangleSymbol(imageSize: CGSize = CGSize(width: 56, height: 56), isError: Bool = false) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
            ScannerStyleKit.drawExclamationTriangleSymbol(frame: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height), isError: isError)

        let imageOfExclamationTriangleSymbol = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return imageOfExclamationTriangleSymbol
    }




    @objc(ScannerStyleKitResizingBehavior)
    public enum ResizingBehavior: Int {
        case aspectFit /// The content is proportionally resized to fit into the target rectangle.
        case aspectFill /// The content is proportionally resized to completely fill the target rectangle.
        case stretch /// The content is stretched to match the entire target rectangle.
        case center /// The content is centered in the target rectangle, but it is NOT resized.

        public func apply(rect: CGRect, target: CGRect) -> CGRect {
            if rect == target || target == CGRect.zero {
                return rect
            }

            var scales = CGSize.zero
            scales.width = abs(target.width / rect.width)
            scales.height = abs(target.height / rect.height)

            switch self {
                case .aspectFit:
                    scales.width = min(scales.width, scales.height)
                    scales.height = scales.width
                case .aspectFill:
                    scales.width = max(scales.width, scales.height)
                    scales.height = scales.width
                case .stretch:
                    break
                case .center:
                    scales.width = 1
                    scales.height = 1
            }

            var result = rect.standardized
            result.size.width *= scales.width
            result.size.height *= scales.height
            result.origin.x = target.minX + (target.width - result.width) / 2
            result.origin.y = target.minY + (target.height - result.height) / 2
            return result
        }
    }
}