//
//  ViewController.swift
//  View Polish
//
//  Created by Stephen Anthony on 18/01/2016.
//  Copyright © 2016 Darjeeling Apps. All rights reserved.
//

import UIKit

let ViewControllerRowHeight: CGFloat = 60.0

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate {
    @IBOutlet private weak var tableView: UITableView!
    private let numberFormatter = NSNumberFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        numberFormatter.numberStyle = .SpellOutStyle
        navigationController?.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let numberViewController = segue.destinationViewController as? NumberViewController, indexPath = tableView.indexPathForSelectedRow else {
            return
        }
        
        numberViewController.number = indexPath.row
    }
    
    //MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.text = numberFormatter.stringFromNumber(indexPath.row)
        return cell
    }
    
    //MARK: UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return ViewControllerRowHeight
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if fabs(velocity.y) > 1.2 {
            // The user has panned quite fast, so settle precisely on a row
            let target = round(targetContentOffset.memory.y / ViewControllerRowHeight)
            if  target != -1.0 { // Preserve top rubber banding
                targetContentOffset.memory.y = target * ViewControllerRowHeight
            }
        }
    }
    
    //MARK: UINavigationControllerDelegate
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let selectedCellFrame = tableView.cellForRowAtIndexPath(tableView.indexPathForSelectedRow!)!.frame
        // Adjust the frame to our table's coordinate space
        var convertedCellFrame = view.convertRect(selectedCellFrame, fromView: tableView)
        // When popping we have to adjust for the top layout guide manually
        convertedCellFrame.origin.y += operation == .Pop ? topLayoutGuide.length : 0
        let zoomTransitionAnimator = ZoomTransitionAnimator(zoomRect: convertedCellFrame, zoomType: operation == .Push ? .ZoomIn : .ZoomOut)
        return zoomTransitionAnimator
    }
}
