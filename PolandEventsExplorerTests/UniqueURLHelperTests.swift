import Testing

@Suite struct UniqueURLHelperTests {
    @Test private func compare_the_same_strings() {
        let firstString = "https://s1.ticketm.net/dam/a/c13/bc0c016f-992a-4fd2-873b-fafc313ecc13_RETINA_PORTRAIT_16_9.jpg"
        let secondString = "https://s1.ticketm.net/dam/a/c13/bc0c016f-992a-4fd2-873b-fafc313ecc13_RETINA_PORTRAIT_16_9.jpg"
        
        let result = UniqueURLHelper.compareStrings(firstString, secondString)
        
        #expect(result == 0)
    }
    
    @Test private func compare_completly_different_strings() {
        let firstString = "https://s1.ticketm.net/dam/a/c13/bc0c016f-992a-4fd2-873b-fafc313ecc13_RETINA_PORTRAIT_16_9.jpg"
        let secondString = "@@@@@"
        
        let result = UniqueURLHelper.compareStrings(firstString, secondString)
        
        #expect(result == 1)
    }
    
    @Test private func compare_half_different_strings() {
        let firstString = "https://s1.ticketm.net/dam"
        let secondString = "https://s1.ti"
        
        
        let result = UniqueURLHelper.compareStrings(firstString, secondString)
        
        #expect(result == 0.5)
    }
    
    @Test private func compare_significantly_different_urls() {
        let firstString = "https://i.ticketweb.com/i/00/12/63/00/23_Edp.jpg?v=2"
        let secondString = "https://s1.ticketm.net/dam/c/fbc/b293c0ad-c904-4215-bc59-8d7f2414dfbc_106141_RETINA_PORTRAIT_3_2.jpg"
        
        let result = UniqueURLHelper.compareStrings(firstString, secondString)
        
        #expect(result > 0.3)
    }
}
