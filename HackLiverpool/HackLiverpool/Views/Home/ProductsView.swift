import SwiftUI

struct Products: View {
    var productImageName: String
    var productName: String
    var price: Double
    var description: String
    var sellerName: String
    var sellerRating: Double
    var ordersCount: Int
    
    @State private var quantity: Int = 1
    @State private var isFavorite: Bool = false
    @State private var selectedSize: String = "100 ml"
    @State private var selectedDeliveryMethod: String = "Recibe a domicilio"
    @State private var showWishlistPopup: Bool = false // Estado para controlar la ventana emergente
    @State private var wishlistSize: String = "100 ml" // Estado para la talla seleccionada en la ventana emergente
    @State private var wishlistColor: String = "Original" // Estado para el color seleccionado en la ventana emergente
    @State private var showWishlistConfirmation: Bool = false // Estado para mostrar confirmación
    @State private var confirmationMessage: String = "" // Mensaje de confirmación personalizado
    @State private var confirmationType: String = "wishlist" // Tipo de confirmación (wishlist o tienda)
    @Environment(\.dismiss) private var dismiss
    
    let sizes = ["100 ml", "15 ml", "30 ml", "50 ml"]
    let colors = ["Original", "Edición Especial", "Verano", "Invierno"]
    let deliveryMethods = ["Click & Collect", "Recibe a domicilio"]
    
    var productCode: String {
        // Genera un código de producto ficticio para el ejemplo
        "1073" + String(format: "%06d", Int.random(in: 10000...999999))
    }
    
    var formattedPrice: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2
        
        if let formattedNumber = numberFormatter.string(from: NSNumber(value: price)) {
            return "$\(formattedNumber)"
        }
        
