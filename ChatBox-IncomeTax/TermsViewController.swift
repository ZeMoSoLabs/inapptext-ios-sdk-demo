//
//  TErnsViewController.swift
//  InAppText SDK Demo
//
//  Created by Raja Vikram on 23/02/17.
//  Copyright © 2017 ZeMoSo Technologoes Pvt. Ltd. All rights reserved.
//

import UIKit

class TermsViewController: UIViewController {

    @IBOutlet weak var termsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let normalFont = UIFont(name: "HelveticaNeue", size: 17)!
        let boldFont = UIFont(name: "HelveticaNeue-Bold", size: 17)!
        
        let normalFontAttr : [String:AnyObject] = [NSFontAttributeName: normalFont]
        
        
        let mainText = NSMutableAttributedString()
        
        let salariedString = NSAttributedString(string: "This income tax calculation is only applicable for salaried employees of India for the financial year 2016-17.", attributes: normalFontAttr)
        mainText.appendAttributedString(salariedString)
        
        
        let itLink = NSAttributedString(string: "\n\nFor more information refer - http://www.incometaxindia.gov.in/pages/tax-laws-rules.aspx", attributes: normalFontAttr)
        mainText.appendAttributedString(itLink)
        
        let note = "\n\nNote : Any other additional fees and taxes to be paid are not included in the final tax calculation amount."
        let noteAttStr = NSMutableAttributedString(string: note, attributes: [NSFontAttributeName: normalFont])
        noteAttStr.addAttribute(NSFontAttributeName, value: boldFont, range: (note as NSString).rangeOfString("Note"))
        mainText.appendAttributedString(noteAttStr)
        
        
        
        termsTextView.attributedText = mainText
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
