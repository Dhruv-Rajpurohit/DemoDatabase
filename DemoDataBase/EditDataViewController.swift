
import UIKit

class EditDataViewController: UIViewController {

    
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var txtMobileNo: UITextField!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    var getId : Int = Int()
    var getName : String = String()
    var getMobileNo : String = String()
    var getEmail : String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtName.text! = getName
        txtMobileNo.text! = getMobileNo
        txtEmail.text! = getEmail
    }
    

    @IBAction func btnUpdateTapped(_ sender: Any) {
        _ = DatabaseManager.shared.updateData(RecordId: getId, Name: txtName.text!, MobileNo: txtMobileNo.text!, Email: txtEmail.text!)
    print("record updated")
    }

}
