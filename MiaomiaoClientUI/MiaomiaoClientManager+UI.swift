//
//  MiaomiaoClientManager+UI.swift
//  Loop
//
//  Copyright © 2018 LoopKit Authors. All rights reserved.
//

import LoopKit
import LoopKitUI
import HealthKit
import MiaomiaoClient


extension MiaoMiaoClientManager: CGMManagerUI {
    public static func setupViewController() -> (UIViewController & CGMManagerSetupViewController & CompletionNotifying)? {
        let setupVC = TransmitterSetupViewController.instantiateFromStoryboard()
            setupVC.cgmManagerType = self
            return setupVC
//        return MiaomiaoClientSetupViewController()
    }

    public func settingsViewController(for glucoseUnit: HKUnit) -> (UIViewController & CompletionNotifying) {
        let settings = TransmitterSettingsViewController(cgmManager: self, glucoseUnit: .milligramsPerDeciliter)
            let nav = SettingsNavigationViewController(rootViewController: settings)
            return nav
        //return MiaomiaoClientSettingsViewController(cgmManager: self, glucoseUnit: glucoseUnit, allowsDeletion: true)
    }

    public var smallImage: UIImage? {
        return nil
    }
}
