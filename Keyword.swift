/**
 This file is part of the Reductio package.
 (c) Sergio Fernández <fdz.sergio@gmail.com>

 For the full copyright and license information, please view the LICENSE
 file that was distributed with this source code.
 */

import Foundation

internal class Keyword {

    private let ngram: Int = 3
    private var words: [String]

    private lazy var ranking = TextRank<String>()

    init(text: String) {
        self.words = Keyword.preprocess(text: text)
    }

    func execute() -> [String] {
        filterWords()
        buildGraph()
//        return ranking.execute()
//            .sort { $0.1 > $1.1 }
//            .map { $0.0 }
        return ranking.execute().sorted(isOrderedBefore: { $0.1 > $1.1 }).map({ $0.0 })
    }

    func filterWords() {
        self.words = self.words
            .filter(removeShortWords)
            .filter(removeStopWords)
    }

    func buildGraph() {
        for (index, node) in words.enumerated() {
            var (min, max) = (index-ngram, index+ngram)
            if min < 0 { min = words.startIndex }
            if max > words.count { max = words.endIndex }
            words[min..<max].forEach { word in
                ranking.addEdge(from: node, word)
            }
        }
    }
}

private extension Keyword {

    static func preprocess(text: String) -> [String] {

        return text.lowercased().components(separatedBy: NSCharacterSet.letters().inverted)
    }

    func removeShortWords(word: String) -> Bool {
        return word.characters.count > 2
    }

    func removeStopWords(word: String) -> Bool {
        return !Stopwords.contains(word)
    }
}
