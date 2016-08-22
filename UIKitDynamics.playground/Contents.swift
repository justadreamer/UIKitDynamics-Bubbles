//: Playground - noun: a place where people can play

import UIKit
import XCPlayground

let resistanceFactor = 25.0
let forceFactor = 50.0
let cs = CGFloat(500.0)

let container = UIView(frame: CGRectMake(0,0,cs,cs))
let animator = UIDynamicAnimator(referenceView:container)
let collision = UICollisionBehavior()
collision.translatesReferenceBoundsIntoBoundary = true
animator.addBehavior(collision)

class Bubble: UIView {
    let pan = UIPanGestureRecognizer()
    let force = UIPushBehavior()
    let resistance = UIDynamicItemBehavior()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        pan.addTarget(self, action: #selector(didPan))
        self.addGestureRecognizer(pan)
        force.addItem(self)
        resistance.addItem(self)
        resistance.resistance = CGFloat(resistanceFactor)
    }
    
    func didPan(gesture: UIPanGestureRecognizer) {
        if gesture.state == .Began {
            force.active = true
        } else if gesture.state == .Ended {
            force.active = false
        } else if gesture.state == .Changed {
            let translation = gesture.translationInView(self.superview)
            let d = sqrt(translation.x * translation.x + translation.y * translation.y)
            force.pushDirection = CGVector(dx: translation.x/d, dy: translation.y/d)
            force.magnitude = force.magnitude * CGFloat(forceFactor)
        }
    }
    
}

func rnd() -> CGFloat {
    return CGFloat(arc4random_uniform(255))/255.0
}

let s: CGFloat = 100
for i in 1...10 {
    let f = CGFloat(i)
    let v = Bubble(frame: CGRectMake(cs/2,cs/2,s,s))
    v.layer.cornerRadius = s/2
    v.backgroundColor = UIColor(red: rnd(), green: rnd(), blue: rnd(), alpha: 1.0)
    container.addSubview(v)
    collision.addItem(v)
    animator.addBehavior(v.force)
    animator.addBehavior(v.resistance)
}

XCPlaygroundPage.currentPage.liveView = container
XCPlaygroundPage.currentPage.needsIndefiniteExecution = true
