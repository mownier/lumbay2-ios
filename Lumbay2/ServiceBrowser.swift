import Foundation

class ServiceBrowser: NSObject, NetServiceDelegate, NetServiceBrowserDelegate, ObservableObject {
    private let serviceType: String
    private let domain: String
    @Published var serverInfo = ServerInfo(hostName: "", port: 0)
    private var serviceBrowser: NetServiceBrowser!
    private var discoveredService: NetService!
    
    init(serviceType: String, domain: String) {
        self.serviceType = serviceType
        self.domain = domain
        super.init()
        serviceBrowser = NetServiceBrowser()
        serviceBrowser.delegate = self
    }
    
    deinit {
        stopBrowsing()
    }
    
    func startBrowsing() {
        serviceBrowser.searchForServices(ofType: serviceType, inDomain: domain)
    }
    
    func stopBrowsing() {
        serviceBrowser.stop()
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didRemove service: NetService, moreComing: Bool) {
        if service == self.discoveredService {
            self.discoveredService.delegate = nil
            self.discoveredService = nil
        }
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        self.discoveredService = service
        service.delegate = self
        service.resolve(withTimeout: 5.0)
        print("did find service", service)
    }
    
    func netServiceDidResolveAddress(_ service: NetService) {
        print("did resolve service", service)
        if let hostName = service.hostName {
            print("host name", hostName)
            serverInfo.hostName = hostName
            serverInfo.port = service.port
            stopBrowsing()
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }
}

class ServerInfo {
    var hostName: String
    var port: Int
    init(hostName: String, port: Int) {
        self.hostName = hostName
        self.port = port
    }
}
