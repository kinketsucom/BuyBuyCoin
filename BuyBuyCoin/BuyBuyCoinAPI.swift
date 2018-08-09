//
//  BuyBuyCoinAPI.swift
//  BuyBuyCoin
//
//  Created by admin on 2018/08/09.
//  Copyright © 2018年 admin. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class BuyBuyCoinAPI{
    var test:Int = 0
    init (){
        test = 2
    }
    struct AllResponseData{
        var max_sell_name = ""
        var max_sell_value = "0"
        var min_buy_name = ""
        var min_buy_value = "9999999999"
    }
    struct AllResponse {
        var bitbank = BuySellResponse()
        var dmm = BuySellResponse()
        var quoine = BuySellResponse()
        var zaif = BuySellResponse()
    }
    struct BuySellResponse{
        var buy:String = "0"
        var sell:String = "0"
    }
    public func GetAllCuurent()->AllResponse{
        var all_resp = AllResponse()
        all_resp.bitbank = GetBitBankCurrent()
        all_resp.dmm = GetDmmCurrent()
        all_resp.quoine = GetQuioneCurrent()
        all_resp.zaif = GetZaifCurrent()
        return all_resp
    }
    
    public func GetZaifCurrent()->BuySellResponse{
        var resp:BuySellResponse = BuySellResponse()
        let semaphore = DispatchSemaphore(value: 0)
        let queue     = DispatchQueue.global(qos: .utility)
        let url = "https://api.zaif.jp/api/1/ticker/btc_jpy"
        Alamofire.request(url, method: .get).responseJSON(queue: queue, completionHandler: { response in
            if let result = response.result.value as? [String: Any] {
                resp.buy = (result["ask"] as! NSNumber).stringValue
                resp.sell = (result["bid"] as! NSNumber).stringValue
            }
            semaphore.signal()
        })
        semaphore.wait()
        return resp
    }
    
    public func GetQuioneCurrent()->BuySellResponse{
        var resp:BuySellResponse = BuySellResponse()
        let semaphore = DispatchSemaphore(value: 0)
        let queue     = DispatchQueue.global(qos: .utility)
        let url = "https://api.quoine.com/products/code/CASH/BTCJPY"
        Alamofire.request(url, method: .get).responseJSON(queue: queue, completionHandler: { response in
            if let result = response.result.value as? [String: Any] {
                resp.buy = ( result["market_ask"] as! NSNumber).stringValue
                resp.sell = (result["market_bid"] as! NSNumber).stringValue
            }
            semaphore.signal()
        })
        semaphore.wait()
        return resp
    }
    public func GetBitBankCurrent()->BuySellResponse{
        var resp:BuySellResponse = BuySellResponse()
        let semaphore = DispatchSemaphore(value: 0)
        let queue     = DispatchQueue.global(qos: .utility)
        let time:String = String(Int(NSDate().timeIntervalSince1970))
        let url = "https://public.bitbank.cc/btc_jpy/ticker?ts="+time
        Alamofire.request(url, method: .get).responseJSON(queue: queue, completionHandler: { response in
            if let result = response.result.value as? [String: Any] {
                let dic = result["data"] as! NSDictionary
                resp.buy = dic["buy"]! as! String
                resp.sell = dic["sell"]! as! String
            }
            semaphore.signal()
        })
        semaphore.wait()
        return resp
    }
    
    public func GetDmmCurrent()->BuySellResponse{
        var resp:BuySellResponse = BuySellResponse()
        let semaphore = DispatchSemaphore(value: 0)
        let queue     = DispatchQueue.global(qos: .utility)
        let url = "https://trade.bitcoin.dmm.com/cccrichpresen/marketpull/gw/market"
        let param:[String:Any] = ["data":["productIds":["OTCEX_BTC/JPY"]],
                                  "event":"priceFeedList"]
        Alamofire.request(url, method: .post,parameters:param, encoding: JSONEncoding.default, headers: nil).responseJSON(queue: queue, completionHandler:{ response in
            if let result = response.result.value as? [String: Any] {
                let dic:NSDictionary = result["body"] as! NSDictionary
                let rate = (dic["rate"] as! NSArray)[0] as!NSArray
                resp.sell = ((rate[2] as! NSArray)[0] as! String).replacingOccurrences(of: ",", with: "")
                resp.buy = ((rate[3] as! NSArray)[0] as! String).replacingOccurrences(of: ",", with: "")
            }
            semaphore.signal()
        })
        semaphore.wait()
        return resp
    }
    
}
