//
//  ImagePicker.swift
//  Sellers Spot
//
//  Created by Bishal Aryal on 20/9/20.
//  Copyright © 2020 Bishal Aryal. All rights reserved.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable
{
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate
    {
        var parent: ImagePicker
        
        init(_ parent: ImagePicker)
        {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
        {
            if let uiImage = info[.editedImage] as? UIImage
            {
                parent.image = uiImage
            }
            else if let uiImage = info[.originalImage] as? UIImage
            {
                parent.image = uiImage
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    
    func makeCoordinator() -> Coordinator
    {
        Coordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController
    {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>)
    {
        
    }
    
}