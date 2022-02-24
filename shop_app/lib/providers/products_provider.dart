import 'dart:convert';
import 'package:flutter/material.dart';
import '/models/http_exception.dart';
// import '/resources/dummy_data.dart';
import '/models/product.dart';
import 'package:http/http.dart' as http; // alias

class ProductsProvider with ChangeNotifier {
  // ignore: prefer_final_fields
  List<Product> _items = []; // DUMMY_PRODUCTS;
  // bool _showFavoritesOnly = false;
  final String? authToken;
  final String? userId;

  ProductsProvider({
    this.authToken,
    this.userId,
    required List<Product> inputItems,
  }) : _items = inputItems;

  List<Product> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((element) => element.isFavorite).toList();
    //   // auto create an copy, not iterate to the variable
    // }
    return [..._items]; // a copy of _items!
  }

  Product findById(String id) {
    return _items.firstWhere(
      (element) => element.id == id,
    );
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Future<void> addProduct(Product product) async {
    // async always return a future!
    final url = Uri.parse(
        'https://shop-app-udemi-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken');
    // post return a future so don't need return at http!
    // return http
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            // 'isFavorite': product.isFavorite, // this no longer be here
            // because favorite mang tính cá nhân chứ không phải toàn bộ
            'creatorId': userId,
          },
        ),
      );
      // also don't need to use then anymore
      //     .then(
      //   (response) {
      // print(response.body);
      // {"name":"-Mw7U-5xJXz7vieWYtSI"}

      // Here important for us is the body named argument because this allows
      // us to define the request body which
      // is the data that gets attached to the request
      // know how to convert map -> json

      // _items.add(value);
      final newProduct = Product(
        id: json.decode(response.body)['name'], // DateTime.now().toString(),
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      // _items.insert(0, newProduct); // at the start of the list
      notifyListeners();
    } catch (error) {
      rethrow;
    }
    // cách để các widget sử dụng state của class này biết được sự thay đổi
    // là thêm notifyListeners() vào sau khi bước thay đổi được thực hiện!
    // },
    // );
    // ).catchError((error) {
    //   // print(error);
    //   // app won't crash!
    //   throw error;
    //   // throw error to catch in another screen!
    // });
    // return Future.value(); // this will be send before the previous code
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((element) => element.id == id);

    if (prodIndex >= 0) {
      final url = Uri.parse(
          'https://shop-app-udemi-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$authToken');
      // nhớ để ý chỗ url này cẩn thận!!!
      await http.patch(
        url,
        body: json.encode(
          {
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
            // 'isFavorite': newProduct.isFavorite,
            // nếu thêm isFavorite vào đây thì khi update qua cái icon
            // thì nó sẽ update cái isFavorite mặc dù mình không hề thay đổi nó!
          },
        ),
      );
      // await http.get(url).then((respone) => print(json.decode(respone.body)));
      // merge the data which is incoming with the existing data
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      // print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://shop-app-udemi-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$authToken');
    //  Utilizing Optimistic Updating
    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    // ignore: unused_local_variable
    Product? existingProduct = _items[existingProductIndex];
    // null safety

    // http.delete(url).then((response) {
    //   // print(response.statusCode);
    //   if (response.statusCode >= 400) {
    //     throw HttpException('Could not delete product.');
    //   }
    //   existingProduct = null;
    // }).catchError((_) {
    //   _items.insert(existingProductIndex, existingProduct!);
    //   // Đấy là lí do thêm cái index và vẫn lưu lại cái product lại!
    //   // để nếu có lỗi thì vẫn quay lại được trước khi có thao tác xoá!
    // });
    _items.removeAt(existingProductIndex);
    notifyListeners();
    // đưa lên trên để optimize thời gian, kiểu như là thay vì phải chờ cái
    // kia chạy xong thì để cái remove lên trước

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;

    // _items.removeWhere((element) => element.id == id);
  }

  Future fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    final url = Uri.parse(
        'https://shop-app-udemi-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken&$filterString');
    // Cái này như kiểu là mình chỉ được phép chỉnh sửa với những product do mình tạo ra
    // Nhưng cái này cũng làm cho lúc mình muốn xem tất cả sản phẩm thì không được

    try {
      final response = await http.get(url);
      // print(json.decode(response.body));
      final extractedData = json.decode(response.body) as Map<String, dynamic>?;
      if (extractedData == null) {
        return;
      }
      // fetch favorite status
      final favUrl = Uri.parse(
          'https://shop-app-udemi-default-rtdb.asia-southeast1.firebasedatabase.app/userFavorites/$userId.json?auth=$authToken');
      final favoriteResponse = await http.get(favUrl);
      final favoriteData = json.decode(favoriteResponse.body);

      final List<Product> loadedProducts = [];
      extractedData.forEach(
        /* (key, value) */ (prodId, prodData) {
          loadedProducts.add(Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            // isFavorite: prodData['isFavorite'],
            isFavorite:
                favoriteData == null ? false : favoriteData[prodId] ?? false,
          ));
        },
      );
      _items = loadedProducts;

      notifyListeners();
    } catch (error) {
      // print(error);
      // print('haiz');
      // throw (error);
    }
  }
}
