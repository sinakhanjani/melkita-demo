//
//  BazaryabMainTableViewController.swift
//  Master
//
//  Created by Sina khanjani on 5/23/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import UIKit
import  RestfulAPI

class BazaryabMainTableViewController: UITableViewController {

    let approveHeader = NotApproveView(height: 120)
    var packageDuration = 90
    var timeBehind = ""
    
    var myEshterak: SinglePackage?
    var packName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "پنل بازاریاب"
        backBarButtonAttribute(color: .black, name: "")
        updateIU()
        if let id = DataManager.shared.userInfo?.registerMarketerPackageId {
            self.fetchPackageId(id: id)
        }
    }
    
    func updateIU() {
        func behind(exDate: Date) -> String {
            var str = ""
            let nowDate = Date()
            let day = exDate.days(from: nowDate)+1
            var minute = 0
            var hour = 0

            if day > 0 {
                hour = exDate.hours(from: nowDate) - ((day-1)*24)

                //3353 < 1440
                minute = exDate.minutes(from: nowDate) // minute
                str = "\(day-1) روز" + " و " + "\(hour) ساعت"

                if hour < 24 {
                    if minute < 1440 { //1440 ---- 393-((7-1)*60)
                        minute = minute-(hour*60)
                        str += " \(minute) دقیقه"
                    }
                }
            }
            if day <= 0 {
                hour = exDate.hours(from: nowDate) - ((1-1)*24)
                str = "\(day-1) روز" + " و " + "\(hour) ساعت"

                //3353 < 1440
                minute = exDate.minutes(from: nowDate) // minute
                if hour < 24 {
                    if minute < 1440 { //1440 ---- 393-((7-1)*60)
                        minute = minute-(hour*60)
                        str += " \(minute) دقیقه"
                    }
                }
            }
            
            return str
        }
        
        if let exDate = DataManager.shared.userInfo?.expireMarketerAccountDate?.toDate() {
            let nowDate = Date()

            timeBehind = behind(exDate: exDate)
            
            //2021-09-02 10:34:00 +0000 2021-08-30 11:06:17 +0000
            if let afterDate = DataManager.shared.userInfo?.expireMarketerAccountAfterDate?.toDate() {
                if nowDate > exDate && nowDate < afterDate {
                    let headerView = NotApproveView(height: 120)
                    let behind = behind(exDate: afterDate)
                    let message = "بازاریاب گرامی اشتراک خریداری شما منقضی شده است و حداکثر تا \(behind) آینده بسته جدید خریداری کنید"
                    headerView.titleLabel.text = message//"بازاریاب عزیز لطفا جهت کسب درامد یک اشتراک بازاریابی خرید کنید"
                    headerView.bgView.layer.borderColor = UIColor.red.cgColor
                    headerView.titleLabel.tintColor = .red
                    self.tableView.tableHeaderView = headerView
                    return
                }
                if nowDate > exDate && nowDate > afterDate {
                    let headerView = NotApproveView(height: 128)
                    headerView.titleLabel.text = "بازاریاب عزیز اشتراک قبلی شما منقضی شده است و کد بازاریابی قبلی شما قابل استفاده نیست. جهت فعال شدن کد بازاریابی لطفا اشتراک جدید خریداری کنید."
                    headerView.bgView.layer.borderColor = UIColor.red.cgColor
                    headerView.titleLabel.tintColor = .red
                    self.tableView.tableHeaderView = headerView
                    return
                }
            }
        }
        
        if !DataManager.shared.isApproveDocument {
            let headerView = NotApproveView(height: 100)
            headerView.titleLabel.text = "مدارک شما هنوز تایید نشده است"
            self.tableView.tableHeaderView = headerView
            return
        } else if !DataManager.shared.isAccountApprive {
            let headerView = NotApproveView(height: 100)
            headerView.titleLabel.text = "هویت شما هنوز تایید نشده است"
            self.tableView.tableHeaderView = headerView
            return
        }
        else if !DataManager.shared.hasMarketerPackage && DataManager.shared.isExpiredBetweenXDayFromNow {
            let headerView = NotApproveView(height: 100)
            headerView.titleLabel.text = "بازاریاب عزیز لطفا جهت کسب درامد یک اشتراک بازاریابی خرید کنید"
            headerView.bgView.layer.borderColor = UIColor.red.cgColor
            headerView.titleLabel.tintColor = .red
            self.tableView.tableHeaderView = headerView
            return
        }
        else if !DataManager.shared.hasMarketerPackage {
            let headerView = NotApproveView(height: 100)
            headerView.titleLabel.text = "بازاریاب عزیز لطفا جهت کسب درامد یک اشتراک بازاریابی خرید کنید"
            headerView.bgView.layer.borderColor = UIColor.red.cgColor
            headerView.titleLabel.tintColor = .red
            self.tableView.tableHeaderView = headerView
            return
        } else if DataManager.shared.hasMarketerPackage && DataManager.shared.isExpiredBetweenXDayFromNow {
            let headerView = NotApproveView(height: 100)
            let msg = "بازاریاب عزیز اشتراک شما \(timeBehind) دیگر به پایان میرسد"
            headerView.titleLabel.text = msg
                //"بازاریاب عزیز اشتراک شما تا \(myEshterak?.daysAfterExpire ?? 3) روز دیگر به پایان میرسد"
            headerView.bgView.layer.borderColor = UIColor.red.cgColor
            headerView.titleLabel.tintColor = .red
            self.tableView.tableHeaderView = headerView
            return
        } else if DataManager.shared.hasMarketerPackage {
            // baste active dare
            approveHeader.titleLabel.text = "شما در حال استفاده از \(packName ?? "") هستید تا انقضای بسته \(timeBehind) باقی مانده است" //
            approveHeader.bgView.layer.borderColor = UIColor.blue.cgColor
            approveHeader.titleLabel.textColor = .blue
            self.tableView.tableHeaderView = approveHeader
        }
    }
    
    func fetchPackageId(id: String) {
        RestfulAPI<Empty,SinglePackage>.init(path: "/Marketer/register-package/single/\(id)")
        .with(auth: .user)
        .with(method: .GET)
        .sendURLSessionRequest { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let res):
                    self.packName = res.title
                    self.packageDuration = res.expireDays ?? 90
                    self.myEshterak = res
                    self.updateIU()
                    break
                case .failure(let err):
                    print(err)
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let exDate = DataManager.shared.userInfo?.expireMarketerAccountDate?.toDate() {
            if (DataManager.shared.hasMarketerPackage) && Date().addingTimeInterval(60*60*24*5) < exDate {
                return 4
            }
        }
        
        return 5
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.item == 0) || (indexPath.item == 1) || (indexPath.item == 3) || (indexPath.item == 4) {
            guard DataManager.shared.isApproveDocument else {
                presentCDAlertWarningAlert(message: "مدارک شما هنوز تایید نشده است", completion: {})
                return
            }
            guard DataManager.shared.isAccountApprive else {
                presentCDAlertWarningAlert(message: "هویت شما هنوز تایید نشده است", completion: {})
                return
            }
            guard DataManager.shared.hasMarketerPackageAfter else {
                if indexPath.item == 4 {
                    // hesab banki
                    let vc = KharidEshterakTableViewController.create()
                    show(vc, sender: nil)
                    return
                }
                if indexPath.item == 3 {
                    // hesab banki
                    let vc = BankListTableViewController.create()
                    show(vc, sender: nil)
                }
                presentCDAlertWarningAlert(message: "بازاریاب عزیز لطفا جهت کسب درامد یک اشتراک بازاریابی خرید کنید", completion: {})
                return
            }
            //
            if indexPath.item == 0 {
                // moarefan man
                let vc = MoarefanManTableViewController.create()
                show(vc, sender: nil)
            }
            if indexPath.item == 1 {
                // kharid man
                let vc = KharidBaCodeManTableViewController.create()
                show(vc, sender: nil)
            }
            if indexPath.item == 4 {
                // hesab banki
                let vc = KharidEshterakTableViewController.create()
                show(vc, sender: nil)
                return
            }
        }

        if indexPath.item == 2 {
            //archive varzii
            let vc = ArchiveVariziTableViewController.create()
            show(vc, sender: nil)
        }
    }
}


extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
}
