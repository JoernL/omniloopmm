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
        let setupVC = MiaomiaoClientSetupViewController.init()
        
            return setupVC

        //        return MiaomiaoClientSetupViewController()
    }

    public func settingsViewController(for glucoseUnit: HKUnit) -> (UIViewController & CompletionNotifying) {
        let settings = MiaomiaoClientSettingsViewController(cgmManager: self, glucoseUnit: .milligramsPerDeciliter, allowsDeletion: true)
            let nav = MiaomiaoClientSettingsViewController(rootViewController: settings)
            return nav
        //return MiaomiaoClientSettingsViewController(cgmManager: self, glucoseUnit: glucoseUnit, allowsDeletion: true)
    }

    public var smallImage: UIImage? {
        return nil
    }
}
