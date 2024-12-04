//
//  ContentView.swift
//  SaveData
//
//  Created by Jan Hovland on 04/12/2024.
//

import SwiftUI

struct AverageDailyDataRecord: Codable {
    var time: [String]
    var precipitationSum: [Double?]
    var temperature2MMin: [Double?]
    var temperature2MMax: [Double?]
}

func getDocumentsDirectory() -> URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
}

func saveData(_ fileName: String, data: AverageDailyDataRecord) {
    let url = getDocumentsDirectory().appendingPathComponent(fileName)
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(data) {
        try? encoded.write(to: url)
    }
}

func loadData(_ fileName: String) -> AverageDailyDataRecord? {
    let url = getDocumentsDirectory().appendingPathComponent(fileName)
    if let data = try? Data(contentsOf: url) {
        let decoder = JSONDecoder()
        return try? decoder.decode(AverageDailyDataRecord.self, from: data)
    }
    return nil
}

func deleteData(_ fileName: String) {
    let url = getDocumentsDirectory().appendingPathComponent(fileName)
    try? FileManager.default.removeItem(at: url)
}

struct ContentView: View {
    @State private var average: AverageDailyDataRecord?
    @State private var fileName = "average.json"
    
    var body: some View {
        VStack {
            Text("Save a struct to Document Direcory")
                .padding(30)
            if let myData = average {
                VStack {
                    Text("Time: \(myData.time)")
                    Text("precipitationSum: \(myData.precipitationSum)")
                    Text("temperature2MMin: \(myData.temperature2MMin)")
                    Text("temperature2MMax \(myData.temperature2MMax)")
                }
                .font(.footnote)
                .padding(30)
            } else {
                Text("No data found.")
            }
            
            VStack {
                Button("Save Data") {
                    let data = AverageDailyDataRecord(time: ["2020-01-01"],
                                                      precipitationSum: [1.23],
                                                      temperature2MMin: [3.89],
                                                      temperature2MMax: [5.78])
                    saveData(fileName, data: data)
                }
                .padding(30)
                Button("Load Data") {
                    average = loadData(fileName)
                }
                .padding(30)
                Button("Delete Data") {
                    deleteData(fileName)
                    average = nil
                }
                .padding(30)
                Spacer()
            }
        }
        .padding()
        .onAppear {
            let data = AverageDailyDataRecord(time: ["1991-01-01","1991-01-02","1991-01-03","1991-01-04","1991-01-05","1991-01-06","1991-01-07","1991-01-08","1991-01-09","1991-01-10"],
                                              precipitationSum: [5.80,0.00,0.00,0.00,6.10,0.70,0.50,0.20,0.30,3.40],
                                              temperature2MMin: [2.1,3.0,2.6,2.3,3.5,3.4,0.9,0.7,0.9,1.8],
                                              temperature2MMax: [9.3,9.4,4.5,5.9,5.0,6.3,3.4,2.6,3.4,4.8])
            saveData(fileName, data: data)
            
        }
    }
}
