import Foundation

struct Card {
    enum Kind: UInt {
        case two = 2, three, four, five, six, seven, eight, nine, ten, jack, queen, king, ace
    }
    enum Suit: String {
        case spade = "S", heart = "H", diamond = "D", club = "C"
    }
    
    let kind: Kind, suit: Suit
}

enum Rank: Int {
    case HighCard = 1, OnePair, TwoPairs, ThreeOfAKind, Straight, Flush, FullHouse, FourOfAKind, StraightFlush, RoyalFlush
}

enum CardError: String, Error {
    case Ranking = "Ranking"
    case DefineHighCards = "Defining high cards"
    case CompareHighCards = "Comparing high cards"
}

class PokerGame {    
    // Define the winner from input string (of the dealed hand), return winner position
    func defineWinner(input: String) throws -> Bool {
        var arrCards = cardsFromString(str: input)
        
        let sortedCardsP1 = sort(cards: [arrCards[0], arrCards[1], arrCards[2], arrCards[3], arrCards[4]])
        let sortedCardsP2 = sort(cards: [arrCards[5], arrCards[6], arrCards[7], arrCards[8], arrCards[9]])
        let (kindsP1, suitsP1) = findKindsAndSuits(cards: sortedCardsP1)
        let (kindsP2, suitsP2) = findKindsAndSuits(cards: sortedCardsP2)
        
        guard let rankP1 = try? rankPlayerHand(sortedCards: sortedCardsP1, kinds: kindsP1, suitsCount: suitsP1.keys.count),
            let rankP2 = try? rankPlayerHand(sortedCards: sortedCardsP2, kinds: kindsP2, suitsCount: suitsP2.keys.count)
            else {
                print("Error: \(CardError.Ranking)")
                throw CardError.Ranking
        }
        
        let finalWinner: Bool
        
        if rankP1 != rankP2 {
            finalWinner = rankP1.rawValue > rankP2.rawValue ? true : false
        } else {
            // Two players have the same rank hands => Check High cards
            guard let highCardsP1 = try? findHighCards(rank: rankP1, sortedCards: sortedCardsP1, kinds: kindsP1),
                let highCardsP2 = try? findHighCards(rank: rankP2, sortedCards: sortedCardsP2, kinds: kindsP2)
                else {
                    print("Error: \(CardError.DefineHighCards)")
                    throw CardError.DefineHighCards
            }
            do {
                finalWinner = try compareHighCards(highCardsP1: highCardsP1, highCardsP2: highCardsP2)
            } catch {
                print("Error: \(CardError.CompareHighCards)")
                throw CardError.CompareHighCards
            }
        }
        
        return finalWinner
    }
    
    func rankPlayerHand(sortedCards: [Card], kinds: [UInt:UInt], suitsCount: Int) throws -> Rank {
        let isStraight = isCardsStraight(sortedCards: sortedCards)
        
        var rank: Rank?
        
        if suitsCount == 1 {
            // Cards is same suit
            rank = isStraight ? (sortedCards[0].kind.rawValue == Card.Kind.ace.rawValue ? Rank.RoyalFlush : Rank.StraightFlush) : Rank.Flush
        } else {
            // Cards is not same suit
            if isStraight {
                rank = Rank.Straight
            } else {
                switch kinds.keys.count {
                case 5:
                    rank = Rank.HighCard
                case 4:
                    rank = Rank.OnePair
                case 3:
                    for kind in kinds {
                        if kind.value == 2 {
                            rank = Rank.TwoPairs
                            break
                        }
                        rank = Rank.ThreeOfAKind
                    }
                case 2:
                    rank = kinds.first?.value == 2 || kinds.first?.value == 3 ? Rank.FullHouse : Rank.FourOfAKind
                default:
                    throw CardError.Ranking
                }
            }
        }
        
        guard let safeRank = rank else { throw CardError.Ranking }
        
        return safeRank
    }
    
