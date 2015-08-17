//
//  RoiPageContentViewController.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 11/08/15.
//  Copyright (c) 2015 Commind. All rights reserved.
//

import UIKit

class RoiSelectionContentViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
        
    var itemIndex: Int = 0
    var selectedROICalculator: ROICalculator!
    var roiContentView: UIView?
    var toggleTimer: NSTimer?

    private let titles = [NSLocalizedString("SELECT PRODUCT", comment: ""),
        NSLocalizedString("NUMBER OF MACHINES", comment: ""),
        NSLocalizedString("ORE GRADE", comment: ""),
        NSLocalizedString("EFFICIENCY", comment: ""),
        NSLocalizedString("ORE PRICE PER TON", comment: ""),
        NSLocalizedString("HOW IT PLAYS OUT FOR YOU", comment: "")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pagesScrollViewSize = scrollView.frame.size
        var noOfPages = 1
        
        /*if itemIndex >= 0{
            noOfPages = 100
        }*/

        scrollView.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(noOfPages),
            height: pagesScrollViewSize.height)
        titleLabel.text = titles[itemIndex]
    }
    
    override func viewDidLayoutSubviews() {
        
        if roiContentView != nil {
            return
        }
        
        if itemIndex == 0 {
            //load products
            let product = selectedROICalculator.input.product
        }
        else {
            let numberView = RoiNumberView(frame: self.scrollView.bounds)
            scrollView.addSubview(numberView)
            numberView.loadNumber(itemIndex, roiInput: selectedROICalculator.input)
            roiContentView = numberView;
        }
    }

    @IBAction func toggleLeft(sender: UIButton) {
       toggleTimer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: Selector("toggleLeft"), userInfo: nil, repeats: true)
    }
    
    @IBAction func toggleRight(sender: UIButton) {
        toggleTimer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: Selector("toggleRight"), userInfo: nil, repeats: true)
    }
    
    func toggleLeft() {
        if let numberView = roiContentView as? RoiNumberView {
            numberView.decreaseNumber(itemIndex, roiInput: selectedROICalculator.input)
        }
    }
    
    func toggleRight() {
        if let numberView = roiContentView as? RoiNumberView {
            numberView.increaseNumber(itemIndex, roiInput: selectedROICalculator.input)
        }
    }
    
    @IBAction func releaseAction(sender: UIButton) {
        toggleTimer?.fire()
        toggleTimer?.invalidate()
        toggleTimer = nil
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
