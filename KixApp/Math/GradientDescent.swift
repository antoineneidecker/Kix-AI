//
//  GradientDescent.swift
//  ShoeSwiperMenus
//
//  Created by Antoine Neidecker on 26/08/2020.
//  Copyright © 2020 Antoine Neidecker. All rights reserved.
//

import Foundation

class GradientDescent {
    
    init(InitialVector: Matrix) {
        GoldenVector = InitialVector
    }
    
//    See Andrew Ng videos on RMS Prop and Adam Optimization for notational details.
    
    var GoldenVector : Matrix
//    var NewVector : Matrix
    var newBatch = true
    var currentMean = Matrix.zeros(rows: 1, columns: 40)
    var numberOfElements = 0.0
//    Here dW is the difference between the previous golden vector and the new one.
    var dW = Matrix.zeros(rows: 1, columns: 40)
    var V = Matrix.zeros(rows: 1, columns: 40)
    var S = Matrix.zeros(rows: 1, columns: 40)
    
    let alpha = 1.0
    let beta1 = 0.9
    let beta2 = 0.999
    let epsilon = Matrix([0.00000001])
    var iteration = 1.0
    var dislikeCoef = Matrix.init(size: (1, 40), repeatedValue: 0.3)
    
//    The following is called every swipe
    func AverageVector(newSwipedW : Matrix, liked : Bool){
        if newBatch{
            if liked{
                currentMean = newSwipedW
            }
            else{
                currentMean =  -newSwipedW * dislikeCoef
            }
            numberOfElements = 1.0
            newBatch = false
        }
        else{
            if liked{
                currentMean = (Matrix.init(size: (1, 40), repeatedValue: numberOfElements) * currentMean + newSwipedW) / Matrix([numberOfElements + 1])
//                currentMean = currentMean + ((newSwipedW - currentMean) / (Matrix([numberOfElements + 1])))
            }
            else{
                currentMean = (Matrix.init(size: (1, 40), repeatedValue: numberOfElements) * currentMean - newSwipedW * dislikeCoef) / Matrix([numberOfElements + 1])
//                currentMean = currentMean - ((newSwipedW * Matrix([dislikeCoef]) - currentMean) / (Matrix([numberOfElements + 1])))
            }
        }
        numberOfElements += 1
    }
    
    func getdW(swipeW: Matrix) -> Matrix{
        dW = swipeW - GoldenVector
        return dW
    }
    
    func updateV() -> Matrix{
        V = beta1 * V + (1 - beta1) * dW
//        The following is the corrected value of V. This avoids having erroneous values at the beginning.
//        V = V/(1 - pow(beta1, iteration))
        return V
    }
    
    
    
    func updateS() -> Matrix{
        S = beta2 * S + (1 - beta2) * (dW * dW)
//        S = S/(1 - pow(beta2, iteration))
        return S
    }
    
//    The following is called every 10 swipes.
    func AdamOp() -> Matrix{
        newBatch = true
        dW = currentMean
        print("Current Mean dW is:")
        print(dW)
        V = updateV()
        S = updateS()
        iteration += 1
        print("Just performed Adam!")
//        print(GoldenVector)
        GoldenVector = GoldenVector + alpha * (V / (S.sqrt() + epsilon))
//        print(GoldenVector)
        return GoldenVector
    }
}
