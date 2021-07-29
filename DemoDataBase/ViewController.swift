
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
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getAllData = DatabaseManager.shared.getData()
        tblTableview.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }

    @IBAction func btnInsertTapped(_ sender: Any) {
        let MainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let DV = MainStoryboard.instantiateViewController(withIdentifier: "InsertDataViewController") as! InsertDataViewController
        self.navigationController?.pushViewController(DV, animated: true)
    }
    
    @IBAction func btnEditTapped(_ sender: UIButton) {
        _ = sender.tag
        var l = DetailsModel()
        l = getAllData.object(at: sender.tag) as! DetailsModel
        let MainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let DV = MainStoryboard.instantiateViewController(withIdentifier: "EditDataViewController") as! EditDataViewController
        DV.getId = l.Id
        DV.getName = l.Name
        DV.getMobileNo = l.MobileNo
        DV.getEmail = l.Email
        self.navigationController?.pushViewController(DV, animated: true)
    }
    
    @IBAction func btnDeleteTapped(_ sender: UIButton) {
        _ = sender.tag
        var l = DetailsModel()
        l = getAllData.object(at: sender.tag) as! DetailsModel
        _ = DatabaseManager.shared.deleteData(RecordId: l.Id)
        getAllData = DatabaseManager.shared.getData()
        tblTableview.reloadData()
    }
    
}

