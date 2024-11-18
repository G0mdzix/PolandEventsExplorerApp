import SwiftUI

struct DashboardView: View {
    
    @StateObject private var viewModel = DashboardViewModel()
    
    @State private var isShowingDetails = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: .zero) {
                sortViewStack
                
                eventsList
            }
            .errorAlert(error: $viewModel.error)
            .navigationBarItems(trailing: menuButton)
            .navigationBarTitle(StringHandler.DashboardView.navigationBarTitle)
            .navigationTitle(StringHandler.DashboardView.navigationTitle)
            .navigationDestination(isPresented: $isShowingDetails, destination: detailsView)
            .searchable(text: $viewModel.searchText)
        }
    }
    
    private var sortViewStack: some View {
        HStack(spacing: Spacings.small) {
            Spacer()
            
            sortList
            
            sortButtonsStack
        }
        .padding(.horizontal, Spacings.medium)
    }
    
    private var sortList: some View {
        ScrollView(.horizontal) {
            HStack(spacing: Spacings.medium) {
                ForEach(Field.allCases, id: \.self) { sortType in
                    if sortType != .none {
                        Button {
                            viewModel.sortField = sortType
                        } label: {
                            sortListItemView(item: sortType)
                        }
                    }
                }
            }
            .padding(.all, Spacings.small)
        }
    }
    
    private var sortButtonsStack: some View {
        HStack(spacing: Spacings.small) {
            sortButtonView(symbol: SFSymbols.cheveronUp, action: { viewModel.sortOption = .ascending })
            
            sortButtonView(symbol: SFSymbols.cheveronDown, action: { viewModel.sortOption = .descending })
                .disabled(viewModel.sortField == .id)
            
            sortButtonView(symbol: SFSymbols.xmark, action: {
                viewModel.sortField = .none
                viewModel.sortOption = .none
            })
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
            Picker(StringHandler.DashboardView.pageSizePickerTitle, selection: $viewModel.pageSize) {
                ForEach(PageSize.allCases) { pageSize in
                    HStack(spacing: .zero) {
                        Text(pageSize.rawValue)
                            .tag(pageSize)
                    }
                }
            }
            .pickerStyle(.menu)
        } label: {
            Label(String(), systemImage: SFSymbols.ellipsis)
                .labelStyle(.iconOnly)
                .font(.headline)
                .foregroundColor(.primary)
                .clipShape(Circle())
        }
    }
    
    private var noSearchResultsView: some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text(StringHandler.DashboardView.noSearchResultsTitle)
                .font(.title)
                .foregroundColor(.textPrimary)
            
            Text(StringHandler.DashboardView.noSearchResultsDescription)
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
    
    private func sortButtonView(symbol: String, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Label(String(), systemImage: symbol)
                .labelStyle(.iconOnly)
                .font(.headline)
                .foregroundColor(.primary)
                .clipShape(Circle())
        }
    }
    
    private func eventsListRow(for item: EventsDashboardModel) -> some View {
        VStack(alignment: .center, spacing: .zero) {
            Text(item.name)
                .multilineTextAlignment(.center)
                .fontWeight(.heavy)
                .font(.title2)
                .foregroundColor(.textPrimary)
                .padding(.vertical, Spacings.small)
                .fixedSize(horizontal: false, vertical: true)
            
            item.image?.image
                .frame(width: Constants.imageSize, height: Constants.imageSize)
                .clipShape(.rect(cornerRadius: Constants.imageCornerRadius))
                .defaultShadow(color: .textSecondary)
                .padding(.bottom, Spacings.large)
            
            detailsStackInformation(for: item)
        }
        .onTapGesture {
            viewModel.selectedEventId = item.id
            isShowingDetails = true
        }
    }
    
    private func sortListItemView(item: Field) -> some View {
        Text(item.rawValue)
            .font(.headline)
            .foregroundColor(viewModel.sortField == item ? Color.accentColor : .secondaryBackground)
            .background {
                RoundedRectangle(cornerRadius: 25)
                    .fill(.inverseMainBackground)
                    .padding(.all, -4)
            }
    }
    
    private func detailsStackInformation(for item: EventsDashboardModel) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: Spacings.medium)
                .stroke(.textSecondary, lineWidth: 2)
                .foregroundColor(.mainBackground)
            
            VStack(alignment: .leading, spacing: .zero) {
                detailsRowInformation(text: item.city, type: .city)
                detailsRowInformation(text: item.objectName, type: .objectName)
                detailsRowInformation(text: item.date, type: .data)
            }
        }
        .padding(.bottom, Spacings.small)
    }
    
    private func detailsRowInformation(text: String, type: DashboardDetailsRowEnum) -> some View {
        HStack(spacing: .zero) {
            Text(type.rawValue)
                .foregroundColor(.textPrimary)
                .font(.headline)
                .fontWeight(.bold)
                .padding(.trailing, Spacings.small / 2)
            
            Text(text)
                .foregroundColor(.textSecondary)
                .font(.body)
                .multilineTextAlignment(.center)
                .italic()
            
            Spacer()
        }
        .padding(.leading, Spacings.small)
        .padding(.bottom, Spacings.small)
        .fixedSize(horizontal: false, vertical: true)
    }
    
    private func detailsView() -> some View {
        DetailsView(eventId: viewModel.selectedEventId)
    }
}

#Preview {
    DashboardView()
}

private enum Constants {
    static let imageSize: CGFloat = 256
    static let imageCornerRadius: CGFloat = 25
}
