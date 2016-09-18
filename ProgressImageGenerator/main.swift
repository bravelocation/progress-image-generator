//
//  main.swift
//  ProgressImageGenerator
//
//  Created by John Pollard on 17/09/2016.
//  Copyright © 2016 Bravelocation Software Ltd. All rights reserved.
//

import Foundation

let generator = ProgressImageGenerator()
for i in 0...100 {
    let directory = String("/Users/John/Documents/code/daysleft/daysleft WatchKit App/Images.xcassets/progress/")?.appendingFormat("progress%d.imageset/", i)
    print("Generating image in \(directory)")
    generator.generateImage(dimension: 150.0, counter: i, maximumValue: 100, directoryToSave: directory!)
}

print("Done!")
