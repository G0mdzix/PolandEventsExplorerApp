import Foundation

enum UniqueURLHelper {
    static func compareStrings(_ str1: String, _ str2: String) -> Double {
        Double(levenshteinDistance(str1, str2)) / Double(max(str1.count, str2.count))
    }

    private static func levenshteinDistance(_ str1: String, _ str2: String) -> Int {
        let m = str1.count, n = str2.count
        var matrix = Array(repeating: Array(repeating: 0, count: n + 1), count: m + 1)

        (0...m).forEach { matrix[$0][0] = $0 }
        (0...n).forEach { matrix[0][$0] = $0 }

        for i in 1...m {
            for j in 1...n {
                let cost = str1[str1.index(str1.startIndex, offsetBy: i - 1)] == str2[str2.index(str2.startIndex, offsetBy: j - 1)] ? 0 : 1
                matrix[i][j] = min(matrix[i - 1][j] + 1, matrix[i][j - 1] + 1, matrix[i - 1][j - 1] + cost)
            }
        }
        
        return matrix[m][n]
    }
}
