//
//  DrinkWaterTableViewController.swift
//  DrinkMoreWater
//
//  Created by Che-wei LIU on 2018/7/12.
//  Copyright © 2018 Che-wei LIU. All rights reserved.
//

import UIKit
import UserNotifications

class DrinkWaterTableViewController: UITableViewController {
    
    private let drinkWaterCell = "drinkWaterCell"
    private let addDrinkWaterCell = "addDrinkWaterCell"
    private let sectionCell = "sectionCell"
    private let editSegue = "editSegue"
    private let settingSegue = "settingSegue"
    private let DAILYWATER_KEY = "dailyWater"
    private let NOTIFICATION_ENABLE_KEY = "notificationEnable"
    private let MORNINGDRINKS_KEY = "morningDrinks"
    private let AFTERNOONDRINKS_KEY = "afternoonDrinks"
    private let EVENINGDRINKS_KEY = "eveningDrinks"
    private let EXERCISEDRINKS_KEY = "exerciseDrinks"
    
    let heightForHeaderInSection = CGFloat(50.0)
    let heightForFooterInSection = CGFloat(50.0)
    
    var morningDrinks = [WaterDetail]()
    var afternoonDrinks = [WaterDetail]()
    var eveningDrinks = [WaterDetail]()
    var exerciseDrinks = [WaterDetail]()
    
    @IBOutlet weak var waterCountLabel: UILabel!
    @IBOutlet weak var waterHintLabel: UILabel!
    
    var dailyWater: Int!
    var notificationEnable: Bool!
    
    var defaultDailyWater = 2000
    var waterCount = 0
    let userDefault = UserDefaults.standard
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeStyle = .short
        
        // Reload user's setting.
        let udDailyWater = userDefault.integer(forKey: DAILYWATER_KEY)
        if udDailyWater != 0 {
            dailyWater = udDailyWater
        } else {
            dailyWater = defaultDailyWater
        }
        
        if let udNotificationEnable = userDefault.string(forKey: NOTIFICATION_ENABLE_KEY), let notificationEnable = Bool(udNotificationEnable) {
            self.notificationEnable = notificationEnable
        } else {
            notificationEnable = true
        }
        
        // Get drink history.
        getFromUserDefualt()
        
        // Dismiss data if data isn't today's history.
        dismissFromUserDefault()
        
