//
//  ViewController.swift
//  Ciroflix
//
//  Created by Ciro Vitale on 24/09/2020.
//  Copyright © 2020 Ciro Vitale. All rights reserved.
//

import UIKit
import RealmSwift


class ViewController: UIViewController {
    
//    MARK - SCROLL VIEW
    lazy var ContentViewSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 500)
    
    
    lazy var scrollView : UIView = {
        let view = UIScrollView(frame: .zero)
        view.backgroundColor = UIColorFromRGB(rgbValue: 0xe8ffff)
        view.contentSize = ContentViewSize
        view.frame = self.view.bounds
        view.autoresizingMask = .flexibleHeight
        view.showsVerticalScrollIndicator = false
        view.bounces = true
        return view
    }()
    
    
    lazy var containerView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColorFromRGB(rgbValue: 0xe8ffff)
        view.frame.size = ContentViewSize
        return view
    }()
    
    
//    MARK - VARIABLES
        private var nowPlayingViewModel = MovieViewModel()
        private var latestViewModel = MovieViewModel()
        private var ViewModel = MovieViewModel()
        var service = TMDBService()
        var movie : Movie?
        var movieDetails : Movie?
        var LatestMovieLaber = UILabel()
        var PopularMovieLaber = UILabel()
        var nowPlayingMoviewLabel = UILabel()
        var TitleToSend = [UILabel]()
        var posterToSend = [UIImageView]()
        var descriptionToSend = [UILabel]()
        var rateToSend = [UILabel]()
        var yearToSend = [UILabel]()
        var upcomingTitleToSend = [UILabel]()
        var upcomingposterToSend = [UIImageView]()
        var upcomingdescriptionToSend = [UILabel]()
        var upcomingrateToSend = [UILabel]()
        var upcomingyearToSend = [UILabel]()
        var nowPlayingTitleToSend = [UILabel]()
        var nowPlayingposterToSend = [UIImageView]()
        var nowPlayingdescriptionToSend = [UILabel]()
        var nowPlayingrateToSend = [UILabel]()
        var nowPlayingyearToSend = [UILabel]()
        var timer : Timer!
    
    
//    MARK - COLLECTION VIEWS
    fileprivate let upcomingCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv1 = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv1.translatesAutoresizingMaskIntoConstraints = false
        cv1.register(TVCell.self, forCellWithReuseIdentifier: "upcomingcells")
        return cv1
    }()
    
    fileprivate let nowPlayingCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv1 = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv1.translatesAutoresizingMaskIntoConstraints = false
        cv1.register(TVCell.self, forCellWithReuseIdentifier: "nowPlayingcells")
        return cv1
    }()
    
    
    fileprivate let popularCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(TVCell.self, forCellWithReuseIdentifier: "popularcells")
        return cv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Visual()
        loadMovies()
        loadLatestMovies()
        loadNowPlayingMoview()
//        reloadTableView()
    }
    
