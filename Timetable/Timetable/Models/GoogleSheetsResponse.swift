//
//  GoogleSheetsResponse.swift
//  TimeTable
//
//  Created by ar_ko on 30/01/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

struct GoogleSheetsResponse: Decodable {
    let sheets: [Data]
    
    struct Data: Decodable {
        let data: [RowData]
        let merges: [GridRange]
                
        struct RowData: Decodable {
            let rowData: [Values]
            
            struct Values: Decodable {
                let values: [CellData]
                
                struct CellData: Decodable {
                    let formattedValue: String?
                    let note: String?
                    let effectiveFormat: EffectiveFormat?
                }
            }
        }
    }
}

struct GridRange: Decodable {
     let sheetId: Int
     let startRowIndex: Int
     let endRowIndex: Int
     let startColumnIndex: Int
     let endColumnIndex: Int
 }

struct EffectiveFormat: Decodable {
    let backgroundColor: color
    let textFormat: ForegroundColor
    
    struct ForegroundColor: Decodable {
        let foregroundColor: color
    }
    
    struct color: Decodable {
        let red: Double?
        let green: Double?
        let blue: Double?
    }
}
