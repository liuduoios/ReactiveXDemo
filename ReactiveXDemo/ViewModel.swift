//
//  ViewModel.swift
//  ReactiveXDemo
//
//  Created by Derek Liu on 2016/12/8.
//  Copyright © 2016年 Inc. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Async

protocol ViewModelType {
    // Input (事件流)
    var usernameInputText: PublishSubject<String> { get }
    var jobInputText: PublishSubject<String> { get }
    var submitButtonDidTap: PublishSubject<Void> { get }
    
    // Ouput (数据流)
    var usernameValid: Observable<Bool> { get }
    var jobValid: Observable<Bool> { get }
    var submitButtonEnabled: BehaviorSubject<Bool> { get }
    var submitCompleted: PublishSubject<Bool> { get }
    
    func validate() -> Observable<Bool>
    func submitInfo() -> Observable<Bool>
}

let minimalUsernameLength = 5
let minimalJobLength = 5

class ViewModel: ViewModelType {
    // MARK: - Input
    let usernameInputText = PublishSubject<String>()
    let jobInputText = PublishSubject<String>()
    let submitButtonDidTap = PublishSubject<Void>()
    
    // MARK: - Ouput
    let usernameValid: Observable<Bool>
    let jobValid: Observable<Bool>
    var submitButtonEnabled = BehaviorSubject<Bool>(value: false)
    let submitCompleted = PublishSubject<Bool>()
    
    private let disposeBag = DisposeBag()
    
    init() {
        usernameValid = usernameInputText
            .asObservable()
            .map { $0.characters.count >= minimalUsernameLength }
            .shareReplay(1)
        
        jobValid = jobInputText
            .asObservable()
            .map { $0.characters.count >= minimalJobLength }
            .shareReplay(1)
        
        Observable.combineLatest(usernameValid, jobValid) { $0 && $1 }
            .shareReplay(1)
            .bindTo(submitButtonEnabled)
            .addDisposableTo(disposeBag)
        
        submitButtonDidTap
            .flatMap(validate)
            .flatMap { validated -> Observable<Bool> in
                if validated {
                    return self.submitInfo()
                } else {
                    return Observable.just(false)
                }
            }
            .bindNext { success in
                self.submitCompleted.onNext(success)
            }
            .addDisposableTo(disposeBag)
    }
    
    func validate() -> Observable<Bool> {
        print(#function)
        
        return Observable.create { observer in
            if (arc4random() % 2 == 1) {
                observer.onNext(true)
            } else {
                observer.onNext(false)
            }
            
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
    
    func submitInfo() -> Observable<Bool> {
        print(#function)
        
        return Observable.create { observer in
            Async.main(after: 2) {
                observer.onNext(true)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
}
