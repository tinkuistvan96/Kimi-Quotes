//
//  QuoteListViewViewModel.swift
//  KimiQuote
//
//  Created by Tinku István on 23/08/2024.
//

import UIKit

protocol QuoteListViewViewModelDelegate: AnyObject {
    func didFinishLoadData(_ quoteListViewViewModel: QuoteListViewViewModel)
    func quoteListViewViewModel(_ quoteListViewViewModel: QuoteListViewViewModel, didSelectQuote quote: Quote)
    func quoteListViewViewModel(_ quoteListViewViewModel: QuoteListViewViewModel, didFinishLoadWithError error: String)
}

class QuoteListViewViewModel: NSObject {
    private var cellViewModels = [QuoteCellViewModel]()
    weak var delegate: QuoteListViewViewModelDelegate?
    private var hasLoaded = false
    private var quotes : [Quote] = [] {
        didSet {
            for quote in quotes {
                let quoteCellViewModel = QuoteCellViewModel(quoteText: quote.quote, imageName: quote.imageName)
                if !cellViewModels.contains(quoteCellViewModel) {
                    cellViewModels.append(quoteCellViewModel)
                }
            }
        }
    }
}

//MARK: - CollectionView Delegate Methods
extension QuoteListViewViewModel: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QuoteCollectionViewCell.cellIdentifier, for: indexPath) as? QuoteCollectionViewCell else {
            fatalError("Unsupported cell")
        }
        cell.configure(with: cellViewModels[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let selectedQuote = quotes[indexPath.row]
        delegate?.quoteListViewViewModel(self, didSelectQuote: selectedQuote)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 8, bottom: 8, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width - 36) / 2
        return CGSize(width: width, height: width * 1.5)
    }
}

//MARK: - Networking
extension QuoteListViewViewModel {
    func fetchQuotes() {
        if hasLoaded {
            delegate?.didFinishLoadData(self)
            return
        }
        quotes.removeAll()
        APIService.shared.getJSON(urlString: "https://kimiquotes.pages.dev/api/quotes") { [weak self] (result: Result<[Quote], APIService.APIError>) in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let quotes):
                strongSelf.hasLoaded = true
                strongSelf.quotes = quotes
                DispatchQueue.main.async {
                    strongSelf.delegate?.didFinishLoadData(strongSelf)
                }
            case .failure(let failure):
                switch failure {
                case .error(let apiError):
                    print(apiError)
                    DispatchQueue.main.async {
                        strongSelf.delegate?.quoteListViewViewModel(strongSelf, didFinishLoadWithError: apiError)
                    }
                }
            }
        }
        
    }
}
