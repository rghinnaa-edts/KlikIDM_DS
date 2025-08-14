//
//  TabDefaultModel.swift
//  KlikIDM_DS
//
//  Created by Rizka Ghinna Auliya on 10/05/25.
//

public struct TabDefaultModel: TabDefaultModelProtocol {
    public var id: String
    public var title: String
    
    public init(id: String, title: String) {
        self.id = id
        self.title = title
    }
}
