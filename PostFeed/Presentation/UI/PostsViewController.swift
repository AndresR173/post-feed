//
//  PostsViewController.swift
//  PostFeed
//
//  Created by Andres Rojas on 24/02/22.
//

import UIKit

class PostsViewController: UIViewController {
    let viewModel: PostViewModelProtocol
    
    init(_ viewModel: PostViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: PostsViewController.self), bundle: Bundle.main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

}
