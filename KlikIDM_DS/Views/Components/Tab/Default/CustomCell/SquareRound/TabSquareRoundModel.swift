//
//  TabSquareRoundModel.swift
//  KlikIDM_DS
//
//  Created by Rizka Ghinna Auliya on 10/05/25.
//

public struct TabSquareRoundModel: TabDefaultModelProtocol {
    public var id: String
    public var title: String
    var isEnable: Bool
    
    public init(id: String, title: String, isEnable: Bool) {
        self.id = id
        self.title = title
        self.isEnable = isEnable
    }
}
