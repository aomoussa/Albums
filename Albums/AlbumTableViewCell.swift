//
//  AlbumTableViewCell.swift
//  Albums
//
//  Created by Ahmed Moussa on 9/26/19.
//  Copyright © 2019 Ahmed Moussa. All rights reserved.
//
// TableViewCell displays the name of an album, the artist, and the album art (thumbnail image).

import UIKit

class AlbumTableViewCell: UITableViewCell {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelArtistName: UILabel!
    @IBOutlet weak var imageAlbumCover: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //rounded corners for album art should equal the radius (or half the view width)
        //the radius may need to be dynamically calculated if cells are to have varying heights
        imageAlbumCover.layer.cornerRadius = 25
        imageAlbumCover.layer.masksToBounds = true
    }
    
    func setup(with album: Album, albumCover: UIImage?) {
        self.labelTitle.text = album.name
        self.labelArtistName.text = album.artistName
        self.labelArtistName.textColor = #colorLiteral(red: 0.4078193307, green: 0.4078193307, blue: 0.4078193307, alpha: 1)
        //since album art is only downloaded on willDisplayCell, recieved image may be nil while image is being downloaded, the AlbumListTableViewController holds the dataSource and will reload the cell with the image on completion of download/fetching
        if let image = albumCover {
            imageAlbumCover.image = image
        }
    }
    
    //prepareForReuse is implemented to delete the album art in order to avoid displaying the wrong image when the cell is reused for a different album
    override func prepareForReuse() {
        imageAlbumCover.image = nil
    }
}
