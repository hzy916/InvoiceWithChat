//
//  InvoiceListViewController.swift
//  Print2PDF
//
//  Created by Gabriel Theodoropoulos on 14/06/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

import UIKit
import UserNotifications



@available(iOS 10.0, *)



class InvoiceListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblInvoices: UITableView!
    
    
    var invoices: [[String: AnyObject]]!
    var selectedInvoiceIndex: Int!
    
    //create notifications

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblInvoices.delegate = self
        tblInvoices.dataSource = self
        
    }
    
    //import livechat
  
    
    
    func scheduleNotifications() {
        
        let content = UNMutableNotificationContent()
        content.title = "Pop Quiz!"
        content.subtitle = "Let's see how smart you are!"
        content.body = "How many countries are there in Africa?"
        content.badge = 1
        content.categoryIdentifier = "quizCategory"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let requestIdentifier = "africaQuiz"
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            // handle error
        })
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let inv = UserDefaults.standard.object(forKey: "invoices") {
            invoices = inv as? [[String: AnyObject]]
            tblInvoices.reloadData()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "idSeguePresentPreview" {
                let previewViewController = segue.destination as! PreviewViewController
                previewViewController.invoiceInfo = invoices[selectedInvoiceIndex]
            }
        }
    }
    

    
    // MARK: IBAction Methods
    
    @IBAction func createInvoice(_ sender: AnyObject) {
        let creatorViewController = storyboard?.instantiateViewController(withIdentifier: "idCreateInvoice") as! CreatorViewController
        creatorViewController.presentCreatorViewControllerInViewController(self) { (invoiceNumber, recipientInfo, totalAmount, items) in
            DispatchQueue.main.async(execute: { 
                if self.invoices == nil {
                    self.invoices = [[String: AnyObject]]()
                }
                
                // Add the new invoice data to the invoices array.
                self.invoices.append(["invoiceNumber": invoiceNumber as AnyObject, "invoiceDate": self.formatAndGetCurrentDate() as AnyObject, "recipientInfo": recipientInfo as AnyObject, "totalAmount": totalAmount as AnyObject, "items": items as AnyObject])
                
                // Update the user defaults with the new invoice.
                UserDefaults.standard.set(self.invoices, forKey: "invoices")
                
                // Reload the tableview.
                self.tblInvoices.reloadData()
            })
        }
    }
    
    
    // MARK: Custom Methods
    
    func formatAndGetCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        return dateFormatter.string(from: Date())
    }
    
    
    // MARK: UITableView Delegate and Datasource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (invoices != nil) ? invoices.count : 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "invoiceCell", for: indexPath)
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "invoiceCell")
        }
        
        cell.textLabel?.text = "\(invoices[(indexPath as NSIndexPath).row]["invoiceNumber"] as! String) - \(invoices[(indexPath as NSIndexPath).row]["invoiceDate"] as! String) - \(invoices[(indexPath as NSIndexPath).row]["totalAmount"] as! String)"
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedInvoiceIndex = (indexPath as NSIndexPath).row
        performSegue(withIdentifier: "idSeguePresentPreview", sender: self)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            invoices.remove(at: (indexPath as NSIndexPath).row)
            tblInvoices.reloadData()
            UserDefaults.standard.set(self.invoices, forKey: "invoices")
        }
    }
    
}


@available(iOS 10.0, *)
extension InvoiceListViewController: UNUserNotificationCenterDelegate {
    
    //for displaying notification when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //If you don't want to show notification when app is open, do something here else and make a return here.
        //Even you you don't implement this delegate method, you will not see the notification on the specified controller. So, you have to implement this delegate and make sure the below line execute. i.e. completionHandler.
        
        completionHandler([.alert, .badge, .sound])
    }
    
    // For handling tap and user actions
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        switch response.actionIdentifier {
        case "action1":
            print("Action First Tapped")
        case "action2":
            print("Action Second Tapped")
        default:
            break
        }
        completionHandler()
    }
}


