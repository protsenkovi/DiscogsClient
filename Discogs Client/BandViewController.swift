//
//  BandViewController.swift
//  Discogs Client
//
//  Created by Leonid Petrov on 25/01/2018.
//  Copyright © 2018 Leonid Petrov. All rights reserved.
//

import UIKit
import AlamofireImage
import FSPagerView

class BandViewController: UIViewController {

    @IBOutlet weak var bandTableView: UITableView!
    @IBAction func artistPhotoPressed(_ sender: Any) {
        let image = selectedArtistImage?.imageView?.image
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        
        let alert = UIAlertController(title: "Saved", message: "Your image has been saved", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        }
    }
    
    let imageCache = AutoPurgingImageCache()
   
    var albumList = [Album]()
    var artistImageList = [String]()
    var artistId = 0
    var artistName = ""
    var artistImage = ""
    var selectedArtistImage: FSPagerViewCell?
    var selectedAlbum: Album?
    
    let  cachesDirectory =  FileManager.default.urls(for : .cachesDirectory,  in: .userDomainMask).first
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailedAlbums"{
            let vc = segue.destination as! AlbumViewController
            vc.album = selectedAlbum
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pagerView.dataSource = self
        pagerView.delegate = self
        
        pagerView.transformer = FSPagerViewTransformer(type: .depth)
        
        bandTableView.rowHeight = UITableViewAutomaticDimension
        bandTableView.estimatedRowHeight = 140
        
        print(cachesDirectory)
        
        Album.getAlbums(artistId: artistId, completion: { [weak self] albumList in
            self?.albumList = albumList
            self?.bandTableView.reloadData()
        } )
        
        Album.getArtistImages(artistId: artistId, completion: {[weak self] imageToAppend in
            self?.artistImageList = imageToAppend
            self?.pagerView.reloadData()
        })
        
//        SearchService.getArtist(name: artistName, completion: { [weak self] artist in
//            self?.artistImage = artist.image!
//            
//            self?.bandImage.af_setImage(withURL: URL(string: (self?.artistImage)!)!, placeholderImage: #imageLiteral(resourceName: "product--preview"), filter: AspectScaledToFillSizeWithRoundedCornersFilter(size: (self?.bandImage.frame.size)!, radius: 20.0))
//        })
        
        
    }
}

extension BandViewController: FSPagerViewDataSource, FSPagerViewDelegate {
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return artistImageList.count
    }
   
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        guard let url = URL(string: artistImageList[index]) else { return cell }
        guard let size = cell.imageView?.frame.size else { return cell }
//        if size.height || size.width > 0 {
        cell.imageView?.af_setImage(withURL: url, placeholderImage: #imageLiteral(resourceName: "product--preview"))
        selectedArtistImage = cell
//        }
//            cell.textLabel?.text = ...
        return cell
    }
}


extension BandViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       selectedAlbum = albumList[indexPath.row]
        self.performSegue(withIdentifier: "toDetailedAlbums", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = bandTableView.dequeueReusableCell(withIdentifier: "bandTableViewCell") as! BandViewCell
        
        let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
            size: cell.albumImage.frame.size,
            radius: 20.0
        )
        
        let currentAlbum = albumList[indexPath.row]
        cell.albumName.text = currentAlbum.title
        cell.albumDate.text = String(describing: currentAlbum.year!)
        guard let url = currentAlbum.image else { return cell }
        guard let tempUrl = URL(string: url) else { return cell }
        cell.albumImage.af_setImage(withURL: tempUrl, placeholderImage: #imageLiteral(resourceName: "product--preview"), filter: filter, imageTransition: .crossDissolve(0.2))
        return cell
    }
}
