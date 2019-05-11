//
//  AdvanceSearch.swift
//  Deli News
//
//  Created by Mohammad Yunus on 10/05/19.
//  Copyright © 2019 taptap. All rights reserved.
//

import UIKit

class AdvanceSearch: UIViewController {
    
    var langDict = [["Arabic": "ar"], ["German": "de"], ["English": "en"], ["Spanish": "es"], ["French": "fr"], ["Hebrew": "he"], ["Italian": "it"], ["Dutch": "nl"], ["Norwegian": "no"], ["Portuguese": "pt"], ["Russian": "ru"], ["Northern Sami": "se"], ["Chinese": "zh"]]
    
    var sortArr = ["relevancy", "popularity", "publishedAt"]
    
    var lang: String?
    
    var sortBy: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lang = langDict[2]["English"]
        sortBy = sortArr[1]
    }
    
    @IBOutlet weak var segCont: UISegmentedControl!{
        didSet{
            segCont.selectedSegmentIndex = 0
            myPickerView.reloadAllComponents()
        }
    }
    
    @IBAction func segConAction(_ sender: UISegmentedControl) {
        myPickerView.reloadAllComponents()
    }
    @IBOutlet weak var myPickerView: UIPickerView!{
        didSet{
            myPickerView.delegate = self
            myPickerView.dataSource = self
        }
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var saveOutlet: UIButton!{
        didSet{
            saveOutlet.isHidden = true
        }
    }
    
    @IBAction func save(_ sender: UIButton) {
        UserDefaults.standard.set(self.lang, forKey: Constants.lang)
        UserDefaults.standard.set(self.sortBy, forKey: Constants.sortBy)
        presentingViewController?.dismiss(animated: true)
    }

}
extension AdvanceSearch: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch segCont.selectedSegmentIndex {
        case 0:
            return langDict.count
        case 1:
            return sortArr.count
        default:
            return 3
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch segCont.selectedSegmentIndex {
        case 0:
            return langDict[row].first?.key
        case 1:
            return sortArr[row]
        default:
            return "error"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        saveOutlet.isHidden = false
        switch segCont.selectedSegmentIndex {
        case 0:
            lang = langDict[row].first?.value
        case 1:
            sortBy = sortArr[row]
        default:
            print("error")
        }
    }
    
    
}
