import SwiftUI

struct DashboardView: View {
    
    @StateObject private var viewModel = DashboardViewModel()
    
    @State private var isShowingDetails = false
    
    var body: some View {
        NavigationStack {
            VStack {
                eventsList
            }
            .errorAlert(error: $viewModel.error)
            .navigationBarItems(trailing: menuButton)
            .navigationBarTitle("Poland Explorer")
            .navigationTitle("Searchable Example")
            .navigationDestination(isPresented: $isShowingDetails, destination: detailsView)
            .searchable(text: $viewModel.searchText)
        }
    }
        
    private var eventsList: some View {
        List {
            if viewModel.isLoading {
                loadingRowView
            } else {
                if !viewModel.searchText.isEmpty && viewModel.searchResults.isEmpty {
                    noSearchResultsView
                } else {
                    ForEach(
                        viewModel.searchText.isEmpty
                            ? Array(viewModel.mappedDashboardEvents)
                            : viewModel.searchResults,
                        id: \.id
                    ) { item in
                        eventsListRow(for: item)
                    }
                    
                    loadingRowView
                }
            }
        }
        .refreshable { viewModel.refreshEvents() }
    }
    
    private var menuButton: some View {
        Menu {
            Picker("Pick page size", selection: $viewModel.pageSize) {
                ForEach(PageSize.allCases) { pageSize in
                    HStack(spacing: .zero) {
                        Text(pageSize.rawValue)
                            .tag(pageSize)
                    }
                }
            }
            .pickerStyle(.menu)
        } label: {
            Label(String(), systemImage: "ellipsis.circle.fill")
                .labelStyle(.iconOnly)
                .font(.headline)
                .foregroundColor(.primary)
                .clipShape(Circle())
        }
    }
    
    private var noSearchResultsView: some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text("No events found")
                .font(.title)
                .foregroundColor(.textPrimary)
            
            Text("Search only works for events that are already loaded!")
                .font(.subheadline)
                .foregroundColor(.textSecondary)
        }
    }
    
    @ViewBuilder private var loadingRowView: some View {
        HStack(spacing: .zero) {
            Spacer()
            
            ProgressView()
            
            Spacer()
        }
        .onAppear { viewModel.fetchEvents() }
        .display(if: viewModel.isMorePagesAvailable && viewModel.searchText.isEmpty)
    }
    
    private func eventsListRow(for item: EventsDashboardModel) -> some View {
        VStack(alignment: .center, spacing: .zero) {
            Text(item.name)
                .multilineTextAlignment(.center)
                .fontWeight(.heavy)
                .font(.title2)
                .foregroundColor(.textPrimary)
                .padding(.vertical, 8)
                .fixedSize(horizontal: false, vertical: true)
            
            item.image?.image
                .frame(width: 256, height: 256)
                .clipShape(.rect(cornerRadius: 25))
                .defaultShadow(color: .textSecondary)
                .padding(.bottom, 24)
            
            detailsStackInformation(for: item)
        }
        .onTapGesture {
            viewModel.selectedEventId = item.id
            isShowingDetails = true
        }
    }
    
    private func detailsStackInformation(for item: EventsDashboardModel) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .stroke(.textSecondary, lineWidth: 2)
                .foregroundColor(.mainBackground)
            
            VStack(alignment: .leading, spacing: .zero) {
                detailsRowInformation(text: item.city, type: .city)
                detailsRowInformation(text: item.objectName, type: .objectName)
                detailsRowInformation(text: item.date, type: .data)
            }
        }
        .padding(.bottom, 8)
    }
    
    private func detailsRowInformation(text: String, type: DashboardDetailsRowEnum) -> some View {
        HStack(spacing: .zero) {
            Text(type.rawValue)
                .foregroundColor(.textPrimary)
                .font(.headline)
                .fontWeight(.bold)
                .padding(.trailing, 4)
            
            Text(text)
                .foregroundColor(.textSecondary)
                .font(.body)
                .multilineTextAlignment(.center)
                .italic()
            
            Spacer()
        }
        .padding(.leading, 8)
        .padding(.bottom, 8)
        .fixedSize(horizontal: false, vertical: true)
    }
    
    private func detailsView() -> some View {
        DetailsView(eventId: viewModel.selectedEventId)
    }
}

#Preview {
    DashboardView()
}
