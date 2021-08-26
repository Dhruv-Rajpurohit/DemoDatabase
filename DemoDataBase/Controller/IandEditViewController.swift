import UIKit
import Photos

class IandEditViewController: UIViewController,UITextFieldDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
    
    @IBOutlet weak var txtName: UITextField!
        
    @IBOutlet weak var txtMobileNo: UITextField!{ didSet {
        let toolbar = UIToolbar(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 0, height: 44)))
        toolbar.items = [
          UIBarButtonItem(barButtonSystemItem: .done, target: self.txtMobileNo,
            action: #selector(resignFirstResponder))
        ]
        txtMobileNo.inputAccessoryView = toolbar
      }}
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var btnAddUpdateData: UIButton!
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBAction func btnToAddImage(_ sender: Any) {
        self.imagePickerController.sourceType = .photoLibrary
        self.present(self.imagePickerController, animated: true, completion: nil)
    }
    
    @IBOutlet weak var showAge: UILabel!
    
    @IBOutlet weak var ChooseDOB: UITextField!
    
    
    let datePicker = UIDatePicker()
    var imagePickerController = UIImagePickerController()
    var isEdit = false
    var getId : Int = Int()
    var getName : String = String()
    var getMobileNo : String = String()
    var getEmail : String = String()
    var getPhoto : String = String()
    var imgName = ""
    var getDOB : String = String()
    var age : Int = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
        txtName.text = getName
        txtMobileNo.text = getMobileNo
        
        txtEmail.text = getEmail
        checkPermissions()
        createDatePicker()
        
        if isEdit{
            btnAddUpdateData.setTitle("Update Data", for: .normal)
            imgView.image = UIImage(contentsOfFile: getPhoto)
            ChooseDOB.text = getDOB
        }
        else{
            btnAddUpdateData.setTitle("Insert Data", for: .normal)
            showAge.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        var maxLength : Int = Int()
                
                if textField == txtName{
                    maxLength = 30
                } else if textField == txtEmail{
                    maxLength = 30
                } else if textField == txtMobileNo{
                    maxLength = 10
                }
                
                let currentString: NSString = textField.text! as NSString
                
                let newString: NSString =  currentString.replacingCharacters(in: range, with: string) as NSString
                return newString.length <= maxLength
    }
    
    func createDatePicker(){
        ChooseDOB.textAlignment = .left
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(cancelPressed))
        toolbar.setItems([cancelBtn,flexibleSpace,doneBtn], animated: true)
        ChooseDOB.inputAccessoryView = toolbar
        ChooseDOB.inputView = datePicker
        
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        
        let calendar = Calendar(identifier: .gregorian)
        let currentDate = Date()
        var components = DateComponents()
        components.calendar = calendar
        components.year = -7
        components.month = 12
        let maxDate = calendar.date(byAdding: components, to: currentDate)!
        components.year = -150
        let minDate = calendar.date(byAdding: components, to: currentDate)!
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        let date = dateFormatter.date(from: getDOB)
        datePicker.date = date ?? Date()
        
        if datePicker.date != Date(){
            let ageComponents = calendar.dateComponents([.year], from: datePicker.date, to: Date())
            age = ageComponents.year!
            showAge.text = String(age)
        }
    }

    @objc func cancelPressed(){
        self.view.endEditing(true)
    }

    @objc func donePressed(){
        let formatter = DateFormatter()
        let calendar = Calendar(identifier: .gregorian)
        let ageComponents = calendar.dateComponents([.year], from: datePicker.date, to: Date())
        age = ageComponents.year!
        showAge.text = String(age)
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        ChooseDOB.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @IBAction func IandEditBtnPressed(_ sender: UIButton) {
        if isEdit{
            
            let alertcontrol = UIAlertController(title: "Record Updated", message: "Your Record has been updated!", preferredStyle: .alert)
            let alertaction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertcontrol.addAction(alertaction)
            present(alertcontrol, animated: true, completion: nil)
            
            _ = DatabaseManager.shared.updateData(RecordId: getId, Name: txtName.text!, MobileNo: txtMobileNo.text!, Email: txtEmail.text!, Photo: imgName, DOB: ChooseDOB.text!)
            
            print("Record Updated")
        }
        else{
            
            let FMDBInfo : DetailsModel = DetailsModel()
            if txtName.text?.isEmpty ?? true{
                let fieldscontrol = UIAlertController(title: "Incomplete Field!", message: "Please fill up name field", preferredStyle: .alert)
                let alertforincompleteaction = UIAlertAction(title: "Retry", style: .destructive, handler: nil)
                fieldscontrol.addAction(alertforincompleteaction)
                present(fieldscontrol, animated: true, completion: nil)
                return
            }else{
                FMDBInfo.Name = txtName.text!
            }
            if txtMobileNo.text?.isEmpty ?? true{
                let fieldscontrol = UIAlertController(title: "Incomplete Field!", message: "Please fill up phone field", preferredStyle: .alert)
                let alertforincompleteaction = UIAlertAction(title: "Retry", style: .destructive, handler: nil)
                fieldscontrol.addAction(alertforincompleteaction)
                present(fieldscontrol, animated: true, completion: nil)
                return
            }else{
                FMDBInfo.MobileNo = txtMobileNo.text!
            }
            if txtEmail.text?.isEmpty ?? true{
                let fieldscontrol = UIAlertController(title: "Incomplete Field!", message: "Please fill up email field", preferredStyle: .alert)
                let alertforincompleteaction = UIAlertAction(title: "Retry", style: .destructive, handler: nil)
                fieldscontrol.addAction(alertforincompleteaction)
                present(fieldscontrol, animated: true, completion: nil)
                return
            }else{
                FMDBInfo.Email = txtEmail.text!
            }
            if imgName.isEmpty {
                let fieldscontrol = UIAlertController(title: "Incomplete Field!", message: "Please select a Image", preferredStyle: .alert)
                let alertforincompleteaction = UIAlertAction(title: "Retry", style: .destructive, handler: nil)
                fieldscontrol.addAction(alertforincompleteaction)
                present(fieldscontrol, animated: true, completion: nil)
                return
            }else{
                FMDBInfo.photo = imgName
            }
            if ChooseDOB.text?.isEmpty ?? true{
                let fieldscontrol = UIAlertController(title: "Incomplete Field!", message: "Please select a Date", preferredStyle: .alert)
                let alertforincompleteaction = UIAlertAction(title: "Retry", style: .destructive, handler: nil)
                fieldscontrol.addAction(alertforincompleteaction)
                present(fieldscontrol, animated: true, completion: nil)
                return
            }else{
                FMDBInfo.DOB = ChooseDOB.text!
            }
            
            let alertcontrol = UIAlertController(title: "Record Inserted", message: "Your Record has been inserted!", preferredStyle: .alert)
            let alertaction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertcontrol.addAction(alertaction)
            present(alertcontrol, animated: true, completion: nil)
            
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

    
    func checkPermissions() {
            if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized {
                PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in ()
                })
            }
            if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            } else {
                PHPhotoLibrary
                    .requestAuthorization(requestAuthorizationHandler)
            }
        }
        
    func requestAuthorizationHandler(status: PHAuthorizationStatus) {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            print("Access granted to use Photo Library")
        } else {
            print("We don't have access to your Photos.")
        }
    }
        
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if picker.sourceType == .photoLibrary {
            
            imgView?.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            imgName = "Img-\(getId).png"
            
            let document = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let imgUrl = document.appendingPathComponent(imgName, isDirectory: true)
            print(imgUrl.path)
            if FileManager.default.fileExists(atPath: imgUrl.path){
                do{
                    try FileManager.default.removeItem(at: imgUrl)
                    try imgView.image?.pngData()?.write(to: imgUrl)
                    print("Image Added Successfully!")
                }
                catch{
                    print("Image not Added!")
                }
            }else{
                do{
                    try imgView.image?.pngData()?.write(to: imgUrl)
                    print("Image Added Successfully!")
                }
                catch{
                    print("Image not Added!")
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
}
