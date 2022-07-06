//
//  Helpers.swift
//  picks
//
//  Created by Elaine Herrera on 25/3/22.
//

import Foundation

extension Optional where Wrapped == Int {
    
    func formatFromMinutes() -> String {
        guard let minutes = self else {
            return ""
        }
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .positional

        let formattedString = formatter.string(from: TimeInterval(minutes * 60))!
        return formattedString
    }
    
    func formatToViews() -> String {
        guard let views = self else {
            return ""
        }
        let num = abs(Double(views))
        let sign = (views < 0) ? "-" : ""

        switch num {
        case 1_000_000_000...:
            var formatted = num / 1_000_000_000
            formatted = formatted.reduceScale(to: 1)
            return "\(sign)\(formatted)B"

        case 1_000_000...:
            var formatted = num / 1_000_000
            formatted = formatted.reduceScale(to: 1)
            return "\(sign)\(formatted)M"

        case 1_000...:
            var formatted = num / 1_000
            formatted = formatted.reduceScale(to: 1)
            return "\(sign)\(formatted)K"

        case 0...:
            return "\(views)"

        default:
            return "\(sign)\(views)"
        }
    }
}

extension Optional where Wrapped == Date {
    func formatFromISO8601() -> String {
        guard let date = self else {
            return ""
        }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        let formattedString = formatter.string(from: date)
        return formattedString
    }
}

extension Double {
    func reduceScale(to places: Int) -> Double {
        let multiplier = pow(10, Double(places))
        let newDecimal = multiplier * self
        let truncated = Double(Int(newDecimal))
        let originalDecimal = truncated / multiplier
        return originalDecimal
    }
}

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return years(from: date) == 1 ? "One year ago" : "\(years(from: date)) years ago"   }
        if months(from: date)  > 0 { return months(from: date) == 1 ? "One month ago" : "\(months(from: date)) months ago"  }
        if weeks(from: date)   > 0 { return weeks(from: date) == 1 ? "One week ago" : "\(weeks(from: date)) weeks ago"   }
        if days(from: date)    > 0 { return days(from: date) == 1 ? "One day ago" : "\(days(from: date)) days ago"}
        if hours(from: date)   > 0 { return hours(from: date) == 1 ? "One hour ago" : "\(hours(from: date)) hours ago"   }
        if minutes(from: date) > 0 { return minutes(from: date) == 1 ? "One minute ago" : "\(minutes(from: date)) minutes ago" }
        if seconds(from: date) > 0 { return seconds(from: date) == 1 ? "One second ago" : "\(seconds(from: date)) seconds ago" }
        return ""
    }
}

extension URLRequest {
    func encode(with parameters: Parameters?) -> URLRequest {
        guard let parameters = parameters else {
            return self
        }
        
        var encodedURLRequest = self
        
        if let url = self.url,
           let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
           !parameters.isEmpty {
            var newUrlComponents = urlComponents
            let queryItems = parameters.map { key, value in
                URLQueryItem(name: key, value: value)
            }
            newUrlComponents.queryItems = queryItems
            encodedURLRequest.url = newUrlComponents.url
            return encodedURLRequest
        }
        else {
            return self
        }
    }
}
