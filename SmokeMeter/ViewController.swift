//
//  ViewController.swift
//  SmokeMeter
//
//  Created by 米田 央 on 2017/06/06.
//  Copyright © 2017年 Swift-Yoneda. All rights reserved.
//

import UIKit

// グローバル変数定義エリア-start
// 銘柄設定済かどうか　初期値はfalse
var settingFlg = false;

// タバコの銘柄リスト
let settingArray : [String] = ["アメリカンスピリット","メビウス","マルヴォロ"]


// 設定されている銘柄
var settingMeigara = "アメリカンスピリット"

// 設定されている銘柄の値段
var settingMeigaraCost = 480

// 設定されている本数
var settingHonsu = 20

// 銘柄設定状況をUserDefaulstsで保存
let userDefaults = UserDefaults.standard

// 禁煙フラグ
var nonSmokingFlg = false

// 禁煙時間
var nonSmokingTime:Int = 0
var nonSmokingHour:Int = 0
var nonSmokingMinute:Int = 0
var nonSmokingSecond:Int = 0

var timer : Timer?


// グローバル変数定義エリア-end


class ViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
  
  // 設定値を覚えるキー
  let settingKey = "meigara_value"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    meigaraSettingPicker.delegate = self
    meigaraSettingPicker.dataSource = self
    
    userDefaults.set(settingMeigara, forKey:"settingMeigaraKey")
    userDefaults.set(settingMeigaraCost, forKey:"settingMeigaraCostKey")
    userDefaults.set(settingHonsu, forKey:"settingHonsuKey")
    
    
    let settingValue = userDefaults.string(forKey: "settingMeigaraKey")
    
    
    for row in 0..<settingArray.count{
      if settingArray[row]==settingValue{
        meigaraSettingPicker.selectRow(row, inComponent: 0, animated: true)
      }
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    smokeCount.text = String(userDefaults.integer(forKey: "settingHonsuKey"))
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBOutlet weak var smokeCount: UITextField!

  @IBOutlet weak var meigaraSettingPicker: UIPickerView!
  
  @IBAction func pushSettingButton(_ sender: Any) {
    // 銘柄設定フラグをset, userDefaultsに対してもset
    settingFlg = true
    userDefaults.set(settingFlg, forKey: "settingFlgKey")
    
    // 入力されている本数をset, userDefaultsに対してもset
    settingHonsu = Int(smokeCount.text!)!
    userDefaults.set(settingHonsu, forKey:"settingHonsuKey")
    
    performSegue(withIdentifier: "goSmoking", sender: nil)
  }
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return settingArray.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    // 選択した銘柄をset, userDefaultsにもset
    let str = settingArray[row]
    
    settingMeigara = str
    userDefaults.set(str, forKey:"settingMeigaraKey")
    
    // strの値に応じて、costをset
    var cost:Int = 0
    if str == "アメリカンスピリット"{
      cost = 480
    }else if str == "メビウス"{
      cost = 410
    }else if str == "マルヴォロ"{
      cost = 440
    }
    
    settingMeigaraCost = cost
    userDefaults.set(cost, forKey:"settingMeigaraCostKey")
    
    return settingArray[row]
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
    userDefaults.set(settingArray,forKey: "settingArrayKey")
    userDefaults.synchronize()
  }
}

