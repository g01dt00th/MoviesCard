//
//  ViewController.swift
//  MoovieCard
//
//  Created by a on 19.09.2020.
//  Copyright © 2020 a. All rights reserved.
//

import UIKit
import CardSlider


class ViewController: UIViewController, CardSliderDataSource {
    
    var dataToCards = [Item]()
    
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true 
        downloadJson()
        
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        
    }
    
    
    @IBAction func didTapButton() {
        let vc = CardSliderViewController.with(dataSource: self)
        vc.title = "Welcome"
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    func item(for index: Int) -> CardSliderItem {
        return dataToCards[index]
    }
    
    func numberOfItems() -> Int {
        dataToCards.count
    }
    
    //Download Data from Internet
    func downloadJson() {
        guard let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=62efe0c91e2b68511bf20a79656c8e1c") else { return }
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let queue = DispatchQueue.global(qos: .utility)
        queue.async {
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
        
            
            do {
                guard let data = data else { return }
                let moovieData = try JSONDecoder().decode(Moovie.self, from: data)
                print(moovieData)
                
                for index in 0...moovieData.results.count-1 {
                    var item = Item(image: UIImage(), rating: 0, title: "", subtitle: "", description: "")
                    
                    
                    DispatchQueue.main.async {
                        item.title = moovieData.results[index].title ?? ""
                        item.description = moovieData.results[index].overview
                        item.rating = Int(moovieData.results[index].vote_average ?? 0)
                        if let imageInfo = moovieData.results[index].poster_path {
                            let urlString = "https://image.tmdb.org/t/p/w500/" + imageInfo
                            let url = URL(string: urlString)
                            do {
                                let data = try Data(contentsOf: url!)
                                    item.image = UIImage(data: data)!
                                    
                            } catch {
                                print("Error download photo")
                            }
                            
                        }
                    }
                    
                    self.dataToCards.append(item)
                    
                }
                
                
                
            }
                
            catch let jsonError {
                print(jsonError)
             }
            }
        
        task.resume()
        }
    }
    
    
}

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
}

