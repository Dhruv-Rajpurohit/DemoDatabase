
import Foundation
import FMDB

class DatabaseManager {
    static let dataBaseFileName = "FMDatabase.db"
    
    static var database: FMDatabase!
    
    static let shared : DatabaseManager = {
        let instance = DatabaseManager()
        return instance
    }()
    
    func createDatabase(){
        let bundlePath = Bundle.main.path(forResource: "FMDatabase", ofType: ".db")
        print(bundlePath ?? "","\n") //prints the correct path
        let destPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let fileManager = FileManager.default
        let fullDestPath = NSURL(fileURLWithPath: destPath).appendingPathComponent("FMDatabase.db")
        let fullDestPathString = fullDestPath!.path
        if fileManager.fileExists(atPath : fullDestPathString){
            print("File is available")
            DatabaseManager.database = FMDatabase(path: fullDestPathString)
            openDataBase()
            print(fullDestPathString)
        }
        else{
            do{
                try fileManager.copyItem(atPath: bundlePath!, toPath: fullDestPathString)
                if fileManager.fileExists(atPath : fullDestPathString){
                    DatabaseManager.database = FMDatabase(path: fullDestPathString)
                    openDataBase()
                    print("file is copied")
                }
                    else{
                        print("file is not copied")
                    }
            }
            catch{
                print("\n")
                print(error)
            }
        }
    }
    
    func openDataBase(){
        if DatabaseManager.database != nil{
            DatabaseManager.database.open()
        }else{
            DatabaseManager.shared.createDatabase()
        }
    }
    
    func closeDataBase(){
        if DatabaseManager.database != nil{
            DatabaseManager.database.close()
        }
    }
    
    func insertData(_ modelname : DetailsModel) -> Bool{
        DatabaseManager.database.open()
        let isSave = DatabaseManager.database.executeUpdate("INSERT INTO Info(Name,MobileNo,Email,photo,DOB) VALUES (?,?,?,?,?);", withArgumentsIn: [modelname.Name,modelname.MobileNo,modelname.Email,modelname.photo,modelname.DOB])
        DatabaseManager.database.close()
        return isSave
    }
    
    func getData() -> NSMutableArray {
        DatabaseManager.database.open()
        let resultset : FMResultSet!  = DatabaseManager.database.executeQuery("SELECT * FROM Info", withArgumentsIn: [0])
        let itemInfo : NSMutableArray = NSMutableArray()
        if (resultset != nil){
            while (resultset?.next())!{
                let item : DetailsModel = DetailsModel()
                item.Id = Int((resultset?.int(forColumn: "Id")) ?? 0)
                item.Name = String((resultset?.string(forColumn: "Name")) ?? "Undefined")
                item.MobileNo = String((resultset?.string(forColumn: "MobileNo")) ?? "0")
                item.Email = String((resultset?.string(forColumn: "Email")) ?? "Undefined")
                item.photo = String((resultset?.string(forColumn: "photo")) ?? "Undefined")
                item.DOB = String((resultset?.string(forColumn: "DOB")) ?? "Undefined")
                itemInfo.add(item)
            }
        }
        DatabaseManager.database.close()
        return itemInfo
    }
    
    func updateData(RecordId : Int, Name : String, MobileNo : String, Email : String, Photo : String, DOB : String) -> NSMutableArray{
        DatabaseManager.database.open()
        let resultset : FMResultSet!  = DatabaseManager.database.executeQuery("UPDATE Info SET Name = ?, MobileNo = ?, Email = ?, photo = ?, DOB = ? WHERE Id = ?", withArgumentsIn: [Name, MobileNo, Email, Photo, DOB, RecordId])
        let itemInfo : NSMutableArray = NSMutableArray()
        if (resultset != nil){
            while (resultset?.next())!{
                let item : DetailsModel = DetailsModel()
                item.Id = Int((resultset?.int(forColumn: "Id")) ?? 0)
                item.Name = String((resultset?.string(forColumn: "Name")) ?? "Undefined")
                item.MobileNo = String((resultset?.string(forColumn: "MobileNo")) ?? "0")
                item.Email = String((resultset?.string(forColumn: "Email")) ?? "Undefined")
                item.photo = String((resultset?.string(forColumn: "photo")) ?? "Undefined")
                item.DOB = String((resultset?.string(forColumn: "DOB")) ?? "Undefined")
                itemInfo.add(item)
            }
        }
        DatabaseManager.database.close()
        return itemInfo
    }
    
    func deleteData(RecordId : Int) -> NSMutableArray{
        DatabaseManager.database.open()
        let resultset : FMResultSet!  = DatabaseManager.database.executeQuery("DELETE FROM Info WHERE Id = ?", withArgumentsIn: [RecordId])
        let itemInfo : NSMutableArray = NSMutableArray()
        if (resultset != nil){
            while (resultset?.next())!{
                let item : DetailsModel = DetailsModel()
                item.Id = Int((resultset?.int(forColumn: "Id")) ?? 0)
                item.Name = String((resultset?.string(forColumn: "Name")) ?? "Undefined")
                item.MobileNo = String((resultset?.string(forColumn: "MobileNo")) ?? "0")
                item.Email = String((resultset?.string(forColumn: "Email")) ?? "Undefined")
                item.photo = String((resultset?.string(forColumn: "photo")) ?? "Undefined")
                item.Email = String((resultset?.string(forColumn: "DOB")) ?? "Undefined")
                itemInfo.add(item)
            }
        }
        DatabaseManager.database.close()
        return itemInfo
    }
}
