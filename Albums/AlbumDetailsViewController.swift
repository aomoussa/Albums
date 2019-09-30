//
//  AlbumDetailsViewController.swift
//  Albums
//
//  Created by Ahmed Moussa on 9/26/19.
//  Copyright © 2019 Ahmed Moussa. All rights reserved.
//
/*
 Displays album details with a larger album cover image at the top of the screen and the same information that is shown for an album cell, plus genre, release date, and copyright info below the image.
 A button is to be displayed on this detail view that when tapped launches the album url. The button should be centered horizontally and pinned 20 points from the bottom of the view and 20 points from the leading and trailing edges of the view.
 */

import UIKit

class AlbumDetailsViewController: UIViewController {

    @IBOutlet weak var imageAlbumCover: UIImageView!
    @IBOutlet weak var labelAlbumTitle: UILabel!
    @IBOutlet weak var labelArtistName: UILabel!
    @IBOutlet weak var labelReleaseDateAndGenre: UILabel!
    @IBOutlet weak var labelCopyright: UILabel!
    @IBOutlet weak var btnItunesLink: UIButton!
    
    private var album: Album?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        guard let album = self.album else { return }
        self.title = album.name
        self.labelAlbumTitle.text = album.name
        self.labelArtistName.text = album.artistName
        self.labelCopyright.text = album.copyright
        let releaseDate = (album.releaseDate).replacingOccurrences(of: "-", with: "/")
        self.labelReleaseDateAndGenre.text = "\(releaseDate) - \(album.genres.first?.name ?? "")"
        ImageFileHelper.fetchImage(for: album.artworkUrl100, completion: { image in
            DispatchQueue.main.async {
                self.imageAlbumCover.image = image
            }
        })
        imageAlbumCover.layer.cornerRadius = 10
        imageAlbumCover.layer.masksToBounds = true
        btnItunesLink.layer.cornerRadius = 10
        btnItunesLink.layer.masksToBounds = true
    }
    
    public func setup(with album: Album) {
        self.album = album
    }
    
    @IBAction func btnITunesLinkTap(_ sender: Any) {
        if let urlString = album?.url, let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}
