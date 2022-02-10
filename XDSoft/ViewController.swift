//
//  ViewController.swift
//  XDSoft
//
//  Created by Зоригто Бадмаин on 10.02.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var primeNumbersButton: UIButton!
    @IBOutlet weak var fibonacciNumbersButton: UIButton!
    
    let composition: CompositionLayout = CompositionLayout()
    let rangeEnd = 1000
    let rangeFibo = 50
    var listPrime: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollection()
        listPrime = primes(upTo: rangeEnd)
        
        primeButton()
        fiboButton()
    }
    
    func primeButton() {
        let gestPrime = UITapGestureRecognizer(target: self, action: #selector(primeGest))
        primeNumbersButton.addGestureRecognizer(gestPrime)
    }
    
    func fiboButton() {
        let gestFibonacci = UITapGestureRecognizer(target: self, action: #selector(fibonacciGest))
        fibonacciNumbersButton.addGestureRecognizer(gestFibonacci)
    }
    
    @objc func primeGest() {
        listPrime = primes(upTo: rangeEnd)
        collectionView.reloadData()
    }
    
    @objc func fibonacciGest() {
        listPrime = fibonacciSequence(numSteps: rangeFibo)
        collectionView.reloadData()
    }
    
    func primes(upTo rangeEndNumber: Int) -> [Int] {
        let firstPrime = 2
        guard rangeEndNumber >= firstPrime else {
            fatalError("End of range has to be greater than or equal to \(firstPrime)!")
        }
        var numbers = Array(firstPrime...rangeEndNumber)
        var currentPrimeIndex = 0
        
        while currentPrimeIndex < numbers.count {
            let currentPrime = numbers[currentPrimeIndex]
            var numbersAfterPrime = numbers.suffix(from: currentPrimeIndex + 1)
            numbersAfterPrime.removeAll(where: { $0 % currentPrime == 0 })

            numbers = numbers.prefix(currentPrimeIndex + 1) + Array(numbersAfterPrime)
            currentPrimeIndex += 1
        }
        
        return numbers
    }
    
    func fibonacciSequence (numSteps: Int) -> [Int]  {

        var sequence = [0, 1]
        if numSteps <= 1 {
            return sequence
        }
        
        for _ in 0...numSteps - 2 {
            let first = sequence[sequence.count - 2]
            let second = sequence.last!
            sequence.append(first + second)
        }
        
        return sequence
    }

    
    private func configureCollection() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.collectionView.collectionViewLayout = composition.createCompositionLayout()
        
        let styleNib = UINib(nibName: "NumbersCell", bundle: nil)
        collectionView.register(styleNib, forCellWithReuseIdentifier: "NumbersCell")
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listPrime.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NumbersCell", for: indexPath) as! NumbersCell
        
        cell.numberLabel.text = "\(listPrime[indexPath.row])"
        
        let chessRow = indexPath.row / 2
        if chessRow % 2 == 0 {
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = UIColor.white
            } else {
                cell.backgroundColor = UIColor.lightGray
            }
        } else {
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = UIColor.lightGray
            }else{
                cell.backgroundColor = UIColor.white
            }
        }
        
        return cell
    }
}