        return "$\(price)"
    }
    
    var body: some View {
        
        ZStack {
            VStack(spacing: 0) {
                // Header rosado con búsqueda
                HStack(spacing: 50) {
                    
                    Image(systemName: "storefront")
                        .foregroundColor(.white)
                    Text("Elige una tienda")
                        .foregroundColor(.white)
                        .font(.subheadline)
                }
                
        
            .padding(.horizontal)
            .padding(.top, 12)
            .padding(.bottom, 12)
                Spacer()
                VStack(spacing: 0) {
                    // Barra superior
                    // Barra de búsqueda
                    HStack(spacing: 16) {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .font(.title3)
                        }
                        
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .padding(.leading, 8)
                            Text("Buscar por producto, marca")
                                .foregroundColor(.gray.opacity(0.8))
                                .font(.system(size: 16))
                            Spacer()
                        }
                        .frame(height: 40)
                        .background(Color.white)
                        .cornerRadius(20)
                        
                        Button(action: {}) {
                            Image(systemName: "bag")
                                .foregroundColor(.white)
                                .font(.title3)
                        }
                        
                        Button(action: {}) {
                            Image(systemName: "ellipsis.vertical")
                                .foregroundColor(.white)
                                .font(.title3)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 14)
                }
                .background(Color(hex: "#D3008B"))
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        // Información del producto
                        VStack(alignment: .leading, spacing: 4) {
                            Text(sellerName.uppercased())
                                .font(.headline)
                                .foregroundColor(.gray)
                                .padding(.top, 20)
                            
                            Text("\(productName)")
                                .font(.title3)
                                .foregroundColor(.black)
                                .padding(.top, 2)
                            
                            HStack {
                                Text("Código de producto: \(productCode)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                                Spacer()
                                
                                HStack(spacing: 2) {
                                    ForEach(0..<5) { index in
                                        Image(systemName: index < Int(sellerRating) ? "star.fill" : (index == Int(sellerRating) && sellerRating.truncatingRemainder(dividingBy: 1) >= 0.5 ? "star.leadinghalf.filled" : "star"))
                                            .foregroundColor(.yellow)
                                            .font(.caption)
                                    }
                                    Text("52")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .padding(.leading, 4)
                                }
                            }
                            .padding(.top, 6)
                        }
                        .padding(.horizontal, 20)
                        
                        // Imagen del producto con botones de compartir y favorito
                        ZStack(alignment: .bottom) {
                            if UIImage(named: productImageName) != nil {
                                Image(productImageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 420)
                                    .padding(.vertical, 20)
                            } else {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(height: 420)
                                    .padding(.vertical, 20)
                                    .overlay(
                                        Text("Imagen no disponible")
                                            .foregroundColor(.gray)
                                    )
                            }
                            
                            // Botones de compartir y favorito
                            HStack {
                                Spacer()
                                
                                Button(action: {
                                    // Acción compartir
                                }) {
                                    Image(systemName: "square.and.arrow.up")
                                        .foregroundColor(.gray)
                                        .padding(12)
                                        .background(Color.white)
                                        .clipShape(Circle())
                                        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                                }
                                
                                Button(action: {
                                    // Mostrar popup de wishlist en lugar de alternar favorito directamente
                                    showWishlistPopup = true
                                }) {
                                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                                        .foregroundColor(isFavorite ? .red : .gray)
                                        .padding(12)
                                        .background(Color.white)
                                        .clipShape(Circle())
                                        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                                }
                                
                                
                            }
                            .padding(.bottom, 20)
                        }
                        
                        // Indicador de página (puntos)
                        HStack(spacing: 8) {
                            ForEach(0..<9) { index in
                                Circle()
                                    .fill(index == 0 ? Color(hex: "#D3008B") : Color.gray.opacity(0.3))
                                    .frame(width: 8, height: 8)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        
                        // Precio
                        Text(formattedPrice)
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(Color(hex: "#E23B30"))
                            .padding(.horizontal, 20)
                            .padding(.top, 15)
                        
                        // Links promociones
                        HStack {
                            Text("Ver más promociones")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        
                        Divider()
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                        
                        // Disponibilidad en tienda
                        HStack {
                            Image(systemName: "building.2")
                                .foregroundColor(.gray)
                                .frame(width: 24)
                            Text("Ver disponibilidad en tienda")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 12)
                        
                        // Envío gratis
                        HStack {
                            Image(systemName: "truck.box")
                                .foregroundColor(.gray)
                                .frame(width: 24)
                            Text("Envío gratis a todo el país")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 24)
                        
                        // Selector de talla
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Talla: \(selectedSize)")
                                    .font(.headline)
                                Spacer()
                                Image(systemName: "chevron.up")
                                    .foregroundColor(.black)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(5)
                            
                            // Opciones de talla
                            HStack(spacing: 12) {
                                ForEach(sizes, id: \.self) { size in
                                    Button(action: {
                                        selectedSize = size
                                    }) {
                                        Text(size)
                                            .font(.subheadline)
                                            .padding(.vertical, 14)
                                            .frame(maxWidth: .infinity)
                                            .background(selectedSize == size ? Color(hex: "#D3008B") : Color.white)
                                            .foregroundColor(selectedSize == size ? .white : .black)
                                            .cornerRadius(5)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 5)
                                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                            )
                                    }
                                }
                            }
                            
                            Text("Mostrar todas(4)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .padding(.top, 6)
                                .padding(.bottom, 10)
                        }
                        .padding(.horizontal, 20)
                        
                        // Selector de cantidad
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Cantidad:")
                                .font(.headline)
                                .padding(.bottom, 4)
                            
                            HStack(spacing: 0) {
                                Button(action: {
                                    if quantity > 1 { quantity -= 1 }
                                }) {
                                    Text("−")
                                        .font(.headline)
                                        .frame(width: 60, height: 48)
                                        .background(Color.white)
                                        .foregroundColor(.black)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 0)
                                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                        )
                                }
                                
                                Text("\(quantity)")
                                    .font(.headline)
                                    .frame(width: 80, height: 48)
                                    .background(Color.white)
                                    .foregroundColor(.black)
                                    .overlay(
                                        Rectangle()
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    )
                                
                                Button(action: { quantity += 1 }) {
                                    Text("+")
                                        .font(.headline)
                                        .frame(width: 60, height: 48)
                                        .background(Color.white)
                                        .foregroundColor(.black)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 0)
                                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                        )
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 24)
                        
                        // Opciones de entrega
                        HStack(spacing: 16) {
                            ForEach(deliveryMethods, id: \.self) { method in
                                Button(action: {
                                    selectedDeliveryMethod = method
                                }) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 8) {
                                            HStack {
                                                if method == "Click & Collect" {
                                                    Image(systemName: "building.2")
                                                        .foregroundColor(.black)
                                                } else {
                                                    Image(systemName: "truck.box")
                                                        .foregroundColor(.black)
                                                }
                                                
                                                Text(method)
                                                    .font(.headline)
                                                    .foregroundColor(.black)
                                            }
                                            
                                            Text(method == "Click & Collect" ? "Recoge en tienda" : "Envío Gratis")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                        
                                        Spacer()
                                        
                                        if selectedDeliveryMethod == method {
                                            Circle()
                                                .fill(Color(hex: "#D3008B"))
                                                .frame(width: 22, height: 22)
                                                .overlay(
                                                    Image(systemName: "checkmark")
                                                        .font(.caption2)
                                                        .foregroundColor(.white)
                                                )
                                        }
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(5)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(selectedDeliveryMethod == method ? Color(hex: "#D3008B") : Color.gray.opacity(0.3), lineWidth: 1)
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Dirección de entrega
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Entrega en: Estrella Verdiguel")
                                .font(.subheadline)
                                .foregroundColor(.black)
                            
                            Text("Cambiar dirección")
                                .font(.subheadline)
                                .foregroundColor(Color(hex: "#D3008B"))
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                        .padding(.bottom, 30)
                        
                        // Botones de acción
                        VStack(spacing: 16) {
                            Button(action: {
                                // Acción comprar ahora
                            }) {
                                Text("Comprar ahora")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 18)
                                    .background(Color(hex: "#D3008B"))
                                    .cornerRadius(8)
                            }
                            
                            Button(action: {
                                // Acción agregar a bolsa
                            }) {
                                Text("Agregar a mi bolsa")
                                    .font(.headline)
                                    .foregroundColor(Color(hex: "#D3008B"))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 18)
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color(hex: "#D3008B"), lineWidth: 1)
                                    )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 50)
                    }
                }
            }
            .edgesIgnoringSafeArea(.top)
            .navigationBarHidden(true)
            
            // Popup de confirmación para agregar a wishlist o ver en tienda
            if showWishlistConfirmation {
                VStack {
                    Color.black.opacity(0.4)
                }
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    showWishlistConfirmation = false
                }
                
                VStack(spacing: 16) {
                    Image(systemName: confirmationType == "wishlist" ? "heart.circle.fill" : "storefront.circle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(Color(hex: "#D3008B"))
                    
                    Text(confirmationType == "wishlist" ?
                         "¡Producto agregado a tu lista de deseos!" :
                         "¡Guardado para despues ver en Tienda!")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        
                    Button(action: {
                        showWishlistConfirmation = false
                    }) {
                        Text("Aceptar")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 120)
                            .padding(.vertical, 12)
                            .background(Color(hex: "#D3008B"))
                            .cornerRadius(8)
                    }
                    .padding(.top, 8)
                }
                .padding(24)
                .background(Color.white)
                .cornerRadius(16)
                .shadow(radius: 10)
                .transition(.scale)
                .zIndex(3) // Por encima de todo
            }
            
            // Popup WishList
            if showWishlistPopup {
                // Fondo oscuro con opacidad
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        showWishlistPopup = false
                    }
                
                // Ventana emergente
                VStack(alignment: .leading, spacing: 24) {
                    // Encabezado
                    HStack {
                        Text("Agregar producto")
                            .font(.headline)
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        Button(action: {
                            showWishlistPopup = false
                        }) {
                            Image(systemName: "xmark")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // Información del producto
                    HStack(spacing: 16) {
                        // Imagen de producto (miniatura)
                        if UIImage(named: productImageName) != nil {
                            Image(productImageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .cornerRadius(8)
                        } else {
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 80, height: 80)
                                .cornerRadius(8)
                                .overlay(
                                    Text("Imagen")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                )
                        }
                        
                        // Detalles del producto
                        VStack(alignment: .leading, spacing: 4) {
                            Text(sellerName)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            Text(productName)
                                .font(.headline)
                                .foregroundColor(.black)
                                .lineLimit(2)
                            
                            Text(formattedPrice)
                                .font(.title3)
                                .foregroundColor(Color(hex: "#E23B30"))
                                .padding(.top, 4)
                        }
                    }
                    
                    Divider()
                    
                    // Selección de talla
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Capacidad")
                            .font(.headline)
                        
                        // Grid de tamaños
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            ForEach(sizes, id: \.self) { size in
                                Button(action: {
                                    wishlistSize = size
                                }) {
                                    Text(size)
                                        .font(.subheadline)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(wishlistSize == size ? Color(hex: "#D3008B") : Color.white)
                                        .foregroundColor(wishlistSize == size ? .white : .black)
                                        .cornerRadius(5)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 5)
                                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                        )
                                }
                            }
                        }
                    }
                    
                    // Selección de color
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Versión")
                            .font(.headline)
                        
                        // Grid de colores
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            ForEach(colors, id: \.self) { color in
                                Button(action: {
                                    wishlistColor = color
                                }) {
                                    Text(color)
                                        .font(.subheadline)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(wishlistColor == color ? Color(hex: "#D3008B") : Color.white)
                                        .foregroundColor(wishlistColor == color ? .white : .black)
                                        .cornerRadius(5)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 5)
                                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                        )
                                }
                            }
                        }
                    }
                    HStack{
                        VStack{
                            Button(action: {
                                // Agregar a favoritos y mostrar confirmación
                                isFavorite = true
                                showWishlistPopup = false
                                confirmationType = "wishlist"
                                showWishlistConfirmation = true
                            }) {
                                Image(systemName: isFavorite ? "heart.fill" : "heart")
                                    .foregroundColor(isFavorite ? .red : .gray)
                                    .padding(12)
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                            }
                            Text("WhisList")
                                .font(.headline)
                                .foregroundColor(Color(hex: "#D3008B"))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .cornerRadius(8)
                        }
                        VStack{
                            Button(action: {
                                // Simular navegación a la tienda
                                showWishlistPopup = false
                                confirmationType = "tienda"
                                showWishlistConfirmation = true
                            }) {
                                Image(systemName: "storefront")
                                    .foregroundColor(.gray)
                                    .padding(12)
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                            }
                            Text("Ver en tienda")
                                .font(.headline)
                                .foregroundColor(Color(hex: "#D3008B"))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(24)
                .background(Color.white)
                .cornerRadius(16)
                .shadow(radius: 10)
                .padding(.horizontal, 24)
                .transition(.scale)
                .zIndex(2) // Por encima del contenido normal
            }
        }
    }
}


struct Products_Previews: PreviewProvider {
    static var previews: some View {
        Products(
            productImageName: "kenzo",
            productName: "Eau de parfum Kenzo Flower para mujer",
            price: 2990.00,
            description: "Perfume floral con notas de violeta y rosa.",
            sellerName: "KENZO",
            sellerRating: 4.5,
            ordersCount: 320
        )
    }
}
