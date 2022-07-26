//
//  ReticleView.swift
//  SplitScreenScanner
//
//  Created by Sean Machen on 3/30/18.
//

import UIKit

class ReticleView: UIView {
    override func draw(_ rect: CGRect) {
        UIColor.white.setStroke()

        let cornerStrokeWidth = rect.width / 3
        let cornerStrokeHeight = rect.height / 4

        let topLeftPoint = CGPoint(x: rect.minX, y: rect.minY)
        let topRightPoint = CGPoint(x: rect.maxX, y: rect.minY)
        let bottomLeftPoint = CGPoint(x: rect.minX, y: rect.maxY)
        let bottomRightPoint = CGPoint(x: rect.maxX, y: rect.maxY)

        strokeCorner(anchorPoint: topLeftPoint, strokeWidth: cornerStrokeWidth, strokeHeight: cornerStrokeHeight)
        strokeCorner(anchorPoint: topRightPoint, strokeWidth: cornerStrokeWidth * -1, strokeHeight: cornerStrokeHeight)
        strokeCorner(anchorPoint: bottomLeftPoint, strokeWidth: cornerStrokeWidth, strokeHeight: cornerStrokeHeight * -1)
        strokeCorner(anchorPoint: bottomRightPoint, strokeWidth: cornerStrokeWidth * -1, strokeHeight: cornerStrokeHeight * -1)
    }
}

// MARK: - Private Methods
private extension ReticleView {
    func strokeCorner(anchorPoint: CGPoint, strokeWidth: CGFloat, strokeHeight: CGFloat) {
        let heightPointX = anchorPoint.x + strokeWidth
        let widthPointY = anchorPoint.y + strokeHeight

        let heightPoint = CGPoint(x: heightPointX, y: anchorPoint.y)
        let widthPoint = CGPoint(x: anchorPoint.x, y: widthPointY)

        let cornerPath = UIBezierPath()
        cornerPath.lineWidth = 8
        cornerPath.move(to: heightPoint)
        cornerPath.addLine(to: anchorPoint)
        cornerPath.addLine(to: widthPoint)

        cornerPath.stroke()
    }
}
