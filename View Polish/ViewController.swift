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
    @IBOutlet fileprivate weak var tableView: UITableView!
    fileprivate let numberFormatter = NumberFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        numberFormatter.numberStyle = .spellOut
        navigationController?.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let numberViewController = segue.destination as? NumberViewController, let indexPath = tableView.indexPathForSelectedRow else {
            return
        }
        
        numberViewController.number = indexPath.row
    }
    
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = numberFormatter.string(from: NSNumber(value: indexPath.row))
        return cell
    }
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ViewControllerRowHeight
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if fabs(velocity.y) > 1.2 {
            // The user has panned quite fast, so settle precisely on a row
            let target = round(targetContentOffset.pointee.y / ViewControllerRowHeight)
            if  target != -1.0 { // Preserve top rubber banding
                targetContentOffset.pointee.y = target * ViewControllerRowHeight
            }
        }
    }
    
    //MARK: UINavigationControllerDelegate
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let selectedCellFrame = tableView.cellForRow(at: tableView.indexPathForSelectedRow!)!.frame
        // Adjust the frame to our table's coordinate space
        var convertedCellFrame = view.convert(selectedCellFrame, from: tableView)
        // When popping we have to adjust for the top layout guide manually
        convertedCellFrame.origin.y += operation == .pop ? topLayoutGuide.length : 0
        let zoomTransitionAnimator = ZoomTransitionAnimator(zoomRect: convertedCellFrame, zoomType: operation == .push ? .zoomIn : .zoomOut)
        return zoomTransitionAnimator
    }
}
