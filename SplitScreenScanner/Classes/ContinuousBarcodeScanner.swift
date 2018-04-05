//
//  ContinuousBarcodeScanner.swift
//  SplitScreenScanner
//
//  Created by Sean Machen on 3/29/18.
//

import AVFoundation

enum ContinuousBarcodeScannerError: Error {
    case noCamera
    case couldNotInitCamera
    case couldNotAddVideoInput
    case couldNotAddMetadataOutput
}

protocol ContinuousBarcodeScannerDelegate: class {
    func didScan(barcode: String)
}

final class ContinuousBarcodeScanner {
    class MetadataContinousCapture: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        typealias BarcodeScannedClosure = (_ barcode: String) -> Void
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
                barcodeScannedClosure?(scannedString)
            }
        }
    }

    weak var delegate: ContinuousBarcodeScannerDelegate?

    private let metadataCapture: MetadataContinousCapture
    private let captureSession: AVCaptureSession
    private var previewLayer: AVCaptureVideoPreviewLayer
    private let previewView: UIView


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
            videoDevice.unlockForConfiguration()
        } catch {
            throw ContinuousBarcodeScannerError.couldNotInitCamera
        }

        do {
            let videoInput = try AVCaptureDeviceInput(device: videoDevice)
            captureSession = AVCaptureSession()
            captureSession.sessionPreset = .high
            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
            } else {
                throw ContinuousBarcodeScannerError.couldNotAddVideoInput
            }
        } catch {
            throw ContinuousBarcodeScannerError.couldNotInitCamera
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = previewView.bounds
        previewLayer.videoGravity = .resizeAspectFill

        metadataCapture = MetadataContinousCapture()
        if captureSession.canAddOutput(metadataCapture.metadataOutput) {
            captureSession.addOutput(metadataCapture.metadataOutput)
        } else {
            throw ContinuousBarcodeScannerError.couldNotAddMetadataOutput
        }
    }
}

// MARK: - Public Methods
extension ContinuousBarcodeScanner {
    func startRunning() {
        captureSession.startRunning()

        let rectOfInterest = previewLayer.metadataOutputRectConverted(fromLayerRect: previewView.bounds)
        metadataCapture.startRunning(rectOfInterest: rectOfInterest) { [weak self] barcode in
            self?.delegate?.didScan(barcode: barcode)
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
}
