import Testing
import Foundation

@Suite struct RequestBuilderTests {
    @Test private func sccessfullBuildUrlRequest() {
        let router: RouterProtocol = RouterMock.getSuccesfulEventMock
        
        do {
            let request = try RequestBuilder.buildRequest(from: router)
            
            #expect(request.url == URL(string: "https://app.ticketmaster.com/discovery/v2/events.json?countryCode=PL"))
        } catch {
            _ = error
        }
    }
    
    @Test private func failedToBuildUrlRequest() {
        let router: RouterProtocol = RouterMock.getFailedEventMock
        
        do {
            let request = try RequestBuilder.buildRequest(from: router)
        } catch {
            #expect(error as! URLError == URLError(.badURL))
        }
    }
}
