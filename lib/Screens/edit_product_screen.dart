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
  void _saveForm() {
    _form.currentState!.validate();
    _form.currentState!.save();
    Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appbarColor,
        centerTitle: true,
        title: const Text("Edit Products"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
                onPressed: _saveForm,
                icon: const Icon(
                  Icons.save,
                )),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
            key: _form,
            child: ListView(
              children: [
                TextFormField(
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
                ),
                TextFormField(
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
                ),
                TextFormField(
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
                ),
                Row(
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
                      ),
                      child: _imageUrlController.text.isEmpty
                          ? const Center(child: Text("Enter URL"))
                          : Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.fill,
                            ),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Image URL'),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlController,
                        focusNode: _imageUrlFocusNode,
                        onFieldSubmitted: (_) {
                          _saveForm();
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
                          } else if (!value.startsWith("http") &&
                              !value.startsWith("https")) {
                            return "Enter valid URL.";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }
}
