//
//  HomeViewController.swift
//  KimiQuote
//
//  Created by Tinku István on 2022. 04. 23..
//

import UIKit

class HomeViewController: UIViewController {
    var hasLoaded = false
    var quotes = [Quote]()
    var quoteCellViewModels: [QuoteViewModel] = []
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let refreshControl = UIRefreshControl()
    let activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
        fetchQuotes()
    }
}


extension HomeViewController {
    private func style() {
        view.backgroundColor = UIColor.appBackgroundColor
        
        title = "Kimi Quotes"
        
        guard let navController = self.navigationController else { return }
        navController.navigationBar.isTranslucent = true
        navController.navigationBar.barStyle = .black
        navController.navigationBar.tintColor = UIColor.white
        navController.navigationBar.barTintColor = UIColor.appBackgroundColor
        navController.navigationBar.shadowImage = UIImage()
        navController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        let avatarView = AvatarView()
        let leftBarButtonItem = UIBarButtonItem(customView: avatarView)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        refreshControl.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
        refreshControl.tintColor = .systemRed
        collectionView.refreshControl = refreshControl
        collectionView.backgroundColor = UIColor.appBackgroundColor
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(QuoteCell.self, forCellWithReuseIdentifier: QuoteCell.reuseIdentifier)
        view.addSubview(collectionView)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .systemRed
        collectionView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc func refreshContent() {
        guard let refreshControl = collectionView.refreshControl else { return }
        fetchQuotes()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            refreshControl.endRefreshing()
            self?.collectionView.reloadData()
        }
    }
}


//MARK: - FlowLayout Delegate Methods
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 8, bottom: 8, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - 36) / 2
        return CGSize(width: width, height: width * 1.5)
    }
}

//MARK: - CollectionView Delegate Methods
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        quoteCellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QuoteCell.reuseIdentifier, for: indexPath) as! QuoteCell
        cell.configure(with: quoteCellViewModels[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let quoteVC = QuoteViewController(quoteViewModel: quoteCellViewModels[indexPath.row])
        //quoteVC.modalTransitionStyle = .coverVertical
        //quoteVC.modalPresentationStyle = .fullScreen
        //present(quoteVC, animated: true)
        navigationController?.pushViewController(quoteVC, animated: true)
    }
}

//MARK: - Networking
extension HomeViewController {
    func fetchQuotes() {
        if hasLoaded {
            quotes.shuffle()
            reloadView()
        } else {
            quotes.removeAll()
            APIService.shared.getJSON(urlString: "https://kimiquotes.herokuapp.com/quotes") { [weak self] (result: Result<[Quote], APIService.APIError>) in
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    self?.activityIndicator.removeFromSuperview()
                    switch result {
                    case .success(let quotes):
                        self?.hasLoaded = true
                        self?.quotes = quotes
                        self?.reloadView()
                    case .failure(let failure):
                        switch failure {
                        case .error(let apiError):
                            let alert = UIAlertController(title: "Error", message: apiError, preferredStyle: .alert)
                            let alertAction = UIAlertAction(title: "Ok", style: .cancel)
                            alert.addAction(alertAction)
                            self?.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    private func reloadView() {
        configureCollectionCells(with: quotes)
        collectionView.reloadData()
    }
    
    private func configureCollectionCells(with quotes: [Quote]) {
        quoteCellViewModels = quotes.map {
            QuoteViewModel(quote: $0.quote, image: KimiImages.getImage())
        }
    }
}
