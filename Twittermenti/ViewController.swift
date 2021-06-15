//
//  ViewController.swift
//  Twittermenti
//
//  Created by Jevgenijs Jefrosinins on 14/05/2021.
//

import UIKit
import SwifteriOS
import CoreML
import SwiftyJSON

class ViewController: UIViewController {
    
    let sentimentClassifier: TweetSentimentClassifier = try! TweetSentimentClassifier(configuration: MLModelConfiguration.init())
    
    let tweetsCount = 100
    let tweetsLanguage = "en"
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    
    let swifter = Swifter(consumerKey: Secrets.apiKey, consumerSecret: Secrets.apiKeySecret)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Instantiation using Twitter's OAuth Consumer Key and secret
        
    }
    
    @IBAction func predictPressed(_ sender: Any) {
        
        fetchTweets()
       
    }
    
    func fetchTweets() {
        if let searchText = textField.text {
            swifter.searchTweet(using: searchText, lang: tweetsLanguage, count: tweetsCount, tweetMode: .extended, success: { [self] results, metadata in
                
                var tweets = [TweetSentimentClassifierInput]()
                
                for i in 0..<tweetsCount {
                    if let tweet = results[i]["full_text"].string {
                        let tweetForClassification = TweetSentimentClassifierInput(text: tweet)
                        tweets.append(tweetForClassification)
                    }
                }
                makePrediction(with: tweets)
            }, failure: { error in
                print("There was error with Twitter API Request, \(error)")
            }
            )}
    }
    
    func makePrediction(with tweets: [TweetSentimentClassifierInput]) {
        do {
            let predictions = try sentimentClassifier.predictions(inputs: tweets)
            
            var sentimentScore = 0
            
            for prediction in predictions {
                let sentiment = prediction.label
                if sentiment == "Pos" {
                    sentimentScore += 1
                } else if sentiment == "Neg" {
                    sentimentScore -= 1
                }
            }
            updateUI(with: sentimentScore)
        } catch {
            print("There was an error with prediction, \(error)")
        }
    }
    
    func updateUI(with sentimentScore: Int) {
        if sentimentScore > 20 {
            sentimentLabel.text = "😍"
        } else if sentimentScore > 10 {
            sentimentLabel.text = "😁"
        } else if sentimentScore == 0 {
            sentimentLabel.text = "😐"
        } else if sentimentScore > -10 {
            sentimentLabel.text = "☹️"
        } else if sentimentScore > -20 {
            sentimentLabel.text = "🤬"
        } else {
            sentimentLabel.text = "🤮"
        }
    }
}

