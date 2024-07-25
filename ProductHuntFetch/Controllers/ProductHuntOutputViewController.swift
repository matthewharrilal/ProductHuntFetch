//
//  ProductHuntOutputViewController.swift
//  ProductHuntFetch
//
//  Created by Space Wizard on 7/23/24.
//

import Foundation
import UIKit

class ProductHuntOutputViewController: UIViewController {
    
    var images: [UIImage] = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.register(ProductHuntTableViewCell.self, forCellReuseIdentifier: ProductHuntTableViewCell.identifier)
        return tableView
    }()
    
    private let networkServiceProtocol: NetworkServiceProtocol
    
    init(networkServiceProtocol: NetworkServiceProtocol) {
        self.networkServiceProtocol = networkServiceProtocol
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        fetchImages()
    }
}

extension ProductHuntOutputViewController  {
    
    func setup() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func fetchImages() {
        Task {
            let (_, imageURLs) = try await networkServiceProtocol.performRequest()
            for await image in await networkServiceProtocol.fetchImagesConcurrently(urls: imageURLs) {
                if let image = image {
                    self.images.append(image)
                    self.addRowForImage()
                }
            }
        }
    }
}

extension ProductHuntOutputViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductHuntTableViewCell.identifier, for: indexPath) as? ProductHuntTableViewCell else { return UITableViewCell() }
        
        cell.configure(image: images[indexPath.row])

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        images.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func addRowForImage() {
        let indexPath = IndexPath(row: images.count - 1, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
    }
}
