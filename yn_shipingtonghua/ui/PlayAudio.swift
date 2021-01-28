//
//  PlayAudio.swift
//  yn_shipingtonghua
//
//  Created by 陈军 on 2021/1/26.
//

import UIKit
import TXLiteAVSDK_TRTC
import SwiftyUserDefaults
import SnapKit
import QMUIKit


let MAX_REMOTE_USER_NUM = 6


class PlayAudio: UIViewController, TRTCCloudDelegate {
    let localVideoView = UIView() //预览本地的
    let playVideoView = UIView() //播放对面的
    let switchCameraBtn = UIButton()
    var userId:String="123456"
    var roomId:UInt32=12333
    var time:TimeInterval=0
    let timeLB = UILabel()
    var codeTimer : DispatchSourceTimer?
    var shengyin = UIButton()
    var fanzhuang = UIButton()
    var bb1 = true;
    var bb2 = true;
    var bb3 = true;

    
    
    // 重现statusBar相关方法
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    
    /// 从摄像头采样
    private var isFrontCamera: Bool = true
    private lazy var remoteUids = NSMutableOrderedSet.init(capacity: MAX_REMOTE_USER_NUM)
    
    
    private lazy var trtcCloud: TRTCCloud = {
        let instance: TRTCCloud = TRTCCloud.sharedInstance()
        ///设置TRTCCloud的回调接口
        instance.delegate = self;
        return instance;
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor=UIColor.init(hexString: "ffffff")

        view.addSubview(playVideoView)
        view.addSubview(localVideoView)
        view.addSubview(timeLB)
        view.addSubview(shengyin)
        view.addSubview(fanzhuang)

        timeLB.textColor=UIColor.white
        timeLB.font=UIFont.systemFont(ofSize: 18)
        playVideoView.backgroundColor=UIColor.black
        let closeImg = VUtils.Button(view: view, name: "guaduanbg", top: 0, left: 0, bottom: 0, right: 0)
        shengyin.setImage(UIImage.init(named: "maikefbf"), for: UIControl.State.normal)
        fanzhuang.setImage(UIImage.init(named: "ffttyy"), for: UIControl.State.normal)

        closeImg.addTarget(self, action: #selector(touchUpInsideFn), for: UIControl.Event.touchUpInside)
        shengyin.addTarget(self, action: #selector(touchUpInsideFn2), for: UIControl.Event.touchUpInside)
        fanzhuang.addTarget(self, action: #selector(touchUpInsideFn3), for: UIControl.Event.touchUpInside)

        localVideoView.snp.makeConstraints { (make) in
              make.top.equalToSuperview().offset(Defaults.topbarHeight+50)
              make.right.equalToSuperview().offset(-10)
              make.width.equalTo(UIScreen.main.bounds.width*0.3)
              make.height.equalTo(UIScreen.main.bounds.width*0.56)
          }
        playVideoView.snp.makeConstraints { (make) in
              make.top.equalToSuperview()
              make.left.equalToSuperview()
              make.right.equalToSuperview()
              make.bottom.equalToSuperview()
          }
        timeLB.snp.makeConstraints { (make) in
              make.top.equalToSuperview().offset(Defaults.topbarHeight+20)
              make.centerX.equalToSuperview()
          }
        
        closeImg.snp.makeConstraints { (make) in
              make.centerX.equalToSuperview()
              make.bottom.equalToSuperview().offset(-UIScreen.main.bounds.size.height*0.16)
              make.width.equalTo(UIScreen.main.bounds.size.width*0.18)
              make.height.equalTo(UIScreen.main.bounds.size.width*0.18)
          }
        shengyin.snp.makeConstraints { (make) in
            make.centerY.equalTo(closeImg.snp.centerY)
            make.right.equalTo(closeImg.snp.left).offset(-UIScreen.main.bounds.size.width*0.1)
              make.width.equalTo(UIScreen.main.bounds.size.width*0.18)
              make.height.equalTo(UIScreen.main.bounds.size.width*0.18)
          }
        fanzhuang.snp.makeConstraints { (make) in
            make.centerY.equalTo(closeImg.snp.centerY)
            make.left.equalTo(closeImg.snp.right).offset(UIScreen.main.bounds.size.width*0.1)
              make.width.equalTo(UIScreen.main.bounds.size.width*0.18)
              make.height.equalTo(UIScreen.main.bounds.size.width*0.18)
          }
        
        /**
         * 设置参数，进入视频通话房间
         * 房间号param.roomId，当前用户id param.userId
         * param.role 指定以什么角色进入房间（anchor主播，audience观众）
         */
        
        print("传入的\(userId)","playAudios")
        print("传入的\(roomId)","playAudios")
        
        let param = TRTCParams.init()
        param.sdkAppId = UInt32(SDKAppID)
        param.roomId   = roomId
        param.userId   = userId
        param.role     = TRTCRoleType.anchor
        /// userSig是进入房间的用户签名，相当于密码（这里生成的是测试签名，正确做法需要业务服务器来生成，然后下发给客户端）
        param.userSig  = GenerateTestUserSig.genTestUserSig(param.userId)
        /// 指定以“视频通话场景”（TRTCAppScene.videoCall）进入房间
        trtcCloud.enterRoom(param, appScene: TRTCAppScene.videoCall)

        /// 设置视频通话的画质（帧率 15fps，码率550, 分辨率 360*640）
        let videoEncParam = TRTCVideoEncParam.init()
        videoEncParam.videoResolution = TRTCVideoResolution._640_360
        videoEncParam.videoBitrate = 550
        videoEncParam.videoFps = 15
        trtcCloud.setVideoEncoderParam(videoEncParam)
        
        /**
         * 设置默认美颜效果（美颜效果：自然，美颜级别：5, 美白级别：1）
         * 视频通话场景推荐使用“自然”美颜效果
         */
        let beautyManager = trtcCloud.getBeautyManager()
        beautyManager?.setBeautyStyle(TXBeautyStyle.nature)
        beautyManager?.setBeautyLevel(5)
        beautyManager?.setWhitenessLevel(1)
        
        /// 调整仪表盘显示位置
        trtcCloud.setDebugViewMargin(userId, margin: TXEdgeInsets.init(top: 80, left: 0, bottom: 0, right: 0))

        let queue = DispatchQueue.global()
                    codeTimer = DispatchSource.makeTimerSource(queue: queue)
                    codeTimer?.schedule(wallDeadline: .now(), repeating: .seconds(1))
                    codeTimer?.setEventHandler { [weak self] in
                        DispatchQueue.main.async(execute: {
                            self?.calculateTime(timeInterval: self?.time ?? 0)
                        })
                    }
                    codeTimer?.resume()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           self.navigationController?.setNavigationBarHidden(true, animated: false)
            // 隐藏导航栏 true 有动画
            /// 开启麦克风采集
            trtcCloud.startLocalAudio(TRTCAudioQuality(rawValue: 2)!)
            /// 开启摄像头采集
            trtcCloud.startLocalPreview(isFrontCamera, view: localVideoView)
       }
    
    func onExitRoom(_ reason: Int) {
        print("退出房间\(reason)","playAudios")
    }
    func onEnterRoom(_ result: Int) {
        print("加入房间\(result)","playAudios")
    }
    
    /**
     * 当前视频通话房间里的其他用户开启/关闭摄像头时会收到这个回调
     * 此时可以根据这个用户的视频available状态来 “显示或者关闭” Ta的视频画面
     */
    func onUserVideoAvailable(_ userId: String, available: Bool) {
        print("userId\(userId)","playAudios")
        print("available\(available)","playAudios")
        let index = remoteUids.index(of: userId)
        if available {
            guard NSNotFound == index else { return }
            remoteUids.add(userId)
            refreshRemoteVideoViews(from: remoteUids.count - 1)
        } else {
            guard NSNotFound != index else { return }
            /// 关闭用户userId的视频画面
            trtcCloud.stopRemoteView(userId,streamType: TRTCVideoStreamType.big)
            remoteUids.removeObject(at: index)
            refreshRemoteVideoViews(from: index)
        }
    }
    
    func onFirstVideoFrame(_ userId: String, streamType: TRTCVideoStreamType, width: Int32, height: Int32) {
        print("eeeeee", "开始渲染本地或远程用户的首帧画面。");
        if bb3 {
            bb3=false
            if remoteUids.count == 0 {
                let alertController = UIAlertController(title: "温馨提示",
                                                            message: "对方未在线,请稍等或联系客服", preferredStyle: .alert)

                    //let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                    let okAction = UIAlertAction(title: "确定", style: .default, handler: {
                        action in
                       
                        self.trtcCloud.exitRoom()
                        self.navigationController?.popViewController(animated: true)
                        alertController.dismiss(animated: true, completion: nil);
                        
                    })
                    alertController.addAction(okAction)
                    //alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    
    func refreshRemoteVideoViews(from: Int) {
        for i in from..<remoteUids.count {
            let remoteUid = remoteUids[i] as! String
            /// 开始显示用户remoteUid的视频画面
            print("开始显示用户\(remoteUid)的视频画面","playAudios")
            trtcCloud.startRemoteView(remoteUid, streamType: TRTCVideoStreamType.big,view: playVideoView)
        }
    }
    
    //析构函数?
    deinit {
        TRTCCloud.destroySharedIntance()
    }
    
    
    //计算时间
    func calculateTime(timeInterval:TimeInterval) {
      //  print(Date().milliStamp,"毫秒级") //13位时间戳
       // print(Date().timeStamp,"秒级") //10位时间戳
      //  print(Date().timestampWithDate(timeInterval: 1699999999),"date")
        // 获取当前时间
        let nowDate = DateUtils.getCurrentDate()
        // 获取结束时间
        let endDate = Date().timestampWithDate(timeInterval: timeInterval)
        let calendar = NSCalendar.current
        // The result of calculating the difference from start to end.
        let components = calendar.dateComponents([.hour, .minute, .second], from: nowDate, to: endDate)
            
        guard let hour = components.hour,
            let minute = components.minute,
            let second = components.second else { return }
            
        //print("差值为：\(hour)时\(minute)分\(second)秒")
        if hour < 0 && minute < 0 && second < 0  {
                removeTimer()
            } else {
                timeLB.text="\(hour)时\(minute)分\(second)秒"
            }
    }
   
    // MARK: - 移除Timer
    fileprivate func removeTimer() {
        if codeTimer != nil {
            codeTimer?.cancel()
            codeTimer = nil
        }
    }
    
    @objc //挂断
    func touchUpInsideFn() {
        let alertController = UIAlertController(title: "温馨提示",
                                                message: "确定要退出聊天吗？", preferredStyle: .alert)

            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "确定", style: .default, handler: {
                action in
               
                self.trtcCloud.exitRoom()
                self.navigationController?.popViewController(animated: true)
                alertController.dismiss(animated: true, completion: nil);
                
            })
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        
    }
    
    @objc //声音
    func touchUpInsideFn2() {
        if bb1 {
            bb1=false
            shengyin.setImage(UIImage.init(named: "jinyingbg"), for: .normal)
            trtcCloud.stopLocalAudio()
        }else{
            bb1=true
            shengyin.setImage(UIImage.init(named: "maikefbf"), for: .normal)
            trtcCloud.startLocalAudio(TRTCAudioQuality(rawValue: 2)!)
        }
    }
    
    
    @objc //翻转
    func touchUpInsideFn3() {
        trtcCloud.switchCamera()
        if isFrontCamera {
            isFrontCamera = false;
        }else{
            isFrontCamera=true
        }
    }
    
    // 当视图将要消失时调用该方法
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            print("视图即将消失")
            removeTimer()
        }
        
        // 当时图已经消失时调用该方法
        override func viewDidDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            print("视图已经消失")
        }
}
