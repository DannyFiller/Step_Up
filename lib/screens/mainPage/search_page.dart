import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stepup/data/providers/filter_vm.dart';
import 'package:stepup/data/providers/product_vm.dart';
import 'package:stepup/widgets/filtedProducts/product_list.dart';
import 'package:stepup/widgets/filter/filter_widget.dart';

import '../../data/models/product_model.dart';
import '../../data/providers/provider.dart';
import '../../widgets/filtedProducts/GridItem.dart';

class SearchPage extends StatefulWidget {
  bool? isSearch = false;
  SearchPage({
    Key? key,
    this.isSearch,
  }) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Product> proList = [];
  TextEditingController _searchController = TextEditingController();
  String searchText = '';
  bool isLoading = false;
  Future<String> _loadProData(
      String text, String brand, RangeValues price, int size) async {
    isLoading = true;
    proList = await ReadData()
        .searchProduct(text, brand: brand, price: price, size: size);
    print("${text}, ${brand}, ${size}, ${price}");
    isLoading = false;
    return '';
  }

  Future<String> _loadAllProData() async {
    proList = await ReadData().loadProductData();
    return '';
  }

  bool isSearch(String text, String brand, int size, RangeValues price) {
    if (!text.isEmpty ||
        brand != "" ||
        size != 0 ||
        price != RangeValues(0.0, 10.0)) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.isSearch = false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(!widget.isSearch! ? "Sản Phẩm" : "Tìm kiếm"),
          ),
          body: SingleChildScrollView(
            child: ChangeNotifierProvider<ProductVMS>(
              create: (context) => ProductVMS(),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(30)),
                      child: Row(
                        children: [
                          Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              child: Icon(Icons.search)),
                          Expanded(
                              child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Nhập từ khóa ở đây',
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors
                                        .transparent), // Tắt gạch dưới khi không focus
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors
                                        .transparent), // Tắt gạch dưới khi focus
                              ),
                            ),
                            onSubmitted: (value) {
                              setState(() {
                                searchText = value;
                                widget.isSearch = true;
                              });
                            },
                          )),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                widget.isSearch = true;
                              });
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Consumer<FilterVMS>(
                                      builder: (context, myType, child) {
                                        return FilterWidget();
                                      },
                                    );
                                  }).whenComplete(() {
                                // Khi modal bottom sheet đóng, bỏ focus khỏi TextField
                                FocusScope.of(context).unfocus();
                              });
                            },
                            child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                child: Icon(Icons.filter_alt_outlined)),
                          ),
                        ],
                      ),
                    ),
                    searchText == ''
                        ? Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.start,
                                'Tất cả sản phẩm'),
                          )
                        : Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.start,
                                'Kết quả tìm kiếm cho \'$searchText\''),
                          ),
                    Consumer<FilterVMS>(
                      builder: (context, myType, child) {
                        return FutureBuilder(
                          future: isSearch(_searchController.text, myType.brand,
                                  myType.size, myType.price)
                              ? _loadProData(searchText, myType.brand,
                                  myType.price, myType.size)
                              : _loadAllProData(),
                          builder: (BuildContext context, snapshot) {
                            return isLoading
                                ? Container(
                                    alignment: Alignment.center,
                                    child: CircularProgressIndicator(),
                                  )
                                : SingleChildScrollView(
                                    child: Container(
                                      color: Colors.white,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8),
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(top: 5),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.7,
                                            child: Container(
                                                child: Consumer<ProductVMS>(
                                              builder:
                                                  (context, myType, child) {
                                                return GridView.builder(
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                    childAspectRatio: 0.8,
                                                    crossAxisCount: 2,
                                                    mainAxisSpacing: 10,
                                                    crossAxisSpacing: 1,
                                                  ),
                                                  itemCount: proList.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Center(
                                                      child: Container(
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            Navigator.pushNamed(
                                                                context,
                                                                "/productDetail",
                                                                arguments:
                                                                    proList[
                                                                        index]);
                                                          },
                                                          child: GridItem(
                                                              product: proList[
                                                                  index]),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}