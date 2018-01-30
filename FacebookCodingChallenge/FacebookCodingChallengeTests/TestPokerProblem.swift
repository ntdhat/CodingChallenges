//
//  TestPokerProblem.swift
//  FacebookCodingChallengeTests
//
//  Created by admin on 1/29/18.
//  Copyright © 2018 ntdhat. All rights reserved.
//

import XCTest
@testable import FacebookCodingChallenge

class TestPokerProblem: XCTestCase {
    var sut: PokerGame!
    var arrHandsDealt: [String]!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = PokerGame()
        
        let testBundle = Bundle(for: type(of: self))
        let pathToTestData = testBundle.path(forResource: "p054_poker", ofType: "txt")
        
        var testData: String!
        do {
            testData = try String(contentsOfFile: pathToTestData!, encoding: .utf8)
        }
        catch { tearDown() }
        
        arrHandsDealt = [String]()
        testData.enumerateLines { (line, _) in
            self.arrHandsDealt.append(line)
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        arrHandsDealt = nil
        super.tearDown()
    }
    
    func test_CountHandsWonOfPlayer1() {
        var p1WinsCount = 0
        for text in arrHandsDealt {
            guard let isP1Win = try? sut.defineWinner(input: text) else {
                XCTFail()
                return
            }
            
            if isP1Win { p1WinsCount += 1 }
        }
        print("Player 1 won \(p1WinsCount) time(s) in total \(arrHandsDealt.count) games")
    }
    
