//
//  MultiplayerService.swift
//  Open Trivia
//
//  Created by Matthew Johnson on 1/30/20.
//  Copyright © 2020 Matthew Johnson. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class MultiplayerService : NSObject {

    // Service type must be a unique string, at most 15 characters long
    // and can contain only ASCII lowercase letters, numbers and hyphens.
    private let MultiplayerServiceType = "trivia-multi" // prevents from advertising wrong service

    private let myPeerId = MCPeerID(displayName: UIDevice.current.name)//display name for others to see
    private let serviceAdvertiser : MCNearbyServiceAdvertiser //adversizes device is online
    private let serviceBrowser : MCNearbyServiceBrowser

    override init() {
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: MultiplayerServiceType)
        self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: MultiplayerServiceType)
        super.init()
        self.serviceAdvertiser.delegate = self
        
        self.serviceBrowser.delegate = self
        
    }
    
    func startService(){
        self.serviceAdvertiser.startAdvertisingPeer()
        self.serviceBrowser.startBrowsingForPeers()
        
        
        //do more later
        let connectedPlayers = session.connectedPeers.count
        var isGameMaster = true
        if connectedPlayers == 0{
            isGameMaster = true
        } else {
            isGameMaster = false
        }
        
        if isGameMaster == true{
            
        } else {
            
        }
        
    }
    
    func stopService(){
        self.serviceAdvertiser.stopAdvertisingPeer()
        self.serviceBrowser.stopBrowsingForPeers()
        session.disconnect()
        
    }

    deinit {
        self.serviceAdvertiser.stopAdvertisingPeer()
        self.serviceBrowser.stopBrowsingForPeers()
        session.disconnect()
    }
    
    var delegate : MultiplayerServiceDelegate?
    
    lazy var session : MCSession = {
        let session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: .required)
        //session.delegate = self
        return session
    }()
    
    func send(ObjectAndChangedTo : String) {
        NSLog("%@", "sendData: \(ObjectAndChangedTo) to \(session.connectedPeers.count) peers")

        if session.connectedPeers.count > 0 {
            do {
                try self.session.send(ObjectAndChangedTo.data(using: .utf8)!, toPeers: session.connectedPeers, with: .reliable)
            }
            catch let error {
                NSLog("%@", "Error for sending: \(error)")
            }
        }

    }

}

extension MultiplayerService : MCNearbyServiceAdvertiserDelegate {

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        NSLog("%@", "didNotStartAdvertisingPeer: \(error)")
    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        NSLog("%@", "didReceiveInvitationFromPeer \(peerID)")
        invitationHandler(true, self.session)
        //Note: This code accepts all incoming connections automatically. This would be like a public chat and you need to be very careful to check and sanitize any data you receive over the network as you cannot trust the peers. To keep sessions private the user should be notified and asked to confirm incoming connections. This can be implemented using the MCAdvertiserAssistant classes.
    }
    
}

extension MultiplayerService : MCNearbyServiceBrowserDelegate {

    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        NSLog("%@", "didNotStartBrowsingForPeers: \(error)")
    }

    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        NSLog("%@", "foundPeer: \(peerID)")
        NSLog("%@", "invitePeer: \(peerID)")
        browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 10)
        //Note: This code invites any peer automatically. The MCBrowserViewController class could be used to scan for peers and invite them manually.
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        NSLog("%@", "lostPeer: \(peerID)")
    }

}

extension MultiplayerService : MCSessionDelegate {

    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        NSLog("%@", "peer \(peerID) didChangeState: \(state.rawValue)")
        self.delegate?.connectedDevicesChanged(manager: self, connectedDevices:
        session.connectedPeers.map{$0.displayName})
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveData: \(data)")
        let str = String(data: data, encoding: .utf8)!
        self.delegate?.somethingChanged(manager: self, objectAndChangedTo: str)
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveStream")
    }

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        NSLog("%@", "didStartReceivingResourceWithName")
    }

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        NSLog("%@", "didFinishReceivingResourceWithName")
    }

}

protocol MultiplayerServiceDelegate {
    
    func connectedDevicesChanged(manager : MultiplayerService, connectedDevices: [String])
    func somethingChanged(manager : MultiplayerService, objectAndChangedTo: String)
    
}

