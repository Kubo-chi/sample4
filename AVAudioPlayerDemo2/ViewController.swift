//
//  ViewController.swift
//  AVAudioPlayerDemo2
//
//  Created by KUWAJIMA MITSURU on 2015/09/20.
//  Copyright © 2015年 nackpan. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import CoreMotion
class ViewController: UIViewController, MPMediaPickerControllerDelegate {
    let motionManager = CMMotionManager()
    var audioPlayer0: AVAudioPlayer?
    var audioPlayer1: AVAudioPlayer?
     var v0,v1: Double?// 0のボリュームと1のボリューム変数
    //let mag: Double = 20.0//
    @IBOutlet weak var songTitleLabel0: UILabel!
    @IBOutlet weak var songTitleLabel1: UILabel!
    //速さ
    @IBOutlet weak var playbackRateSlider0: UISlider!
    @IBOutlet weak var playbackRateSlider1: UISlider!
    
    
    //@IBOutlet weak var volumeSlider0: UISlider!
    //@IBOutlet weak var volumeSlider1: UISlider!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func pick(_ sender: AnyObject) {
        // MPMediaPickerControllerのインスタンスを作成
        let picker = MPMediaPickerController()
        // ピッカーのデリゲートを設定
        picker.delegate = self
        // 複数選択を可にする。（trueにすると、複数選択できる）
        picker.allowsPickingMultipleItems = true
        // ピッカーを表示する
        present(picker, animated: true, completion: nil)
    }
    
    // メディアアイテムピッカーでアイテムを選択完了したときに呼び出される
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        
        // このfunctionを抜けるときにピッカーを閉じる
        defer {
            // ピッカーを閉じ、破棄する
            dismiss(animated: true, completion: nil)
        }
        
        
        
        // 選択した曲情報がmediaItemCollectionに入っている
        // mediaItemCollection.itemsから入っているMPMediaItemの配列を取得できる
        let items = mediaItemCollection.items
        if items.count < 2 {
            // itemが2個以上ない場合戻る
            
            // 曲目ラベルをデフォルトに戻す
            songTitleLabel0.text = "曲 1"
            songTitleLabel1.text = "曲 2"
            
            return
        }
        
        // 先頭のMPMediaItemを取得し、そのassetURLからプレイヤーを作成する
        let item0 = items[0]
        let item1 = items[1]
        if let url0 = item0.assetURL, let url1 = item1.assetURL {
            audioPlayer0 = try? AVAudioPlayer(contentsOf: url0)
            audioPlayer1 = try? AVAudioPlayer(contentsOf: url1)
            
            if audioPlayer0 == nil || audioPlayer1 == nil {
                // 再生できません
                
                return
            }
            
            
            // 再生開始
            if let player0 = audioPlayer0, let player1 = audioPlayer1 {
                // 曲目表示
                songTitleLabel0.text = item0.title ?? ""
                songTitleLabel1.text = item1.title ?? ""
                
                // 再生レート変更可能にする
                player0.enableRate = true
                player1.enableRate = true
                
                // sliderに合わせてrateを変更
                player0.rate = playbackRateSlider0.value
                player1.rate = playbackRateSlider1.value
                motionManager.accelerometerUpdateInterval = 0.1
                
                //player0.volume = volumeSlider0.value
                //player1.volume = volumeSlider1.value
                //player0.volume=
                
                // 再生
                player0.play()
                player1.play()
                
            }
            

        } else {
            // urlがnilなので再生できない
            // プレイヤーをnilとする
            audioPlayer0 = nil
            audioPlayer1 = nil
        }
        
    }
    
    
    //選択がキャンセルされた場合に呼ばれる
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        // ピッカーを閉じ、破棄する
        dismiss(animated: true, completion: nil)
    }

    // MARK: Playback Rate Changed 速度

    @IBAction func song0RateValueChanged(_ sender: AnyObject) {
        let slider = sender as! UISlider
        
        if let player = audioPlayer0 {
            player.rate = slider.value
        }
        

    }
    
    @IBAction func song1RateValueChanged(_ sender: AnyObject) {
        let slider = sender as! UISlider
        
        if let player = audioPlayer1 {
            player.rate = slider.value
        }
    }
    
    // MARK: Volume Changed 音量
    @IBAction func song0VolumeChanged(_ sender: AnyObject) {
        let slider = sender as! UISlider
        
        if let player = audioPlayer0 {
            player.volume = slider.value
        }
        
    }
    
    @IBAction func song1VolumeChanged(_ sender: AnyObject) {
        let slider = sender as! UISlider
        
        if let player = audioPlayer1 {
            player.volume = slider.value
        }
    }
    //@IBAction func song1volumeupdated(_ sender1: AnyObject){
   //     let grave = sender1 as
    //}
    // MARK: Play, Pause, Stop
    
    
    @IBAction func playBtnTapped(_ sender: AnyObject) {
        if let player0 = audioPlayer0, let player1 = audioPlayer1 {
            player0.play()
            player1.play()
        }
    }
    
    
    @IBAction func pauseBtnTapped(_ sender: AnyObject) {
        if let player0 = audioPlayer0, let player1 = audioPlayer1 {
            player0.pause()
            player1.pause()
        }
    }
    
    @IBAction func stopBtnTapped(_ sender: AnyObject) {
        if let player0 = audioPlayer0, let player1 = audioPlayer1 {
            player0.stop()
            player1.stop()
        }
    }
    
    
    
    


}

