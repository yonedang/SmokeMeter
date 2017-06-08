//
//  ViewController.swift
//  SmokeMeter
//
//  Created by 米田 央 on 2017/06/06.
//  Copyright © 2017年 Swift-Yoneda. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
  
  // タバコの銘柄リスト
  let settingArray : [String] = ["アメリカンスピリット","メビウス","マルヴォロ"]
  
  // 設定値を覚えるキー
  let settingKey = "meigara_value"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    meigaraSettingPicker.delegate = self
    meigaraSettingPicker.dataSource = self
    
    let settings = UserDefaults.standard
    
    settings.register(defaults: [settingKey:"アメリカンスピリット"])
    let settingValue = settings.string(forKey: settingKey)
    
    for row in 0..<settingArray.count{
      if settingArray[row]==settingValue{
        meigaraSettingPicker.selectRow(row, inComponent: 0, animated: true)
      }
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBOutlet weak var smokeCount: UITextField!

  @IBOutlet weak var meigaraSettingPicker: UIPickerView!
  
  @IBAction func pushSettingButton(_ sender: Any) {
    performSegue(withIdentifier: "goSmoking", sender: nil)
  }
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return settingArray.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return settingArray[row]
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    let settings = UserDefaults.standard
    settings.setValue(settingArray, forKey: settingKey)
    settings.synchronize()
  }
}

