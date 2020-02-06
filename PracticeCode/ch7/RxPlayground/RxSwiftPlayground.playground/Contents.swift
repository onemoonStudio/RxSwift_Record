import Foundation
import RxSwift



/*:
 Copyright (c) 2019 Razeware LLC
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 distribute, sublicense, create a derivative work, and/or sell copies of the
 Software in any work that is designed, intended, or marketed for pedagogical or
 instructional purposes related to programming, coding, application development,
 or information technology.  Permission for such use, copying, modification,
 merger, publication, distribution, sublicensing, creation of derivative works,
 or sale is expressly withheld.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */
struct Student {
    let score: BehaviorSubject<Int>
}

example(of: "flatMap") {
    let disposeBag = DisposeBag()
    
    // 1
    let laura = Student(score: BehaviorSubject(value: 80))
    let charlotte = Student(score: BehaviorSubject(value: 90))
    
    // 2
    let student = PublishSubject<Student>()
    
    // 3
    //  student
    //    .flatMap {
    //      $0.score
    //    }
    //    // 4
    //    .subscribe(onNext: {
    //      print($0)
    //    })
    //    .disposed(by: disposeBag)
    
    student
        .flatMapLatest {
            $0.score
    }
        // 4
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
    
    
    student.onNext(laura)
    student.onNext(charlotte)
    laura.score.onNext(85)
    charlotte.score.onNext(95)
    
}

example(of: "materialize and dematerialize") {
    // 1
    enum MyError: Error {
        case anError
    }
    
    let disposeBag = DisposeBag()
    
    // 2
    let laura = Student(score: BehaviorSubject(value: 80))
    let charlotte = Student(score: BehaviorSubject(value: 100))
    
    let student = BehaviorSubject(value: laura)
    
    // 1
    let studentScore = student
        .flatMapLatest {
//            $0.score
            $0.score.materialize()
    }
    
    // 2
    studentScore
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
    
    // 3
    laura.score.onNext(85)
    
    laura.score.onError(MyError.anError)
    
    laura.score.onNext(90)
    
    // 4
    student.onNext(charlotte)
}


