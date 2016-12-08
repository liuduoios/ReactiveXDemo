//
//  ViewController.swift
//  ReactiveXDemo
//
//  Created by Derek Liu on 2016/12/8.
//  Copyright © 2016年 Inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PKHUD

class ViewController: UIViewController {
    
    private let mainView: MainView
    
    private let viewModel: ViewModelType
    
    private let disposeBag = DisposeBag()
    
    init(viewModel: ViewModelType) {
        self.viewModel = viewModel
        mainView = Bundle.main.loadNibNamed("MainView", owner: nil, options: nil)?.first as! UIView as! MainView
        
        super.init(nibName: nil, bundle: nil)
        
        title = "ReactiveX Demo"
        view.addSubview(mainView)
        bindViewModel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func bindViewModel() {
        // bind input
        
        mainView.submitButton.rx.tap
            .map {
                HUD.show(.progress)
            }
            .bindTo(viewModel.submitButtonDidTap)
            .addDisposableTo(disposeBag)
        
        mainView.usernameTextField.rx.text.orEmpty
            .bindTo(viewModel.usernameInputText)
            .addDisposableTo(disposeBag)
        
        mainView.jobTextField.rx.text.orEmpty
            .bindTo(viewModel.jobInputText)
            .addDisposableTo(disposeBag)
        
        // bind output

        viewModel.usernameValid
            .bindTo(mainView.usernameValidLabel.rx.isHidden)
            .addDisposableTo(disposeBag)
        
        viewModel.jobValid
            .bindTo(mainView.jobValidLabel.rx.isHidden)
            .addDisposableTo(disposeBag)
        
        viewModel.submitButtonEnabled
            .bindTo(mainView.submitButton.rx.isEnabled)
            .addDisposableTo(disposeBag)
        
        viewModel.submitCompleted
            .subscribe(onNext: { succeed in
                HUD.flash(succeed ? .success : .error)
            })
            .addDisposableTo(disposeBag)
    }
}

