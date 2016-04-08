import UIKit

class ConversionViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var celiusLabel: UILabel!
    @IBOutlet var textField: UITextField!
    var fahrenheitValue: Double? {
        didSet {
            updateCeliusLabel()
        }
    }
    var celsiusValue: Double? {
        if let value = fahrenheitValue {
            return (value - 32) * (5/9)
        }
        else {
            return nil
        }
    }
    let numberFormatter: NSNumberFormatter = {
        let nf = NSNumberFormatter()
        nf.numberStyle = .DecimalStyle
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        return nf
    }()
    
    @IBAction func fahrenheitFieldEditingChanged(textField: UITextField) {
        if let text = textField.text, value = Double(text) {
            fahrenheitValue = value
        }
        else {
            fahrenheitValue = nil
        }
    }
    
    @IBAction func dimissKeyboard(sender: AnyObject) {
        textField.resignFirstResponder()
    }
    
    func updateCeliusLabel() {
        if let value = celsiusValue {
            celiusLabel.text = numberFormatter.stringFromNumber(value)
        }
        else {
            celiusLabel.text = "???"
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let existingTextHasDecimalSeparator = textField.text?.rangeOfString(".")
        let replacementTextHasDecimalSeparator = string.rangeOfString(".")
        let replacementTextHasLetters = string.rangeOfCharacterFromSet(NSCharacterSet.letterCharacterSet())
        return (existingTextHasDecimalSeparator == nil || replacementTextHasDecimalSeparator == nil) && replacementTextHasLetters == nil;
    }
    
}