//        MARK - REFRESH COLLECTION VIEWS EVERY 1 MINUTE TO TRY
    func reloadTableView() {
        timer = Timer.scheduledTimer(timeInterval: 3,target: self, selector: #selector(reload),userInfo: nil, repeats: true )
    }
    @objc func reload() {
        self.popularCollectionView.reloadData()
        self.upcomingCollectionView.reloadData()
    }
    
//    MARK - LOAD POPULAR MOVIES
    private func loadMovies() {
               ViewModel.fetchPopularMoviesData { [weak self] in
                   self?.popularCollectionView.dataSource = self
                   self?.popularCollectionView.reloadData()
               }
           }
    
//    MARK - LOAD LATEST MOVIES
    private func loadLatestMovies() {
        latestViewModel.fetchLatestMoviesData { [weak self] in
            self?.upcomingCollectionView.dataSource = self
            self?.upcomingCollectionView.reloadData()
        }
    }
    
//    MARK - LOAD NOW PLAYING MOVIES
    private func loadNowPlayingMoview() {
        nowPlayingViewModel.fetchNowPlayingMoviesData { [weak self] in
            self?.nowPlayingCollectionView.dataSource = self
            self?.nowPlayingCollectionView.reloadData()
        }
    }
    
    
    func Visual() {
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        view.backgroundColor = UIColorFromRGB(rgbValue: 0xe8ffff)


        //    MARK - POPULAR MOVIES LABEL AND CV
        containerView.addSubview(PopularMovieLaber)
                PopularMovieLaber.backgroundColor = UIColorFromRGB(rgbValue: 0xe8ffff)
                PopularMovieLaber.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, trailing: containerView.trailingAnchor, bottom: nil, padding: UIEdgeInsets(top: 110, left: 0, bottom: 0, right: 0))
                PopularMovieLaber.adjustsFontForContentSizeCategory = true
                PopularMovieLaber.textColor = UIColorFromRGB(rgbValue: 0x213e3b)
                PopularMovieLaber.text = "POPULAR MOVIES"
                PopularMovieLaber.textAlignment = .center
                
        containerView.addSubview(popularCollectionView)
                popularCollectionView.backgroundColor = UIColorFromRGB(rgbValue: 0xe8ffff)
                popularCollectionView.topAnchor.constraint(equalTo: PopularMovieLaber.bottomAnchor, constant: 40).isActive = true
                popularCollectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
                popularCollectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
                popularCollectionView.heightAnchor.constraint(equalTo: popularCollectionView.widthAnchor, multiplier: 0.5).isActive = true
                popularCollectionView.delegate = self
                popularCollectionView.showsHorizontalScrollIndicator = false
                
        //        MARK - LATEST MOVIES LABEL AND CV
        containerView.addSubview(LatestMovieLaber)
                LatestMovieLaber.backgroundColor = UIColorFromRGB(rgbValue: 0xe8ffff)
                LatestMovieLaber.anchor(top: popularCollectionView.bottomAnchor, leading: containerView.leadingAnchor, trailing: containerView.trailingAnchor, bottom: nil, padding: UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0))
                LatestMovieLaber.adjustsFontForContentSizeCategory = true
                LatestMovieLaber.textColor = UIColorFromRGB(rgbValue: 0x213e3b)
                LatestMovieLaber.text = "LATEST MOVIES"
                LatestMovieLaber.textAlignment = .center
                
        containerView.addSubview(upcomingCollectionView)
                upcomingCollectionView.backgroundColor = UIColorFromRGB(rgbValue: 0xe8ffff)
                upcomingCollectionView.topAnchor.constraint(equalTo: LatestMovieLaber.bottomAnchor, constant: 40).isActive = true
                upcomingCollectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
                upcomingCollectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
                upcomingCollectionView.heightAnchor.constraint(equalTo: upcomingCollectionView.widthAnchor, multiplier: 0.5).isActive = true
                upcomingCollectionView.delegate = self
                upcomingCollectionView.showsHorizontalScrollIndicator = false
        
        //        MARK - NOWPLAYING LABEL AND CV
                containerView.addSubview(nowPlayingMoviewLabel)
                nowPlayingMoviewLabel.backgroundColor = UIColorFromRGB(rgbValue: 0xe8ffff)
                nowPlayingMoviewLabel.anchor(top: upcomingCollectionView.bottomAnchor, leading: containerView.leadingAnchor, trailing: containerView.trailingAnchor, bottom: nil, padding: UIEdgeInsets(top: 110, left: 0, bottom: 0, right: 0))
                nowPlayingMoviewLabel.adjustsFontForContentSizeCategory = true
                nowPlayingMoviewLabel.textColor = UIColorFromRGB(rgbValue: 0x213e3b)
                nowPlayingMoviewLabel.text = "NOW PLAYING MOVIES"
                nowPlayingMoviewLabel.textAlignment = .center
                
                containerView.addSubview(nowPlayingCollectionView)
                nowPlayingCollectionView.backgroundColor = UIColorFromRGB(rgbValue: 0xe8ffff)
                nowPlayingCollectionView.topAnchor.constraint(equalTo: nowPlayingMoviewLabel.bottomAnchor, constant: 40).isActive = true
                nowPlayingCollectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
                nowPlayingCollectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
                nowPlayingCollectionView.heightAnchor.constraint(equalTo: popularCollectionView.widthAnchor, multiplier: 0.5).isActive = true
                nowPlayingCollectionView.delegate = self
                nowPlayingCollectionView.showsHorizontalScrollIndicator = false
               
    }
}


