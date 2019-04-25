//
//  MiaomiaoClientManager+UI.swift
//  Loop
//
//  Copyright © 2018 LoopKit Authors. All rights reserved.
//

import LoopKit
import LoopKitUI
import HealthKit
import CGMBLEKit
import MiaomiaoClient


extension MiaoMiaoClientManager: CGMManagerUI {
/*    public static func setupViewController() -> (UIViewController & CGMManagerSetupViewController & CompletionNotifying)? {
        let setupVC = TransmitterSetupViewController.instantiateFromStoryboard()
        setupVC.cgmManagerType = self
        return setupVC

        //        return MiaomiaoClientSetupViewController()
    }

    public func settingsViewController(for glucoseUnit: HKUnit) -> (UIViewController & CompletionNotifying) {
        let settings = MiaomiaoClientSettingsViewController(cgmManager: self, glucoseUnit: .milligramsPerDeciliter, allowsDeletion: true)
            return settings
        //return MiaomiaoClientSettingsViewController(cgmManager: self, glucoseUnit: glucoseUnit, allowsDeletion: true)
    }
*/
    public var smallImage: UIImage? {
        return nil
    }
}
