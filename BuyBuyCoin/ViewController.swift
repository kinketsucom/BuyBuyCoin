//
//  ViewController.swift
//  BuyBuyCoin
//
//  Created by admin on 2018/08/09.
//  Copyright © 2018年 admin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class ViewController: UIViewController {
    var timer: Timer!
    
    var api = BuyBuyCoinAPI.init()
    var resp = BuyBuyCoinAPI.BuySellResponse()
    var before_resp = BuyBuyCoinAPI.BuySellResponse()
    

    var all_resp = BuyBuyCoinAPI.AllResponse()
    var eval_data = BuyBuyCoinAPI.AllResponseData()
    
    @IBOutlet weak var BitBankBuyLabel: UILabel!
    @IBOutlet weak var BitBankSellLabel: UILabel!
    @IBOutlet weak var DmmBuyLabel: UILabel!
    @IBOutlet weak var DmmSellLabel: UILabel!
    @IBOutlet weak var QuoineBuyLabel: UILabel!
    @IBOutlet weak var QuoineSellLabel: UILabel!

    @IBOutlet weak var RecommendLabel: UILabel!
    @IBOutlet weak var RecommendPriceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil,repeats: true)
        timer.fire()
    }

    @objc func update(tm: Timer) {
        all_resp = api.GetAllCuurent()
        BitBankBuyLabel.text = all_resp.bitbank.buy
        BitBankSellLabel.text = all_resp.bitbank.sell
        DmmBuyLabel.text = all_resp.dmm.buy
        DmmSellLabel.text = all_resp.dmm.sell
        QuoineBuyLabel.text = all_resp.quoine.buy
        QuoineSellLabel.text = all_resp.quoine.sell
        
        //計算部
        eval_data = AllRespMinMaxValue(all_resp: all_resp)
        RecommendLabel.text = "買"+eval_data.min_buy_name+" 売り:"+eval_data.max_sell_name
        RecommendPriceLabel.text = String(Double(eval_data.max_sell_value)! - Double(eval_data.min_buy_value)!)
        
    }
    
    
    func AllRespMinMaxValue(all_resp:BuyBuyCoinAPI.AllResponse)->BuyBuyCoinAPI.AllResponseData{
        var resp_data = BuyBuyCoinAPI.AllResponseData()
        
        var max = Double(all_resp.bitbank.sell)!
        resp_data.max_sell_name = "BB"
        resp_data.max_sell_value = all_resp.bitbank.sell
        //最大売値をみる
        if(max < Double(all_resp.dmm.sell)!){
            max = Double(all_resp.dmm.sell)!
            resp_data.max_sell_name = "DMM"
            resp_data.max_sell_value = all_resp.dmm.sell
        }
        if(max < Double(all_resp.quoine.sell)!){
            resp_data.max_sell_name = "Quione"
            resp_data.max_sell_value = all_resp.quoine.sell
        }
        //最安買値をみる
        var min = Double(all_resp.bitbank.buy)!
        resp_data.min_buy_name = "BB"
        resp_data.min_buy_value = all_resp.bitbank.buy
        if(min > Double(all_resp.dmm.buy)!){
            max = Double(all_resp.dmm.buy)!
            resp_data.min_buy_name = "DMM"
            resp_data.min_buy_value = all_resp.dmm.buy
        }
        if(min > Double(all_resp.quoine.buy)!){
            resp_data.min_buy_name = "Quione"
            resp_data.min_buy_value = all_resp.quoine.buy
        }
        return resp_data
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

