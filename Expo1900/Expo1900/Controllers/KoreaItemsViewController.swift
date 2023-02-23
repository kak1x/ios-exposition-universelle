//
//  KoreaItemsViewController.swift
//  Expo1900
//
//  Created by kaki, brody on 2023/02/21.
//

import UIKit

final class KoreaItemsViewController: UIViewController, ReuseIdentifying {
    var reuseIdentifier: String = "cell"
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var expositionItems: [ExpositionUniverselleItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        let result = JSONDecoder().loadJSONData(name: AssetName.items, type: [ExpositionUniverselleItem].self)
        switch result {
        case .success(let items):
            expositionItems = items
            setupTableView()
        case .failure(_):
            showFailAlert()
        }
    }
    
    private func setupNavigation() {
        self.navigationController?.isNavigationBarHidden = false
        self.title = "한국의 출품작"
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension KoreaItemsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expositionItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = expositionItems[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier),
                let image = UIImage(named: item.imageName)  else {
            return UITableViewCell()
        }
        
        var content = cell.defaultContentConfiguration()
        content.image = image.squareImage()
        content.imageToTextPadding = CGFloat(5)
        content.text = item.name
        content.secondaryText = item.shortDescription
        content.textProperties.font = .preferredFont(forTextStyle: .title1)
        content.secondaryTextProperties.font = .preferredFont(forTextStyle: .body)
        cell.contentConfiguration = content
        
        return cell
    }
}

extension KoreaItemsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let itemDetailVC = storyboard?.instantiateViewController(identifier: "ItemDetailViewController", creator: { creator in
            let item = self.expositionItems[indexPath.row]
            let viewController = ItemDetailViewController(item: item, coder: creator)
            return viewController
        }) {
            self.navigationController?.pushViewController(itemDetailVC, animated: true)
        }
    }
}
