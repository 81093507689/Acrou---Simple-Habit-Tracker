//
//  ADDNewHabit.swift
//  Acror
//
//  Created by developer on 23/03/19.
//  Copyright © 2019 Acror. All rights reserved.
//

import UIKit
import IQDropDownTextField

class ADDNewHabit: UIViewController,UITextFieldDelegate,IQDropDownTextFieldDelegate {

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtDetail: UITextField!
    @IBOutlet weak var viwTime: UIView!
    @IBOutlet weak var txtType: IQDropDownTextField!
    @IBOutlet weak var txtTime: IQDropDownTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

            self.title = "Add New Habit"
        txtType.isOptionalDropDown = true
        txtType.itemList = ["Daily", "Weekly", "Few time a week"]
        
        txtTime.isOptionalDropDown = false
        txtTime.itemList = ["1", "2", "3","4", "5", "6", "7"]
        viwTime.isHidden = true
    }
    
    
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // this method get called when you tap "Go"
        textField.resignFirstResponder()
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let nsString = NSString(string: textField.text!)
        let newText = nsString.replacingCharacters(in: range, with: string)
        
        
        if(textField == txtName || textField == txtDetail)
        {
            let aSet = NSCharacterSet(charactersIn:"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ. ").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            if( string == numberFiltered)
            {
                return true
            }else
            {
                return false
            }
        }
        
        return false
    }
    func textField(_ textField: IQDropDownTextField, didSelectItem item: String?) {
        if(textField == txtType)
        {
            if(item == "Few time a week")
            {
                self.viwTime.isHidden = false
            }else
            {
                self.viwTime.isHidden = true
            }
        }
    }
    
    
    @IBAction func click_submit(_ sender: UIButton)
    {
        let getText = self.txtName.text as? String ?? ""
        let getFName = getText.trimmingCharacters(in: .whitespaces)
        
        let getDetail = self.txtDetail.text as? String ?? ""
        let getFDetail = getDetail.trimmingCharacters(in: .whitespaces)
        
        if(getFName.count > 0)
        {
            let getType:String = self.txtType.selectedItem ?? ""
            
            if(getType.count > 0)
            {
                if(getType == "Few time a week")
                {
                    let getTime:String = self.txtTime.selectedItem ?? ""
                    if(getTime.count > 0)
                    {
                         FMDBQueueManager.shareFMDBQueueManager.insertNote(getTitle: getFName, getDetail: getFDetail, getType: getType, howTime: getTime)
                        self.navigationController?.popViewController(animated: true)
                    }else
                    {
                        let alert = UIAlertController(title: "OOPS!", message: "Please select time", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }else
                {
                    FMDBQueueManager.shareFMDBQueueManager.insertNote(getTitle: getFName, getDetail: getFDetail, getType: getType, howTime: "0")
                    self.navigationController?.popViewController(animated: true)
                }
                
            }else
            {
                let alert = UIAlertController(title: "OOPS!", message: "Please select type", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
           
            
        }else
        {
            let alert = UIAlertController(title: "OOPS!", message: "Please enter habit name", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }

}
