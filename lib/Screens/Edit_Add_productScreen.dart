import 'package:flutter/material.dart';
import 'package:online_market/models/product_model.dart';
import 'package:provider/provider.dart';

class EditAddProducScreen extends StatefulWidget {
  const EditAddProducScreen({super.key});

  @override
  State<EditAddProducScreen> createState() => _EditAddProducScreenState();
}

class _EditAddProducScreenState extends State<EditAddProducScreen> {
  final _FormTextid = GlobalKey<FormState>();
  final _formImageId = GlobalKey<FormState>();

  var _product =
      Product(id: '', Title: '', Descriptions: '', url: '', price: 0.0);

  void SaveImage() {
    final ImageIsNotEmty = _formImageId.currentState!.validate();
    if (ImageIsNotEmty) {
      setState(() {});
      _formImageId.currentState!.save();
      Navigator.of(context).pop();
    }
  }

  var init = true;
  var hasImage = true;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (init) {
      final Productid = ModalRoute.of(context)!.settings.arguments;
      if (Productid != null) {
        final Editproduct =
            Provider.of<ProductList>(context).FindById(Productid.toString());
        _product = Editproduct;
      }
    }

    init = false;
  }

  void _SaveForm() {
    final TextIsNotEmty = _FormTextid.currentState!.validate();
    print(TextIsNotEmty);
    if (TextIsNotEmty) {
      setState(() {
        _FormTextid.currentState!.save();
        if (_product.id.isEmpty) {
          Provider.of<ProductList>(context, listen: false).Addproduct(_product);
        } else {
          Provider.of<ProductList>(context, listen: false)
              .UpDateProduct(_product);
        }

        Navigator.of(context).pop();
      });
    }
    setState(() {
      hasImage = false;
    });
  }

  void ShowImageURLEnter(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: ((context) {
        return AlertDialog(
          title: Text('Rasm URLni kiriting!'),
          content: Form(
            key: _formImageId,
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'URL:',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url,
              initialValue: _product.url,
              validator: ((value) {
                if (value == null || value.isEmpty) {
                  return 'Iltimos Rasm URLni kiriting!';
                }
              }),
              onSaved: (newValue) {
                _product = Product(
                    id: _product.id,
                    Title: _product.Title,
                    Descriptions: _product.Descriptions,
                    url: newValue!,
                    price: _product.price);
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Yuq',
                style: TextStyle(fontSize: 18),
              ),
            ),
            ElevatedButton(
              onPressed: SaveImage,
              child: Text(
                'Ha',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mahsulot tahrirlash'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () => _SaveForm(), icon: Icon(Icons.save)),
        ],
      ),
      body: Form(
          key: _FormTextid,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'nomi:',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,
                  initialValue: _product.Title,
                  validator: ((value) {
                    if (value == null || value.isEmpty) {
                      return 'Iltimos mahsulot nomini kiriting!';
                    }
                  }),
                  onSaved: (newValue) {
                    _product = Product(
                        id: _product.id,
                        Title: newValue!,
                        Descriptions: _product.Descriptions,
                        url: _product.url,
                        price: _product.price);
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'narx:',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  initialValue:
                      _product.price == 0 ? "" : _product.price.toString(),
                  validator: ((value) {
                    if (value == null || value.isEmpty) {
                      return 'Iltimos mahsulot narxini kiriting!';
                    } else if (double.tryParse(value) == null) {
                      return 'Iltimos narxni to`g`ri kiriting';
                    } else if (double.parse(value) < 1) {
                      return 'Iltimos 0 dan katta qiymat bering';
                    }
                  }),
                  onSaved: (newValue) {
                    _product = Product(
                        id: _product.id,
                        Title: _product.Title,
                        Descriptions: _product.Descriptions,
                        url: _product.url,
                        price: double.parse(newValue!));
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'tarif:',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,
                  maxLines: 5,
                  initialValue: _product.Descriptions,
                  validator: ((value) {
                    if (value == null || value.isEmpty) {
                      return 'Iltimos mahsulotga tarif bering!';
                    } else if (value.length < 40) {
                      return 'Tarif 10 ta so`zdan kam bulmasin!  ';
                    }
                  }),
                  onSaved: (newValue) {
                    _product = Product(
                        id: _product.id,
                        Title: _product.Title,
                        Descriptions: newValue!,
                        url: _product.url,
                        price: _product.price);
                  },
                ),
                SizedBox(height: 10),
                Card(
                  clipBehavior: Clip.hardEdge,
                  margin: const EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: hasImage
                              ? Colors.grey
                              : Theme.of(context).errorColor),
                      borderRadius: BorderRadius.circular(5)),
                  child: InkWell(
                    onTap: () => ShowImageURLEnter(context),
                    splashColor: Theme.of(context).primaryColor,
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      child: _product.url.isEmpty
                          ? Center(
                              child: Text(
                              'Rasm URLni kiriting?',
                              style: TextStyle(
                                  color: hasImage
                                      ? Colors.black.withOpacity(0.7)
                                      : Theme.of(context).errorColor),
                            ))
                          : _product.url.startsWith('assets/')
                              ? Image.asset(
                                  _product.url,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                )
                              : Image.network(
                                  _product.url,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
