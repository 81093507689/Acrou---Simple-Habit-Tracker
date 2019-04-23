//
//  ViewController.swift

//
//  Created by developer on 23/03/19.
//  Copyright © 2019 EasyChecklist. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    
    
    var aryData: NSMutableArray = NSMutableArray()
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var viwNorecord: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbl.tableFooterView = UIView()
        tbl.estimatedRowHeight = 44.0
        self.tbl.rowHeight = UITableView.automaticDimension
        
        self.title = "Acrou"
        navigationBar()
        
        viwNorecord.isHidden = true
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        aryData = FMDBQueueManager.shareFMDBQueueManager.GetAllCategory()
        if(aryData.count > 0)
        {
            viwNorecord.isHidden = true
        }else
        {
            viwNorecord.isHidden = false
        }
        tbl.reloadData()
    }
    
    
    func navigationBar()
    {
        let testUIBarButtonItem = UIBarButtonItem(image: UIImage(named: "add"), style: .plain, target: self, action: #selector(self.click_Setting))
        
        self.navigationItem.rightBarButtonItem  = testUIBarButtonItem
        
        
    }
    
    @IBAction func click_Setting(sender: UIButton)
    {
        let mainStory : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let viewController:ADDNewHabit = mainStory.instantiateViewController(withIdentifier: "ADDNewHabit") as! ADDNewHabit
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    
    
  
}




extension ViewController:UITableViewDataSource,UITableViewDelegate
{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return self.aryData.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        
        let getObje = aryData.object(at: indexPath.row) as! NSDictionary
        
        cell.lblTitle.text = getObje.value(forKey: "text") as? String ?? ""
        cell.lblDetail.text = getObje.value(forKey: "detail") as? String ?? ""
        
        let total = getObje.value(forKey: "total") as? String ?? ""
    
        cell.lblTotalCount.text = "Total Completed \(total)"
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let getObje = aryData.object(at: indexPath.row) as! NSDictionary
        let mainStory : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let viewController:HorizontalCalendarController = mainStory.instantiateViewController(withIdentifier: "HorizontalCalendarController") as! HorizontalCalendarController
        viewController.getTitle = getObje.value(forKey: "text") as? String ?? ""
        let getCategoryID:String = getObje.value(forKey: "id") as? String ?? ""
        print(getCategoryID)
        viewController.getCategoryId = getCategoryID
        viewController.getDetail = getObje.value(forKey: "detail") as? String ?? ""
        self.navigationController?.pushViewController(viewController, animated: true)
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
