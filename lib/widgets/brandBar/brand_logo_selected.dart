// ignore_for_file: unused_field

import 'package:flutter/material.dart';

class BrandLogoSelected extends StatefulWidget {
  final String logoImg;
  final String brandName;
  final bool isSelected;

  const BrandLogoSelected({
    Key? key,
    required this.logoImg,
    required this.brandName,
    this.isSelected = false,
  }) : super(key: key);

  @override
  _BrandLogoSelectedState createState() => _BrandLogoSelectedState();
}

class _BrandLogoSelectedState extends State<BrandLogoSelected> {
  bool _textVisible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.only(right: 5, left: 3),
      padding: EdgeInsets.only(left: 5, right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: widget.isSelected ? null : Border.all(),
        color:
            widget.isSelected ? Color.fromRGBO(53, 114, 239, 1) : Colors.white,
      ),
      child: Row(
        children: [
          widget.brandName == "Tất cả"
              ? Container()
              : Container(
                  padding: EdgeInsets.all(5),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: widget.isSelected
                        ? Color.fromRGBO(53, 114, 239, 1)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(
                    widget.logoImg,
                    fit: BoxFit.contain,
                    color: widget.isSelected ? Colors.white : Colors.black,
                    errorBuilder: (context, error, stackTrace) => Container(),
                  ),
                ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.center,
            child: Text(
              textAlign: TextAlign.center,
              widget.brandName,
              style: TextStyle(
                fontSize: 14,
                color: widget.isSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}