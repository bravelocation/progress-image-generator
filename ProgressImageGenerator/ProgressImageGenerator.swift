//
//  ProgressImageGenerator.swift
//  ProgressImageGenerator
//
//  Created by John Pollard on 17/09/2016.
//  Copyright © 2016 Bravelocation Software Ltd. All rights reserved.
//

import Foundation
import AppKit

class ProgressImageGenerator {
    let π:CGFloat = CGFloat(M_PI)
    
    private var view: NSView? = nil
    private var baseCircle: CAShapeLayer? = nil
    private var progressCircle: CAShapeLayer? = nil
    
    func generateImage(dimension:Double, counter:Int, maximumValue:Int, directoryToSave:String) {
        // Initialise view size of dimension
        let frame = NSRect(x: 0.0, y: 0.0, width: dimension, height: dimension)
        
        self.view = NSView(frame: frame)
        self.view!.wantsLayer = true
        self.view!.layer = CALayer()

        self.baseCircle = CAShapeLayer(layer: self.view?.layer)
        self.progressCircle = CAShapeLayer(layer: self.view?.layer)
        
        // Set sizes and colors
        let outlineColor: NSColor = NSColor(red: 41.0/255.0, green: 63.0/255.0, blue: 1.0/255.0, alpha: 1.0)
        let counterColor: NSColor = NSColor(red: 203.0/255.0, green: 237.0/255.0, blue: 142.0/255.0, alpha: 1.0)
        
        // Define the start and end angles for the arc
        let startAngle: CGFloat = 5 * π / 4
        
        // Define the center point of the view where you’ll rotate the arc around
        let endAngle: CGFloat = -1.0 * π / 4
        
        // Generate bottom layer
        self.addPathToView(layer: self.baseCircle!, pathColor: outlineColor, startAngle: startAngle, endAngle: endAngle, addShadow:true)
        
        // First calculate the difference between the two angles
        // ensuring it is positive
        let angleDifference = startAngle - endAngle
        
        // Then calculate the arc for each single glass
        let arcLengthPerGlass = angleDifference / CGFloat(maximumValue)
        
        // Then multiply out by the actual glasses drunk
        let progressEndAngle = startAngle - (arcLengthPerGlass * CGFloat(counter))
        
        // Now add the progress circle
        self.addPathToView(layer: self.progressCircle!, pathColor: counterColor, startAngle: startAngle, endAngle: progressEndAngle, addShadow:false)

        // Finally, capture the view and save as an image
        let fullPath = directoryToSave.appendingFormat("progress%d@2x.png", counter)
        let imagePath = URL(fileURLWithPath: fullPath)
        self.writeImageData(destination:imagePath)
    }
    
    func addPathToView(layer:CAShapeLayer, pathColor:NSColor, startAngle:CGFloat, endAngle:CGFloat, addShadow:Bool) {
        // Generate bottom layer
        let frameDimension = (self.view?.frame.width)!
        let arcWidth = frameDimension / 3.0
        let center = CGPoint(x:frameDimension/2, y: frameDimension/2)
        let radius = ((frameDimension - arcWidth) / 2) - 5
        
        let path = CGMutablePath()
        path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        //path.closeSubpath()
        
        layer.path = path
        layer.fillColor = NSColor.clear.cgColor
        layer.strokeColor = pathColor.cgColor
        layer.lineWidth = arcWidth
        
        if (addShadow) {
            layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
            layer.shadowOpacity = 0.25
        }
        
        self.view?.layer?.addSublayer(layer)
    }
    
    func writeImageData(destination: URL) {
        let bounds = self.view?.bounds
        let rep = self.view!.bitmapImageRepForCachingDisplay(in: bounds!)
        self.view!.cacheDisplay(in: bounds!, to: rep!)
        
        let data = rep?.representation(using: .PNG, properties: [:])
        do {
            try data?.write(to: destination, options: .atomicWrite)
        }
        catch {
            print("Couldn't save file")
        }
    }
}
