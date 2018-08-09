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
    
    var all_resp = BuyBuyCoinAPI.AllResponse()
    var before_all_resp = BuyBuyCoinAPI.AllResponse()
    
    var eval_data = BuyBuyCoinAPI.AllResponseData()
    
    @IBOutlet weak var BitBankBuyLabel: UILabel!
    @IBOutlet weak var BitBankSellLabel: UILabel!
    @IBOutlet weak var BitBankBuyView: UIView!
    @IBOutlet weak var BitBankSellView: UIView!
    @IBOutlet weak var DmmBuyLabel: UILabel!
    @IBOutlet weak var DmmSellLabel: UILabel!
    @IBOutlet weak var DmmBuyView: UIView!
    @IBOutlet weak var DmmSellView: UIView!
    @IBOutlet weak var QuoineBuyLabel: UILabel!
    @IBOutlet weak var QuoineSellLabel: UILabel!
    @IBOutlet weak var QuoineBuyView: UIView!
    @IBOutlet weak var QuoineSellView: UIView!
    @IBOutlet weak var ZaifBuyLabel: UILabel!
    @IBOutlet weak var ZaifSellLabel: UILabel!
    @IBOutlet weak var ZaifBuyView: UIView!
    @IBOutlet weak var ZaifSellView: UIView!
    
    
    
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
        //前回の値と比較
        EvalAllResp(all_resp: all_resp, before_all_resp: before_all_resp)
        before_all_resp = all_resp
        //計算部
        eval_data = AllRespMinMaxValue(all_resp: all_resp)
        SetText(eval_data: eval_data)
        RecommendLabel.text = "買"+eval_data.min_buy_name+" 売り:"+eval_data.max_sell_name
        RecommendPriceLabel.text = String(Double(eval_data.max_sell_value)! - Double(eval_data.min_buy_value)!)
    }
    
    
    
    func EvalAllResp(all_resp:BuyBuyCoinAPI.AllResponse,before_all_resp:BuyBuyCoinAPI.AllResponse){
        //bitbank
        if(Double(all_resp.bitbank.buy)!>Double(before_all_resp.bitbank.buy)!){
            BitBankBuyLabel.textColor = UIColor.green
        }else if(Double(all_resp.bitbank.buy)! == Double(before_all_resp.bitbank.buy)!){
            BitBankBuyLabel.textColor = UIColor.black
        }else{
            BitBankBuyLabel.textColor = UIColor.red
        }
        if(Double(all_resp.bitbank.sell)! > Double(before_all_resp.bitbank.sell)!){
            BitBankSellLabel.textColor = UIColor.green
        }else if(Double(all_resp.bitbank.sell)! == Double(before_all_resp.bitbank.sell)!){
            BitBankSellLabel.textColor = UIColor.black
        }else{
            BitBankSellLabel.textColor = UIColor.red
        }
        //Dmm
        if(Double(all_resp.dmm.buy)!>Double(before_all_resp.dmm.buy)!){
            DmmBuyLabel.textColor = UIColor.green
        }else if(Double(all_resp.dmm.buy)! == Double(before_all_resp.dmm.buy)!){
            DmmBuyLabel.textColor = UIColor.black
        }else{
            DmmBuyLabel.textColor = UIColor.red
        }
        if(Double(all_resp.dmm.sell)! > Double(before_all_resp.dmm.sell)!){
            DmmSellLabel.textColor = UIColor.green
        }else if(Double(all_resp.dmm.sell)! == Double(before_all_resp.dmm.sell)!){
            DmmSellLabel.textColor = UIColor.black
        }else{
            DmmSellLabel.textColor = UIColor.red
        }
        //Quoine
        if(Double(all_resp.quoine.buy)! > Double(before_all_resp.quoine.buy)!){
            QuoineBuyLabel.textColor = UIColor.green
        }else if(Double(all_resp.quoine.buy)! == Double(before_all_resp.quoine.buy)!){
            QuoineBuyLabel.textColor = UIColor.black
        }else{
            QuoineBuyLabel.textColor = UIColor.red
        }
        if(Double(all_resp.quoine.sell)! > Double(before_all_resp.quoine.sell)!){
            QuoineSellLabel.textColor = UIColor.green
        }else if(Double(all_resp.quoine.sell)! == Double(before_all_resp.quoine.sell)!){
            QuoineSellLabel.textColor = UIColor.black
        }else{
            QuoineSellLabel.textColor = UIColor.red
        }
        //Zaif
        if(Double(all_resp.zaif.buy)! > Double(before_all_resp.zaif.buy)!){
            ZaifBuyLabel.textColor = UIColor.green
        }else if(Double(all_resp.zaif.buy)! == Double(before_all_resp.zaif.buy)!){
            ZaifBuyLabel.textColor = UIColor.black
        }else{
            ZaifBuyLabel.textColor = UIColor.red
        }
        if(Double(all_resp.zaif.sell)! > Double(before_all_resp.zaif.sell)!){
            ZaifSellLabel.textColor = UIColor.green
        }else if(Double(all_resp.zaif.sell)! ==  Double(before_all_resp.zaif.sell)!){
            ZaifSellLabel.textColor = UIColor.black
        }else{
            ZaifSellLabel.textColor = UIColor.red
        }
    }

    func SetText(eval_data:BuyBuyCoinAPI.AllResponseData){
        BitBankBuyLabel.text = all_resp.bitbank.buy
        BitBankSellLabel.text = all_resp.bitbank.sell
        DmmBuyLabel.text = all_resp.dmm.buy
        DmmSellLabel.text = all_resp.dmm.sell
        QuoineBuyLabel.text = all_resp.quoine.buy
        QuoineSellLabel.text = all_resp.quoine.sell
        ZaifBuyLabel.text = all_resp.zaif.buy
        ZaifSellLabel.text = all_resp.zaif.sell
        
        switch eval_data.min_buy_name {
        case "BitBank":
            ResetViewBackGround()
            BitBankBuyView.backgroundColor = UIColor.yellow
        case "Dmm":
            ResetViewBackGround()
            DmmBuyView.backgroundColor = UIColor.yellow
        case "Quoine":
            ResetViewBackGround()
            QuoineBuyView.backgroundColor = UIColor.yellow
        case "Zaif":
            ResetViewBackGround()
            ZaifBuyView.backgroundColor = UIColor.yellow
        default:
            ResetViewBackGround()
        }
        switch eval_data.max_sell_name {
        case "BitBank":
            ResetViewBackGround()
            BitBankSellView.backgroundColor = UIColor.yellow
        case "Dmm":
            ResetViewBackGround()
            DmmSellView.backgroundColor = UIColor.yellow
        case "Quoine":
            ResetViewBackGround()
            QuoineSellView.backgroundColor = UIColor.yellow
        case "Zaif":
            ResetViewBackGround()
            ZaifSellView.backgroundColor = UIColor.yellow
        default:
            ResetViewBackGround()
        }
    }
    
    func ResetViewBackGround(){
        BitBankBuyView.backgroundColor = UIColor.white
        DmmBuyView.backgroundColor = UIColor.white
        QuoineBuyView.backgroundColor = UIColor.white
        ZaifBuyView.backgroundColor = UIColor.white
        BitBankSellView.backgroundColor = UIColor.white
        DmmSellView.backgroundColor = UIColor.white
        QuoineSellView.backgroundColor = UIColor.white
        ZaifSellView.backgroundColor = UIColor.white
    }
    
    func AllRespMinMaxValue(all_resp:BuyBuyCoinAPI.AllResponse)->BuyBuyCoinAPI.AllResponseData{
        var resp_data = BuyBuyCoinAPI.AllResponseData()
        
        var max = Double(all_resp.bitbank.sell)!
        resp_data.max_sell_name = "BitBank"
        resp_data.max_sell_value = all_resp.bitbank.sell
        //最大売値をみる
        if(max < Double(all_resp.dmm.sell)!){
            max = Double(all_resp.dmm.sell)!
            resp_data.max_sell_name = "Dmm"
            resp_data.max_sell_value = all_resp.dmm.sell
        }
        if(max < Double(all_resp.quoine.sell)!){
            max = Double(all_resp.quoine.buy)!
            resp_data.max_sell_name = "Quione"
            resp_data.max_sell_value = all_resp.quoine.sell
        }
        if(max < Double(all_resp.zaif.sell)!){
            max = Double(all_resp.zaif.buy)!
            resp_data.max_sell_name = "Zaif"
            resp_data.max_sell_value = all_resp.zaif.sell
        }
        
        //最安買値をみる
        var min = Double(all_resp.bitbank.buy)!
        resp_data.min_buy_name = "BitBank"
        resp_data.min_buy_value = all_resp.bitbank.buy
        if(min > Double(all_resp.dmm.buy)!){
            min = Double(all_resp.dmm.buy)!
            resp_data.min_buy_name = "DMM"
            resp_data.min_buy_value = all_resp.dmm.buy
        }
        if(min > Double(all_resp.quoine.buy)!){
            min = Double(all_resp.quoine.buy)!
            resp_data.min_buy_name = "Quoine"
            resp_data.min_buy_value = all_resp.quoine.buy
        }
        if(min > Double(all_resp.zaif.buy)!){
            min = Double(all_resp.zaif.buy)!
            resp_data.min_buy_name = "Zaif"
            resp_data.min_buy_value = all_resp.zaif.buy
        }
        return resp_data
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

