//
//  SavedPostsViewController.swift
//  FamousFootPrints
//
//  Created by mac on 07/07/22.
//

import UIKit
import NavigationDrawer
class SavedPostsViewController: UIViewController {
    let interactor = Interactor()
    
    
    @IBOutlet weak var bar: UINavigationItem!
    
    @IBOutlet weak var savedPostsNB: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        savedPostsNB.shadowImage = UIImage()
        if UserDefaults.standard.bool(forKey: "languageSelection") == true{
            languageChange(str: "ar")
        }else if UserDefaults.standard.bool(forKey: "languageSelection") == false{
            languageChange(str: "en")
        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? SlidingViewController {
            destinationViewController.transitioningDelegate = self
            destinationViewController.interactor = self.interactor
            
            #warning("From iOS 13, you need to make presentationStyle to fullScreen.")
            destinationViewController.modalPresentationStyle = .fullScreen
//            destinationViewController.mainVC = self
        }
    }

    @IBAction func edgePanGesture(sender: UIScreenEdgePanGestureRecognizer) {
        let translation = sender.translation(in: view)

        let progress = MenuHelper.calculateProgress(translationInView: translation, viewBounds: view.bounds, direction: .Right)

        MenuHelper.mapGestureStateToInteractor(
            gestureState: sender.state,
            progress: progress,
            interactor: interactor){
                self.performSegue(withIdentifier: "SPshowSlidingMenu", sender: nil)
        }
    }
    func languageChange(str: String){
        self.bar.title = "Saved Posts".localizableString(loc: str)
    }
}
extension SavedPostsViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if UserDefaults.standard.bool(forKey: "languageSelection") == true{
            let animator = PresentMenuAnimator(direction: .Right)
            animator.shadowOpacity = 0.1
            return animator

        }else if UserDefaults.standard.bool(forKey: "languageSelection") == false{
            let animator = PresentMenuAnimator(direction: .Left)
            animator.shadowOpacity = 0.1
            return animator

        }
        let animator = PresentMenuAnimator(direction: .Left)
        animator.shadowOpacity = 0.1
        return animator    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissMenuAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}

