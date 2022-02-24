import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/products_provider.dart';
import '/models/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  // stateful vì data phải quản lý chỉ sử dụng ở trong widget này!
  const EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  // final _priceFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  // to interact form with another method!
  // hầu như toàn dùng với form

  // ignore: prefer_final_fields
  Product _editedProduct = Product(
    id: '',
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );

  bool _isInit = true;
  bool _isLoading = false;

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImageUrl);
    // add my own listener
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments;
      if (productId != null) {
        _editedProduct = Provider.of<ProductsProvider>(context, listen: false)
            .findById(productId as String);
        // print(_editedProduct.id);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
        // print(_imageUrlController.text);
      }
    }
    _isInit = false;
  }

  @override
  void dispose() {
    super.dispose();
    // _priceFocusNode.dispose();
    // nhớ luôn phải dispose controller và focus node!
    _imageUrlController.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    // remove listener using this function
    _imageUrlFocusNode.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (!_imageUrlController.text.startsWith('http') &&
          !_imageUrlController.text.startsWith('https')) {
        return;
      }
      if (!_imageUrlController.text.endsWith('.png') &&
          !_imageUrlController.text.endsWith('.jpg') &&
          !_imageUrlController.text.endsWith('.jpeg')) {
        return;
      }
      setState(() {});
    }
    // preview when unfocus image url text field
  }

  void _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    // form is a stateful widget
    _form.currentState!.save();
    // print(_editedProduct.title);
    // print(_editedProduct.description);
    // print(_editedProduct.price);
    // print(_editedProduct.imageUrl);
    setState(() {
      // using setState here because the _isLoading
      // just be used only inside this widget
      _isLoading = true;
    });

    if (_editedProduct.id == '') {
      try {
        await Provider.of<ProductsProvider>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        // catch here!!!
        // showDialog return a future
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('An error occurred!'),
            content: const Text('Something went wrong.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                // close dialog
                child: const Text('Okay'),
              ),
            ],
          ),
        ).then((value) => null);
        // catchError yêu cầu Future<void> nên phải thêm then vào!
      }
      // finally {
      //   // always run no matter success or error
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
      // chỉ đẩy dữ liệu không hiện dữ liệu => listen = false

    } else {
      // update product
      await Provider.of<ProductsProvider>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
      // setState(() {
      //   _isLoading = false;
      // });
      // Navigator.of(context).pop();
      // doesn't send http request here so don't need to wait!
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EDIT PRODUCT'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    // vì biết rõ số lượng con bên trong và biết nó ít nên có thể dùng
                    // ListView thường
                    TextFormField(
                      initialValue: _initValues['title'],
                      // the form will have u get the value of the TextField
                      // => don't need controller!
                      decoration: const InputDecoration(
                        labelText: 'Product Title',
                      ),
                      textInputAction: TextInputAction.next,
                      // onFieldSubmitted: (_) {
                      //   FocusScope.of(context).requestFocus(_priceFocusNode);
                      // },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: value!,
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a product title.';
                        }
                        return null;
                        // return null; // input is correct
                        // return 'This is wrong!'; // the output show to the user
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      decoration: const InputDecoration(
                        labelText: 'Price',
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                      // focusNode: _priceFocusNode,
                      // thực ra không cần dùng đến focusNode vì nó tự có cái next rồi
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: double.parse(value!),
                          imageUrl: _editedProduct.imageUrl,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a price.';
                        }
                        if (double.tryParse(value) == null) {
                          // fail
                          return 'Please enter a valid number.';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please enter a number greater than zero.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                      // textInputAction: TextInputAction.next,
                      // chỉ có thể thêm multiline hoặc là .next này thôi vì không có
                      // chỗ cho cả hai nút ở trên keyboard!
                      maxLines: 3,
                      keyboardType:
                          TextInputType.multiline, // will have end line
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: value!,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a description.';
                        }
                        if (value.length < 10) {
                          return 'Should be at least 10 characters long.';
                        }
                        return null;
                        // return null; // input is correct
                        // return 'This is wrong!'; // the output show to the user
                      },
                    ),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(
                            top: 8,
                            right: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Container(
                            child: _imageUrlController.text.isEmpty
                                ? const Center(child: Text('Enter a URL'))
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: FittedBox(
                                      fit: BoxFit.fill,
                                      child: Image(
                                        image: NetworkImage(
                                          _imageUrlController.text,
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                        ), // preview
                        Expanded(
                          child: TextFormField(
                            // initialValue: _initValues['imageUrl'],
                            // the problem here is that I also use a controller for
                            // the imageUrl. Now you can't use both,
                            decoration: const InputDecoration(
                              labelText: 'Image URL',
                            ),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            onEditingComplete: () {
                              setState(() {
                                // By adding it now and by calling setState() in there
                                // (even though it's empty), we force Flutter to
                                // update the screen, hence picking up the latest
                                // image value entered by the user.
                                _imageUrlFocusNode.unfocus();
                                // dismiss the onscreen keyboard
                              });
                            },
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                id: _editedProduct.id,
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                price: _editedProduct.price,
                                imageUrl: value!,
                                isFavorite: _editedProduct.isFavorite,
                              );
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter an image URL.';
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Please enter a valid URL.';
                              }
                              if (!value.endsWith('.png') &&
                                  !value.endsWith('.jpg') &&
                                  !value.endsWith('.jpeg')) {
                                return 'Please enter a valid URL.';
                              }
                              return null;
                              // return null; // input is correct
                              // return 'This is wrong!'; // the output show to the user
                            },
                          ),

                          // cái textformfield này sẽ lấy chiều rộng theo cha của nó
                          // mà nếu để cha là row thì row không fixed cái width
                          // => Cần wrap nó trong expanded
                        ), // enter url
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
