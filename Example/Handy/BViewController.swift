//
//  BViewController.swift
//  TSHandyKit_Example
//
//  Created by leetangsong on 2022/9/17.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import Handy
class BViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        handy.title = "不跟主题"
        handy.naviBackgroundColor = UIColor.handy.color(hex6: 0xFF7E79)
        let button = UIButton.init(frame: CGRect.init(x: 200, y: 300, width: 100, height: 100))
        view.addSubview(button)
        button.backgroundColor = .red
        button.setTitle("上一页", for: .normal)
        button.addTarget(self, action: #selector(lastPage), for: .touchUpInside)

       
    }
   
    
    @objc func lastPage(){
        navigationController?.popViewController(animated: true)
    }
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true)
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
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

extension BViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .red.withAlphaComponent(0.4)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    
}

