//
//  AlarmsClientSettingsViewController.swift
//  MiaomiaoClientUI
//
//  Created by Bjørn Inge Berg on 11/04/2019.
//  Copyright © 2019 Mark Wilson. All rights reserved.
//
import UIKit
import LoopKitUI
import LoopKit



public protocol AlarmSettingsTableViewControllerDelegate: class {
    func deliveryLimitSettingsTableViewControllerDidUpdateMaximumBasalRatePerHour(_ vc: DeliveryLimitSettingsTableViewController)
    
    func deliveryLimitSettingsTableViewControllerDidUpdateMaximumBolus(_ vc: DeliveryLimitSettingsTableViewController)
}


public enum DeliveryLimitSettingsResult {
    case success(maximumBasalRatePerHour: Double, maximumBolus: Double)
    case failure(Error)
}


public protocol AlarmSettingsTableViewControllerSyncSource: class {
    func syncDeliveryLimitSettings(for viewController: AlarmSettingsTableViewController, completion: @escaping (_ result: DeliveryLimitSettingsResult) -> Void)
    
    func syncButtonTitle(for viewController: AlarmSettingsTableViewController) -> String
    
    func syncButtonDetailText(for viewController: AlarmSettingsTableViewController) -> String?
    
    func deliveryLimitSettingsTableViewControllerIsReadOnly(_ viewController: AlarmSettingsTableViewController) -> Bool
}


public class AlarmSettingsTableViewController: UITableViewController {
    
    public weak var delegate: AlarmSettingsTableViewControllerDelegate?
    
    
    
    public var maximumBasalRatePerHour: Double? {
        didSet {
            /*if isViewLoaded, let cell = tableView.cellForRow(at: IndexPath(row: 0, section: Section.basalRate.rawValue)) as? TextFieldTableViewCell {
                if let maximumBasalRatePerHour = maximumBasalRatePerHour {
                    cell.textField.text = valueNumberFormatter.string(from:  maximumBasalRatePerHour)
                } else {
                    cell.textField.text = nil
                }
            }*/
        }
    }
    
    public var maximumBolus: Double? {
        didSet {
            /*if isViewLoaded, let cell = tableView.cellForRow(at: IndexPath(row: 0, section: Section.bolus.rawValue)) as? TextFieldTableViewCell {
                if let maximumBolus = maximumBolus {
                    cell.textField.text = valueNumberFormatter.string(from: maximumBolus)
                } else {
                    cell.textField.text = nil
                }
            }*/
        }
    }
    
    public var isReadOnly = false
    
    private var isSyncInProgress = false {
        didSet {
            for cell in tableView.visibleCells {
                switch cell {
                case let cell as TextButtonTableViewCell:
                    cell.isEnabled = !isSyncInProgress
                    cell.isLoading = isSyncInProgress
                case let cell as TextFieldTableViewCell:
                    cell.textField.isEnabled = !isReadOnly && !isSyncInProgress
                default:
                    break
                }
            }
            
            for item in navigationItem.rightBarButtonItems ?? [] {
                item.isEnabled = !isSyncInProgress
            }
            
            navigationItem.hidesBackButton = isSyncInProgress
        }
    }
    
    private lazy var valueNumberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 1
        
