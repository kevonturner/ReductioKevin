/**
 This file is part of the Reductio package.
 (c) Sergio Fernández <fdz.sergio@gmail.com>

 For the full copyright and license information, please view the LICENSE
 file that was distributed with this source code.
 */

import Foundation

internal struct Stemmer {

    typealias Language = String
    typealias Script = String

    private static let language: Language = "en"
    private static let script: Script = "Latn"
    private static let orthography = NSOrthography(dominantScript: script, languageMap: [script : [language]])

    static func stemmingWordsInText(text: String) -> [String] {
        var stems: [String] = []

        let range = NSRange(location: 0, length: text.characters.count)
        let tagOptions: NSLinguisticTagger.Options = [.omitWhitespace, .omitPunctuation, .omitOther]
        let tagSchemes = NSLinguisticTagger.availableTagSchemes(forLanguage: language)
        let tagger = NSLinguisticTagger(tagSchemes: tagSchemes, options: Int(tagOptions.rawValue))

        tagger.string = text
        tagger.setOrthography(orthography, range: range)
        tagger.enumerateTags(in: range, scheme: NSLinguisticTagSchemeLemma, options: tagOptions) { (tag: String?, tokenRange, range, stop) in
            let token = (text as NSString).substring(with: tokenRange)
            if !token.isEmpty {
                stems.append(token.lowercased())
            }
        }

        return stems
    }
}
