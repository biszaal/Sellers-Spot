//
//  ImagePickerView.swift
//  Sellers Spot
//
//  Created by Bishal Aryal on 20/9/22.
//  Copyright © 2020 Bishal Aryal. All rights reserved.
//

import SwiftUI

struct PostImageView: View
{
    @Binding var image: [UIImage]
    @State var viewImagePicker: Bool = false
    
    var body: some View
    {
        ScrollView(.horizontal, showsIndicators: false)
        {
            HStack
            {
                HStack
                {
                    ForEach(image.indices, id: \.self)    // self is important here
                    { imageIndex in
                        
                        ZStack(alignment: .topTrailing)
                        {
                            Image(uiImage: image[imageIndex])
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .cornerRadius(10)
                            
                            Button(action:
                                    {
                                        image.remove(at: imageIndex)
                                    })
                            {
                                Image(systemName: "xmark")
                                    .font(.callout)
                                    .foregroundColor(.white)
                            }
                            .padding(7)
                        }
                    }
                }
                
                if image.count < 5
                {
                    Button(action:
                            {
                                self.viewImagePicker = true
                            })
                    {
                        ZStack
                        {
                            Rectangle()
                                .foregroundColor(.secondary.opacity(0.1))
                            
                            VStack
                            {
                                Image(systemName: "photo")
                                Text("Add Image")
                            }
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        }
                        .frame(width: 100, height: 100)
                        .cornerRadius(10)
                    }
                }
            }
        }
        
        .sheet(isPresented: self.$viewImagePicker)
        {
            ImagePicker(images: self.$image, picker: self.$viewImagePicker)
                .animation(.default)
        }
    }
}
