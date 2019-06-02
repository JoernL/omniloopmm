//
//  MiaomiaoClient.h
//  MiaomiaoClient
//
//  Created by Mark Wilson on 5/7/16.
//  Copyright © 2016 Mark Wilson. All rights reserved.
//

import Foundation
import LoopKit
import HealthKit

let defaults = UserDefaults.standard
//public var observer = GlucoseObserver()

public struct LibreGlucose {
    public let unsmoothedGlucose: Double
    public var glucoseDouble: Double
    public var glucose: Float {
        return Float(glucoseDouble.rounded())
    }
    public var trend: UInt8
    public let timestamp: Date
    public let collector: String?
   
}

extension LibreGlucose: GlucoseValue {
    
    public var startDate: Date {
        return timestamp
    }
    
    public var quantity: HKQuantity {
        
        if (defaults.object(forKey: "extraSlope") == nil) {
            defaults.set("1.0", forKey: "extraSlope")
        }
        let extraSlope = defaults.float(forKey: "extraSlope")
        let glucoseValue = glucose * extraSlope
        defaults.set(glucoseValue, forKey: "glucoseValue")
        //observer.observeGlucose()
        return HKQuantity(unit: .milligramsPerDeciliter, doubleValue: Double(glucose * extraSlope))
    }
}


extension LibreGlucose: SensorDisplayable {
    
    public var isStateValid: Bool {
        
         return glucose >= 39
    }

    
    public var trendType: GlucoseTrend? {
        return GlucoseTrend(rawValue: Int(trend))
    }
    
    public var isLocal: Bool {
        return true
    }

}
    

