//
//  TableViewController.swift
//  Spot
//
//  Created by Unlocked on 4/21/17.
//  Copyright © 2017 Unlocked. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation

var player = AVAudioPlayer()

struct post {
    let mainImage : UIImage!
    let name : String!
    let previewURL : String!
}

class TableViewController: UITableViewController {
    
    let searchURL = "https://api.spotify.com/v1/search?q=Shawn+Mendes&type=track"
    var posts = [post]()

    typealias JSONStandard = [String : AnyObject]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callAlamofire(url: searchURL)
    }
    
    func callAlamofire(url: String){
        Alamofire.request(url).responseJSON { response in
            self.parseData(JSONData: response.data!)
        }
    }
    
    func parseData(JSONData : Data) {
        do {
            let readableJSON = try JSONSerialization
                .jsonObject(with: JSONData, options: .mutableContainers) as? JSONStandard
            if let tracks = readableJSON?["tracks"] as? JSONStandard {
                
                if let items = tracks["items"] as? [JSONStandard] {
                    for i in 0..<items.count {
                        let item = items[i]
                        let name = item["name"] as! String
                        let previewURL = item["preview_url"] as! String
                        
                        if let album = item["album"] as? JSONStandard {
                            if let images = album["images"] as? [JSONStandard] {
                                let imageData = images[0]
                                let mainImageURL = URL(string: imageData["url"] as! String)
                                let mainImageData = NSData(contentsOf: mainImageURL!)
                                let mainImage = UIImage(data: mainImageData! as Data)
                                posts.append(post.init(mainImage: mainImage, name: name, previewURL: previewURL))
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
        catch {
            print(error)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        let mainImageView = cell?.viewWithTag(2) as! UIImageView
        mainImageView.image = posts[indexPath.row].mainImage
        let mainLabel = cell?.viewWithTag(1) as! UILabel
        mainLabel.text = posts[indexPath.row].name
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = self.tableView.indexPathForSelectedRow?.row
        let vc = segue.destination as! AudioViewController
        vc.image = posts[indexPath!].mainImage
        vc.mainSongTitle = posts[indexPath!].name
        vc.mainPreviewURL = posts[indexPath!].previewURL
    }
}
