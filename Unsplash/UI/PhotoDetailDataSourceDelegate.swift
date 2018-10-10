//
//  PhotoDetailDataSourceDelegate.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 10/10/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import UIKit

final class PhotoDetailDataSourceDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private let photo: PresentablePhoto
    private let imageProvider: ImageProvider
    
    init(photo: PresentablePhoto, imageProvider: ImageProvider) {
        self.photo = photo
        self.imageProvider = imageProvider
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableStructure.count.rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case TableStructure.image.rawValue: return imageCell(tableView)
        case TableStructure.description.rawValue:
            return defaultSubtitleCell(title: "Description", subtitle: photo.description)
        case TableStructure.dateCreated.rawValue:
            return defaultSubtitleCell(title: "Date Created", subtitle: photo.dateCreated)
        case TableStructure.creatorName.rawValue:
            return defaultSubtitleCell(title: "Creator", subtitle: photo.creatorName)
        case TableStructure.creatorPortfolioURL.rawValue:
            return defaultSubtitleCell(title: "Creator's portfolio", subtitle: photo.creatorPortfolioURLString)
        default: return UITableViewCell()
        }
    }
    
    private func imageCell(_ tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell") as! ImageCell
        imageProvider.fetchImage(for: photo.corePhoto) { _ in }
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
