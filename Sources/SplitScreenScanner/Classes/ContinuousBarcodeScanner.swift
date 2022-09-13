//
//  ContinuousBarcodeScanner.swift
//  SplitScreenScanner
//
//  Created by Sean Machen on 3/29/18.
//

import AVFoundation
import UIKit

enum ContinuousBarcodeScannerError: Error {
    case noCamera
    case couldNotInitCamera
    case couldNotAddVideoInput
    case couldNotAddMetadataOutput
}

protocol ContinuousBarcodeScannerDelegate: AnyObject {
    func didScan(barcode: String)
}

final class ContinuousBarcodeScanner {
    class MetadataContinousCapture: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        typealias BarcodeScannedClosure = (_ barcodeObject: AVMetadataMachineReadableCodeObject) -> Void
        private var barcodeScannedClosure: BarcodeScannedClosure?

        let metadataOutput: AVCaptureMetadataOutput
        var lastBarcodeScanned: String?

        override init() {
            metadataOutput = AVCaptureMetadataOutput()
            super.init()
            let metadataQueue = DispatchQueue(label: "com.clutter.SplitScreenScanner.metadata", attributes: [])
            metadataOutput.metadataObjectTypes = metadataOutput.availableMetadataObjectTypes
            metadataOutput.setMetadataObjectsDelegate(self, queue: metadataQueue)
        }

        func startRunning(rectOfInterest: CGRect, _ barcodeScannedClosure: @escaping BarcodeScannedClosure) {
            metadataOutput.rectOfInterest = rectOfInterest
            metadataOutput.metadataObjectTypes = metadataOutput.availableMetadataObjectTypes
            self.barcodeScannedClosure = barcodeScannedClosure
        }

        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
                let scannedString = metadataObject.stringValue,
                scannedString != lastBarcodeScanned {
                lastBarcodeScanned = scannedString

                DispatchQueue.main.async {
                    self.barcodeScannedClosure?(metadataObject)
                }
            }
        }
    }

    weak var delegate: ContinuousBarcodeScannerDelegate?

    private let metadataCapture: MetadataContinousCapture
    private let captureSession: AVCaptureSession
    private var previewLayer: AVCaptureVideoPreviewLayer
    private let previewView: UIView
    private var barcodeOverlayView: UIView?

    init(previewView: UIView) throws {
        self.previewView = previewView

        guard let videoDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            throw ContinuousBarcodeScannerError.noCamera
        }

        do {
            try videoDevice.lockForConfiguration()
            videoDevice.focusMode = .continuousAutoFocus
            videoDevice.exposureMode = .continuousAutoExposure
            videoDevice.whiteBalanceMode = .continuousAutoWhiteBalance

            if videoDevice.isAutoFocusRangeRestrictionSupported {
                videoDevice.autoFocusRangeRestriction = .near
            }

            if videoDevice.isSmoothAutoFocusSupported {
                videoDevice.isSmoothAutoFocusEnabled = false
            }

            videoDevice.unlockForConfiguration()
        } catch {
            throw ContinuousBarcodeScannerError.couldNotInitCamera
        }

        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo

        guard let videoInput = try? AVCaptureDeviceInput(device: videoDevice) else {
            throw ContinuousBarcodeScannerError.couldNotInitCamera
        }
        guard captureSession.canAddInput(videoInput) else {
            throw ContinuousBarcodeScannerError.couldNotAddVideoInput
        }
        captureSession.addInput(videoInput)

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)

        if previewView.bounds.height > previewView.bounds.width {
            previewLayer.frame = .init(
                x: 0,
                y: 0,
                width: previewView.bounds.height,
                height: previewView.bounds.width
            )
        } else {
            previewLayer.frame = .init(
                x: 0,
                y: 0,
                width: previewView.bounds.width,
                height: previewView.bounds.height
            )
        }

        previewLayer.videoGravity = .resizeAspectFill

        metadataCapture = MetadataContinousCapture()
        guard captureSession.canAddOutput(metadataCapture.metadataOutput) else {
            throw ContinuousBarcodeScannerError.couldNotAddMetadataOutput
        }
        captureSession.addOutput(metadataCapture.metadataOutput)
    }

    func drawOverlayFor(barcodeObject: AVMetadataMachineReadableCodeObject) -> UIView? {

        guard let barcode = barcodeObject.stringValue,
              let bounds = self.previewLayer.transformedMetadataObject(for: barcodeObject)?.bounds else {
                  return nil
        }

        let overlayView = UIView(frame: bounds)
        let overlayLabel = UILabel(frame: overlayView.bounds)

        overlayView.layer.borderWidth = 5.0
        overlayView.backgroundColor = UIColor.green.withAlphaComponent(0.75)
        overlayView.layer.borderColor = UIColor.green.cgColor

        overlayLabel.font = UIFont.boldSystemFont(ofSize: 18)
        overlayLabel.text = barcode
        overlayLabel.textColor = UIColor.white
        overlayLabel.textAlignment = .center
        overlayLabel.numberOfLines = 0

        if barcodeObject.type != .qr {
            overlayLabel.sizeToFit()
            overlayView.frame = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.width, height: overlayLabel.frame.height + 10)
        }

        overlayLabel.center = overlayView.convert(overlayView.center, from: overlayLabel)

        overlayView.addSubview(overlayLabel)

        return overlayView
    }

    func addBarcodeOverlayViewFor(barcodeObject: AVMetadataMachineReadableCodeObject) {
        if self.barcodeOverlayView != nil {
            self.barcodeOverlayView?.removeFromSuperview()
            self.barcodeOverlayView = nil
        }

        guard let overlayView = self.drawOverlayFor(barcodeObject: barcodeObject) else {
            return
        }

        self.barcodeOverlayView = overlayView
        self.previewView.addSubview(overlayView)
    }
}

// MARK: - Public Methods
extension ContinuousBarcodeScanner {
    func startRunning() {
        captureSession.startRunning()

        let rectOfInterest = previewLayer.metadataOutputRectConverted(fromLayerRect: previewView.bounds)
        metadataCapture.startRunning(rectOfInterest: rectOfInterest) { [weak self] barcodeObject in
            self?.delegate?.didScan(barcode: barcodeObject.stringValue ?? "")
            self?.addBarcodeOverlayViewFor(barcodeObject: barcodeObject)
        }

        if let sublayer = previewView.layer.sublayers?.first {
            previewView.layer.insertSublayer(previewLayer, below: sublayer)
        } else {
            previewView.layer.addSublayer(previewLayer)
        }
    }

    func stopRunning() {
        captureSession.stopRunning()
        previewLayer.removeFromSuperlayer()
    }

    func resetLastScannedBarcode() {
        metadataCapture.lastBarcodeScanned = nil
    }
}
