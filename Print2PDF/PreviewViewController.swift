//
//  PreviewViewController.swift
//  Print2PDF
//
//  Created by Gabriel Theodoropoulos on 14/06/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {
    
    var invoiceComposer: InvoiceComposer!
    
    var HTMLContent: String!
    
    
    @IBOutlet weak var webPreview: UIWebView!
    
    
    @IBAction func GotoSupport(_ sender: Any) {
        
        performSegue(withIdentifier: "supportView", sender: self)
    }
    
    
    @IBAction func exportCSV(_ sender: Any) {
        
        let fileName = "report.csv"
        
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        
        var csvText = "EmployeeName,Started\n"
        
        let product = invoiceInfo["items"]
        let count = product?.count
        
        if count! > 0 {
            for i in 0..<invoiceInfo["items"]?.count {
                let newLine = "\(items[i]["item"]!),\(items[i]["price"])\n"
                csvText.append(newLine)
            }
        }
        
        do {
            try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("Failed to create file")
            print("\(error)")
        }
        
    }
    
    
    var invoiceInfo: [String: AnyObject]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        createInvoiceAsHTML()
    }


    
    // MARK: IBAction Methods
    
    @IBAction func exportToPDF(_ sender: AnyObject) {
        
    }
    
    func createInvoiceAsHTML() {
        invoiceComposer = InvoiceComposer()
        if let invoiceHTML = invoiceComposer.renderInvoice(invoiceNumber: invoiceInfo["invoiceNumber"] as! String,
                                                           invoiceDate: invoiceInfo["invoiceDate"] as! String,
                                                           recipientInfo: invoiceInfo["recipientInfo"] as! String,
                                                           items: invoiceInfo["items"] as! [[String: String]],
                                                           totalAmount: invoiceInfo["totalAmount"] as! String) {
            
            webPreview.loadHTMLString(invoiceHTML, baseURL: NSURL(string: invoiceComposer.pathToInvoiceHTMLTemplate!)! as URL)
            HTMLContent = invoiceHTML
        }
    }
    
}
