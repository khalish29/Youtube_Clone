//
//  VideoTableViewCell.swift
//  Youtube Clone
//
//  Created by macOS User on 25/03/21.
//

import UIKit

class VideoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var video:Video?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // inisialisai
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCell(_ v:Video){
        self.video = v
        
        //Ensure that we have video
        guard self.video != nil else {
            return
        }
        
        //set the title
        self.titleLable.text = video?.title
        
        //set the date
        let df =  DateFormatter()
        df.dateFormat = "EEEE, MMM d, yyyy"
        self.dateLabel.text = df.string(from: video!.published)
        
        //set the thumbnail
        guard self.video!.thumbnail != "" else {
            return
        }
        
        // check cache before downloading data
        if let cachedData = CacheManager.getVideoCache(self.video!.thumbnail) {
            
          // set the thumbnail imageView
            self.thumbnailImageView.image = UIImage(data: cachedData)
            return
        }
        
        // download the thumbnail data
        let url = URL(string: self.video!.thumbnail)
        
        //set the shared URL Session Object
        let session = URLSession.shared
        
        //create a data task
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            
            if error == nil && data != nil {
                
                // save the data in the cache
                CacheManager.setVideoCache(url!.absoluteString, data)
                
                //check that the downloading url matches the video thumbnail url that this cell is currently set to display
                if url?.absoluteString != self.video?.thumbnail {
                    
                    // video cell has been recycled for another video and no imager matches the thumbnail that was downloaded
                    return
                }
                
                //Create the image project
                let image = UIImage(data: data!)
                
                //set the imageview
                DispatchQueue.main.async {
                    self.thumbnailImageView.image = image
                }
            
            }
        
        }
        //start data task
        dataTask.resume()
    }
    
}
