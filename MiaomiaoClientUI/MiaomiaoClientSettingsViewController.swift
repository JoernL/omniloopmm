//
//  MiaomiaoClientSettingsViewController.swift
//  Loop
//
//  Copyright © 2018 LoopKit Authors. All rights reserved.
//

import UIKit
import HealthKit
import LoopKit
import LoopKitUI
import MiaomiaoClient


public class MiaomiaoClientSettingsViewController: UITableViewController, CompletionNotifying {
    public var completionDelegate: CompletionDelegate?
    
    private let isDemoMode = false
    public var cgmManager: MiaoMiaoClientManager?

    public let glucoseUnit: HKUnit

    public let allowsDeletion: Bool
    
    public let extraOffset: String
    
    public init(cgmManager: MiaoMiaoClientManager, glucoseUnit: HKUnit, allowsDeletion: Bool) {
        self.cgmManager = cgmManager
        self.glucoseUnit = glucoseUnit
        self.allowsDeletion = allowsDeletion
        self.extraOffset = "0"
        
        
        super.init(style: .grouped)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        title = cgmManager?.localizedTitle

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44

        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 55

        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.className)
        tableView.register(TextButtonTableViewCell.self, forCellReuseIdentifier: TextButtonTableViewCell.className)
    }

    // MARK: - UITableViewDataSource

    private enum Section: Int {
        case authentication
        case latestReading
        case extraOffset
        case sensorInfo
        case latestBridgeInfo
        case latestCalibrationData
        case alarms
        
        case delete

        static let count = 7
    }

    override public func numberOfSections(in tableView: UITableView) -> Int {
        return allowsDeletion ? Section.count : Section.count - 1
    }

    private enum LatestReadingRow: Int {
        case glucose
        case date
        case trend
        case footerChecksum
        static let count = 4
    }
    
    private enum ExtraOffsetRow: Int {
        case offset
        
        static let count = 1
    }
    
    private enum LatestSensorInfoRow: Int {
        case sensorAge
        case sensorState
        case sensorSerialNumber
        static let count = 3
    }
    
    private enum LatestBridgeInfoRow: Int {
        
        case battery
        case hardware
        case firmware
        case connectionState
        
        static let count = 4
    }
    
    private enum LatestCalibrationDataInfoRow: Int {
        case slopeslope
        case slopeoffset
        case offsetslope
        case offsetoffset
        case isValidForFooterWithCRCs
        
        
        static let count = 5
    }
    
    private enum AlarmInfoRow {
        case alarms
        
        static let count = 1
    }

    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .authentication:
            return 1
        case .latestReading:
            return LatestReadingRow.count
        case .extraOffset:
            return 1
        case .sensorInfo:
            return LatestSensorInfoRow.count
        case .delete:
            return 1
        case .latestBridgeInfo:
            return LatestBridgeInfoRow.count
            
        case .latestCalibrationData:
            return LatestCalibrationDataInfoRow.count
        
        case .alarms:
            return AlarmInfoRow.count
        }
    }

    private lazy var glucoseFormatter: QuantityFormatter = {
        let formatter = QuantityFormatter()
        formatter.setPreferredNumberFormatter(for: glucoseUnit)
        return formatter
    }()

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .long
        formatter.doesRelativeDateFormatting = true
        return formatter
    }()

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section(rawValue: indexPath.section)! {
        case .authentication:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.className, for: indexPath) as! SettingsTableViewCell

            

            cell.textLabel?.text = LocalizedString("Calibration Settings", comment: "Title of cell to set credentials")
            let tokenLength = cgmManager?.miaomiaoService.accessToken?.count ?? 0
            
            cell.detailTextLabel?.text =  tokenLength > 0 ? "token set" : "token not set"
            cell.accessoryType = .disclosureIndicator

            return cell
        case .latestReading:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.className, for: indexPath) as! SettingsTableViewCell
            let glucose = cgmManager?.latestBackfill

            switch LatestReadingRow(rawValue: indexPath.row)! {
            case .glucose:
                cell.textLabel?.text = LocalizedString("Glucose", comment: "Title describing glucose value")

                if let quantity = glucose?.quantity, let formatted = glucoseFormatter.string(from: quantity, for: glucoseUnit) {
                    cell.detailTextLabel?.text = formatted
                } else {
                    cell.detailTextLabel?.text = SettingsTableViewCell.NoValueString
                }
            case .date:
                cell.textLabel?.text = LocalizedString("Date", comment: "Title describing glucose date")

                if let date = glucose?.timestamp {
                    cell.detailTextLabel?.text = dateFormatter.string(from: date)
                } else {
                    cell.detailTextLabel?.text = SettingsTableViewCell.NoValueString
                }
            case .trend:
                cell.textLabel?.text = LocalizedString("Trend", comment: "Title describing glucose trend")

                cell.detailTextLabel?.text = glucose?.trendType?.localizedDescription ?? SettingsTableViewCell.NoValueString
           
            case .footerChecksum:
                cell.textLabel?.text = LocalizedString("Sensor Footer checksum", comment: "Title describing Sensor footer reverse checksum")
                
                
                cell.detailTextLabel?.text = isDemoMode ? "demo123" : cgmManager?.sensorFooterChecksums
            }

            return cell
        case .delete:
            let cell = tableView.dequeueReusableCell(withIdentifier: TextButtonTableViewCell.className, for: indexPath) as! TextButtonTableViewCell

            cell.textLabel?.text = LocalizedString("Delete CGM", comment: "Title text for the button to remove a CGM from Loop")
            cell.textLabel?.textAlignment = .center
            cell.tintColor = .delete
            cell.isEnabled = true
            return cell
        
        case .extraOffset:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.className, for: indexPath) as! SettingsTableViewCell
            
            cell.textLabel?.text = LocalizedString("Extra Offset", comment: "Title of cell to set an Extra Offset")
            let tokenLength = 0
            cell.detailTextLabel?.text = extraOffset
            cell.accessoryType = .disclosureIndicator
            
            return cell
           
        case .latestBridgeInfo:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.className, for: indexPath) as! SettingsTableViewCell
            
            
            switch LatestBridgeInfoRow(rawValue: indexPath.row)! {
            case .battery:
                cell.textLabel?.text = LocalizedString("Battery", comment: "Title describing bridge battery info")
                
                
                cell.detailTextLabel?.text = cgmManager?.battery
                
            case .firmware:
                cell.textLabel?.text = LocalizedString("Firmware", comment: "Title describing bridge firmware info")
                
                
                cell.detailTextLabel?.text = cgmManager?.firmwareVersion
                
            case .hardware:
                cell.textLabel?.text = LocalizedString("Hardware", comment: "Title describing bridge hardware info")
                
                cell.detailTextLabel?.text = cgmManager?.hardwareVersion
            case .connectionState:
                cell.textLabel?.text = LocalizedString("Connection State", comment: "Title Bridge connection state")
                
                cell.detailTextLabel?.text = cgmManager?.connectionState
            }
            
            return cell
        case .latestCalibrationData:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.className, for: indexPath) as! SettingsTableViewCell
            
            let data = cgmManager?.calibrationData
            /*
             case slopeslope
             case slopeoffset
             case offsetslope
             case offsetoffset
             */
            switch LatestCalibrationDataInfoRow(rawValue: indexPath.row)! {
            
            case .slopeslope:
                cell.textLabel?.text = LocalizedString("Slope_slope", comment: "Title describing calibrationdata slopeslope")
                
                if let data=data{
                    cell.detailTextLabel?.text = "\(data.slope_slope.scientificStyle)"
                } else {
                    cell.detailTextLabel?.text = SettingsTableViewCell.NoValueString
                }
            case .slopeoffset:
                cell.textLabel?.text = LocalizedString("Slope_offset", comment: "Title describing calibrationdata slopeoffset")
                
                if let data=data{
                    cell.detailTextLabel?.text = "\(data.slope_offset.scientificStyle)"
                } else {
                    cell.detailTextLabel?.text = SettingsTableViewCell.NoValueString
                }
            case .offsetslope:
                cell.textLabel?.text = LocalizedString("Offset_slope", comment: "Title describing calibrationdata offsetslope")
                
                if let data=data{
                    cell.detailTextLabel?.text = "\(data.offset_slope.scientificStyle)"
                } else {
                    cell.detailTextLabel?.text = SettingsTableViewCell.NoValueString
                }
            case .offsetoffset:
                cell.textLabel?.text = LocalizedString("Offset_offset", comment: "Title describing calibrationdata offsetoffset")
                
                if let data=data{
                    cell.detailTextLabel?.text = "\(data.offset_offset.fourDecimals)"
                } else {
                    cell.detailTextLabel?.text = SettingsTableViewCell.NoValueString
                }
            
            case .isValidForFooterWithCRCs:
                cell.textLabel?.text = LocalizedString("Valid For Footer", comment: "Title describing calibrationdata validity")
                
                if let data=data{
                    cell.detailTextLabel?.text = isDemoMode ? "demo123"  : "\(data.isValidForFooterWithReverseCRCs)"
                } else {
                    cell.detailTextLabel?.text = SettingsTableViewCell.NoValueString
                }
            }
            return cell
        case .sensorInfo:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.className, for: indexPath) as! SettingsTableViewCell
            
            
            switch LatestSensorInfoRow(rawValue: indexPath.row)! {
            case .sensorState:
                cell.textLabel?.text = LocalizedString("Sensor State", comment: "Title describing sensor state")
                
                cell.detailTextLabel?.text = cgmManager?.sensorStateDescription
            case .sensorAge:
                cell.textLabel?.text = LocalizedString("Sensor Age", comment: "Title describing sensor Age")
                
                cell.detailTextLabel?.text = cgmManager?.sensorAge
                
            case .sensorSerialNumber:
                cell.textLabel?.text = LocalizedString("Sensor Serial", comment: "Title describing sensor serial")
                
                cell.detailTextLabel?.text = isDemoMode ? "0M007DEMO1" :cgmManager?.sensorSerialNumber
                
                
                
                
            }
            return cell
        case .alarms:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.className, for: indexPath) as! SettingsTableViewCell
            cell.textLabel?.text = LocalizedString("Alarms", comment: "Title describing sensor serial")
            
            cell.detailTextLabel?.text = "Alarms details"
            return cell
        }
    }

    public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch Section(rawValue: section)! {
        case .authentication:
            return nil
        case .sensorInfo:
            return LocalizedString("Sensor Info", comment: "Section title for latest sensor info")
        case .latestReading:
            return LocalizedString("Latest Reading", comment: "Section title for latest glucose reading")
        case .extraOffset:
            return nil
        case .delete:
            return nil
        case .latestBridgeInfo:
            return LocalizedString("Latest Bridge info", comment: "Section title for latest bridge info")
        case .latestCalibrationData:
            return LocalizedString("Latest Autocalibration Parameters", comment: "Section title for latest bridge info")
       
        case .alarms:
            return LocalizedString("Alarms", comment: "Section Alarms")
        }
    }

    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch Section(rawValue: indexPath.section)! {
        case .authentication:
            guard let service = cgmManager?.miaomiaoService else {
                NSLog("dabear:: no miaomiaoservice?")
                self.tableView.reloadRows(at: [indexPath], with: .none)
                break
            }
            let vc = AuthenticationViewController(authentication: service)
            vc.authenticationObserver = { [weak self] (service) in
                self?.cgmManager?.miaomiaoService = service
                
                let keychain = KeychainManager()
                do{
                    NSLog("dabear:: miaomiaoservice alter: setAutoCalibrateWebAccessToken called")
                    try keychain.setAutoCalibrateWebAccessToken(accessToken: service.accessToken, url: service.url)
                } catch {
                    NSLog("dabear:: miaomiaoservice alter:could not permanently save setAutoCalibrateWebAccessToken")
                }
                
                self?.tableView.reloadRows(at: [indexPath], with: .none)
            }

            show(vc, sender: nil)
            
            
            
        case .extraOffset:
            
          guard let service = cgmManager?.miaomiaoService else {
                NSLog("dabear:: no miaomiaoservice?")
                self.tableView.reloadRows(at: [indexPath], with: .none)
                break
            }
            let vc = AuthenticationViewController(authentication: service)
            vc.authenticationObserver = { [weak self] (service) in
                self?.cgmManager?.miaomiaoService = service
                
                let offset = KeychainManager()
                do{
                    NSLog("dabear:: miaomiaoservice alter: setAutoCalibrateWebAccessToken called")
                try
                    offset.replaceGenericPassword(service.extraOffset, forService: extraOffset)
                } catch {
                    NSLog("dabear:: miaomiaoservice alter:could not permanently save setAutoCalibrateWebAccessToken")
                }
                    
                    
                
                
              
 
 /*               struct RuntimeError: Error {
                    let message: String
                    
                    init(_ message: String) {
                        self.message = message
                    }
                    
                    public var localizedDescription: String {
                        return message
                    }
  */              //}
                
                
                
                //offset.replaceGenericPassword(self.extraOffset, forService: "test") throw RuntimeError("Error")
                
                
                //offset.setInternetPassword(extraOffset, account: "test", atURL: url)
                self?.tableView.reloadRows(at: [indexPath], with: .none)
                let extraOffset = service.extraOffset
            }
        
            show(vc, sender: nil)
            
            
            
            
            
            
            
        case .latestReading:
            tableView.deselectRow(at: indexPath, animated: true)
        case .delete:
            let confirmVC = UIAlertController(cgmDeletionHandler: {
                NSLog("dabear:: confirmed: cgmmanagerwantsdeletion")
                if let cgmManager = self.cgmManager {
                    cgmManager.disconnect()
                    cgmManager.cgmManagerDelegate?.cgmManagerWantsDeletion(cgmManager)
                    
                    self.cgmManager = nil
                    
                    
                    
                }
                
                self.navigationController?.popViewController(animated: true)
            })

            present(confirmVC, animated: true) {
                tableView.deselectRow(at: indexPath, animated: true)
            }
        case .latestBridgeInfo:
            tableView.deselectRow(at: indexPath, animated: true)
        case .latestCalibrationData:
            
            let confirmVC = UIAlertController(calibrateHandler:  {
               
                if let cgmManager = self.cgmManager {
                   
                    guard let (accessToken, url) =  cgmManager.keychain.getAutoCalibrateWebCredentials() else {
                        NSLog("dabear:: could not calibrate, accesstoken or url was nil")
                        self.presentStatus(OKAlertController(LibreError.invalidAutoCalibrationCredentials.errorDescription, title: "Error"))
                        
                        return
                    }
                    
                    guard let data = cgmManager.lastValidSensorData else {
                        NSLog("No sensordata was present, unable to recalibrate!")
                        self.presentStatus(OKAlertController(LibreError.noSensorData.errorDescription, title: "Error"))
                        
                        return
                    }
                    
                    calibrateSensor(accessToken: accessToken, site: url.absoluteString, sensordata: data) { [weak self] (calibrationparams)  in
                        guard let params = calibrationparams else {
                            NSLog("dabear:: could not calibrate sensor, check libreoopweb permissions and internet connection")
                            self?.presentStatus(OKAlertController(LibreError.noCalibrationData.errorDescription, title: "Error"))
                            
                            return
                        }
                        
                        do {
                            try self?.cgmManager?.keychain.setLibreCalibrationData(params)
                        } catch {
                            NSLog("dabear:: could not save calibrationdata")
                            self?.presentStatus(OKAlertController(LibreError.invalidCalibrationData.errorDescription, title: "Error"))
                            return
                        }
                        
                        self?.presentStatus(OKAlertController("Calibration success!", title: "Success"))
                       
                        
                        
                    }
                    
                    
                    
                }
                
                
            })
            
            present(confirmVC, animated: true) {
                tableView.deselectRow(at: indexPath, animated: true)
                
            }
            
            
        case .sensorInfo:
            tableView.deselectRow(at: indexPath, animated: true)
        case .alarms:
            tableView.deselectRow(at: indexPath, animated: true)
            let alarmsVC = AlarmSettingsTableViewController()
            show(alarmsVC, sender: nil)
        }
    }
    
    func presentStatus(_ controller: UIAlertController) {
        self.present(controller, animated: true) {
            NSLog("calibrationstatus shown")
        }
    }
}

