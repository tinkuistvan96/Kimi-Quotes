//
//  QuoteListView.swift
//  KimiQuote
//
//  Created by Tinku István on 23/08/2024.
//

import UIKit

protocol QuoteListViewDelegate: AnyObject {
    func quoteListView(_ quoteListView: QuoteListView, didSelectQuote quote: Quote)
}

class QuoteListView: UIView {
    
    private let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.appBackgroundColor
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.register(QuoteCollectionViewCell.self, forCellWithReuseIdentifier: QuoteCollectionViewCell.cellIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let activityIndicator : UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .systemRed
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    let refreshControl = UIRefreshControl()
    private let viewModel = QuoteListViewViewModel()
    weak var delegate: QuoteListViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
        layout()
        viewModel.delegate = self
        activityIndicator.startAnimating()
        viewModel.fetchQuotes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 200, height: 200)
    }
}

extension QuoteListView {
    
    func style() {
        translatesAutoresizingMaskIntoConstraints = false
        refreshControl.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
        refreshControl.tintColor = .systemRed
        
        collectionView.refreshControl = refreshControl
        collectionView.delegate = viewModel
        collectionView.dataSource = viewModel
        addSubview(collectionView)
        addSubview(activityIndicator)
    }
    
    func layout() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            activityIndicator.heightAnchor.constraint(equalToConstant: 100),
            activityIndicator.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    @objc func refreshContent() {
        guard let refreshControl = collectionView.refreshControl else { return }
        viewModel.fetchQuotes()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            refreshControl.endRefreshing()
            self?.collectionView.reloadData()
        }
    }
}

extension QuoteListView: QuoteListViewViewModelDelegate {
    func quoteListViewViewModel(_ quoteListViewViewModel: QuoteListViewViewModel, didSelectQuote quote: Quote) {
        delegate?.quoteListView(self, didSelectQuote: quote)
    }
    
    func quoteListViewViewModel(_ quoteListViewViewModel: QuoteListViewViewModel, didFinishLoadWithError error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .cancel)
        alert.addAction(alertAction)
        //present(alert, animated: true, completion: nil)
        //TODO: - Create a reusable alert view to present errors
    }
    
    func didFinishLoadData(_ homeViewViewModel: QuoteListViewViewModel) {
        activityIndicator.stopAnimating()
        collectionView.isHidden = false
        collectionView.reloadData()
        UIView.animate(withDuration: 0.4) {
            self.collectionView.alpha = 1
        }
    }
}