        reloadWaterCountLabel()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return morningDrinks.count + 1
        case 1:
            return afternoonDrinks.count + 1
        case 2:
            return eveningDrinks.count + 1
        case 3:
            return exerciseDrinks.count + 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heightForHeaderInSection
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: sectionCell) as? HeaderTableViewCell else {
            assertionFailure("Fail to get viewForHeaderInSection")
            return nil
        }
        
        let headerImage = cell.headerImage
        let headerTextLabel = cell.headerTextLabel
        
        switch section {
        case 0:
            headerImage?.image = UIImage(named: "morning")
            headerTextLabel?.text = "早上"
        case 1:
            headerImage?.image = UIImage(named: "afternoon")
            headerTextLabel?.text = "中午"
        case 2:
            headerImage?.image = UIImage(named: "evening")
            headerTextLabel?.text = "晚上"
        case 3:
            headerImage?.image = UIImage(named: "exercise")
            headerTextLabel?.text = "運動補充"
        default:
            headerImage?.image = nil
            headerTextLabel?.text = nil
        }
        return cell.contentView
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let addDrinkWaterCell = tableView.dequeueReusableCell(withIdentifier: self.addDrinkWaterCell, for: indexPath)
        
        guard let drinkWaterCell = tableView.dequeueReusableCell(withIdentifier: self.drinkWaterCell, for: indexPath) as? DrinkWaterTableViewCell else {
            assertionFailure("Fail to convert to DrinkWaterTableViewCell")
            return UITableViewCell()
        }
        
        switch indexPath.section {
        case 0:
            if morningDrinks.count == 0 || morningDrinks.count == indexPath.row {
                return addDrinkWaterCell
            } else {
                drinkWaterCell.timeLabel.text = "\(dateFormatter.string(from: morningDrinks[indexPath.row].date))"
                drinkWaterCell.waterLabel.text = "\(morningDrinks[indexPath.row].water)ml"
                return drinkWaterCell
            }
        case 1:
            if afternoonDrinks.count == 0 || afternoonDrinks.count == indexPath.row {
                return addDrinkWaterCell
            } else {
                drinkWaterCell.timeLabel.text = "\(dateFormatter.string(from:afternoonDrinks[indexPath.row].date))"
                drinkWaterCell.waterLabel.text = "\(afternoonDrinks[indexPath.row].water)ml"
                return drinkWaterCell
            }
        case 2:
            if eveningDrinks.count == 0 || eveningDrinks.count == indexPath.row {
                return addDrinkWaterCell
            } else {
                drinkWaterCell.timeLabel.text = "\(dateFormatter.string(from:eveningDrinks[indexPath.row].date))"
                drinkWaterCell.waterLabel.text = "\(eveningDrinks[indexPath.row].water)ml"
                return drinkWaterCell
            }
        case 3:
            if exerciseDrinks.count == 0 || exerciseDrinks.count == indexPath.row {
                return addDrinkWaterCell
            } else {
                drinkWaterCell.timeLabel.text = "\(dateFormatter.string(from:exerciseDrinks[indexPath.row].date))"
                drinkWaterCell.waterLabel.text = "\(exerciseDrinks[indexPath.row].water)ml"
                return drinkWaterCell
            }
        default:
            return UITableViewCell()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        case 0:
            if morningDrinks.count == 0 || morningDrinks.count == indexPath.row {
                return false
            } else {
                return true
            }
        case 1:
            if afternoonDrinks.count == 0 || afternoonDrinks.count == indexPath.row {
                return false
            } else {
                return true
            }
        case 2:
            if eveningDrinks.count == 0 || eveningDrinks.count == indexPath.row {
                return false
            } else {
                return true
            }
        case 3:
            if exerciseDrinks.count == 0 || exerciseDrinks.count == indexPath.row {
                return false
            } else {
                return true
            }
        default:
            return false
        }
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard editingStyle == .delete else {
            assertionFailure("Fail to delete.")
            return
        }
        
        
        switch indexPath.section {
        case 0:
            morningDrinks.remove(at: indexPath.row)
            saveToUserDefault(drinkWaterTime: .morning)
            tableView.deleteRows(at: [indexPath], with: .fade)
        case 1:
            afternoonDrinks.remove(at: indexPath.row)
            saveToUserDefault(drinkWaterTime: .afternoon)
            tableView.deleteRows(at: [indexPath], with: .fade)
        case 2:
            eveningDrinks.remove(at: indexPath.row)
            saveToUserDefault(drinkWaterTime: .evening)
            tableView.deleteRows(at: [indexPath], with: .fade)
        case 3:
            exerciseDrinks.remove(at: indexPath.row)
            saveToUserDefault(drinkWaterTime: .exercise)
            tableView.deleteRows(at: [indexPath], with: .fade)
        default:
            return
        }
        tableView.reloadData()
        reloadWaterCountLabel()
    }
    
    
    @IBAction func unwind(segue: UIStoryboardSegue) {
        
        guard let indexPath = tableView.indexPathForSelectedRow else {
            assertionFailure("Fail to get indexPath.")
            return
        }
        
        guard let controller = segue.source as? EditWaterViewController else {
            assertionFailure("Fail to get EditWaterViewController.")
            return
        }
        
        guard let waterDetail = controller.waterDetail else {
            assertionFailure("Fail to get waterDetail from EditWaterViewController.")
            return
        }
        
        if segue.identifier == unwindAddSegue {
            switch indexPath.section {
            case 0:
                morningDrinks.append(waterDetail)
                saveToUserDefault(drinkWaterTime: .morning)
            case 1:
                afternoonDrinks.append(waterDetail)
                saveToUserDefault(drinkWaterTime: .afternoon)
            case 2:
                eveningDrinks.append(waterDetail)
                saveToUserDefault(drinkWaterTime: .evening)
            case 3:
                exerciseDrinks.append(waterDetail)
                saveToUserDefault(drinkWaterTime: .exercise)
            default:
                return
            }
            
        } else if segue.identifier == unwindEditSegue {
            switch indexPath.section {
            case 0:
                morningDrinks[indexPath.row] = waterDetail
                saveToUserDefault(drinkWaterTime: .morning)
            case 1:
                afternoonDrinks[indexPath.row] = waterDetail
                saveToUserDefault(drinkWaterTime: .afternoon)
            case 2:
                eveningDrinks[indexPath.row] = waterDetail
                saveToUserDefault(drinkWaterTime: .evening)
            case 3:
                exerciseDrinks[indexPath.row] = waterDetail
                saveToUserDefault(drinkWaterTime: .exercise)
            default:
                return
            }
        }
        
        reloadWaterCountLabel()
        tableView.reloadData()
        // Use data from the view controller which initiated the unwind segue
    }
    
    @IBAction func unwindSettingSegue(segue: UIStoryboardSegue) {
        
        guard let controller = segue.source as? SettingTableViewController else {
            assertionFailure("Fail to get SettingTableViewController.")
            return
        }
        
        dailyWater = controller.dailyWater
        notificationEnable = controller.notificationSwitch.isOn
        reloadWaterCountLabel()
        
        userDefault.set(dailyWater, forKey: DAILYWATER_KEY)
        userDefault.set(String(notificationEnable), forKey: NOTIFICATION_ENABLE_KEY)
        userDefault.synchronize()
        // Use data from the view controller which initiated the unwind segue
    }
    
    @IBAction func cancelSegue(_ sender: UIStoryboardSegue) {
        // Use data from the view controller which initiated the unwind segue
    }
    
    func reloadWaterCountLabel() {
        
        waterCount = 0
        
        for morningWater in morningDrinks {
            waterCount += morningWater.water
        }
        
        for afternoonWater in afternoonDrinks {
            waterCount += afternoonWater.water
        }
        
        for eveningWater in eveningDrinks {
            waterCount += eveningWater.water
        }
        
        for exerciseWater in exerciseDrinks {
            waterCount += exerciseWater.water
        }
        
        let count = dailyWater - waterCount
        
        if count > 0 {
            waterHintLabel.text = "今天還剩下"
            waterCountLabel.text = "\(count)"
        } else {
            waterHintLabel.text = "今天已經喝了"
            waterCountLabel.text = "\(waterCount)"
        }
        showLocalNotificaitonMessage()
    }
    
    func showLocalNotificaitonMessage() {
        
        let center = UNUserNotificationCenter.current()

        // Check user's notificationEnable.
        guard notificationEnable else {
            center.removeAllDeliveredNotifications()
            center.removeAllPendingNotificationRequests()
            return
        }
        
        let count = dailyWater - waterCount
        print("count:\(count), watercount:\(waterCount)")
        
        // Create notification content.
        let morningContent = UNMutableNotificationContent()
        morningContent.title = "早晨一杯水,健康變水水"
        
        let afternoonContent = UNMutableNotificationContent()
        afternoonContent.title = "餐前一杯水,健康不變肥"
        
        let eveningContent = UNMutableNotificationContent()
        
        if count == 0 {
            morningContent.body = "今日尚位登記喝水紀錄唷！趕快紀錄喝水狀況"
            afternoonContent.body = "今日尚位登記喝水紀錄唷！趕快紀錄喝水狀況"
            eveningContent.body = "今日尚位登記喝水紀錄唷！趕快紀錄喝水狀況"
            
        } else if count > 0 {
            morningContent.body = "距離今日目標還剩\(count)ml"
            afternoonContent.body = "距離今日目標還剩\(count)ml"
            eveningContent.title = "今天的目標還沒達成喔"
            eveningContent.body = "距離今日目標還剩\(count)ml"
            
        } else {
            morningContent.body = "今天已經喝了\(waterCount)ml"
            afternoonContent.body = "今天已經喝了\(waterCount)ml"
            eveningContent.title = "已達成今日目標"
            eveningContent.body = "今天已經喝了\(waterCount)ml"
        }
        
        // Create DateComponents.
        var morningDateComponent = DateComponents()
        morningDateComponent.hour = 8
        var afternoonDateComponent = DateComponents()
        afternoonDateComponent.hour = 12
        var eveningDateComponent = DateComponents()
        eveningDateComponent.hour = 21
        
        
        // Create notification trigger.
        let morningTrigger = UNCalendarNotificationTrigger(dateMatching: morningDateComponent, repeats: false)
        let afternoonTrigger = UNCalendarNotificationTrigger(dateMatching: afternoonDateComponent, repeats: false)
        let eveningTrigger = UNCalendarNotificationTrigger(dateMatching: eveningDateComponent, repeats: false)
        
        // Create notification request.
        let morningRequest = UNNotificationRequest(identifier: "morning", content: morningContent, trigger: morningTrigger)
        let afternoonRequest = UNNotificationRequest(identifier: "afternoon", content: afternoonContent, trigger: afternoonTrigger)
        let eveninRequest = UNNotificationRequest(identifier: "evening", content: eveningContent, trigger: eveningTrigger)
        
        // Add trigger to the notificationcenter
        center.add(morningRequest) { (error) in
            if let error = error {
                print("Add Notification request fail: \(error)")
                return
            }
            print("Add MorningNotification request OK.")
        }
        
        center.add(afternoonRequest) { (error) in
            if let error = error {
                print("Add Notification request fail: \(error)")
                return
            }
            print("Add AfternoonNotification request OK.")
        }
        
        center.add(eveninRequest) { (error) in
            if let error = error {
                print("Add Notification request fail: \(error)")
                return
            }
            print("Add EveningNotification request OK.")
        }
    }
    
    func saveToUserDefault(drinkWaterTime: DrinkWaterTime) {
        
        let encoder = JSONEncoder()
        
        switch drinkWaterTime {
        case .morning:
            let result = try? encoder.encode(morningDrinks)
            userDefault.set(result, forKey: MORNINGDRINKS_KEY)
        case .afternoon:
            let result = try? encoder.encode(afternoonDrinks)
            userDefault.set(result, forKey: AFTERNOONDRINKS_KEY)
        case .evening:
            let result = try? encoder.encode(eveningDrinks)
            userDefault.set(result, forKey: EVENINGDRINKS_KEY)
        case .exercise:
            let result = try? encoder.encode(exerciseDrinks)
            userDefault.set(result, forKey: EXERCISEDRINKS_KEY)
        }
        
        userDefault.synchronize()

    }
    
    func getFromUserDefualt() {
        
        let decoder = JSONDecoder()
        
        if let udMorningDrinks = userDefault.data(forKey: MORNINGDRINKS_KEY) {
            guard let result = try? decoder.decode([WaterDetail].self, from: udMorningDrinks) else {
                return
            }
            morningDrinks = result
        }
        
        if let udAfternoonDrinks = userDefault.data(forKey: AFTERNOONDRINKS_KEY) {
            guard let result = try? decoder.decode([WaterDetail].self, from: udAfternoonDrinks) else {
                return
            }
            afternoonDrinks = result
        }
        
        if let udEveningDrinks = userDefault.data(forKey: EVENINGDRINKS_KEY) {
            guard let result = try? decoder.decode([WaterDetail].self, from: udEveningDrinks) else {
                return
            }
            eveningDrinks = result
        }
        
        if let udExerciseDrinks = userDefault.data(forKey: EXERCISEDRINKS_KEY) {
            guard let result = try? decoder.decode([WaterDetail].self, from: udExerciseDrinks) else {
                return
            }
            exerciseDrinks = result
        }
    }
    
    func dismissFromUserDefault() {
        
        if let lastMorningDate = morningDrinks.last?.date,
            !Calendar.current.isDateInToday(lastMorningDate) {
            clearAllHistory()
        }
        
        if let lastAfternoonDate = afternoonDrinks.last?.date,
            !Calendar.current.isDateInToday(lastAfternoonDate) {
            clearAllHistory()
        }
        
        if let lastEveningDate = eveningDrinks.last?.date,
            !Calendar.current.isDateInToday(lastEveningDate) {
            clearAllHistory()
        }
        
        if let lastExercise = exerciseDrinks.last?.date,
            !Calendar.current.isDateInToday(lastExercise) {
            clearAllHistory()
        }
        
    }
    
    func clearAllHistory() {
        
        morningDrinks.removeAll()
        afternoonDrinks.removeAll()
        eveningDrinks.removeAll()
        exerciseDrinks.removeAll()
        
        userDefault.removeObject(forKey: MORNINGDRINKS_KEY)
        userDefault.removeObject(forKey: AFTERNOONDRINKS_KEY)
        userDefault.removeObject(forKey: EVENINGDRINKS_KEY)
        userDefault.removeObject(forKey: EXERCISEDRINKS_KEY)
        
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == editSegue {
            
            guard let indexPath = tableView.indexPathForSelectedRow else {
                assertionFailure("Fail to get indexPathForSelectedRow")
                return
            }
            
            guard let controller = segue.destination as? EditWaterViewController else {
                assertionFailure("Fail to get EditWaterViewController")
                return
            }
            
            
            switch indexPath.section {
            case 0:
                controller.waterDetail = morningDrinks[indexPath.row]
            case 1:
                controller.waterDetail = afternoonDrinks[indexPath.row]
            case 2:
                controller.waterDetail = eveningDrinks[indexPath.row]
            case 3:
                controller.waterDetail = exerciseDrinks[indexPath.row]
            default:
                return
            }
        } else if segue.identifier == settingSegue {
            
            guard let controller = segue.destination as? SettingTableViewController else {
                assertionFailure("Fail to get SettingTableViewController.")
                return
            }
            controller.dailyWater = dailyWater
            controller.notificationEnable = notificationEnable
        }
    }
    
    
}