extension ViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
//    MARK - COLLECTION VIEW
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize( width: collectionView.frame.width/2.5, height: collectionView.frame.width/2.5)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailController = ShowDetailsViewController()
        if collectionView == popularCollectionView {
        detailController.DetailsTitle = TitleToSend [indexPath.row]
        detailController.DetailsYear = yearToSend [indexPath.row]
        detailController.DetailsRate = rateToSend [indexPath.row]
        detailController.DetailsPoster = posterToSend [indexPath.row]
        detailController.DetailsDescription = descriptionToSend [indexPath.row]
            present(detailController, animated: false, completion: nil)
        }else if collectionView == upcomingCollectionView {
            detailController.DetailsTitle = upcomingTitleToSend [indexPath.row]
            detailController.DetailsYear = upcomingyearToSend [indexPath.row]
            detailController.DetailsRate = upcomingrateToSend [indexPath.row]
            detailController.DetailsPoster = upcomingposterToSend [indexPath.row]
            detailController.DetailsDescription = upcomingdescriptionToSend [indexPath.row]
            present(detailController, animated: false, completion: nil)
        }else {
            detailController.DetailsTitle = nowPlayingTitleToSend [indexPath.row]
            detailController.DetailsYear = nowPlayingyearToSend [indexPath.row]
            detailController.DetailsRate = nowPlayingrateToSend [indexPath.row]
            detailController.DetailsPoster = nowPlayingposterToSend [indexPath.row]
            detailController.DetailsDescription = nowPlayingdescriptionToSend [indexPath.row]
            present(detailController, animated: false, completion: nil)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == popularCollectionView {
        return ViewModel.numberOfRowInSection(section: section)
        }else if collectionView == upcomingCollectionView {
        return latestViewModel.numberOfRowInSection(section: section)
        }else {
        return nowPlayingViewModel.numberOfRowInSection(section: section)
        }
    }
    
    func collectionView(_ collectionView : UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.popularCollectionView {
        let cell = popularCollectionView.dequeueReusableCell(withReuseIdentifier: "popularcells", for: indexPath) as! TVCell
        let movie = ViewModel.cellForRowAt(indexPath: indexPath)
        cell.settings(movie)
        let title = cell.MTitle
        let poster = cell.MPoster
        let rate = cell.MRate
        let year = cell.MYear
        let description = cell.MDescription
        TitleToSend.append(title)
        posterToSend.append(poster)
        rateToSend.append(rate)
        yearToSend.append(year)
        descriptionToSend.append(description)
        return cell
        }else if collectionView == upcomingCollectionView {
    let cell = upcomingCollectionView.dequeueReusableCell(withReuseIdentifier: "upcomingcells", for: indexPath) as! TVCell
    let movie = latestViewModel.cellForRowAt(indexPath: indexPath)
    cell.settings(movie)
            let title = cell.MTitle
            let poster = cell.MPoster
            let rate = cell.MRate
            let year = cell.MYear
            let description = cell.MDescription
    upcomingTitleToSend.append(title)
    upcomingposterToSend.append(poster)
    upcomingrateToSend.append(rate)
    upcomingyearToSend.append(year)
    upcomingdescriptionToSend.append(description)
            return cell
        }else {
            let cell = nowPlayingCollectionView.dequeueReusableCell(withReuseIdentifier: "nowPlayingcells", for: indexPath) as! TVCell
            let movie = nowPlayingViewModel.cellForRowAt(indexPath: indexPath)
            cell.settings(movie)
                    let title = cell.MTitle
                    let poster = cell.MPoster
                    let rate = cell.MRate
                    let year = cell.MYear
                    let description = cell.MDescription
            nowPlayingTitleToSend.append(title)
            nowPlayingposterToSend.append(poster)
            nowPlayingrateToSend.append(rate)
            nowPlayingyearToSend.append(year)
            nowPlayingdescriptionToSend.append(description)
            return cell
        }
    }
}
extension UIViewController {
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

}
