//
//  DetailViewController.swift
//  Notes
//
//  Created by Dmitry Belkin on 03/08/2019.
//  Copyright © 2019 parameter. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailScrollView: UIScrollView!

    var images = [UIImage]()
    var selectedImage = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        detailScrollView.frame = view.frame

        for i in 0..<images.count {
            let imageView = UIImageView()
            imageView.image = images[i]
            imageView.contentMode = .scaleAspectFit
            let xPosition = self.view.frame.width * CGFloat(i)
            imageView.frame = CGRect(x: xPosition, y: 0, width: self.detailScrollView.frame.width, height: self.detailScrollView.frame.height)

            detailScrollView.contentSize.width = detailScrollView.frame.width * CGFloat(i + 1)
            detailScrollView.addSubview(imageView)
        }

        detailScrollView.contentOffset = CGPoint(x: self.view.frame.width * CGFloat(selectedImage), y: 0)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
