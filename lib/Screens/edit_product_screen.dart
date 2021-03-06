import 'package:flutter/material.dart';
import 'package:manga_store/Provider/products.dart';
import 'package:provider/provider.dart';

import '../Provider/product.dart';
import '../utils/colors.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );
  bool _initFirstTime = true;
  bool _isLoading = false;

  // this function if for adding listner...
  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_initFirstTime) {
      var productId = ModalRoute.of(context)!.settings.arguments;
      if (productId != null) {
        productId = productId as String;
        _editedProduct = Provider.of<Products>(context).findById(productId);
        _imageUrlController.text = _editedProduct.imageUrl!;
      }
    }
    super.didChangeDependencies();
    _initFirstTime = false;
  }

  // this function is for disposing of the instances that we created from readymade classes...
  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  // nothing just for triggering setstate...
  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  // for saving the user input...
  Future<void> _saveForm(id) async {
    final navigate = Navigator.of(context);
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    Products product = Provider.of<Products>(context, listen: false);
    if (id == null) {
      try {
        await product.addProduct(_editedProduct);
      } catch (error) {
        // ignore: prefer_void_to_null
        await showDialog<Null>(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text("An error occured"),
                  content: const Text("Something went wrong"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: const Text("Okay"))
                  ],
                ));
      }
      // finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    } else {
      await product.updateProduct(id, _editedProduct);
      // print("don't make new product");
    }
    setState(() {
      _isLoading = false;
    });
    navigate.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                  key: _form,
                  child: ListView(
                    children: [
                      titleField(context),
                      priceField(context),
                      discriptionField(),
                      Row(
                        children: [
                          showImage(),
                          Expanded(
                            child: imageURLField(),
                          ),
                        ],
                      )
                    ],
                  )),
            ),
    );
  }

  AppBar showAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: appbarColor,
      centerTitle: true,
      title: const Text("Edit Products"),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: IconButton(
              onPressed: (() => _saveForm(_editedProduct.id)),
              icon: const Icon(
                Icons.save,
              )),
        )
      ],
    );
  }

  TextFormField imageURLField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Image URL'),
      keyboardType: TextInputType.url,
      textInputAction: TextInputAction.done,
      controller: _imageUrlController,
      focusNode: _imageUrlFocusNode,
      onFieldSubmitted: (_) {
        _saveForm(_editedProduct.id);
      },
      onSaved: (value) {
        _editedProduct = Product(
            id: null,
            title: _editedProduct.title,
            description: _editedProduct.description,
            price: _editedProduct.price,
            imageUrl: value);
      },
      validator: (value) {
        if (value!.isEmpty) {
          return "Please Enter Image URL.";
        } else if (!value.startsWith("http") && !value.startsWith("https")) {
          return "Enter valid URL.";
        }
        return null;
      },
    );
  }

  Container showImage() {
    return Container(
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
      ),
      child: _imageUrlController.text.isEmpty
          ? const Center(child: Text("Enter URL"))
          : Image.network(
              _imageUrlController.text,
              fit: BoxFit.fill,
            ),
    );
  }

  TextFormField discriptionField() {
    return TextFormField(
      initialValue: _editedProduct.description,
      decoration: const InputDecoration(label: Text("Discription")),
      maxLines: 3,
      keyboardType: TextInputType.multiline,
      focusNode: _descriptionFocusNode,
      onSaved: (value) {
        _editedProduct = Product(
            id: null,
            title: _editedProduct.title,
            description: value,
            price: _editedProduct.price,
            imageUrl: _editedProduct.imageUrl);
      },
      validator: (value) {
        if (value!.isEmpty) {
          return "Please Enter Discription.";
        } else if (value.length < 10) {
          return "Shouldn't be less than 10 characters.";
        }
        return null;
      },
    );
  }

  TextFormField priceField(BuildContext context) {
    return TextFormField(
      initialValue: _editedProduct.price.toString(),
      decoration: const InputDecoration(label: Text("Price")),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      focusNode: _priceFocusNode,
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_descriptionFocusNode);
      },
      validator: (value) {
        if (value!.isEmpty) {
          return "Please Enter Price.";
        } else if (double.tryParse(value) == null) {
          return 'Enter Numbers for Price.';
        } else if (double.parse(value) <= 0) {
          return "Price should be greater than 0.";
        }
        return null;
      },
      onSaved: (value) {
        _editedProduct = Product(
            id: null,
            title: _editedProduct.title,
            description: _editedProduct.description,
            price: double.parse(value!),
            imageUrl: _editedProduct.imageUrl);
      },
    );
  }

  TextFormField titleField(BuildContext context) {
    return TextFormField(
      initialValue: _editedProduct.title,
      decoration: const InputDecoration(label: Text("Title")),
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_priceFocusNode);
      },
      onSaved: (value) {
        _editedProduct = Product(
            id: null,
            title: value,
            description: _editedProduct.description,
            price: _editedProduct.price,
            imageUrl: _editedProduct.imageUrl);
      },
      validator: (value) {
        if (value!.isEmpty) {
          return "Please Enter Title.";
        }
        return null;
      },
    );
  }
}
