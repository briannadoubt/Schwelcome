//
//  FeatureCell.swift
//  Taro
//
//  Created by Brianna Zamora on 9/21/21.
//

import SwiftUI

public struct Feature: Identifiable {
    
    /// The `systemImage` SF Symbols name used in `Image(systemName:)` Image initialization.
    public var image: String
    public var title: String
    public var subtitle: String
    public var color: Color
    
    public init(image: String, title: String, subtitle: String, color: Color) {
        self.image = image
        self.title = title
        self.subtitle = subtitle
        self.color = color
    }
    
    public var id = UUID()
}

public struct FeatureCell: View {
    
    public var feature: Feature
    
    public init(feature: Feature) {
        self.feature = feature
    }
    
    public var body: some View {
        let image = Image(systemName: feature.image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(feature.color)
            .frame(width: 32, height: 32)
        
        let text = VStack(alignment: .leading, spacing: 2) {
            Text(feature.title)
                .font(.subheadline)
                .fontWeight(.semibold)
            Text(feature.subtitle)
                .layoutPriority(1)
                .foregroundColor(.secondary)
                .font(.subheadline)
                .lineLimit(nil)
        }
        
        #if os(watchOS)
        HStack(alignment: .firstTextBaseline) {
            image
            text
        }
        #else
        HStack(alignment: .center) {
            image
            text
        }
        #endif
    }
}

struct FeatureCell_Previews: PreviewProvider {
    static var previews: some View {
        FeatureCell(
            feature: Feature(
                image: "text.badge.checkmark",
                title: "Title",
                subtitle: "Subtitle",
                color: .blue
            )
        )
    }
}
