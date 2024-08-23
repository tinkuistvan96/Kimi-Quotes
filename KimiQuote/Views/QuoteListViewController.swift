//
//  QuoteListViewController.swift
//  KimiQuote
//
//  Created by Tinku István on 2022. 04. 23..
//

import UIKit

class QuoteListViewController: UIViewController {
    
    let quoteListView = QuoteListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
        quoteListView.delegate = self
    }
}

extension QuoteListViewController {
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
        view.addSubview(quoteListView)
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            quoteListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            quoteListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            quoteListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            quoteListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

extension QuoteListViewController: QuoteListViewDelegate {
    func quoteListView(_ quoteListView: QuoteListView, didSelectQuote quote: Quote) {
        let quoteViewModel = QuoteCellViewModel(quoteText: quote.quote, imageName: quote.imageName)
        let quoteViewController = QuoteDetailViewController(viewModel: quoteViewModel)
        self.navigationController?.pushViewController(quoteViewController, animated: true)
    }
}