        return formatter
    }()
    
    // MARK: -
    public init() {
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(AlarmTimeInputRangeCell.nib(), forCellReuseIdentifier: AlarmTimeInputRangeCell.className)
        
        tableView.register(TextFieldTableViewCell.nib(), forCellReuseIdentifier: TextFieldTableViewCell.className)
        tableView.register(TextButtonTableViewCell.self, forCellReuseIdentifier: TextButtonTableViewCell.className)
    }
    
    // MARK: - Table view data source
    
    private enum Section: Int {
        case schedule1
        case schedule2
        
        case sync
        
        static let count=3
    }
    
    
    public override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count
        
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .schedule1:
            return 2
        case .schedule2:
            return 2
        case .sync:
            return 1
        }
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section(rawValue: indexPath.section)! {
        case .schedule1:
            /*
             switch LatestReadingRow(rawValue: indexPath.row)! {
             case .glucose:
             */
           
            /*let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.className, for: indexPath) as!  TextFieldTableViewCell
            
            
           
            cell.textField.keyboardType = .decimalPad
            cell.textField.placeholder = isReadOnly ? LocalizedString("Enter a low glucose alarm value", comment: "The placeholder text instructing users how to enter a low glucose value") : nil
            cell.textField.isEnabled = !isReadOnly && !isSyncInProgress
            cell.unitLabel?.text = LocalizedString("mgdl", comment: "The unit string for low glucose")
            */
            
            let cell = tableView.dequeueReusableCell(withIdentifier: AlarmTimeInputRangeCell.className, for: indexPath) as!  AlarmTimeInputRangeCell
            
            cell.minValue = "first"
            cell.maxValue = "second"
           
           
            
           
            

            
            
            //cell.delegate = self
            
            return cell
        case .schedule2:
            let cell = tableView.dequeueReusableCell(withIdentifier: AlarmTimeInputRangeCell.className, for: indexPath) as!  AlarmTimeInputRangeCell
            
            //cell.minValue = "first"
            
            return cell
        case .sync:
            let cell = tableView.dequeueReusableCell(withIdentifier: TextButtonTableViewCell.className, for: indexPath) as! TextButtonTableViewCell
            
            cell.textLabel?.text = LocalizedString("Save glucose alarms", comment: "The title for Save glucose alarms")
            cell.isEnabled = !isSyncInProgress
            cell.isLoading = isSyncInProgress
            
            return cell
        }
    }
    
    public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch Section(rawValue: section)! {
        case .schedule1:
            return LocalizedString("Glucose Alarm Schedule #1", comment: "The title text for the Glucose Alarm Schedule #1")
        case .schedule2:
            return LocalizedString("Glucose Alarm Schedule #2", comment: "The title text for the lGlucose Alarm Schedule #2")
        case .sync:
            return nil
        }
    }
    
    public override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch Section(rawValue: section)! {
        case .schedule1:
            return nil
        case .schedule2:
            return nil
        case .sync:
            return nil //LocalizedString("Save alarms", comment: "The title for saving alarms")
        }
    }
    
    public override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch Section(rawValue: indexPath.section)! {
        case .schedule1, .schedule2:
            if let cell = tableView.cellForRow(at: indexPath) as? TextFieldTableViewCell {
                if cell.textField.isFirstResponder {
                    cell.textField.resignFirstResponder()
                } else {
                    cell.textField.becomeFirstResponder()
                }
            }
        case .sync:
            tableView.endEditing(true)
            
            isSyncInProgress = true
            
            
            DispatchQueue.main.async {
                usleep(5000000)
                self.isSyncInProgress = false
            }
            
            /*syncSource.syncDeliveryLimitSettings(for: self) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(maximumBasalRatePerHour: let maxBasal, maximumBolus: let maxBolus):
                        self.maximumBasalRatePerHour = maxBasal
                        self.maximumBolus = maxBolus
                        
                        self.delegate?.deliveryLimitSettingsTableViewControllerDidUpdateMaximumBasalRatePerHour(self)
                        self.delegate?.deliveryLimitSettingsTableViewControllerDidUpdateMaximumBolus(self)
                        
                        self.isSyncInProgress = false
                    case .failure(let error):
                        self.presentAlertController(with: error, animated: true, completion: {
                            self.isSyncInProgress = false
                        })
                    }
                }
            }*/
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


/*extension AlarmSettingsTableViewController: TextFieldTableViewCellDelegate {
    public func textFieldTableViewCellDidBeginEditing(_ cell: TextFieldTableViewCell) {
    }
    
    public func textFieldTableViewCellDidEndEditing(_ cell: TextFieldTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        let value = valueNumberFormatter.number(from: cell.textField.text ?? "")?.doubleValue
        
        switch Section(rawValue: indexPath.section)! {
        case .highGlucoseAlarm:
            //maximumBasalRatePerHour = value
           break
        case .lowGlucoseAlarm:
            //maximumBolus = value
            break
        case .sync:
            break
        }
    }
}
*/
