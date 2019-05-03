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
let tmp = defaults.object(forKey: "extraOffset") as? Int16
var extraOffset: Int16 = tmp!

public struct LibreGlucose {
    public let unsmoothedGlucose: Double
    public var glucoseDouble: Double
    public var glucose: Int16 {
        return Int16(glucoseDouble.rounded())
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
        return HKQuantity(unit: .milligramsPerDeciliter, doubleValue: Double(glucose + extraOffset))
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
    

