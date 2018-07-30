//
//  DrinkWaterViewController.swift
//  DrinkMoreWater
//
//  Created by Che-wei LIU on 2018/7/18.
//  Copyright © 2018 Che-wei LIU. All rights reserved.
//

import UIKit

class EditWaterViewController: UIViewController {

    @IBOutlet weak var doneBarBtn: UIBarButtonItem!
    @IBOutlet weak var waterTextField: UITextField!
    
    var waterDetail: WaterDetail?

    override func viewDidLoad() {
        super.viewDidLoad()
        waterTextField.delegate = self
        waterTextField.addTarget(self, action: #selector(enableDoneBarBtn), for: .allEditingEvents)
        
        if let waterDetail = waterDetail {
            waterTextField.text = "\(waterDetail.water)"
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func doneBtnPressed(_ sender: Any) {
        waterTextField.endEditing(true)
        
        guard let waterText = waterTextField.text, let water = Int(waterText) else {
            assertionFailure("Fail to get waterText.")
            return
        }
        
        if let waterDetail = waterDetail {
            waterDetail.water = water
            waterDetail.date = Date()
            performSegue(withIdentifier: unwindEditSegue, sender: nil)
        } else {
            waterDetail = WaterDetail(water: water, date: Date())
            performSegue(withIdentifier: unwindAddSegue, sender: nil)
        }
    }
    
    @IBAction func add300ml(_ sender: UIButton) {
        addToTextField(num: 300)
    }
    
    @IBAction func add500ml(_ sender: UIButton) {
        addToTextField(num: 500)
    }
    
    @IBAction func add1000ml(_ sender: UIButton) {
        addToTextField(num: 1000)
    }
    
    
    @objc
    func enableDoneBarBtn() {
        guard let water = waterTextField.text, !water.isEmpty, Int(water) != 0 else {
            doneBarBtn.isEnabled = false
            return
        }
        
        doneBarBtn.isEnabled = true
    }
    
    func addToTextField(num: Int) {
        if let water = waterTextField.text, !water.isEmpty {
            waterTextField.text = String( Int(water)! + num )
        } else {
            waterTextField.text = "\(num)"
        }
        doneBarBtn.isEnabled = true

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension EditWaterViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {
            return true
        }
        let newLength = text.count + string.count - range.length
        return newLength <= 5  // your max length value
    }
}
