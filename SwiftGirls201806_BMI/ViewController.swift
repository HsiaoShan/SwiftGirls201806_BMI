//
//  ViewController.swift
//  SwiftGirls201806_BMI
//
//  Created by HsiaoShan on 2018/5/24.
//  Copyright © 2018年 SwiftGirls. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var genderSegment: UISegmentedControl!
    @IBOutlet weak var ageText: UITextField!
    @IBOutlet weak var heightText: UITextField!
    @IBOutlet weak var weightText: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    //點“計算”按鈕，開始計算BMI，顯示計算結果
    @IBAction func calculate(_ sender: Any) {
        //檢查欄位是否有輸入,並且是數字
        //當TextField.text 是 “” 空字串, 在後面轉成數字的時候, 因為是空字串所以轉換數字失敗
        //因此在TextField沒有輸入的情況下, 程式仍然進入了guard裡面
        guard let ageText = ageText.text, let age = Int(ageText)  else {
            resultLabel.text = "請輸入年齡"
            return
        }
        guard let heightText = heightText.text, let height = Float(heightText)  else {
            resultLabel.text = "請輸入身高"
            return
        }
        guard let weightText = weightText.text, let weight = Float(weightText)  else {
            resultLabel.text = "請輸入體重"
            return
        }
        //gender: 0=女, 1=男
        let gender = genderSegment.selectedSegmentIndex
        let bmi = getBMI(height: height / 100, weight: weight)
        let result = checkBMIResult(age: age, gender: gender, bmi: bmi)
        resultLabel.text = "\(result)"
        print("\(result)...")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboard()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //計算BMI值, 四捨五入取小數點後一位
    //BMI＝體重(公斤)÷身高(公尺)÷身高(公尺)
    func getBMI(height: Float, weight: Float) -> Float {
        let bmi = weight / pow(height, 2)
        return round(bmi * 10) / 10
    }
    
    //BMI值判斷健康狀態
    //gender性別 0:女, 1:男
    func checkBMIResult(age: Int, gender: Int, bmi: Float) -> String {
        guard age < 18 else {
            //18歲（含）以上的成人BMI範圍值 體重是否正常
            //https://obesity.hpa.gov.tw/TC/weight.aspx
            switch bmi {
            case ..<18.5:
                return "BMI:\(bmi)\n 「體重過輕」，需要多運動，均衡飲食，以增加體能，維持健康！"
            case 18.5..<24:
                return "BMI:\(bmi)\n 恭喜！「健康體重」，要繼續保持！"
            case 24..<27:
                return "BMI:\(bmi)\n 「體重過重」了，要小心囉，趕快力行「健康體重管理」！"
            case 27...:
                return "BMI:\(bmi)\n 啊～「肥胖」，需要立刻力行「健康體重管理」囉！"
            default:
                return "BMI:\(bmi)"
            }
        }
        
        //未滿18歲BMI範圍值 體重是否正常
        //https://obesity.hpa.gov.tw/TC/BMIproposal.aspx
        let range = ChildBMI.getRange(age: age, gender: gender)
        switch bmi {
        case range[0]..<range[1]:
            return "BMI:\(bmi)\n 正常"
        case range[1]..<range[2]:
            return "BMI:\(bmi)\n 過重"
        case range[2]...:
            return "BMI:\(bmi)\n 肥胖"
        default:
            return "BMI:\(bmi)"
        }
    }
    
    //在鍵盤上面加上Done按鈕, 點了把鍵盤收起來
    func setupKeyboard() {
        let toolbar = UIToolbar()
        //target-action是來自Objective-C的概念
        //target負責幫忙去接受事件(ex:觸控)
        //action則是在target接受到事件之後去執行的動作
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(hideKeyboard))
        toolbar.items = [doneBtn]
        toolbar.sizeToFit()
        //將toolbar放在textfield的inputAccessory
        heightText.inputAccessoryView = toolbar
        weightText.inputAccessoryView = toolbar
        ageText.inputAccessoryView = toolbar
    }
    
    //把鍵盤收起來
    //@objc是用來宣告hideKeyboard()這個func也可以被Objective-c的程式使用
    @objc func hideKeyboard() {
        print("hide...")
        view.endEditing(true)
    }
    
    //點畫面收鍵盤
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touch...")
        view.endEditing(true)
    }
}

