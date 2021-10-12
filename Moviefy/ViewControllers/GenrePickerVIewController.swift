//
//  GenrePickerVIewController.swift
//  Moviefy
//
//  Created by A-Team Intern on 24.09.21.
//

import Foundation
import UIKit

protocol GenrePickerViewControllerDelegate: AnyObject {
    func getSelectedGenre(genre: String)
}

class GenrePickerViewController: UIViewController {
    let genreChipsCollectionViewLayout = GenreChipsCollectionViewLayout()
    var genres = [String]()
    var selectedGenres: [String] = []
    weak var delegate: GenrePickerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let genres = MoviesService.genres {
            self.genres = Array(genres.values)
        }
        
        self.genreChipsCollectionViewLayout.genrePickerView.delegate = self
        self.genreChipsCollectionViewLayout.genrePickerView.dataSource = self
        
        let gestureTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(animateDismissView))
        self.genreChipsCollectionViewLayout.dimmedView.addGestureRecognizer(gestureTapRecognizer)
        
        self.genreChipsCollectionViewLayout.doneButton.addTarget(self, action: #selector(self.doneButtonTap), for: .touchUpInside)
        if self.selectedGenres.count == self.genres.count {
            self.genreChipsCollectionViewLayout.doneButton.isUserInteractionEnabled = false
            self.genreChipsCollectionViewLayout.doneButton.setTitleColor(.systemGray, for: .normal)
        }
        
        self.genreChipsCollectionViewLayout.closeButton.addTarget(self, action: #selector(self.closeButtonTap), for: .touchUpInside)
        
        self.setupPanGesture()
        
        for i in (0...self.genres.count) {
            if selectedGenres.contains(self.genres[i]) {
                continue
            } else {
                self.genreChipsCollectionViewLayout.genrePickerView.selectRow(i, inComponent: 0, animated: false)
                break
            }
        }
    }
    
    override func loadView() {
        self.view = self.genreChipsCollectionViewLayout
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.animateShowContainerView()
        self.animateShowDimmedView()
    }
    
    func animateShowContainerView() {
        UIView.animate(withDuration: 0.3) {
            self.genreChipsCollectionViewLayout.containerViewBottomConstraint?.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func animateShowDimmedView() {
        self.genreChipsCollectionViewLayout.dimmedView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.genreChipsCollectionViewLayout.dimmedView.alpha = self.genreChipsCollectionViewLayout.maxDimmedAlpha
        }
    }
    
    @objc func animateDismissView() {
        UIView.animate(withDuration: 0.3) {
            self.genreChipsCollectionViewLayout.containerViewBottomConstraint?.constant = self.genreChipsCollectionViewLayout.defaultHeight
            self.view.layoutIfNeeded()
        }
        
        self.genreChipsCollectionViewLayout.dimmedView.alpha = self.genreChipsCollectionViewLayout.maxDimmedAlpha
        UIView.animate(withDuration: 0.4) {
            self.genreChipsCollectionViewLayout.dimmedView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @objc func closeButtonTap() {
        self.delegate?.getSelectedGenre(genre: "")
        self.animateDismissView()
    }
    
    @objc func doneButtonTap() {
        let chosenGenre = self.genres[self.genreChipsCollectionViewLayout.genrePickerView.selectedRow(inComponent: 0)]
        self.delegate?.getSelectedGenre(genre: chosenGenre)
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
        let newHeight = self.genreChipsCollectionViewLayout.currentContainerHeight - translation.y
        
        switch gesture.state {
        case .changed:
            if newHeight < self.genreChipsCollectionViewLayout.defaultHeight {
                self.genreChipsCollectionViewLayout.containerViewHeightConstraint?.constant = newHeight
                self.view.layoutIfNeeded()
            }
        case .ended:
            if newHeight < self.genreChipsCollectionViewLayout.dismissibleHeight {
                self.animateDismissView()
            } else if newHeight < self.genreChipsCollectionViewLayout.defaultHeight {
                self.animateContainerHeight(height: self.genreChipsCollectionViewLayout.defaultHeight)
            }
        default:
            break
        }
    }
    
    func animateContainerHeight(height: CGFloat) {
        UIView.animate(withDuration: 0.4) {
            self.genreChipsCollectionViewLayout.containerViewHeightConstraint?.constant = height
            self.view.layoutIfNeeded()
        }
        self.genreChipsCollectionViewLayout.currentContainerHeight = height
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
            for(firstHalfIndex, secondHalfIndex) in zip(firstHalf, secondHalf) {
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
        var color: UIColor
        if selectedGenres.contains(self.genres[row]) {
            color = UIColor.lightGray
        } else {
            color = UIColor.black
        }
        
        return NSAttributedString(string: self.genres[row], attributes: [NSAttributedString.Key.foregroundColor: color])
    }
}
