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
        return MiaomiaoClientSetupViewController() as! (UIViewController & CGMManagerSetupViewController & CompletionNotifying)
        
    }

    public func settingsViewController(for glucoseUnit: HKUnit) -> (UIViewController & CompletionNotifying) {
        return MiaomiaoClientSettingsViewController(cgmManager: self, glucoseUnit: glucoseUnit, allowsDeletion: true) as! (UIViewController & CompletionNotifying)
        
    }

    public var smallImage: UIImage? {
        return nil
    }
}
