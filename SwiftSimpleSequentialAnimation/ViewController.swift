//
//  ViewController.swift
//  SwiftSimpleSequentialAnimation
//
//  Created by Steve Greenwood on 10/04/2019.
//  Copyright © 2019 Steve Greenwood. All rights reserved.
//
//  example code to investigate possible method to animate 4 labels using
//
//  UIView.transition options: .transitionCrossDissolve used to animate colour change
//  UIView.animateKeyframes(withDuration: & UIView.addKeyframe(withRelativeStartTime: used to create motion

import UIKit

class ViewController: UIViewController {
    
    let noOfColumns = 4
    
    lazy var labelList: [UILabel] = {
        var tempLabelList = [UILabel]()
        let spacing : CGFloat = 20.0
        let nodeSize = CGSize(width: 40.0, height: 40.0)
        
        for column in 0..<noOfColumns {
            let y = CGFloat(0.0)
            let x = CGFloat(column) * (spacing + nodeSize.width)
            let label = UILabel(frame: CGRect(origin: CGPoint(x: x, y: y), size: nodeSize))
            label.backgroundColor = .lightGray
            label.text = "A"
            label.font = UIFont.boldSystemFont(ofSize: 32)
            label.textColor = .blue
            label.highlightedTextColor = .red
            label.textAlignment = .center
            tempLabelList.append(label)
        }
        return tempLabelList
    }()                             // parentheses essential
    
    lazy var toolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.barStyle = .blackTranslucent
        toolbar.tintColor = .green
        let reset = UIBarButtonItem(barButtonSystemItem: .stop, target: self,
                                    action: #selector(ViewController.resetAll(_:)))
        let highlightThem = UIBarButtonItem(barButtonSystemItem: .play, target: self,
                                            action: #selector(ViewController.highlightSequentially(_:)))
        let moveThem = UIBarButtonItem(barButtonSystemItem: .play, target: self,
                                       action: #selector(ViewController.moveSequentially(_:)))
        let space1 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.setItems([reset, space1, highlightThem, space1, moveThem], animated: true)
        return toolbar
    }()
    
    @objc func resetAll(_ barButtonItem: UIBarButtonItem) {
        for column in 0..<self.noOfColumns {
            labelList[column].frame.origin.y = 0.0
            labelList[column].isHighlighted = false
        }
    }
    
    @objc func highlightSequentially(_ barButtonItem: UIBarButtonItem) {
        let duration = 1.0
        UIView.transition(with: labelList[0], duration: duration, options: .transitionCrossDissolve, animations: {
            self.labelList[0].isHighlighted = true
        }, completion: { _ in
            UIView.transition(with:self.labelList[1], duration: duration, options: .transitionCrossDissolve, animations: {
                self.labelList[1].isHighlighted = true
            }, completion: { _ in
                UIView.transition(with: self.labelList[2], duration: duration, options: .transitionCrossDissolve, animations: {
                    self.labelList[2].isHighlighted = true
                }, completion: { _ in
                    UIView.transition(with: self.labelList[3], duration: duration, options: .transitionCrossDissolve, animations: {
                        self.labelList[3].isHighlighted = true
                    }, completion: { _ in
                        print("I'm done!")
                    })
                })
            })
        })
    }
    
    @objc func moveSequentially(_ barButtonItem: UIBarButtonItem) {
        let duration = 4.0
        let noOfSteps = Double(self.noOfColumns)
        let relativeDuration = 1 / noOfSteps
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: [.calculationModeCubic], animations: {
            for column in 0..<self.noOfColumns {
                let myLabel = self.labelList[column]
                let relativeStartTime = Double(column) / duration
                // Add animations
                UIView.addKeyframe(withRelativeStartTime: relativeStartTime, relativeDuration: relativeDuration, animations: {
                    myLabel.frame.origin.y += 100.0
                })
            }
        }, completion:{ _ in
            print("I'm done!")
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        view.addSubview(toolbar)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        let contentView = UIView()
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            contentView.bottomAnchor.constraint(equalTo: toolbar.topAnchor),
            ])
        
        for column in 0..<noOfColumns {
            contentView.addSubview(labelList[column])
        }
    }
    
}
