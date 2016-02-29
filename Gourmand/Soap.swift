//
//  Soap.swift
//  Gourmand
//
//  Created by alireza ghias on 2/27/16.
//  Copyright © 2016 MacMini. All rights reserved.
//

import Foundation
class Soap : NSObject, NSXMLParserDelegate{
    //MARK: Properties
    var parser : NSXMLParser?
    var dict  = [String:String]()
    let key="YA91-TU72-FU79-XK99"
    var validation = false
    var cardType : String?
    var taskCard : NSURLSessionDataTask?
    var taskAddress : NSURLSessionDataTask?
    
    //MARK: Functions
    func findAddress(address:String, completeHandler:()->()){
        let requestUrl = "https://services.postcodeanywhere.co.uk/CapturePlus/Interactive/Find/v2.10/xmla.ws?"
        + "&Key=" + key
        + "&SearchTerm=" + address
        + "&LastId=" + ""
        + "&SearchFor=" + "Everything"
        + "&Country=" + "GBR"
        + "&LanguagePreference=" + "en"
        + "&MaxSuggestions=" + "7"
        + "&MaxResults=" + "100"
        let url : NSURL = NSURL(string: requestUrl.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)!
        let request = NSMutableURLRequest(URL:url)
        if(taskAddress != nil){
            taskAddress!.cancel()
        }
        taskAddress = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if(data != nil){
                self.parser = NSXMLParser(data: data!)
                self.parser!.delegate = self
                self.parser!.parse()
                dispatch_async(dispatch_get_main_queue(), {
                    completeHandler()
                })
            }
            
        })
        taskAddress!.resume()
            
        
    }
    
    func validateCreditCard(cardNumber:String, completeHandler:()->()){
        let requestUrl = "https://services.postcodeanywhere.co.uk/CardValidation/Interactive/Validate/v1.00/xmla.ws?"
        + "&Key=" + key
        + "&CardNumber=" + cardNumber
        let url : NSURL = NSURL(string: requestUrl.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)!
        let request = NSMutableURLRequest(URL:url)
        if(taskCard != nil) {
            taskCard!.cancel()
        }
        taskCard = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            self.parser = NSXMLParser(data: data!)
            self.parser!.delegate = self
            self.parser!.parse()
            dispatch_async(dispatch_get_main_queue(), {
                completeHandler()
            })
        })
        taskCard!.resume()
       
    }
    func parserDidStartDocument(parser: NSXMLParser) {
        dict.removeAll()
    }
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if((attributeDict["Id"]?.rangeOfString("GBR")) != nil){
            dict[attributeDict["Id"]!] = attributeDict["Text"]
        }else if(attributeDict["CardNumber"] != nil){
            validation = attributeDict["IsValid"] == "True"
            cardType = attributeDict["CardType"]
        }
            
        
    }
    
}