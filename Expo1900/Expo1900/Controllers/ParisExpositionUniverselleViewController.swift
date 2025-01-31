//
//  Expo1900 - ParisExpositionUniverselleViewController.swift
//  Created by kaki, brody.
//  Copyright © yagom academy. All rights reserved.
// 

import UIKit

final class ParisExpositionUniverselleViewController: UIViewController {
    @IBOutlet private weak var expositionTitle: UILabel!
    @IBOutlet private weak var expositionPoster: UIImageView!
    @IBOutlet private weak var expositionVisitors: UILabel!
    @IBOutlet private weak var expositionLocation: UILabel!
    @IBOutlet private weak var expositionDuration: UILabel!
    @IBOutlet private weak var expositionDescription: UILabel!
    @IBOutlet private weak var flagImage1: UIImageView!
    @IBOutlet private weak var flagImage2: UIImageView!
    
    private var expositionData: ExpositionUniverselle?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "메인"
        do {
            expositionData = try JSONDecoder().loadJSONData(name: AssetName.exposition, type: ExpositionUniverselle.self)
            setupUI()
        } catch {
            showFailAlert()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func setupUI() {
        guard let expositionData = expositionData else { return }
        
        expositionTitle.text = expositionData.displayedTitle
        expositionPoster.image = UIImage(named: AssetName.poster)
        expositionPoster.accessibilityLabel = "파리 만국박람회 포스터"
        expositionVisitors.attributedText = expositionData.displayedNumberOfVisitor.attributedString
        expositionLocation.attributedText = expositionData.displayedLocation.attributedString
        expositionDuration.attributedText = expositionData.displayedDuration.attributedString
        expositionDescription.text = expositionData.description
        flagImage1.image = UIImage(named: AssetName.flag)
        flagImage2.image = UIImage(named: AssetName.flag)
    }
}

fileprivate extension String {
    var attributedString: NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        guard let index = self.firstIndex(of: ":") else { return attributedString }
        
        let range = String(self[index...])
        attributedString.addAttribute(.font, value: UIFont.preferredFont(forTextStyle: .subheadline), range: (self as NSString).range(of: range))
        
        return attributedString
    }
}
