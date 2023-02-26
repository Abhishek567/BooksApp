//
//  BookCell.swift
//  Gbooks
//
//  Created by Swaminarayan on 26/02/23.
//

import UIKit
import SDWebImage

class BookCell: UITableViewCell {

    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var authors: UILabel!
    
    var bookDetail: VolumeInfo?{
        didSet{
            if let data = bookDetail?.offlineImage{
                bookImage.image = UIImage(data: data)
            }
            else if let url = URL(string: bookDetail?.imageLinks?.thumbnail ?? ""){
                bookImage.sd_setImage(with: url, placeholderImage: UIImage(named: "book"))
            }
            else{
                bookImage.image = nil
            }
            bookTitle.text = bookDetail?.title ?? ""
            authors.text = bookDetail?.authors?.joined(separator: ", ")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
