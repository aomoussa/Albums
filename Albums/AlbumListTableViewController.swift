//
//  AlbumListTableViewController.swift
//  Albums
//
//  Created by Ahmed Moussa on 9/26/19.
//  Copyright © 2019 Ahmed Moussa. All rights reserved.
//
/*
 Displays UITableView showing one album per cell. Each cell displays the name of the album, the artist, and the album art (thumbnail image).
 Tapping on a cell should push another view controller onto the navigation stack with more details about the album
*/

import UIKit

class AlbumListTableViewController: UITableViewController {

    private var albums = [Album]()
    private var downloadedAlbumCovers = [UIImage?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Albums"
        self.navigationController?.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        tableView.register(UINib(nibName: "AlbumTableViewCell", bundle: Bundle(for: AlbumTableViewCell.self)), forCellReuseIdentifier: "AlbumTableViewCell")
        fetchAlbums()
    }
    
    //function to fetch albums on loading, this may also be used to reload the albums if necessary
    private func fetchAlbums() {
        JsonHelper.fetchJson(completion: { (albums) in
            self.albums = albums
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            //downloaded album art images array should always be equal in count to the albums array, an alternative solution is to store the optional image with the album in a model struct or class, this would be more justified if lazy loading is required
            albums.forEach({_ in self.downloadedAlbumCovers.append(nil)})
        })
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumTableViewCell", for: indexPath) as! AlbumTableViewCell
        cell.setup(with: albums[indexPath.row], albumCover: downloadedAlbumCovers[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //album art images are fetched only on display of a cell for quicker loading of the tableView, the images are stored on fetch completion and are updated on the UI be reloading the specific cell that's been displayed
        guard self.downloadedAlbumCovers[indexPath.row] == nil else { return }
        ImageFileHelper.fetchImage(for: albums[indexPath.row].artworkUrl100, completion: { image in
            self.downloadedAlbumCovers[indexPath.row] = image
            DispatchQueue.main.async {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        })
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "AlbumDetailsViewController", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //the selected cell details are passed to the detail VC using the tableview's selected indexPath
        if let destinationVC = segue.destination as? AlbumDetailsViewController, let i = tableView.indexPathForSelectedRow?.row {
            destinationVC.setup(with: albums[i])
        }
    }
}
