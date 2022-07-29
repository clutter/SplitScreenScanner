//
//  Coordinator.swift
//  SplitScreenScanner
//
//  Created by Sean Machen on 3/28/18.
//

import Foundation

protocol Coordinator: AnyObject {
    var identifier: UUID { get }
    var rootCoordinator: RootCoordinator? { get set }
}

protocol RootCoordinator: AnyObject {
    var coordinators: [UUID: Coordinator] { get set }

    func pushCoordinator(_ coordinator: Coordinator)
    func popCoordinator(_ coordinator: Coordinator)
}

extension RootCoordinator {
    func pushCoordinator(_ coordinator: Coordinator) {
        coordinators[coordinator.identifier] = coordinator
    }

    func popCoordinator(_ coordinator: Coordinator) {
        coordinators[coordinator.identifier] = nil
    }
}
