//
//  NetworkReachabilityService.swift
//  FFQuotes
//
//  Created by Dmitriy Mirovodin on 24.04.2021.
//

import SystemConfiguration

protocol NetworkReachabilityProtocol {
    func isNetworkReachable() -> Bool
}

final class NetworkReachabilityService: NetworkReachabilityProtocol {

    // MARK: - NetworkReachabilityProtocol
    func isNetworkReachable() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags = SCNetworkReachabilityFlags()
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }

        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)

        let result = (isReachable && !needsConnection)

        return result
    }
}
