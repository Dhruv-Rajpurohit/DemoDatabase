
import UIKit

class InsertDataViewController: UIViewController {

    @IBOutlet weak var textName: UITextField!
    
    @IBOutlet weak var textMobile: UITextField!
    
    @IBOutlet weak var textEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func BtnForSavingData(_ sender: Any) {
        let FMDBInfo : DetailsModel = DetailsModel()
        FMDBInfo.Name = textName.text!
        FMDBInfo.MobileNo = textMobile.text!
        FMDBInfo.Email = textEmail.text!
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
