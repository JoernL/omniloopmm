import UIKit

public class ViewTextController: UITableViewController, UITextfieldDelegate {
    
    var additionalOffset = 0
    
    var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    @IBOutlet weak var glucoseOffsetTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        glucoseOffsetTextField.delegate = self
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let glucoseOffset = UserDefaults.standard.glucoseOffset
        
        glucoseOffsetTextField.text = numberFormatter.string(from: NSNumber(value: glucoseOffset))
    
    }
    
    
    @IBAction func tapGestureRecognized(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true) // resign keyoard
    }
    
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case glucoseOffsetTextField:
            handleNumericTextFieldInput(textField)
        }
         return true
        
    }
            
            
    func handleNumericTextFieldInput(_ textField: UITextField) {
        guard let aNumber = numberFormatter.number(from: textField.text!) else {
            displayAlertForTextField(textField)
            return
        }
        
        
        switch textField {
        case glucoseOffsetTextField:
            UserDefaults.standard.glucoseOffset = Double(truncating: aNumber)
        }
        
        
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "updateBloodSugarTableViewController"), object: self)
        
    }
    
            
    
}
