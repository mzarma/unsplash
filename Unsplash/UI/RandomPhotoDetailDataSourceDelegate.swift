//
//  RandomPhotoDetailDataSourceDelegate.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 19/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import UIKit

class RandomPhotoDetailDataSourceDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private let photo: PresentableRandomPhoto
    private let image: UIImage
    
    init(photo: PresentableRandomPhoto, image: UIImage) {
        self.photo = photo
        self.image = image
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableStructure.count.rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case TableStructure.image.rawValue: return imageCell(tableView)
        case TableStructure.description.rawValue: return descriptionCell()
        case TableStructure.dateCreated.rawValue: return dateCreatedCell()
        case TableStructure.creatorName.rawValue: return creatorNameCell()
        default: return UITableViewCell()
        }
    }
    
    private func imageCell(_ tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell") as! ImageCell
        cell.photoImage = image
        return cell
    }
    
    private func descriptionCell() -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = "Description"
        cell.detailTextLabel?.text = photo.description
        return cell
    }
    
    private func dateCreatedCell() -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = "Date Created"
        cell.detailTextLabel?.text = photo.dateCreated
        return cell
    }
    
    private func creatorNameCell() -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = "Creator"
        cell.detailTextLabel?.text = photo.creatorName
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

