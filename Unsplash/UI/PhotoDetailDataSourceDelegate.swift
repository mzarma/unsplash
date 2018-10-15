//
//  PhotoDetailDataSourceDelegate.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 10/10/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import UIKit

final class PhotoDetailDataSourceDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private let photoDetails: PresentablePhotoDetails
    private let imageProvider: ImageProvider
    
    init(photoDetails: PresentablePhotoDetails, imageProvider: ImageProvider) {
        self.photoDetails = photoDetails
        self.imageProvider = imageProvider
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableStructure.count.rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case TableStructure.image.rawValue: return imageCell(tableView)
        case TableStructure.description.rawValue:
            return defaultSubtitleCell(title: photoDetails.descriptionTitle, subtitle: photoDetails.description)
        case TableStructure.dateCreated.rawValue:
            return defaultSubtitleCell(title: photoDetails.dateCreatedTitle, subtitle: photoDetails.dateCreated)
        case TableStructure.creatorName.rawValue:
            return defaultSubtitleCell(title: photoDetails.creatorNameTitle, subtitle: photoDetails.creatorName)
        case TableStructure.creatorPortfolioURL.rawValue:
            return defaultSubtitleCell(title: photoDetails.portfolioURLTitle, subtitle: photoDetails.creatorPortfolioURLString)
        default: return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case TableStructure.image.rawValue: return 350
        default: return 60
        }
    }
    
    private func imageCell(_ tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell") as! ImageCell
        imageProvider.fetchImage(for: photoDetails.corePhoto) { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    cell.photoImage = image
                }
            case .error(_): break
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    
    private func defaultSubtitleCell(title: String, subtitle: String?) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = subtitle
        cell.selectionStyle = .none
        return cell
    }
}

private enum TableStructure: Int {
    case image = 0
    case description
    case dateCreated
    case creatorName
    case creatorPortfolioURL
    case count
}
