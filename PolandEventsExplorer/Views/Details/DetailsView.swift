import SwiftUI

struct DetailsView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    @StateObject private var viewModel: DetailsViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: .zero) {
                imageSlider
                    .padding(.bottom, Spacings.large)
                
                VStack(alignment: .leading, spacing: .zero) {
                    detailsViewTitle
                    
                    artistView
                        .padding(.bottom, Spacings.large)
                               
                    detailsInfoTitle
                    
                    detailsInfoStack
                }
                .padding(.horizontal, Spacings.medium)
                
                seatMapView
            }
        }
        .display(if: !viewModel.isLoading)
        .errorAlert(error: $viewModel.error, onDismiss: { presentationMode.wrappedValue.dismiss() })
        .navigationBarItems(leading: backButton)
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea(.container, edges: .top)
    }
    
    private var artistView: some View {
        VStack(alignment: .center, spacing: .zero) {
            divider
                .padding(.bottom, Spacings.extraLarge)
            
            VStack(spacing: Spacings.small) {
                icon(SFSymbols.artist)
                    .padding(.top, -Spacings.medium)
                
                artistLabels
                
                twoPartText(StringHandler.DetailsView.genreLabel, viewModel.eventDetailsInfo.genre)
                    .display(if: viewModel.shouldShowGenreLabel)
            }
            .background {
                RoundedRectangle(cornerRadius: Constants.rectangleCornerRadius)
                    .stroke(.textSecondary, lineWidth: 2)
                    .foregroundColor(.secondaryBackground)
                    .defaultShadow(color: .textPrimary)
                    .padding(.horizontal, -Spacings.small)
                    .padding(.vertical, -Spacings.small / 2)
            }
        }
        .display(if: viewModel.shouldShowGenreLabel && viewModel.shouldShowArtistLabels)
    }
    
    private var divider: some View {
        Divider()
            .frame(height: 3)
            .bold()
            .overlay(Color.inverseMainBackground)
    }
    
    private var detailsViewTitle: some View {
        Text(viewModel.eventDetailsInfo.name)
            .foregroundColor(.textPrimary)
            .font(.largeTitle)
            .fontWeight(.heavy)
            .padding(.vertical, Spacings.medium)
    }
    
    private var detailsInfoTitle: some View {
        Text(StringHandler.DetailsView.detailsInfoTitle)
            .foregroundColor(.textSecondary)
            .font(.headline)
            .fontWeight(.bold)
            .padding(.bottom, Spacings.large)
    }
        
    private var detailsInfoStack: some View {
        VStack(alignment: .leading, spacing: .zero) {
            detailsStackRow(
                image: SFSymbols.calendar,
                title: viewModel.eventDetailsInfo.fullDate,
                description: viewModel.eventDetailsInfo.timezone,
                additionalDescription: viewModel.eventDetailsInfo.time
            )
            .display(if: viewModel.shouldShowCalendarRow)
            
            detailsStackRow(
                image: SFSymbols.location,
                title: viewModel.eventDetailsInfo.country,
                additionalTitle: viewModel.eventDetailsInfo.city
            )
            .display(if: viewModel.shouldShowLocationRow)
            
            detailsStackRow(
                image: SFSymbols.building,
                title: viewModel.eventDetailsInfo.objectName,
                description: viewModel.eventDetailsInfo.address
            )
            .display(if: viewModel.shouldShowBuildingRow)
            
            detailsStackRow(
                image: SFSymbols.dollar,
                title: StringHandler.DetailsView.priceRangeTitle,
                description: viewModel.priceRangeString
            )
            .display(if: viewModel.shouldShowPriceRangerRow)
        }
        .padding(.horizontal, Spacings.large)
    }
    
    private var imageSlider: some View {
        VStack(spacing: .zero) {
            TabView {
                ForEach(0..<(viewModel.eventDetailsInfo.gallery.count), id: \.self) { index in
                    viewModel.eventDetailsInfo.gallery[index].image
                        .ignoresSafeArea()
                }
            }
            .ignoresSafeArea()
            .frame(height: Constants.imageHeight)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            
            Spacer()
        }
    }
    
    private var artistLabels: some View {
        VStack(spacing: .zero) {
            Text(StringHandler.DetailsView.artistLabel)
                .foregroundColor(.textPrimary)
                .font(.headline)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text(viewModel.eventDetailsInfo.bandName)
                .foregroundColor(.textSecondary)
                .font(.body)
                .multilineTextAlignment(.center)
        }
        .display(if: viewModel.shouldShowArtistLabels)
    }
    
    private var backButton: some View {
        Button(
            action: {
                presentationMode.wrappedValue.dismiss()
            },
            label: {
                icon(SFSymbols.xmark)
            }
        )
    }
    
    @ViewBuilder private var seatMapView: some View {
        VStack(spacing: .zero) {
            Text(StringHandler.DetailsView.seatMapTitle)
                .foregroundColor(.textPrimary)
                .font(.largeTitle)
                .fontWeight(.heavy)
                .padding(.vertical, Spacings.medium)
            
            AsyncImage(url: URL(string: viewModel.eventDetailsInfo.layoutImage)) { phase in
                switch phase {
                case .failure:
                    Image(systemName: SFSymbols.questionmark)
                        .font(.largeTitle)
                case .success(let image):
                    image
                        .resizable()
                        .frame(height: Constants.seatMapHeight)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, Spacings.extraLarge)
                default:
                    EmptyView()
                }
            }
            .defaultShadow(color: .textPrimary)
        }
        .display(if: viewModel.shouldShowSeatMap)
    }

    init(eventId: String) {
        _viewModel = StateObject(wrappedValue: DetailsViewModel(eventId: eventId))
    }
        
    private func detailsStackRow(
        image: String,
        title: String,
        description: String? = nil,
        additionalTitle: String? = nil,
        additionalDescription: String? = nil
    ) -> some View {
        HStack(spacing: .zero) {
            icon(image)
                .padding(.trailing, Spacings.medium)
            
            VStack(alignment: .leading, spacing: .zero) {
                twoPartText(title, additionalTitle)
                
                if let description {
                    twoPartText(description, additionalDescription)
                }
            }
        }
        .padding(.bottom, Spacings.large)
    }
    
    private func twoPartText(_ title: String, _ description: String? = nil) -> some View {
        HStack(spacing: .zero) {
            Text(title)
                .foregroundColor(.textPrimary)
                .font(.headline)
                .fontWeight(.bold)
                .padding(.trailing, Spacings.small / 2)
            
            if let description = description {
                Text(description)
                    .foregroundColor(.textSecondary)
                    .font(.body)
                    .multilineTextAlignment(.leading)
            }
        }
    }
    
    private func icon(_ image: String) -> some View {
        Image(systemName: image)
            .resizable()
            .foregroundColor(.mainBackground)
            .frame(width: Constants.circleSize / 2, height: Constants.circleSize / 2)
            .aspectRatio(contentMode: .fit)
            .bold()
            .makeStrokeCircleBackground(
                color: .inverseMainBackground,
                size: Constants.circleSize,
                strokeColor: .mainBackground,
                lineWidth: 2
            )
    }
}

#Preview {
    DetailsView(eventId: "")
}

private enum Constants {
    static let circleSize: CGFloat = 40
    static let seatMapHeight: CGFloat = 200
    static let imageHeight: CGFloat = 250
    static let rectangleCornerRadius: CGFloat = 16
}
