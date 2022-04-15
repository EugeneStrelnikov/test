//
//  WebService.swift
//  Test
//
//  Created by Eugene on 15.04.2022.
//

import Foundation
import Combine

class WebService {
    var url = URL(string: "https://api.tjournal.ru/v2.1/timeline")!
    
    func getEntries() -> AnyPublisher<[Entry], Never> {
        let publisher = URLSession.shared.dataTaskPublisher(for: url)
            .tryMap {
                $0.data
            }
            .decode(type: TimelineResponse.self, decoder: JSONDecoder())
            .map { response in
                response.result.items
            }
            .map { items in
                items
                    .compactMap { item in
                        Entry.fromTimelineItem(item.data)
                    }
                    .filter { $0.group != "Непонятно" } //FIXME: 123
            }
            .receive(on: RunLoop.main)
            .catch { e -> AnyPublisher<[Entry], Never> in
                //TODO: 123
                return Just([Entry]()).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        return publisher
    }
}

extension Entry {
    static func fromTimelineItem(_ item: TimelineItemData) -> Entry? {
        guard let block = item.blocks.first else { return nil }
        
        var description = ""
        var imageId: String? = nil
        switch block.data {
        case .media(let mediaBlock):
            imageId = mediaBlock.items.first?.image.data.uuid
            description = mediaBlock.items.first?.title ?? ""
            print("media, \(block.type)")
        case .tweet(let tweetBlock):
            description = tweetBlock.markdown
            print("tweet, \(block.type)")
        case .hz(let hzBlock):
            print("hz, \(block.type)")
        }
        
        let entry = Entry(
            id: item.id,
            title: item.title,
            description: description,
            imageId: imageId,
            authorName: item.author.name,
            date: Date(timeIntervalSince1970: item.date),
            group: block.data.group,
            commentsCount: item.counters.comments,
            rating: 9999 //TODO: Непонятно
        )
        return entry
    }
}

struct TimelineResponse: Codable {
    var message: String
    var result: TimelineResult
}

struct TimelineResult: Codable {
    var items: [TimelineItem]
    var lastId: Double
    var lastSortingValue: Double
}

struct TimelineItem: Codable {
    var type: String
    var data: TimelineItemData
}

struct TimelineItemData: Codable {
    var id: Int
    var title: String
    var date: Double
    var blocks: [TimelineItemDataBlock]
    var counters: Counters
    var author: TimelineItemDataAuthor
    
    struct TimelineItemDataAuthor: Codable {
        var name: String
    }

    struct Counters: Codable {
        var comments: Int
    }
    
    struct TimelineItemDataBlock: Codable {
        var type: String
        var data: BlockType
    }


    enum BlockType: Codable {
        case tweet(TimelineItemDataBlockTweetData)
        case media(TimelineItemDataBlockMediaData)
        case hz(HZ)

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let x = try? container.decode(TimelineItemDataBlockTweetData.self) {
                self = .tweet(x)
                return
            }
            if let x = try? container.decode(TimelineItemDataBlockMediaData.self) {
                self = .media(x)
                return
            }
            if let x = try? container.decode(HZ.self) {
                self = .hz(x)
                return
            }
            throw DecodingError.typeMismatch(BlockType.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for MyValue"))
        }
        
        var group: String {
            switch self {
            case .tweet(_):
                return "Твиттер"
            case .media(_):
                return "Медиа"
            case .hz(_):
                return "Непонятно"
            }
        }
    }

    struct HZ: Codable {
    }
    
    struct TimelineItemDataBlockTweetData: Codable {
        var markdown: String
    }

    struct TimelineItemDataBlockMediaData: Codable {
        var items: [TimelineItemDataBlockMediaDataItem]
        
        struct TimelineItemDataBlockMediaDataItem: Codable {
            var title: String
            var image: TimelineItemDataBlockMediaDataItemImage
            
            struct TimelineItemDataBlockMediaDataItemImage: Codable {
                var type: String
                var data: TimelineImageData
            }

        }
    }

}

struct TimelineImageData: Codable {
    var uuid: String
}

