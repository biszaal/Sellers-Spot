//
//  NewPostView.swift
//  Sellers Spot
//
//  Created by Bishal Aryal on 20/9/16.
//  Copyright © 2020 Bishal Aryal. All rights reserved.
//
import Combine
import SwiftUI
import Firebase
import FirebaseStorage

struct NewPostView: View
{
    @State var userId: String = UserDefaults.standard.string(forKey: "userId") ?? ""
    @State var username: String = UserDefaults.standard.string(forKey: "username") ?? ""
    @State var userEmail: String = UserDefaults.standard.string(forKey: "userEmail") ?? ""
    @State var userImage: String = UserDefaults.standard.string(forKey: "userImage") ?? ""
    @State var postId: String = ""
    
    @State var postName: String = ""
    @State var postDescription: String = ""
    @State var postImages: [String] = []        // this is for to store image URL as string
    @State var postPrice: String = ""
    @State var postLocation: String = ""
    
    @State var keyboardHeight: CGFloat = 0
    @State var openAccountView: Bool = false
    @State var loggedIn: Bool = UserDefaults.standard.bool(forKey: "status")
    
    @Binding var newPostView: Bool
    @Binding var photoUplodingProgress: Float
    @Binding var isUploading: Bool
    
    @State var storeImages: [UIImage?] = []
    
    @ObservedObject var post = PostObserver()
    @ObservedObject var user = UserDataObserver()
    
    var body: some View
    {
        VStack
        {
            HStack
            {
                Button(action: {
                    self.newPostView = false
                    print(String(storeImages.count))
                    storeImages.removeAll()
                })
                {
                    Text("Cancel")
                    Image(systemName: "xmark.circle.fill")
                }
                .foregroundColor(.red)
                
                Spacer()
                
                Button(action:      //this is post button
                        {
                            isUploading = true  // show uploading process bar
                            
                    self.newPostView = false
                    postId = UUID().uuidString      // creating unique identifier for each post ( this is gonna be name of the post and image folder)
                    
                    print("\(storeImages.count) images uploaded")
                    
                    // Storing images to the firebase Storage
                    
                    let storage = Storage.storage()
                    for i in 0..<storeImages.count
                    {
                        let taskReference = storage.reference().child("ImagesOfPosts/\(userId)/\(postId)/image\(i).jpeg").putData((storeImages[i]!.jpegData(compressionQuality: 0.50))!, metadata: nil)
                        {   (url, err) in
                            if err != nil
                            {
                                print((err?.localizedDescription)!)
                                return
                            }
                            print("success uploading image\(i) to firebase")
                            
                            storage.reference().child("ImagesOfPosts/\(userId)/\(postId)/image\(i).jpeg").downloadURL
                            {   url, err in
                                if err != nil
                                {
                                    print((err?.localizedDescription)!)
                                    return
                                } else
                                {
                                    self.postImages.append(url!.absoluteString)
                                    print(url!)
                                }
                            }
                        }
                        
                        // show progress
                        taskReference.observe(.progress)
                        { snapshot in
                            guard let pctThere = snapshot.progress?.fractionCompleted else { return }
                            self.photoUplodingProgress = Float(pctThere)
                            print("you are \(pctThere) completed")
                        }
                        
                    }
                    // Storing post the firebase Cloud
                    DispatchQueue.main.asyncAfter(deadline: .now() + 15) {  // wait 15 second and upload everything
                        // waiting 15 seconds will give time to save all images to firebase storage
                        self.post.addPost(id: postId, userId: userId, username: userEmail, userImage: userImage, postName: postName, postImage: postImages, postDescription: postDescription, postPrice: postPrice)
                        print("Done")
                        
                        isUploading = false     // hide uploading bar
                        
                        storeImages.removeAll()
                    }
                })
                {
                    Image(systemName: "paperplane.fill")
                    Text("Post")
                }
            }
            .font(.headline)
            .padding()
            .background(Color.secondary.opacity(0.3))
            
            Spacer()
            
            VStack
            {
                ScrollView(.vertical)
                {
                    VStack(alignment: .leading, spacing: 20)
                    {
                        
                        PostUserInfoView(username: username, userEmail: userEmail, userImage: userImage)
                            .frame(alignment: .center)
                        
                        Text("Name")
                        TextField("Write the name of your product.", text: $postName)
                            .frame(height: 50)
                            .padding()
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(10)
                            .onReceive(Just(postName)) { (newValue: String) in
                                self.postName = String(newValue.prefix(50))
                            }
                        
                        HStack
                        {
                            Text("Description")
                            
                            Spacer()
                            
                            Text("\(postDescription.count) / 1000 words")
                                .foregroundColor(.secondary)
                                .font(.caption)
                                .padding()
                        }
                        
                        TextEditor(text: $postDescription)
                            .frame(height: 300, alignment: .topLeading)
                            .padding()
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(10)
                            .multilineTextAlignment(.leading)
                            .onReceive(Just(postDescription))
                            { (newValue: String) in
                                self.postDescription = String(newValue.prefix(1000))
                            }
                        
                        Text("Images")
                        PostImageView(image: self.$storeImages)
                        
                        Text("Price")
                        TextField("Input the price.", text: self.$postPrice)
                            .frame(height: 30)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(10)
                            .onReceive(Just(postPrice)) { (newValue: String) in
                                self.postPrice = String(newValue.prefix(10))
                            }
                        
                    }
                    .padding()
                }
                .navigationBarTitle("")
                .navigationBarHidden(true)
            }
        }
    }
}