func OKAlertController(_ message: String, title: String )-> UIAlertController {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    // Create OK button
    let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
        
        // Code in this block will trigger when OK button tapped.
        
        
    }
    alertController.addAction(OKAction)
    return alertController
}


private extension UIAlertController {
    
    convenience init(cgmDeletionHandler handler: @escaping () -> Void) {
        self.init(
            title: nil,
            message: LocalizedString("Are you sure you want to delete this CGM?", comment: "Confirmation message for deleting a CGM"),
            preferredStyle: .actionSheet
        )

        addAction(UIAlertAction(
            title: LocalizedString("Delete CGM", comment: "Button title to delete CGM"),
            style: .destructive,
            handler: { (_) in
                handler()
            }
        ))

        let cancel = LocalizedString("Cancel", comment: "The title of the cancel action in an action sheet")
        addAction(UIAlertAction(title: cancel, style: .cancel, handler: nil))
    }
    convenience init(calibrateHandler handler: @escaping () -> Void) {
        self.init(
            title: nil,
            message: LocalizedString("Are you sure you want to recalibrate this sensor?", comment: "Confirmation message for recalibrate sensor"),
            preferredStyle: .actionSheet
        )
        
        addAction(UIAlertAction(
            title: LocalizedString("Recalibrate", comment: "Button title to recalibrate"),
            style: .destructive,
            handler: { (_) in
                handler()
        }
        ))
        
        let cancel = LocalizedString("Cancel", comment: "The title of the cancel action in an action sheet")
        addAction(UIAlertAction(title: cancel, style: .cancel, handler: nil))
    }
}
