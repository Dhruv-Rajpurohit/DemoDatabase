
import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tblTableview: UITableView!
    
    var getAllData = NSMutableArray()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getAllData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoTableViewCell") as! InfoTableViewCell
        cell.btnDeleteData.tag = indexPath.row
        cell.btnEditData.tag = indexPath.row
        var l = DetailsModel()
        l = getAllData.object(at: indexPath.row) as! DetailsModel
        cell.lblEmail.text! = l.Email
        cell.lblMobileNo.text! = l.MobileNo
        cell.lblName.text! = l.Name
        let url = documentsDir().appending("/\(l.photo)")
        cell.ImgInTableViewCell.image = UIImage(contentsOfFile: url)
        cell.DOBOnCell.text! = l.DOB
        return cell
    }
    
    func documentsDir() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [String]
            return paths[0]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getAllData = DatabaseManager.shared.getData()
        tblTableview.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        300
    }
        
    @IBAction func btnInsertTapped(_ sender: Any) {
        let MainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let DV = MainStoryboard.instantiateViewController(withIdentifier: "IandEditViewController") as! IandEditViewController
        if getAllData.count > 0{
                let data = getAllData.lastObject as! DetailsModel
                DV.getId = data.Id + 1
            }else{
                DV.getId = 1
        }
        self.navigationController?.pushViewController(DV, animated: true)
        DV.isEdit = false
        DV.title = "Insert Data!"
    }
    
    @IBAction func btnEditTapped(_ sender: UIButton) {
        _ = sender.tag
        var l = DetailsModel()
        l = getAllData.object(at: sender.tag) as! DetailsModel
        let MainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let DV = MainStoryboard.instantiateViewController(withIdentifier: "IandEditViewController") as! IandEditViewController
        DV.title = "Update Data!"
        DV.isEdit = true
        DV.getId = l.Id
        DV.getName = l.Name
        DV.getMobileNo = l.MobileNo
        DV.getEmail = l.Email
        let url = documentsDir().appending("/\(l.photo)")
        DV.imgName = l.photo
        DV.getPhoto = url
        DV.getDOB = l.DOB
        self.navigationController?.pushViewController(DV, animated: true)
    }
    
    @IBAction func btnDeleteTapped(_ sender: UIButton) {
        
        let alertcontrol = UIAlertController(title: "Record Deleted", message: "Your Record has been deleted!", preferredStyle: .alert)
        let alertaction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertcontrol.addAction(alertaction)
        present(alertcontrol, animated: true, completion: nil)
        
        _ = sender.tag
        var l = DetailsModel()
        l = getAllData.object(at: sender.tag) as! DetailsModel
        _ = DatabaseManager.shared.deleteData(RecordId: l.Id)
        getAllData = DatabaseManager.shared.getData()
        tblTableview.reloadData()
    }
}
