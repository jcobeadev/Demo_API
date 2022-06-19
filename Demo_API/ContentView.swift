//
//  ContentView.swift
//  Demo_API
//
//  Created by Jco Bea on 6/19/22.
//

import SwiftUI

struct Quote: Codable {
    var id: Int
    var quote: String
    var author: String
    
    enum CodingKeys: CodingKey {
        case id
        case quote
        case author
        
        var stringValue: String {
            switch self {
            case .id:
                return "quote_id"
            case .quote:
                return "quote"
            case .author:
                return "author"
            }
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        quote = try container.decode(String.self, forKey: .quote)
        author = try container.decode(String.self, forKey: .author)
    }
}

struct ContentView: View {
    
    @State private var quotes: [Quote] = []
    
    var body: some View {
        NavigationView {
            List(quotes, id: \.id) { quote in
                VStack(alignment: .leading) {
                    Text(quote.author)
                        .font(.headline)
                        .foregroundColor(.primary)
//                        .foregroundColor(Color("skyBlue"))
                    Text(quote.quote)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Quotes")
        }.task {
            await fetchData()
        }
    }
    
    func fetchData() async {
        
        guard let url = URL(string: "https://www.breakingbadapi.com/api/quotes") else {
            print("url doesnt exist")
            return
        }
        
        do {
            let response = try await URLSession.shared.data(from: url)
            let data = response.0
            
            if let decodedResponse = try? JSONDecoder().decode([Quote].self, from: data) {
                quotes = decodedResponse
            }
            
        } catch {
            print("error: \(error.localizedDescription)")
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
