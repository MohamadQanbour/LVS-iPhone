//
//  LoadingView.swift
//  LVS
//
//  Created by Jalal on 1/7/17.
//  Copyright © 2017 Abd Al Majed. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    var balls = [UIImageView]()
    
    var timer : Timer!
    
    var activeColor = UIColor()
    
    var nonActiveColor = UIColor()
    
    var activeBall = 0
    
    var prevActiveBall = 0

    func draw(midX: CGFloat, midY: CGFloat, ballDim: Int, ballsCount: Int, activeColor: UIColor, nonActiveColor: UIColor) {
        
        self.activeColor = activeColor
        
        self.nonActiveColor = nonActiveColor
        
        let totalWidth = CGFloat(ballsCount * (ballDim + 4) - 4)
        
        self.frame = CGRect(x: midX - (totalWidth / 2), y: midY - CGFloat(ballDim / 2), width: totalWidth, height: CGFloat(ballDim))
        
        self.backgroundColor = UIColor.clear
        
        var i = 0
        
        while i < ballsCount {
            
            let x = i * (ballDim + 4)
            
            let ball = UIImageView(frame: CGRect(x: x, y: 0, width: ballDim, height: ballDim))
            
            ball.layer.cornerRadius = CGFloat(ballDim) / 2.0
            
            ball.backgroundColor = nonActiveColor
            
            self.balls.append(ball)
            
            self.addSubview(ball)
            
            i += 1;
        }
        
        activeBall = 0
        
        prevActiveBall = 0
        
        timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.animateBalls), userInfo: nil, repeats: true);
        
        timer.fire()
        
    }
    
    @objc func animateBalls()
    {
        UIView.animate(withDuration: 0.15) {
            self.balls[self.prevActiveBall].backgroundColor = self.nonActiveColor
        }
        
        UIView.animate(withDuration: 0.15) {
            self.balls[self.activeBall].backgroundColor = self.activeColor
        }
        
        prevActiveBall = activeBall
        
        if activeBall == (balls.count - 1)
        {
            activeBall = 0
        }
        else
        {
            activeBall += 1
        }
    }

}
