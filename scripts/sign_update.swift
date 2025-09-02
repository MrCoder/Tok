#!/usr/bin/swift

import Foundation
import CryptoKit

// DictaFlow.ai 更新签名工具
// 使用EdDSA私钥签名更新包

func signUpdate(filePath: String, privateKeyBase64: String) -> String? {
    guard let fileURL = URL(string: "file://" + filePath),
          let fileData = try? Data(contentsOf: fileURL) else {
        print("❌ 无法读取文件: \(filePath)")
        return nil
    }
    
    guard let privateKeyData = Data(base64Encoded: privateKeyBase64) else {
        print("❌ 无效的私钥格式")
        return nil
    }
    
    do {
        // 从原始数据创建私钥
        let privateKey = try Curve25519.Signing.PrivateKey(rawRepresentation: privateKeyData)
        
        // 签名文件数据
        let signature = try privateKey.signature(for: fileData)
        
        // 返回Base64编码的签名
        return signature.base64EncodedString()
        
    } catch {
        print("❌ 签名失败: \(error)")
        return nil
    }
}

// 主程序
guard CommandLine.arguments.count >= 3 else {
    print("❌ 用法: \(CommandLine.arguments[0]) <file_path> <private_key_base64>")
    exit(1)
}

let filePath = CommandLine.arguments[1]
let privateKeyBase64 = CommandLine.arguments[2]

if let signature = signUpdate(filePath: filePath, privateKeyBase64: privateKeyBase64) {
    print(signature)
    exit(0)
} else {
    exit(1)
}
