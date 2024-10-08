//
//  QuoteDetailViewController.swift
//  KimiQuote
//
//  Created by Tinku István on 2022. 05. 26..
//

import UIKit

class QuoteDetailViewController: UIViewController {
    
    let label = UILabel()
    let imageView = UIImageView()
    let detailView: QuoteDetailView
    var viewModel : QuoteCellViewModel!
    
    init(viewModel: QuoteCellViewModel) {
        self.viewModel = viewModel
        self.detailView = QuoteDetailView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
    }
}


extension QuoteDetailViewController {
    private func style() {
        
        view.backgroundColor = UIColor.appBackgroundColor
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward.circle"), style: .done, target: self, action: #selector(handleBackTap))
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: viewModel.imageName)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = viewModel.quoteText
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.numberOfLines = 0
    }
    
    private func layout() {
        view.addSubview(imageView)
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: view.bounds.height / 3),
            
            label.topAnchor.constraint(equalToSystemSpacingBelow: imageView.bottomAnchor, multiplier: 2),
            label.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: label.trailingAnchor, multiplier: 1)
        ])
    }
    
    @objc
    func handleBackTap() {
        navigationController?.popViewController(animated: true)
    }
}