    func findHighCards(rank: Rank, sortedCards: [Card], kinds: [UInt:UInt]) throws -> [UInt] {
        var highCards: [UInt]
        
        switch rank {
        case .HighCard:
            highCards = [UInt]()
            for idx in 0..<5 {
                highCards.append(sortedCards[idx].kind.rawValue)
            }
        case .OnePair:
            var thePair: UInt = 0
            var others = [UInt]()
            for kind in kinds {
                if kind.value == 2 {
                    thePair = kind.key
                } else {
                    others.append(kind.key)
                }
            }
            highCards = others.sorted(by: { return $0 > $1 })
            highCards.insert(thePair, at: 0)
        case .TwoPairs:
            var pairs = [UInt]()
            var lastCard: UInt = 0
            for kind in kinds {
                if kind.value == 2 {
                    pairs.append(kind.key)
                } else {
                    lastCard = kind.key
                }
            }
            highCards = pairs.sorted(by: { return $0 > $1 })
            highCards.append(lastCard)
        case .ThreeOfAKind:
            var theThree: UInt = 0
            var others = [UInt]()
            for kind in kinds {
                if kind.value == 1 {
                    others.append(kind.key)
                } else {
                    theThree = kind.key
                }
            }
            highCards = others.sorted(by: { return $0 > $1 })
            highCards.insert(theThree, at: 0)
        case .Straight:
            highCards = [sortedCards[0].kind.rawValue]
        case .Flush:
            highCards = [UInt]()
            for idx in 0..<5 {
                highCards.append(sortedCards[idx].kind.rawValue)
            }
        case .FullHouse:
            var theThree: UInt = 0
            var thePair: UInt = 0
            for kind in kinds {
                if kind.value == 2 {
                    thePair = kind.key
                } else {
                    theThree = kind.key
                }
            }
            highCards = [theThree, thePair]
        case .FourOfAKind:
            var theFour: UInt = 0
            var lastCard: UInt = 0
            for kind in kinds {
                if kind.value == 1 {
                    lastCard = kind.key
                } else {
                    theFour = kind.key
                }
            }
            highCards = [theFour, lastCard]
        case .StraightFlush:
            highCards = [sortedCards[0].kind.rawValue]
        case .RoyalFlush:
            highCards = [sortedCards[0].kind.rawValue]
        }
        
        return highCards
    }
    
    func findKindsAndSuits(cards:[Card]) -> (kinds: [UInt:UInt], suits: [String:UInt]) {
        var kinds = [UInt:UInt]()
        var suits = [String:UInt]()
        for card in cards {
            if let s = suits[card.suit.rawValue] {
                suits[card.suit.rawValue] = s + 1
            } else {
                suits[card.suit.rawValue] = 1
            }
            
            if let k = kinds[card.kind.rawValue] {
                kinds[card.kind.rawValue] = k + 1
            } else {
                kinds[card.kind.rawValue] = 1
            }
        }
        return (kinds, suits)
    }
    
    func isCardsStraight(sortedCards: [Card]) -> Bool {
        var isStraight = true
        let firstCardValue = sortedCards[0].kind.rawValue
        for index in 1..<sortedCards.count {
            if !isStraight {
                break
            }
            let card = sortedCards[index]
            isStraight = (card.kind.rawValue + UInt(index) == firstCardValue)
        }
        return isStraight
    }
    
    func sort(cards: [Card]) -> [Card] {
        return cards.sorted(by: { (card1, card2) -> Bool in
            return card1.kind.rawValue > card2.kind.rawValue
        })
    }
    
    func compareHighCards(highCardsP1: [UInt], highCardsP2: [UInt]) throws -> Bool {
        guard highCardsP1.count == highCardsP2.count else {
            throw CardError.CompareHighCards
        }
        
        var result: Bool?
        for idx in 0..<highCardsP1.count {
            if highCardsP1[idx] != highCardsP2[idx] {
                result = highCardsP1[idx] > highCardsP2[idx]
                break
            }
        }
        
        guard let safeResult = result else {
            throw CardError.CompareHighCards
        }
        
        return safeResult
    }
    
    func cardsFromString(str: String) -> [Card] {
        let arrCardStrs = str.split(separator: " ")
        var arrCards = [Card]()
        for cardStr in arrCardStrs {
            let card = cardFromString(str: String(cardStr))
            arrCards.append(card)
        }
        return arrCards
    }
    
    func cardFromString(str: String) -> Card {
        let kindIndex = str.startIndex
        let kindChar = String(str[kindIndex])
        let kind: UInt
        switch kindChar {
        case "2","3","4","5","6","7","8","9":
            kind = UInt(kindChar)!
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
        
        let suitIndex = str.index(str.startIndex, offsetBy: 1)
        let suit = String(str[suitIndex])
        
        return Card(kind: Card.Kind(rawValue: kind)!, suit: Card.Suit(rawValue:suit)!)
    }
}

