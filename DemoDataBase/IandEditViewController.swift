import UIKit

class IandEditViewController: UIViewController {

    @IBOutlet weak var txtName: UITextField!
        
    @IBOutlet weak var txtMobileNo: UITextField!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var btnAddUpdateData: UIButton!
    
    var isEdit = false
    
    var getId : Int = Int()
    var getName : String = String()
    var getMobileNo : String = String()
    var getEmail : String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtName.text = getName
        txtMobileNo.text = getMobileNo
        txtEmail.text = getEmail
        
        if isEdit{
            btnAddUpdateData.setTitle("Update Data", for: .normal)
        }
        else{
            btnAddUpdateData.setTitle("Insert Data", for: .normal)
        }
    }
    
    @IBAction func IandEditBtnPressed(_ sender: UIButton) {
        if isEdit{
            _ = DatabaseManager.shared.updateData(RecordId: getId, Name: txtName.text!, MobileNo: txtMobileNo.text!, Email: txtEmail.text!)
        print("Record Updated")
        }
        else{
            let FMDBInfo : DetailsModel = DetailsModel()
            FMDBInfo.Name = txtName.text!
            FMDBInfo.MobileNo = txtMobileNo.text!
            FMDBInfo.Email = txtEmail.text!
            let isInserted =
                DatabaseManager.shared.insertData(FMDBInfo)
            if isInserted{
                print("Insert Successful")
            }
            else{
                print("Insert Unsuccessful")
            }
        }
    }
}
