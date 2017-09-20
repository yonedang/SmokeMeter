//
//  TimerViewController.swift
//  SmokeMeter
//
//  Created by 米田 央 on 2017/06/07.
//  Copyright © 2017年 Swift-Yoneda. All rights reserved.
//

import UIKit
import AVFoundation

class TimerViewController: UIViewController {
  
  var pushCal:Date = Date.init()
//  var nonSmokingTime:Int = 0
//  var nonSmokingHour:Int = 0
//  var nonSmokingMinute:Int = 0
//  var nonSmokingSecond:Int = 0
  
//  var timer : Timer?
  
  var boxCount:Int = 0
  var moneyCount:Int = 0
  
  let honsu = 20
  let price : Int = 480
  
  // 効果音用
  let startSoundPath = Bundle.main.bundleURL.appendingPathComponent("crrect_answer3.mp3")
  let endSoundPath = Bundle.main.bundleURL.appendingPathComponent("blip04.mp3")
  var startSoundPlayer = AVAudioPlayer()
  var endSoundPlayer = AVAudioPlayer()
  
  

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  override func viewWillAppear(_ animated: Bool) {
    // 現在時刻取得
    let now = Date()
    
    // スタイル制御
    if nonSmokingFlg{
      setStyleStart()
      timeLabelUpdate()
      
      timer?.invalidate()
      timer = Timer.scheduledTimer(timeInterval: 1.0,
                                   target: self,
                                   selector: #selector(self.timerInterrupt(_:)),
                                   userInfo: nil,
                                   repeats: true)

    }else{
      setStyleStop()
    }
    
    
    // log
    print("銘柄:" + settingMeigara)
    print("cost:")
    print(settingMeigaraCost)
    print("本数:")
    print(settingHonsu)
    print(nonSmokingTime)
    print(nonSmokingHour)
    print(nonSmokingMinute)
    print(nonSmokingSecond)
  }
  

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
  @IBOutlet weak var startButton: UIButton!

  @IBAction func pushStartButton(_ sender: Any) {
    pushCal = Date()
    
    if nonSmokingFlg != true{
      nonSmokingFlg = true
      userDefaults.set(nonSmokingFlg, forKey: "nonSmokingFlgKey")
      
      // スタートの音鳴らす
      soundPlayer(&startSoundPlayer, path: startSoundPath, count: 0)
      
      
      // ボタン、ラベルの表示変更
      setStyleStart()
//      startButton.setTitle("STOP", for: .normal)
//      startButton.backgroundColor = UIColor.blue
//      
//      smokingLabel.text = "禁煙中"
//      smokingLabel.backgroundColor = UIColor.blue
      
      
      // dateをフォーマット
      let formatter = DateFormatter()
      let jaLocale = Locale(identifier: "ja_JP")
      formatter.locale = jaLocale
      formatter.dateStyle = .long
      formatter.timeStyle = .long
      
      // 出力
      //    timeLabel.text = formatter.string(from: pushCal)
      
      nonSmokingHour = 0
      nonSmokingMinute = 0
      nonSmokingSecond = 0
      
      
      timeLabelUpdate()
      //    timeLabel.text = String(nonSmokingHour) + ":"
      //                      + String(nonSmokingMinute) + ":"
      //                      + String(nonSmokingSecond)
      
//      if let nowTimer = timer{
//        if nowTimer.isValid == true{
//          return
//        }
//      }
      
      timer = Timer.scheduledTimer(timeInterval: 1.0,
                                   target: self,
                                   selector: #selector(self.timerInterrupt(_:)),
                                   userInfo: nil,
                                   repeats: true)
    } else{
      nonSmokingFlg = false
      userDefaults.set(nonSmokingFlg, forKey: "nonSmokingFlgKey")
      
      // 終了の音鳴らす
      soundPlayer(&endSoundPlayer, path: endSoundPath, count: 0)
      
      // ボタン、ラベルの表示変更
      setStyleStop()
//      startButton.setTitle("START", for: .normal)
//      startButton.backgroundColor = UIColor.red
//      
//      smokingLabel.text = "喫煙中"
//      smokingLabel.backgroundColor = UIColor.red
      
      // タイマーとめる
      timer?.invalidate()
//      if let nowTimer = timer{
//        if nowTimer.isValid == true{
//          nowTimer.invalidate()
//        }
//      }
    }
  }
  
  func setStyleStart(){
    // ボタン、ラベルの表示変更
    startButton.setTitle("STOP", for: .normal)
    startButton.backgroundColor = UIColor.blue
    
    smokingLabel.text = "禁煙中"
    smokingLabel.backgroundColor = UIColor.blue

  }
  
  func setStyleStop(){
    startButton.setTitle("START", for: .normal)
    startButton.backgroundColor = UIColor.red
    
    smokingLabel.text = "喫煙中"
    smokingLabel.backgroundColor = UIColor.red
}
  
  func timerInterrupt(_ timer:Timer){
    nonSmokingSecond += 1
    calcTime()
    
    // 時間をuserDefaultsに保存
    saveTime()
    
    timeLabelUpdate()
  }
  
  // 時間ラベル更新
  func timeLabelUpdate(){
    timeLabel.text = String(nonSmokingHour) + ":"
      + String(nonSmokingMinute) + ":"
      + String(nonSmokingSecond)
  }
  
  // 経過時間計算
  func calcTime(){
    if nonSmokingSecond == 60{
      nonSmokingMinute += 1
      nonSmokingSecond -= 60
    }
    if nonSmokingMinute == 60{
      nonSmokingHour += 1
      nonSmokingMinute -= 60
    }
    nonSmokingTime = nonSmokingHour*60*60 + nonSmokingMinute*60 + nonSmokingSecond
  }
  
  // 経過時間をuserDefaultsに保存
  func saveTime(){
    userDefaults.set(nonSmokingTime, forKey:"nonSmokingTimeKey")
    userDefaults.set(nonSmokingHour, forKey:"nonSmokingHourKey")
    userDefaults.set(nonSmokingMinute, forKey:"nonSmokingMinuteKey")
    userDefaults.set(nonSmokingSecond, forKey:"nonSmokingSecondKey")
    userDefaults.synchronize()
  }
  
  // 禁煙本数
  func countUpBox(){
    // TODO
  }
  
  // 禁煙金額
  func countUpMoney(){
    //TODO
  }
  
  
  // 効果音再生メソッド
  fileprivate func soundPlayer(_ player:inout AVAudioPlayer, path:URL, count:Int){
    do{
      player = try AVAudioPlayer(contentsOf:path, fileTypeHint:nil)
      player.numberOfLoops = count
      player.play()
    }catch{
      print("効果音再生でエラー発生")
    }
  }
  
  // 設定ボタン押下メソッド
  @IBAction func settingButtonAction(_ sender: Any) {
    performSegue(withIdentifier: "goSetting", sender: nil)
    
  }
  @IBOutlet weak var timeLabel: UILabel!
  
  @IBOutlet weak var boxLabel: UILabel!
  
  @IBOutlet weak var moneyLabel: UILabel!
  
  @IBOutlet weak var smokingLabel: UILabel!
  
  
}