    /* Uncomment for other test cases
     
    func test_DefineWinner_ReturnClearWinner() {
        for text in arrHandsDealt {
            guard let _ = try? sut.defineWinner(input: text) else {
                XCTFail()
                return
            }
        }
    }
    
    func test_CompareHighCards_ReturnP1Win() {
        let text = "2C 8C 7D 8S QH 8D 8H JD 2C 7D"
        let arrCards = sut.cardsFromString(str: text)
        
        let cardsP1 = [arrCards[0],arrCards[1],arrCards[2],arrCards[3],arrCards[4]]
        let sortedCardsP1 = sut.sort(cards: cardsP1)
        let (kindsP1, _) = sut.findKindsAndSuits(cards: sortedCardsP1)
        let highCardsP1 = try! sut.findHighCards(rank: Rank.OnePair, sortedCards: sortedCardsP1, kinds: kindsP1)
        
        let cardsP2 = [arrCards[5],arrCards[6],arrCards[7],arrCards[8],arrCards[9]]
        let sortedCardsP2 = sut.sort(cards: cardsP2)
        let (kindsP2, _) = sut.findKindsAndSuits(cards: sortedCardsP2)
        let highCardsP2 = try! sut.findHighCards(rank: Rank.OnePair, sortedCards: sortedCardsP2, kinds: kindsP2)
        
        guard let result = try? sut.compareHighCards(highCardsP1: highCardsP1, highCardsP2: highCardsP2) else {
            XCTFail()
            return
        }
        
        XCTAssertTrue(result)
    }
    
    func test_CompareHighCards_ReturnP2Win() {
        let text = "2C 8C 7D 8S QH 8D 8H 3D QC 7D"
        let arrCards = sut.cardsFromString(str: text)
        
        let cardsP1 = [arrCards[0],arrCards[1],arrCards[2],arrCards[3],arrCards[4]]
        let sortedCardsP1 = sut.sort(cards: cardsP1)
        let (kindsP1, _) = sut.findKindsAndSuits(cards: sortedCardsP1)
        let highCardsP1 = try! sut.findHighCards(rank: Rank.OnePair, sortedCards: sortedCardsP1, kinds: kindsP1)
        
        let cardsP2 = [arrCards[5],arrCards[6],arrCards[7],arrCards[8],arrCards[9]]
        let sortedCardsP2 = sut.sort(cards: cardsP2)
        let (kindsP2, _) = sut.findKindsAndSuits(cards: sortedCardsP2)
        let highCardsP2 = try! sut.findHighCards(rank: Rank.OnePair, sortedCards: sortedCardsP2, kinds: kindsP2)
        
        guard let result = try? sut.compareHighCards(highCardsP1: highCardsP1, highCardsP2: highCardsP2) else {
            XCTFail()
            return
        }
        
        XCTAssertFalse(result)
    }
    
    func test_RankHighCard() {
        let arrTexts = ["5H 2H QH 3D TS",
                        "AH 2H QH 3D TS",
                        "5H 2H QH 3D KS"]
        for text in arrTexts {
            let arrCards = sut.cardsFromString(str: text)
            let sortedCards = sut.sort(cards: arrCards)
            let (kinds, suits) = sut.findKindsAndSuits(cards: sortedCards)
            
            let rank = try! sut.rankPlayerHand(sortedCards: sortedCards, kinds: kinds, suitsCount: suits.keys.count)
            
            XCTAssertEqual(rank, Rank.HighCard)
        }
    }
    
    func test_RankOnePair() {
        let arrTexts = ["5H 2H QH 2D TS",
                        "3H 2H 4H 3D 5S",
                        "5H 2H QH 3D QS",
                        "TH 2H QH 3D TS"]
        for text in arrTexts {
            let arrCards = sut.cardsFromString(str: text)
            let sortedCards = sut.sort(cards: arrCards)
            let (kinds, suits) = sut.findKindsAndSuits(cards: sortedCards)
            
            let rank = try! sut.rankPlayerHand(sortedCards: sortedCards, kinds: kinds, suitsCount: suits.keys.count)
            
            XCTAssertEqual(rank, Rank.OnePair)
        }
    }
    
    func test_RankTwoPairs() {
        let arrTexts = ["5H 2H QH 2D 5S",
                        "3H 2H QH 3D QS",
                        "2H 2S QH 3D QS",
                        "TH 2H QH 2D TS"]
        for text in arrTexts {
            let arrCards = sut.cardsFromString(str: text)
            let sortedCards = sut.sort(cards: arrCards)
            let (kinds, suits) = sut.findKindsAndSuits(cards: sortedCards)
            
            let rank = try! sut.rankPlayerHand(sortedCards: sortedCards, kinds: kinds, suitsCount: suits.keys.count)
            
            XCTAssertEqual(rank, Rank.TwoPairs)
        }
    }
    
    func test_RankThreeOfAKind() {
        let arrTexts = ["5H 2H QH 5D 5S",
                        "3H 3S QH 3D TS",
                        "2H QC QH 3D QS",
                        "TH KH TC 2D TS"]
        for text in arrTexts {
            let arrCards = sut.cardsFromString(str: text)
            let sortedCards = sut.sort(cards: arrCards)
            let (kinds, suits) = sut.findKindsAndSuits(cards: sortedCards)
            
            let rank = try! sut.rankPlayerHand(sortedCards: sortedCards, kinds: kinds, suitsCount: suits.keys.count)
            
            XCTAssertEqual(rank, Rank.ThreeOfAKind)
        }
    }
    
    func test_RankStraight() {
        let arrTexts = ["5H 2H 3H 6D 4S",
                        "TH JS QH AD KS"]
        for text in arrTexts {
            let arrCards = sut.cardsFromString(str: text)
            let sortedCards = sut.sort(cards: arrCards)
            let (kinds, suits) = sut.findKindsAndSuits(cards: sortedCards)
            
            let rank = try! sut.rankPlayerHand(sortedCards: sortedCards, kinds: kinds, suitsCount: suits.keys.count)
            
            XCTAssertEqual(rank, Rank.Straight)
        }
    }
    
    func test_RankFlush() {
        let arrTexts = ["5H 2H 3H 8H 4H",
                        "4S JS QS 2S KS",
                        "4D JD QD 2D KD",
                        "4C JC QC 2C KC"]
        for text in arrTexts {
            let arrCards = sut.cardsFromString(str: text)
            let sortedCards = sut.sort(cards: arrCards)
            let (kinds, suits) = sut.findKindsAndSuits(cards: sortedCards)
            
            let rank = try! sut.rankPlayerHand(sortedCards: sortedCards, kinds: kinds, suitsCount: suits.keys.count)
            
            XCTAssertEqual(rank, Rank.Flush)
        }
    }
    
    func test_RankFullHouse() {
        let arrTexts = ["5H QD QH 5D 5S",
                        "3H 3S TH 3D TS",
                        "2H QC QH 2D QS",
                        "TH KH TC KD TS"]
        for text in arrTexts {
            let arrCards = sut.cardsFromString(str: text)
            let sortedCards = sut.sort(cards: arrCards)
            let (kinds, suits) = sut.findKindsAndSuits(cards: sortedCards)
            
            let rank = try! sut.rankPlayerHand(sortedCards: sortedCards, kinds: kinds, suitsCount: suits.keys.count)
            
            XCTAssertEqual(rank, Rank.FullHouse)
        }
    }
    
    func test_RankFourOfAKind() {
        let arrTexts = ["5H 5D QH 5C 5S",
                        "3H 3S 3C 3D TS",
                        "2H QC QH QD QS",
                        "TH KH TC TD TS"]
        for text in arrTexts {
            let arrCards = sut.cardsFromString(str: text)
            let sortedCards = sut.sort(cards: arrCards)
            let (kinds, suits) = sut.findKindsAndSuits(cards: sortedCards)
            
            let rank = try! sut.rankPlayerHand(sortedCards: sortedCards, kinds: kinds, suitsCount: suits.keys.count)
            
            XCTAssertEqual(rank, Rank.FourOfAKind)
        }
    }
    
    func test_RankStraightFlush() {
        let arrTexts = ["5H 2H 3H 6H 4H",
                        "5D 2D 3D 6D 4D",
                        "5S 2S 3S 6S 4S",
                        "5C 2C 3C 6C 4C"]
        for text in arrTexts {
            let arrCards = sut.cardsFromString(str: text)
            let sortedCards = sut.sort(cards: arrCards)
            let (kinds, suits) = sut.findKindsAndSuits(cards: sortedCards)
            
            let rank = try! sut.rankPlayerHand(sortedCards: sortedCards, kinds: kinds, suitsCount: suits.keys.count)
            
            XCTAssertEqual(rank, Rank.StraightFlush)
        }
    }
    
    func test_RankRoyalFlush() {
        let arrTexts = ["AH QH KH TH JH",
                        "JD QD KD TD AD",
                        "KS QS TS JS AS",
                        "TC JC QC AC KC"]
        for text in arrTexts {
            let arrCards = sut.cardsFromString(str: text)
            let sortedCards = sut.sort(cards: arrCards)
            let (kinds, suits) = sut.findKindsAndSuits(cards: sortedCards)
            
            let rank = try! sut.rankPlayerHand(sortedCards: sortedCards, kinds: kinds, suitsCount: suits.keys.count)
            
            XCTAssertEqual(rank, Rank.RoyalFlush)
        }
    }
    
    func test_FindHighCardsWhenHighCard() {
        let text = "2C 5C 7D 8S QH"
        let arrCards = sut.cardsFromString(str: text)
        let sortedCards = sut.sort(cards: arrCards)
        let (kinds, _) = sut.findKindsAndSuits(cards: sortedCards)
        
        let highCards = try! sut.findHighCards(rank: Rank.HighCard, sortedCards: sortedCards, kinds: kinds)
        
        XCTAssertEqual(highCards.count, 5)
        XCTAssertEqual(highCards[0], Card.Kind.queen.rawValue)
        XCTAssertEqual(highCards[1], Card.Kind.eight.rawValue)
        XCTAssertEqual(highCards[2], Card.Kind.seven.rawValue)
        XCTAssertEqual(highCards[3], Card.Kind.five.rawValue)
        XCTAssertEqual(highCards[4], Card.Kind.two.rawValue)
    }
    
    func test_FindHighCardsWhenOnePair() {
        let text = "2C 8C 7D 8S QH"
        let arrCards = sut.cardsFromString(str: text)
        let sortedCards = sut.sort(cards: arrCards)
        let (kinds, _) = sut.findKindsAndSuits(cards: sortedCards)
        
        let highCards = try! sut.findHighCards(rank: Rank.OnePair, sortedCards: sortedCards, kinds: kinds)
        
        XCTAssertEqual(highCards.count, 4)
        XCTAssertEqual(highCards[0], Card.Kind.eight.rawValue)
        XCTAssertEqual(highCards[1], Card.Kind.queen.rawValue)
        XCTAssertEqual(highCards[2], Card.Kind.seven.rawValue)
        XCTAssertEqual(highCards[3], Card.Kind.two.rawValue)
    }
    
    func test_FindHighCardsWhenTwoPairs() {
        let text = "7C 8C 7D 8S QH"
        let arrCards = sut.cardsFromString(str: text)
        let sortedCards = sut.sort(cards: arrCards)
        let (kinds, _) = sut.findKindsAndSuits(cards: sortedCards)
        
        let highCards = try! sut.findHighCards(rank: Rank.TwoPairs, sortedCards: sortedCards, kinds: kinds)
        
        XCTAssertEqual(highCards.count, 3)
        XCTAssertEqual(highCards[0], Card.Kind.eight.rawValue)
        XCTAssertEqual(highCards[1], Card.Kind.seven.rawValue)
        XCTAssertEqual(highCards[2], Card.Kind.queen.rawValue)
    }
    
    func test_FindHighCardsWhenThreeOfAKind() {
        let text = "8C 8D 7D 8S QH"
        let arrCards = sut.cardsFromString(str: text)
        let sortedCards = sut.sort(cards: arrCards)
        let (kinds, _) = sut.findKindsAndSuits(cards: sortedCards)
        
        let highCards = try! sut.findHighCards(rank: Rank.ThreeOfAKind, sortedCards: sortedCards, kinds: kinds)
        
        XCTAssertEqual(highCards.count, 3)
        XCTAssertEqual(highCards[0], Card.Kind.eight.rawValue)
        XCTAssertEqual(highCards[1], Card.Kind.queen.rawValue)
        XCTAssertEqual(highCards[2], Card.Kind.seven.rawValue)
    }
    
    func test_FindHighCardsWhenStraight() {
        let text = "5C 8D 7D 6S 4H"
        let arrCards = sut.cardsFromString(str: text)
        let sortedCards = sut.sort(cards: arrCards)
        let (kinds, _) = sut.findKindsAndSuits(cards: sortedCards)
        
        let highCards = try! sut.findHighCards(rank: Rank.Straight, sortedCards: sortedCards, kinds: kinds)
        
        XCTAssertEqual(highCards.count, 1)
        XCTAssertEqual(highCards[0], Card.Kind.eight.rawValue)
    }
    
    func test_FindHighCardsWhenFlush() {
        let text = "5D 8D 7D 2D JD"
        let arrCards = sut.cardsFromString(str: text)
        let sortedCards = sut.sort(cards: arrCards)
        let (kinds, _) = sut.findKindsAndSuits(cards: sortedCards)
        
        let highCards = try! sut.findHighCards(rank: Rank.Flush, sortedCards: sortedCards, kinds: kinds)
        
        XCTAssertEqual(highCards.count, 5)
        XCTAssertEqual(highCards[0], Card.Kind.jack.rawValue)
        XCTAssertEqual(highCards[1], Card.Kind.eight.rawValue)
        XCTAssertEqual(highCards[2], Card.Kind.seven.rawValue)
        XCTAssertEqual(highCards[3], Card.Kind.five.rawValue)
        XCTAssertEqual(highCards[4], Card.Kind.two.rawValue)
    }
    
    func test_FindHighCardsWhenFullHouse() {
        let text = "8C 8D QD 8S QH"
        let arrCards = sut.cardsFromString(str: text)
        let sortedCards = sut.sort(cards: arrCards)
        let (kinds, _) = sut.findKindsAndSuits(cards: sortedCards)
        
        let highCards = try! sut.findHighCards(rank: Rank.FullHouse, sortedCards: sortedCards, kinds: kinds)
        
        XCTAssertEqual(highCards.count, 2)
        XCTAssertEqual(highCards[0], Card.Kind.eight.rawValue)
        XCTAssertEqual(highCards[1], Card.Kind.queen.rawValue)
    }
    
    func test_FindHighCardsWhenFourOfAKind() {
        let text = "8C 8D 3D 8S 8H"
        let arrCards = sut.cardsFromString(str: text)
        let sortedCards = sut.sort(cards: arrCards)
        let (kinds, _) = sut.findKindsAndSuits(cards: sortedCards)
        
        let highCards = try! sut.findHighCards(rank: Rank.FourOfAKind, sortedCards: sortedCards, kinds: kinds)
        
        XCTAssertEqual(highCards.count, 2)
        XCTAssertEqual(highCards[0], Card.Kind.eight.rawValue)
        XCTAssertEqual(highCards[1], Card.Kind.three.rawValue)
    }
    
    func test_FindHighCardsWhenStraightFlush() {
        let text = "5D 8D 7D 6D 4D"
        let arrCards = sut.cardsFromString(str: text)
        let sortedCards = sut.sort(cards: arrCards)
        let (kinds, _) = sut.findKindsAndSuits(cards: sortedCards)
        
        let highCards = try! sut.findHighCards(rank: Rank.StraightFlush, sortedCards: sortedCards, kinds: kinds)
        
        XCTAssertEqual(highCards.count, 1)
        XCTAssertEqual(highCards[0], Card.Kind.eight.rawValue)
    }
    
    func test_FindHighCardsWhenRoyalFlush() {
        let text = "JD QD AD KD TD"
        let arrCards = sut.cardsFromString(str: text)
        let sortedCards = sut.sort(cards: arrCards)
        let (kinds, _) = sut.findKindsAndSuits(cards: sortedCards)
        
        let highCards = try! sut.findHighCards(rank: Rank.RoyalFlush, sortedCards: sortedCards, kinds: kinds)
        
        XCTAssertEqual(highCards.count, 1)
        XCTAssertEqual(highCards[0], Card.Kind.ace.rawValue)
    }
    
    func test_FindKindsAndSuits() {
        for str in arrHandsDealt {
            let arrCardStrs = str.split(separator: " ")
            var expectedKindsP1 = [String:UInt]()
            var expectedSuitsP1 = [String:UInt]()
            for idx in 0...4 {
                let cardStr = arrCardStrs[idx]
                let kindIndex = cardStr.startIndex
                let kindChar = String(cardStr[kindIndex])
                if let k = expectedKindsP1[kindChar] {
                    expectedKindsP1[kindChar] = k + 1
                } else {
                    expectedKindsP1[kindChar] = 1
                }
                
                let suitIndex = cardStr.index(cardStr.startIndex, offsetBy: 1)
                let suitChar = String(cardStr[suitIndex])
                if let s = expectedSuitsP1[suitChar] {
                    expectedSuitsP1[suitChar] = s + 1
                } else {
                    expectedSuitsP1[suitChar] = 1
                }
            }
            
            let arrCards = sut.cardsFromString(str: str)
            let sortedCardsP1 = sut.sort(cards: [arrCards[0], arrCards[1], arrCards[2], arrCards[3], arrCards[4]])
            let (kindsP1, suitsP1) = sut.findKindsAndSuits(cards: sortedCardsP1)
            
            XCTAssertEqual(kindsP1.keys.count, expectedKindsP1.keys.count)
            for key in expectedKindsP1.keys {
                let kind: UInt
                switch key {
                case "2","3","4","5","6","7","8","9":
                    kind = UInt(key)!
                case "T":
                    kind = 10
                case "J":
                    kind = 11
                case "Q":
                    kind = 12
                case "K":
                    kind = 13
                default:
                    kind = 14
                }
                XCTAssertEqual(kindsP1[kind], expectedKindsP1[key])
            }
            
            XCTAssertEqual(suitsP1.keys.count, expectedSuitsP1.keys.count)
            for key in expectedSuitsP1.keys {
                XCTAssertEqual(suitsP1[key], expectedSuitsP1[key])
            }
        }
    }
    
    func test_CardsIsStraight() {
        let arrTexts = ["AH KH QH JD TS",
                        "KD QH JC TC 9D",
                        "QS JS TS 9D 8C",
                        "TH 9S 8D 7D 6H",
                        "6C 5C 4C 3C 2C"]
        for str in arrTexts {
            let arrCards = sut.cardsFromString(str: str)
            let sortedCards = sut.sort(cards: arrCards)
            XCTAssertTrue(sut.isCardsStraight(sortedCards: sortedCards))
        }
    }
    
    func test_CardsIsNotStraight() {
        let arrTexts = ["AH KH QH JD JS",
                        "AH KH QH TD TS",
                        "AH KH QH TD 9S",
                        "AH KH KH TD 9S",
                        "AH KH QH QD JS",
                        "AH AD AS KD QS",
                        "KD QH JC 9C 8D",
                        "QS JS JH 9D 8C",
                        "9H 9S 8D 7D 6H",
                        "AC 5C 4C 3C 2C"]
        for text in arrTexts {
            let arrCards = sut.cardsFromString(str: text)
            let sortedCards = sut.sort(cards: arrCards)
            XCTAssertFalse(sut.isCardsStraight(sortedCards: sortedCards))
        }
    }
    
    func test_Sort() {
        for str in arrHandsDealt {
            let cards = sut.cardsFromString(str: str)
            let cardsForP1 = [cards[0],cards[1],cards[2],cards[3],cards[4]]
            let cardsForP2 = [cards[5],cards[6],cards[7],cards[8],cards[9]]
            let sortedCardsP1 = sut.sort(cards: cardsForP1)
            let sortedCardsP2 = sut.sort(cards: cardsForP2)
            
            XCTAssertTrue(sortedCardsP1[0].kind.rawValue >= sortedCardsP1[1].kind.rawValue)
            XCTAssertTrue(sortedCardsP1[1].kind.rawValue >= sortedCardsP1[2].kind.rawValue)
            XCTAssertTrue(sortedCardsP1[2].kind.rawValue >= sortedCardsP1[3].kind.rawValue)
            XCTAssertTrue(sortedCardsP1[3].kind.rawValue >= sortedCardsP1[4].kind.rawValue)
            
            XCTAssertTrue(sortedCardsP2[0].kind.rawValue >= sortedCardsP2[1].kind.rawValue)
            XCTAssertTrue(sortedCardsP2[1].kind.rawValue >= sortedCardsP2[2].kind.rawValue)
            XCTAssertTrue(sortedCardsP2[2].kind.rawValue >= sortedCardsP2[3].kind.rawValue)
            XCTAssertTrue(sortedCardsP2[3].kind.rawValue >= sortedCardsP2[4].kind.rawValue)
        }
        
    }
    
    func test_ParseCardsFromString_ReturnCardsInText() {
        for str in arrHandsDealt {
            let cards = sut.cardsFromString(str: str)
            XCTAssertNotNil(cards)
            XCTAssertTrue(cards.count == 10)
        }
    }
    
    func test_ParseCardFromString_ReturnCard() {
        for kind in 2...14 {
            let kindStr: String!
            switch kind {
            case 2...9:
                kindStr = String(kind)
            case 10:
                kindStr = "T"
            case 11:
                kindStr = "J"
            case 12:
                kindStr = "Q"
            case 13:
                kindStr = "K"
            default:
                kindStr = "A"
            }
            for suit in ["C", "D", "S", "H"] {
                let inputText: String = kindStr + suit
                let expectedReturnCard = Card(kind: Card.Kind(rawValue: UInt(kind))!, suit: Card.Suit(rawValue: suit)!)
                let createdCard = sut.cardFromString(str: inputText)
                XCTAssertEqual(createdCard.kind, expectedReturnCard.kind)
                XCTAssertEqual(createdCard.suit, expectedReturnCard.suit)
            }
        }
    }
    */
}
