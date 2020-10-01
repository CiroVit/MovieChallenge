//
//  TVCell.swift
//  Ciroflix
//
//  Created by Ciro Vitale on 25/09/2020.
//  Copyright © 2020 Ciro Vitale. All rights reserved.
//

import UIKit
import RealmSwift

class TVCell: UICollectionViewCell {
    
    let realm = try! Realm.init()
    var MPoster = UIImageView()
    var MTitle = UILabel()
    var MYear = UILabel()
    var MDescription = UILabel()
    var MRate = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.addSubview(MPoster)

//        MPoster.layer.cornerRadius = 10
//        MPoster.contentMode = .scaleToFill
        MPoster.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, bottom: contentView.bottomAnchor)

    }
    
    required init?(coder: NSCoder) {
        fatalError("error")
    }
    
    private var url: String = ""
    
    func settings(_ movie: Movie){
        Pick(title: movie.title, releaseDate: movie.year, rate: movie.rate, description: movie.overview, poster: movie.posterImage)
    }
   
    private func Pick( title: String?, releaseDate: String?, rate:Double?, description: String?, poster: String?) {
        self.MTitle.text = title
        self.MYear.text = converDate(releaseDate)
        guard let rate = rate else { return }
        self.MRate.text = String(rate)
        self.MDescription.text = description
        guard let posterAsString = poster else {return}
        url = "https://image.tmdb.org/t/p/w300" + posterAsString
        guard let posterImageURL = URL(string: url) else {
            self.MPoster.image = UIImage(named: "noImageAvailable")
            return
        }
        self.MPoster.image = nil
        getImage(url: posterImageURL)
    }
    
    private func getImage(url: URL) {
        URLSession.shared.dataTask(with: url) { (data,response,error) in
            
            if let error = error {
                print("error: \(error.localizedDescription)")
            }
            guard let data = data else {
                print("empty")
                return
            }
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    self.MPoster.image = image
                }
            }
        } .resume()
    }

    func converDate(_ date:String?) -> String {
        var fixDate = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        if let originalDate = date {
            if let newDate = dateFormatter.date(from: originalDate) {
                dateFormatter.dateFormat = "dd.mm.yyyy"
                fixDate = dateFormatter.string(from: newDate)
            }
        }
        return fixDate
    }
}
extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, trailing: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
        
        if let top = top {
            translatesAutoresizingMaskIntoConstraints = false
            topAnchor.constraint(equalTo: top,constant: padding.top).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom,constant: -padding.bottom).isActive = true
        }
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading,constant: padding.left).isActive = true
        }
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing,constant: -padding.right).isActive = true
        }
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
        
        
    }
}
