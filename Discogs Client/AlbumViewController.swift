//
//  AlbumViewController.swift
//  Discogs Client
//
//  Created by Leonid Petrov on 22/04/2018.
//  Copyright © 2018 Leonid Petrov. All rights reserved.
//

import UIKit
import AlamofireImage
import FSPagerView

class AlbumViewController: UIViewController {
    
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var albumTitleLabel: UILabel!
    @IBOutlet weak var yearOfReleaseLabel: UILabel!
    @IBOutlet weak var tracksTableView: UITableView!
    
    var album: Album?

    @IBOutlet weak var albumPagerView: FSPagerView! {
        didSet {
            self.albumPagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        albumPagerView.dataSource = self
        albumPagerView.delegate = self
        
        artistNameLabel.text = album?.title
        yearOfReleaseLabel.text = "\(album?.year ?? 0)"
        albumTitleLabel.text = album?.title
        
        album?.getAlbumDetails(completion: {
            self.tracksTableView.reloadData()
        })
    }
    
}

extension AlbumViewController: FSPagerViewDataSource, FSPagerViewDelegate {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return album?.image?.count ?? 0
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = albumPagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        guard let url = URL(string: (album?.qualityImage)!) else { return cell }
        cell.imageView?.af_setImage(withURL: url, placeholderImage: #imageLiteral(resourceName: "product--preview"))
        return cell
    }
}

extension AlbumViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return album?.tracklist.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tracksTableView.dequeueReusableCell(withIdentifier: "albumCell") as! AlbumTableViewCell
        cell.trackNumberLabel.text = String(indexPath.row + 1)
        cell.trackNameLabel.text = album?.tracklist[indexPath.row]
        return cell
    }
    
    
}
