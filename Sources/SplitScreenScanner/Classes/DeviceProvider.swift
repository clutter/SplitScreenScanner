//
//  DeviceProvider.swift
//  SplitScreenScanner
//
//  Created by Sean Machen on 4/2/18.
//

import AVFoundation

protocol DeviceProviding {
    var isTorchOn: Bool { get set }
    var hasTorch: Bool { get }

    func lockForConfiguration() throws
    func unlockForConfiguration()
}

class DeviceProvider: DeviceProviding {
    let device: AVCaptureDevice

    var isTorchOn: Bool {
        get {
            return device.torchMode == .on
        }

        set {
            device.torchMode = newValue ? .on : .off
        }
    }

    var hasTorch: Bool {
        return device.hasTorch
    }

    init(device: AVCaptureDevice) {
        self.device = device
    }

    func lockForConfiguration() throws {
        try device.lockForConfiguration()
    }

    func unlockForConfiguration() {
        device.unlockForConfiguration()
    }
}
