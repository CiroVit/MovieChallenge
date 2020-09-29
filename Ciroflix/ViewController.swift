//
//  ViewController.swift
//  Ciroflix
//
//  Created by Ciro Vitale on 24/09/2020.
//  Copyright © 2020 Ciro Vitale. All rights reserved.
//

import UIKit
import RealmSwift


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableview = UITableView()
    private var ViewModel = MovieViewModel()
    var service = TMDBService()
    var movie : Movie?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableview)
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableview.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableview.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableview.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableview.showsVerticalScrollIndicator = false
        tableview.delegate = self
        tableview.dataSource = self
        tableview.rowHeight = 300
        
        print(Realm.Configuration.defaultConfiguration.fileURL)
        loadMovies()
        
        }
    
    
//    func tableviewStuff() {
//        self.view.addSubview(tableview)
//        tableview.translatesAutoresizingMaskIntoConstraints = false
//        tableview.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        tableview.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        tableview.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        tableview.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        tableview = UITableView(frame: self.view.bounds,style: .plain)
//        tableview.showsVerticalScrollIndicator = false
//        tableview.delegate = self
//        tableview.dataSource = self
//        self.view.addSubview(tableview)
//
//    }
    
    
    private func loadMovies() {
           ViewModel.fetchMoviesData { [weak self] in
               self?.tableview.dataSource = self
               self?.tableview.reloadData()
           }
       }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ViewModel.numberOfRowInSection(section: section)
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.tableview.register(TVCell.self, forCellReuseIdentifier: "cell")
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TVCell
        
        let movie = ViewModel.cellForRowAt(indexPath: indexPath)
        cell.settings(movie)
        
        return cell
    }
   
    
}

