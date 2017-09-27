

import UIKit
import AVFoundation
import MediaPlayer
import CoreMotion
class ViewController: UIViewController, MPMediaPickerControllerDelegate {
    let motionManager = CMMotionManager()
    var audioPlayer0: AVAudioPlayer?
    var audioPlayer1: AVAudioPlayer?
     var v0,v1: Double?// 0のボリュームと1のボリューム変数
    @IBOutlet weak var songTitleLabel0: UILabel!
    @IBOutlet weak var songTitleLabel1: UILabel!
    //速さ
    
    
    
    @IBOutlet var button :UIButton!
    
    var count = 0
    
    // UIImage のインスタンスを設定
    let image0:UIImage = UIImage(named:"se1.png")!
    let image1:UIImage = UIImage(named:"se2.png")!
    let image2:UIImage = UIImage(named:"se3.png")!
    let image3:UIImage = UIImage(named:"se4.png")!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }

    @IBAction func buttonTapped(sender : AnyObject) {
        count += 1
        
        if(count%4 == 0){
            button.setImage(image0, for: UIControlState())
        }
        else if(count%4 == 1){
            button.setImage(image1, for: UIControlState())
        }
        else if(count%4 == 2){
            button.setImage(image2, for: UIControlState())
        }
        else if(count%4 == 3){
            button.setImage(image3, for: UIControlState())
        }
        else{
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goA" { //SecondViewControllerに遷移する場合
            // SecondViewControllerをインスタンス化
            let secondVc = segue.destination as! ViewControllerA
            // 値を渡す
            secondVc.a = self.songTitleLabel0.text!
            secondVc.b = self.songTitleLabel1.text!
        }
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
    //この画面に戻って来るとき
    @IBAction func backToTop(segue: UIStoryboardSegue) {}
    
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
            songTitleLabel0.text = "-----"
            songTitleLabel1.text = "-----"
            
            return
        }
        
        // 先頭のMPMediaItemを取得し、そのassetURLからプレイヤーを作成する
        let item0 = items[0]
        let item1 = items[1]
        if let url0 = item0.assetURL, let url1 = item1.assetURL {
            audioPlayer0 = try? AVAudioPlayer(contentsOf: url0)
            audioPlayer1 = try? AVAudioPlayer(contentsOf: url1)
            
            if audioPlayer0 == nil || audioPlayer1 == nil {
                
                return
            }
            
            
            // 再生開始
            if let player0 = audioPlayer0, let player1 = audioPlayer1 {
                // 曲目表示
                songTitleLabel0.text = item0.title ?? ""
                songTitleLabel1.text = item1.title ?? ""
                
                player0.enableRate = true
                player1.enableRate = true
                
                
                motionManager.accelerometerUpdateInterval = 0.1
                
                

                
                // 再生
                player0.play()
                player1.play()
                
                motionManager.startDeviceMotionUpdates( to: OperationQueue.current!, withHandler:{
                    deviceManager, error in
                    
                    
                    let attitude: CMAttitude = deviceManager!.attitude
                    
                    if(attitude.pitch>0){
                        //上
                    player1.volume = Float(1.0 + attitude.pitch*0.8)
                    player0.volume = Float(1.0 - attitude.pitch*0.8)
                        
                    }else{
                        //下
                    player1.volume = Float(1.0 + attitude.pitch*0.8)
                    player0.volume = Float(1.0 - attitude.pitch*0.8)
                    }
                    if(attitude.roll>0){
                        //遅くなる
                    player0.rate = Float(1.0 + attitude.roll*0.2)
                    player1.rate = Float(1.0 - attitude.roll*0.2)
                    }else{
                        //早くなる
                    player0.rate = Float(1.0 + attitude.roll*0.2)
                    player1.rate = Float(1.0 - attitude.roll*0.2)
                        
                    }
                    let accel: CMAcceleration = deviceManager!.userAcceleration
                    if(fabs(accel.z)>0.05){
                        player0.rate = Float(1.0 + fabs(accel.z)*0.7)
                        player1.rate = Float(1.0 + fabs(accel.z)*0.7)
                    }
                    
                })

                
                
                
                
                
            }
            

        } else {
            
            audioPlayer0 = nil
            audioPlayer1 = nil
        }
        
    }
    //
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        if let player0 = audioPlayer0, let player1 = audioPlayer1 {
            player0.stop()
            player1.stop()
        }

        
        
            
        }
    //選択がキャンセルされた場合に呼ばれる
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        // ピッカーを閉じ、破棄する
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
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

