
import UIKit

protocol buttonDelegate {
    func EditButton(sender : InfoTableViewCell)
    func DeleteButton(sender : InfoTableViewCell)
}

class InfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    
    
    @IBOutlet weak var lblMobileNo: UILabel!
    
    
    @IBOutlet weak var lblEmail: UILabel!
    
    
    var editData : buttonDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func btEditTapped(_ sender: Any) {
        self.editData?.EditButton(sender: self)
    }
    
    
    @IBAction func btnDeleteTapped(_ sender: Any) {
        self.editData?.DeleteButton(sender: self)
    }
    
}
