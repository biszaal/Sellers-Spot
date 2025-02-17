import SwiftUI
import SDWebImageSwiftUI

struct MessagesListView: View
{
    var theirId: String
    var chatId: String
    
    @ObservedObject var userObserver = UserDataObserver()
    @ObservedObject var messageObserver = MessagesObserver()
    
    @State var user: UserData = UserData(id: "", name: "", email: "", image: "")
    
    @State var message: String = ""
    @State var time: Date = Date()
    @State var dateFormatter = DateFormatter()
    
    var body: some View
    {
        HStack(spacing: 12)
        {
            WebImage(url: URL(string: user.image))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 40, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                .overlay(
                    Circle().stroke(Color.blue, lineWidth: 1))
                .shadow(radius: 5)
            
            VStack(alignment: .leading, spacing: 12)
            {
                Text(user.name)
                    .lineLimit(1)
                
                Text(message)
                    .font(.caption)
                    .lineLimit(1)
            }
            
            Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
            
            VStack
            {
                Text(time.timeAgoDisplayed())
                    .font(.caption)
                
                Spacer()
            }
        }
        .padding(.vertical)
        
        .onAppear()
        {
            userObserver.getUserDetails(id: self.theirId)
            { user in
                self.user = user
            }
            
            messageObserver.lastText(chatId: self.chatId)
            { message  in
                self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                let time = self.dateFormatter.date(from: message.time) ?? Date()
                self.message = message.message
                self.time = time
            }
        }
    }
}
