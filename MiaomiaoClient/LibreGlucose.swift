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

public struct LibreGlucose {
    public let unsmoothedGlucose: Double
    public var glucoseDouble: Double
    public var glucose: UInt16 {
        return UInt16(glucoseDouble.rounded())
    }
    public var trend: UInt8
    public let timestamp: Date
    public let collector: String?
    public let offset = defaults.object(forKey: "extraOffset") as? (UInt16)
  
}

extension LibreGlucose: GlucoseValue {
    public var startDate: Date {
        return timestamp
    }
    
    public var quantity: HKQuantity {
        return HKQuantity(unit: .milligramsPerDeciliter, doubleValue: Double(glucose))
    }
}


extension LibreGlucose: SensorDisplayable {
    public var isStateValid: Bool {
        return (glucose + offset!) >= 39
    }
    
    public var trendType: GlucoseTrend? {
        return GlucoseTrend(rawValue: Int(trend))
    }
    
    public var isLocal: Bool {
        return true
    }
}



    

