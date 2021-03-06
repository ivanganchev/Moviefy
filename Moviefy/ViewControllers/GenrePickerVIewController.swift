//
//  GenrePickerVIewController.swift
//  Moviefy
//
//  Created by A-Team Intern on 24.09.21.
//

import UIKit

protocol GenrePickerViewControllerDelegate: AnyObject {
    func genrePickerViewController(genrePickerViewController: GenrePickerViewController, genre: String)
    func viewDismissed(genrePickerViewController: GenrePickerViewController)
}

class GenrePickerViewController: UIViewController {
    let genreChipsCollectionView = GenreChipsCollectionView()
    let genrePickerViewControllerDataSource = GenrePickerViewControllerDataSource()
    var selectedGenres: [String] = []
    weak var delegate: GenrePickerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.genreChipsCollectionView.genrePickerView.delegate = self
        self.genreChipsCollectionView.genrePickerView.dataSource = self.genrePickerViewControllerDataSource
        
        let gestureTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(animateDismissView))
        self.genreChipsCollectionView.dimmedView.addGestureRecognizer(gestureTapRecognizer)
        
        self.genreChipsCollectionView.doneButton.addTarget(self, action: #selector(self.doneButtonTap), for: .touchUpInside)
        if self.selectedGenres.count == self.genrePickerViewControllerDataSource.getGenres().count {
            self.genreChipsCollectionView.doneButton.isUserInteractionEnabled = false
            self.genreChipsCollectionView.doneButton.setTitleColor(.systemGray, for: .normal)
        }
        
        self.genreChipsCollectionView.closeButton.addTarget(self, action: #selector(self.closeButtonTap), for: .touchUpInside)
        
        self.setupPanGesture()
        
        self.selectRowAtBeginning()
    }
    
    override func loadView() {
        self.view = self.genreChipsCollectionView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.animateShowContainerView()
        self.animateShowDimmedView()
    }
    
    func selectRowAtBeginning() {
        let selectedGenresCount = self.selectedGenres.count
        let allGenresCount = MoviesService.genres.count
        
        guard selectedGenresCount < allGenresCount else {
            self.genreChipsCollectionView.genrePickerView.selectRow(0, inComponent: 0, animated: false)
            return
        }
        
        for i in (0...) {
            guard let genre = self.genrePickerViewControllerDataSource.getGenre(at: i) else {
                return
            }
            if selectedGenres.contains(genre) {
                continue
            } else {
                self.genreChipsCollectionView.genrePickerView.selectRow(i, inComponent: 0, animated: false)
                break
            }
        }
        
    }
    
    func animateShowContainerView() {
        UIView.animate(withDuration: 0.3) {
            self.genreChipsCollectionView.containerViewBottomConstraint?.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func animateShowDimmedView() {
        self.genreChipsCollectionView.dimmedView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.genreChipsCollectionView.dimmedView.alpha = self.genreChipsCollectionView.maxDimmedAlpha
        }
    }
    
    @objc func animateDismissView() {
        UIView.animate(withDuration: 0.3) {
            self.genreChipsCollectionView.containerViewBottomConstraint?.constant = self.genreChipsCollectionView.defaultHeight
            self.view.layoutIfNeeded()
        }
        
        self.genreChipsCollectionView.dimmedView.alpha = self.genreChipsCollectionView.maxDimmedAlpha
        UIView.animate(withDuration: 0.4) {
            self.genreChipsCollectionView.dimmedView.alpha = 0
        } completion: { _ in
            self.delegate?.viewDismissed(genrePickerViewController: self)
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @objc func closeButtonTap() {
        self.delegate?.genrePickerViewController(genrePickerViewController: self, genre: "")
        self.animateDismissView()
    }
    
    @objc func doneButtonTap() {
        guard let chosenGenre = self.genrePickerViewControllerDataSource.getGenre(at: self.genreChipsCollectionView.genrePickerView.selectedRow(inComponent: 0)) else {
            self.animateDismissView()
            return
        }
        
        guard !self.selectedGenres.contains(chosenGenre) else {
            self.animateDismissView()
            return
        }
        
        self.delegate?.genrePickerViewController(genrePickerViewController: self, genre: chosenGenre)
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
        let newHeight = self.genreChipsCollectionView.currentContainerHeight - translation.y
        
        switch gesture.state {
        case .changed:
            if newHeight < self.genreChipsCollectionView.defaultHeight {
                self.genreChipsCollectionView.containerViewHeightConstraint?.constant = newHeight
                self.view.layoutIfNeeded()
            }
        case .ended:
            if newHeight < self.genreChipsCollectionView.dismissibleHeight {
                self.animateDismissView()
            } else if newHeight < self.genreChipsCollectionView.defaultHeight {
                self.animateContainerHeight(height: self.genreChipsCollectionView.defaultHeight)
            }
        default:
            break
        }
    }
    
    func animateContainerHeight(height: CGFloat) {
        UIView.animate(withDuration: 0.4) {
            self.genreChipsCollectionView.containerViewHeightConstraint?.constant = height
            self.view.layoutIfNeeded()
        }
        self.genreChipsCollectionView.currentContainerHeight = height
    }
}

extension GenrePickerViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.genrePickerViewControllerDataSource.getGenre(at: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let index = GenrePickerHelper.getUnselectedGenre(rowNumber: row, allGenres: self.genrePickerViewControllerDataSource.getGenres(), selectedGenres: self.selectedGenres)
        
        pickerView.selectRow(index ?? 0, inComponent: component, animated: true)
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var color: UIColor
        guard let genre = self.genrePickerViewControllerDataSource.getGenre(at: row) else {
            return nil
        }
        
        if selectedGenres.contains(genre) {
            color = UIColor.lightGray
        } else {
            color = UIColor.black
        }
        
        return NSAttributedString(string: genre, attributes: [NSAttributedString.Key.foregroundColor: color])
    }
}
