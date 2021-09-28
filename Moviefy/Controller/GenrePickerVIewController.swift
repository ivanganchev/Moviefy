//
//  GenrePickerVIewController.swift
//  Moviefy
//
//  Created by A-Team Intern on 24.09.21.
//

import Foundation
import UIKit

class GenrePickerViewController: UIViewController {
    let maxDimmedAlpha: CGFloat = 0.6
    let defaultHeight: CGFloat = 300
    var currentContainerHeight: CGFloat = 300
    let dismissibleHeight: CGFloat = 200
    // Тук също не съм сигурен
    var genres: [String] = Array(MoviesService.genres!.values)
    var selectedGenres: [String] = []
    var onDoneBlock: ((String) -> Void)?
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view .clipsToBounds = true
        return view
    }()
    
    lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = self.maxDimmedAlpha
        return view
    }()
    
    lazy var genrePickerView: UIPickerView = {
        let genrePickerView = UIPickerView()
        genrePickerView.delegate = self
        genrePickerView.dataSource = self
        return genrePickerView
    }()
    
    lazy var barView: UIView = {
        let barView = UIView()
        barView.backgroundColor = .lightGray
        
        let doneButton = UIButton()
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(.systemBlue, for: .normal)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.addTarget(self, action: #selector(self.doneButtonTap), for: .touchUpInside)
        if self.selectedGenres.count == self.genres.count {
            doneButton.isUserInteractionEnabled = false
            doneButton.setTitleColor(.systemGray, for: .normal)
        }
        
        let closeButton = UIButton()
        closeButton.setTitle("Close", for: .normal)
        closeButton.setTitleColor(.systemBlue, for: .normal)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(self.closeButtonTap), for: .touchUpInside)
        
        let titleLabel = UILabel()
        titleLabel.text = "Genres"
        titleLabel.font = UIFont(name: "Helvetica", size: 18)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.sizeToFit()
        
        barView.addSubview(doneButton)
        barView.addSubview(closeButton)
        barView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalTo: barView.leadingAnchor, constant: 10),
            closeButton.topAnchor.constraint(equalTo: barView.topAnchor),
            closeButton.bottomAnchor.constraint(equalTo: barView.bottomAnchor),
            
            doneButton.trailingAnchor.constraint(equalTo: barView.trailingAnchor, constant:  -10),
            doneButton.topAnchor.constraint(equalTo: barView.topAnchor),
            doneButton.bottomAnchor.constraint(equalTo: barView.bottomAnchor),
            
            titleLabel.centerXAnchor.constraint(equalTo: barView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: barView.centerYAnchor)
        ])
        
        return barView
    }()
    
    var containerViewHeightConstraint: NSLayoutConstraint?
    var containerViewBottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        self.setupConstraints()
        self.setupPanGesture()
        
        for i in (0...self.genres.count) {
            if selectedGenres.contains(self.genres[i]) {
                continue
            } else {
                self.genrePickerView.selectRow(i, inComponent: 0, animated: false)
                break
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.animateShowContainerView()
        self.animateShowDimmedView()
    }
    
    func setupConstraints() {
        self.view.addSubview(self.dimmedView)
        self.view.addSubview(self.containerView)
        self.dimmedView.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        let gestureTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(animateDismissView))
        self.dimmedView.addGestureRecognizer(gestureTapRecognizer)
        
        self.containerView.addSubview(self.genrePickerView)
        self.containerView.addSubview(self.barView)
        self.genrePickerView.translatesAutoresizingMaskIntoConstraints = false
        self.barView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.dimmedView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.dimmedView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.dimmedView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.dimmedView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            self.containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        
        self.containerViewHeightConstraint = self.containerView.heightAnchor.constraint(equalToConstant: self.defaultHeight)
        self.containerViewBottomConstraint = self.containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: self.defaultHeight)
        
        self.containerViewHeightConstraint?.isActive = true
        self.containerViewBottomConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            self.barView.topAnchor.constraint(equalTo: self.containerView.topAnchor),
            self.barView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
            self.barView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor),
            self.barView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            self.genrePickerView.topAnchor.constraint(equalTo: self.barView.bottomAnchor),
            self.genrePickerView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor),
            self.genrePickerView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
            self.genrePickerView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor)
        ])
    }
    
    func animateShowContainerView() {
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func animateShowDimmedView() {
        self.dimmedView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = self.maxDimmedAlpha
        }
    }
    
    @objc func animateDismissView() {
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = self.defaultHeight
            self.view.layoutIfNeeded()
        }
        
        self.dimmedView.alpha = maxDimmedAlpha
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @objc func closeButtonTap() {
        self.onDoneBlock!("")
        self.animateDismissView()
    }
    
    @objc func doneButtonTap() {
        let chosenGenre = self.genres[self.genrePickerView.selectedRow(inComponent: 0)]
        self.onDoneBlock!(chosenGenre)
        self.animateDismissView()
    }
    
    func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanAction(gesture:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        self.view.addGestureRecognizer(panGesture)
    }
    
    @objc func handlePanAction(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.view)
        let newHeight = self.currentContainerHeight - translation.y
        
        switch gesture.state {
        case .changed:
            if newHeight < self.defaultHeight {
                self.containerViewHeightConstraint?.constant = newHeight
                self.view.layoutIfNeeded()
            }
        case .ended:
            if newHeight < self.dismissibleHeight {
                self.animateDismissView()
            } else if newHeight < defaultHeight {
                self.animateContainerHeight(height: defaultHeight)
            }
        default:
            break
        }
    }
    
    func animateContainerHeight(height: CGFloat) {
        UIView.animate(withDuration: 0.4) {
            self.containerViewHeightConstraint?.constant = height
            self.view.layoutIfNeeded()
        }
        self.currentContainerHeight = height
    }
}

extension GenrePickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.genres.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let row = self.genres[row]
        return row
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var index = 0
        
        let firstHalf: [Int] = Array(0..<row).reversed()
        let secondHalf: [Int] = Array((row + 1)...self.genres.count)
        
        if self.selectedGenres.contains(self.genres[row]) {
            for(firstHalfIndex,secondHalfIndex) in zip(firstHalf, secondHalf) {
                if !(self.selectedGenres.contains(self.genres[firstHalfIndex])) {
                    index = firstHalfIndex
                    break
                } else if !(self.selectedGenres.contains(self.genres[secondHalfIndex])) {
                    index = secondHalfIndex
                    break
                }
            }
            
            if index == 0 {
                if firstHalf.count < secondHalf.count {
                    for i in (secondHalf[firstHalf.count]...secondHalf.count) {
                        if !(self.selectedGenres.contains(self.genres[i])) {
                            index = i
                            break
                        }
                    }
                } else {
                    for i in (0...firstHalf[secondHalf.count]).reversed() {
                        if !(self.selectedGenres.contains(self.genres[i])) {
                            index = i
                            break
                        }
                    }
                }
            }
        } else {
            index = row
        }

        pickerView.selectRow(index, inComponent: component, animated: true)
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let color: UIColor
        if selectedGenres.contains(self.genres[row]){
            color = UIColor.lightGray
        } else {
            color = UIColor.black
        }
        
        return NSAttributedString(string: self.genres[row], attributes: [NSAttributedString.Key.foregroundColor: color])
    }
}
