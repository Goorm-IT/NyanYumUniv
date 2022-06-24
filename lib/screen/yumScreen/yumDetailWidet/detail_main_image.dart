import 'package:cached_network_image/cached_network_image.dart';
import 'package:deanora/model/menu_by_store.dart';
import 'package:deanora/model/yum_store_list_composition.dart';
import 'package:deanora/screen/yumScreen/yumDetailWidet/detail_three_button.dart';
import 'package:flutter/material.dart';

class MainImage extends StatefulWidget {
  bool isNull;
  String imagePath;
  List<MenuByStore> menuList;
  final StoreComposition storeInfo;
  MainImage(
      {required this.isNull,
      required this.menuList,
      required this.storeInfo,
      this.imagePath = "",
      Key? key})
      : super(key: key);

  @override
  State<MainImage> createState() => _MainImageState();
}

class _MainImageState extends State<MainImage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 225,
          width: MediaQuery.of(context).size.width,
          child: widget.isNull
              ? Container(
                  color: Color(0xffF3F3F5),
                  child: Center(
                    child: Image.asset(
                      'assets/images/default_nobackground.png',
                      fit: BoxFit.fill,
                      width: 88,
                    ),
                  ),
                )
              : CachedNetworkImage(
                  fadeInDuration: const Duration(milliseconds: 100),
                  fadeOutDuration: const Duration(milliseconds: 100),
                  imageUrl: widget.imagePath,
                  fit: BoxFit.fill,
                  placeholder: (context, url) => Image.asset(
                    'assets/images/defaultImg.png',
                    width: 110,
                    height: 110,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
        ),
        Opacity(
          opacity: 0.7,
          child: Container(
            height: 35,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[Colors.black, Colors.transparent]),
            ),
          ),
        ),
        ThreeButton(
          isNull: false,
          menuList: widget.menuList,
          storeInfo: widget.storeInfo,
        ),
      ],
    );
  }
}
