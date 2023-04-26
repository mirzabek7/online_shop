import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../models/product.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});

  static const routeName = 'edit-product';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _form = GlobalKey<FormState>();
  final _imageForm = GlobalKey<FormState>();
  var _product =
      Product(id: "", title: "", description: "", price: 0.0, imageUrl: "");
  var hasImage = true;
  var _init = true;
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (_init) {
      final productId = ModalRoute.of(context)!.settings.arguments;
      if (productId != null) {
        final editingProduct =
            Provider.of<Products>(context).findById(productId as String);
        _product = editingProduct;
      }
    }
    _init = false;
  }

  void _showImageDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text("Rasm URL-ni kiriting"),
            content: Form(
              key: _imageForm,
              child: TextFormField(
                initialValue: _product.imageUrl,
                decoration: const InputDecoration(
                  labelText: "Rasm URL",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.url,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Iltimos, rasm URL-ni kiriting!';
                  } else if (!value.startsWith("http")) {
                    return "To'g'ri URL kiriting";
                  }
                },
                onSaved: (newValue) {
                  _product = Product(
                      id: _product.id,
                      title: _product.title,
                      description: _product.description,
                      price: _product.price,
                      imageUrl: newValue!,
                      isFavorite: _product.isFavorite);
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("BEKOR QILISH"),
              ),
              ElevatedButton(
                onPressed: () => _imageFormSave(),
                child: const Text("SAQLASH"),
              ),
            ],
          );
        });
  }

  void _imageFormSave() {
    final isValid = _imageForm.currentState!.validate();
    if (isValid) {
      _imageForm.currentState!.save();
      hasImage = true;
      setState(() {});
      Navigator.of(context).pop();
    }
  }

  Future<void> _saveForm() async {
    FocusScope.of(context).unfocus();
    final isValid = _form.currentState!.validate();
    setState(() {
      hasImage = _product.imageUrl.isNotEmpty;
    });
    if (isValid) {
      _form.currentState!.save();
      setState(() {
        isLoading = true;
      });
      if (_product.id.isEmpty) {
        try {
          await Provider.of<Products>(context, listen: false)
              .addProduct(_product);
        } catch (error) {
          await showDialog<Null>(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  title: const Text("Xatolik!"),
                  content: const Text(
                      "Mahsulotni kiritish vaqtida xatolik yuz berdi"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("OK"))
                  ],
                );
              });
        }
      } else {
        try {
          await Provider.of<Products>(context, listen: false)
              .updateProduct(_product);
        } catch (e) {
          await showDialog<Null>(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  title: const Text("Xatolik!"),
                  content: const Text(
                      "Mahsulotni kiritish vaqtida xatolik yuz berdi"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("OK"))
                  ],
                );
              });
        }
      }
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  // final _priceFocus = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_product.id.isEmpty
            ? "Mahsulot Qo'shish"
            : "Mahsulotni tahrirlash"),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _product.title,
                        decoration: const InputDecoration(
                          label: Text("Nomi"),
                          border: OutlineInputBorder(),
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Iltimos, mahsulot nomini kiriting!';
                          }
                        },
                        onSaved: (newValue) {
                          _product = Product(
                              id: _product.id,
                              title: newValue!,
                              description: _product.description,
                              price: _product.price,
                              imageUrl: _product.imageUrl,
                              isFavorite: _product.isFavorite);
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        initialValue: _product.price.toStringAsFixed(2),
                        decoration: const InputDecoration(
                          label: Text("Narxi"),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Iltimos, mahsulot narxini kiriting!';
                          } else if (double.tryParse(value) == null) {
                            return "To'g'ri narx kiriting";
                          } else if (double.parse(value) < 0) {
                            return "Mahsulot narxi 0 dan kichik bo'lishi mumkin emas!";
                          }
                        },
                        // focusNode: _priceFocus,
                        onSaved: (newValue) {
                          _product = Product(
                              id: _product.id,
                              title: _product.title,
                              description: _product.description,
                              price: double.parse(newValue!),
                              imageUrl: _product.imageUrl,
                              isFavorite: _product.isFavorite);
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        initialValue: _product.description,
                        decoration: const InputDecoration(
                          label: Text("Qo'shimcha ma'lumot"),
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true,
                        ),
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Iltimos, mahsulot haqida ma\'lumot kiriting!';
                          } else if (value.length < 15) {
                            return "Iltimos, batafsilroq ma'lumot kiriting";
                          }
                        },
                        // focusNode: _priceFocus,
                        onSaved: (newValue) {
                          _product = Product(
                              id: _product.id,
                              title: _product.title,
                              description: newValue!,
                              price: _product.price,
                              imageUrl: _product.imageUrl,
                              isFavorite: _product.isFavorite);
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Card(
                        margin: const EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: hasImage
                                  ? Colors.grey
                                  : Theme.of(context).colorScheme.error),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: InkWell(
                          splashColor:
                              Theme.of(context).primaryColor.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(3),
                          highlightColor: Colors.transparent,
                          onTap: () => _showImageDialog(context),
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            height: 250,
                            child: _product.imageUrl.isEmpty
                                ? Text(
                                    "Asosiy rasm URL-ini kiriting!",
                                    style: TextStyle(
                                        color: hasImage
                                            ? Colors.black
                                            : Theme.of(context)
                                                .colorScheme
                                                .error),
                                  )
                                : Image.network(
                                    _product.imageUrl,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
