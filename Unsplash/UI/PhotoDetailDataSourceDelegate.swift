//
//  PhotoDetailDataSourceDelegate.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 10/10/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import UIKit

fileprivate let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM d, yyyy"
    return formatter
}()

struct PresentablePhotoDetails {
    let corePhoto: CorePhoto
    
    var description: String {
        return corePhoto.description
    }
    
    var dateCreated: String {
        return dateFormatter.string(from: corePhoto.dateCreated)
    }
    
    var creatorName: String {
        return corePhoto.creatorName
    }

    var creatorPortfolioURLString: String? {
        return corePhoto.creatorPortfolioURLString
    }
}

final class PhotoDetailDataSourceDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private let photoDetails: PresentablePhotoDetails
    private let imageProvider: ImageProvider
    
    init(photo: PresentablePhotoDetails, imageProvider: ImageProvider) {
        self.photoDetails = photo
        self.imageProvider = imageProvider
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableStructure.count.rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case TableStructure.image.rawValue: return imageCell(tableView)
        case TableStructure.description.rawValue:
            return defaultSubtitleCell(title: "Description", subtitle: photoDetails.description)
        case TableStructure.dateCreated.rawValue:
            return defaultSubtitleCell(title: "Date Created", subtitle: photoDetails.dateCreated)
        case TableStructure.creatorName.rawValue:
            return defaultSubtitleCell(title: "Creator", subtitle: photoDetails.creatorName)
        case TableStructure.creatorPortfolioURL.rawValue:
            return defaultSubtitleCell(title: "Creator's Portfolio", subtitle: photoDetails.creatorPortfolioURLString)
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
        return cell
    }
    
    private func defaultSubtitleCell(title: String, subtitle: String?) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = subtitle
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
