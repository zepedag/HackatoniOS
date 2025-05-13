import SwiftUI

struct WorkerView: View {
    @State private var isAttending: Bool = false
    @State private var isFinished: Bool = false
    @State var clientname: String
    @State var profileImage: String
    @State private var isBusy: Bool = false

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.liverpoolPink
                .edgesIgnoringSafeArea(.all)
            if isBusy {
                LiverpoolView(isBusy: $isBusy)
            } else {
                VStack() {
                    VStack(spacing: 60) {
                        Text(clientname)
                            .font(
                                isFinished ?
                                    .system(size: UIScreen.main.bounds.width * 0.1) :
                                isAttending ?
                                    .system(size: UIScreen.main.bounds.width * 0.075) :
                                    .system(size: UIScreen.main.bounds.width * 0.1)
                            )
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .bold()
                            .lineLimit(1)

                        GeometryReader { geometry in
                            Image(profileImage)
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                .frame(
                                    width: geometry.size.width * (isAttending ? 0.5 : 0.6), // La imagen ocupa el 40% del ancho si atendiendo, 60% sino
                                    height: geometry.size.width * (isAttending ? 0.5 : 0.6) // Mantiene la proporción cuadrada
                                )
                                .padding()
                                .frame(maxWidth: .infinity, maxHeight: .infinity) // Centra la imagen dentro del GeometryReader
                        }
                        .aspectRatio(1, contentMode: .fit) // Asegura que el GeometryReader sea cuadrado

                        if !isFinished && isAttending {
                            ItemView(isAttending: $isAttending, isFinished: $isFinished)
                                .frame(height: UIScreen.main.bounds.height * 0.3) // Altura relativa de la lista
                        } else if isFinished {
                            Text("¡Listo!")
                                .font(.system(size: UIScreen.main.bounds.width * 0.08))
                                .foregroundColor(.white)
                                .transition(.opacity)
                                .bold()
                            Button("Siguiente cliente") {
                                print("Siguiente Cliente")
                                withAnimation {
                                    isFinished = false
                                    isAttending = false
                                    clientname = "Esteban"
                                    profileImage = "TestClient"
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .foregroundColor(.liverpoolPink)
                            .cornerRadius(10)
                            .font(.system(size: UIScreen.main.bounds.width * 0.05))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .top)
                    .background(Color.liverpoolPink)
                    .padding(.top, isAttending ? UIScreen.main.bounds.height / 23 : UIScreen.main.bounds.height / 23)
                    .padding(.bottom, isAttending ? UIScreen.main.bounds.height / 28 : UIScreen.main.bounds.height / 28)

                    Spacer()

                    if isAttending && !isFinished {
                        Button("Apoyo finalizado") {
                            print("Apoyo finalizado")
                            withAnimation {
                                isFinished = true
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.liverpoolPink)
                        .cornerRadius(10)
                        .font(.system(size: UIScreen.main.bounds.width * 0.05))
                    } else if !isAttending && !isFinished {
                        HStack(spacing: 80) {
                            Spacer()
                            Button("Atender") {
                                print("Atender")
                                withAnimation {
                                    isAttending = true
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .foregroundColor(.liverpoolPink)
                            .cornerRadius(10)
                            .font(.system(size: UIScreen.main.bounds.width * 0.05))
                            .scaledToFill()

                            Button("Ocupado") {
                                print("Ocupado")
                                withAnimation {
                                    isBusy = true
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .foregroundColor(.liverpoolPink)
                            .cornerRadius(10)
                            .font(.system(size: UIScreen.main.bounds.width * 0.05))
                            .scaledToFill()
                            Spacer()
                        }
                        .padding(.bottom)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .top)
            }
        }
    }
}
struct ItemView: View {
    @Binding var isAttending: Bool
    @Binding var isFinished: Bool
    @State private var imageList: [ImageData] = [
        ImageData(imageName: "LATTAFA", description: "Eau de parfum Yara para mujer", brand: "LATTAFA", barcode: "237454938223", comments: "100 mL"),
        ImageData(imageName: "DIOR", description: "Eau de toilette Sauvage para hombre", brand: "DIOR", barcode: "234234123423", comments: "100 mL"),
        ImageData(imageName: "HERMES", description: "Eau de parfum Terre d'Hermès para hombre", brand: "HERMÈS", barcode: "732641823643", comments: "75 mL"),
        ImageData(imageName: "CHANEL", description: "CHANCE EAU SPLENDIDE", brand: "CHANEL", barcode: "731763249123", comments: "100 mL")
    ]
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                ForEach(imageList) { imageData in
                    HStack {
                        VStack(alignment: .leading) {
                            Image(imageData.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: UIScreen.main.bounds.width * 0.5)
                                .cornerRadius(10)

                            Text("Descripción: \(imageData.description)")
                                .font(.system(size: UIScreen.main.bounds.width * 0.025))
                                .foregroundColor(.black)
                                .lineLimit(3)
                            Text("Marca: \(imageData.brand)")
                                .font(.system(size: UIScreen.main.bounds.width * 0.025))
                                .foregroundColor(.black)
                                .lineLimit(1)
                            Text("Código de barras: \(imageData.barcode)")
                                .font(.system(size: UIScreen.main.bounds.width * 0.025))
                                .foregroundColor(.black)
                                .lineLimit(1)
                            Text("Comentarios: \(imageData.comments)")
                                .font(.system(size: UIScreen.main.bounds.width * 0.025))
                                .foregroundColor(.black)
                                .lineLimit(3)
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.5)
                        if isAttending {
                            Button {
                                if let index = imageList.firstIndex(where: { $0.id == imageData.id }) {
                                    imageList.remove(at: index)
                                }
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                                    .font(.system(size: UIScreen.main.bounds.width * 0.075))
                            }
                        }
                    }
                }
            }
        }
        .frame(height: isAttending ? UIScreen.main.bounds.width * 0.5 : UIScreen.main.bounds.width * 0.7)


        .scaledToFit()
        .background(.white)
    }
}
struct LiverpoolView: View {
    @Binding var isBusy: Bool
    var body: some View {
        ZStack {
            Color.liverpoolPink
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("Liverpool")
                    .font(.system(size: UIScreen.main.bounds.width * 0.2)) // Tamaño relativo al ancho de la pantalla
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                Text("Es parte de tu vida")
                    .font(.system(size: UIScreen.main.bounds.width * 0.05))                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.bottom)
                Button("Desocupado") { // Corrección del texto del segundo botón
                    // Acción cuando el cliente está ocupado (aquí debería ser la acción del trabajador)
                    print("Desocupado")
                    withAnimation {
                        isBusy = false
                    }
                }
                .padding()
                .background(Color.white)
                .foregroundColor(.liverpoolPink)
                .cornerRadius(10)
                .font(.system(size: UIScreen.main.bounds.width * 0.04))
                .scaledToFill()
                .bold()
            }
            .padding()
        }
    }
}
struct ImageData: Identifiable {
    let id = UUID()
    let imageName: String
    let description: String
    let brand: String
    let barcode: String
    let comments: String
}

// Para previsualizar esta vista en Xcode:
struct WorkerViewPreview: PreviewProvider {
    static var previews: some View {
        WorkerView(clientname: "Maria Alicia", profileImage: "Tita")
    }
}
