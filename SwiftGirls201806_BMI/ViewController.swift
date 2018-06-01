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
        guard let ageText = ageText.text, let age = Int(ageText)  else {
            resultLabel.text = "請輸入年齡"
            return
        }
        guard let heightText = heightText.text, let height = Double(heightText)  else {
            resultLabel.text = "請輸入身高"
            return
        }
        guard let weightText = weightText.text, let weight = Double(weightText)  else {
            resultLabel.text = "請輸入體重"
            return
        }
        
        let bmi = getBMI(height: height, weight: weight)
        let result = checkBMIResult(age: age, bmi: bmi)
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
    func getBMI(height: Double, weight: Double) -> Double {
        let heightm = height / 100
        let bmi = weight / pow(Double(heightm), 2)
        return round(bmi * 10) / 10
    }
    
//    18歲（含）以上的成人BMI範圍值 體重是否正常
//    BMI＜18.5 kg/m2
//    「體重過輕」，需要多運動，均衡飲食，以增加體能，維持健康！
//    18.5 kg/m2 ≤ BMI＜24 kg/m2
//    恭喜！「健康體重」，要繼續保持！
//    24 kg/m2 ≤ BMI＜27 kg/m2
//    「體重過重」了，要小心囉，趕快力行「健康體重管理」！
//    BMI ≥ 27 kg/m2
//    啊～「肥胖」，需要立刻力行「健康體重管理」囉！
    func checkBMIResult(age: Int, bmi: Double) -> String {
        guard age < 18 else {
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
        return checkChildBMI(age: age, bmi: bmi)
    }
    
    //未滿18歲BMI範圍值 體重是否正常
    //https://obesity.hpa.gov.tw/TC/BMIproposal.aspx
    func checkChildBMI(age: Int, bmi: Double) -> String {
        let age17 = [[17.8, 23.5, 25.6],
                     [17.3, 22.7, 25.3]]
        if age == 17 {
            let range = age17[genderSegment.selectedSegmentIndex]
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
        return "BMI:\(bmi)"
    }
    
    //在鍵盤上面加上Done按鈕, 點了把鍵盤收起來
    func setupKeyboard() {
        let toolbar = UIToolbar()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(hideKeyboard))
        toolbar.items = [doneBtn]
        toolbar.sizeToFit()
        //將toolbar放在textfield的inputAccessory
        heightText.inputAccessoryView = toolbar
        weightText.inputAccessoryView = toolbar
        ageText.inputAccessoryView = toolbar
    }
    
    //把鍵盤收起來
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

