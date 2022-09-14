import 'package:deanora/http/yumServer/yumHttp.dart';
import 'package:deanora/model/menu_by_store.dart';
import 'package:deanora/model/yum_store_list_composition.dart';
import 'package:deanora/screen/yumScreen/yum_add_store.dart';
import 'package:flutter/material.dart';

class YumSearchAddStore extends StatefulWidget {
  const YumSearchAddStore({Key? key}) : super(key: key);

  @override
  State<YumSearchAddStore> createState() => _YumSearchAddStoreState();
}

class _YumSearchAddStoreState extends State<YumSearchAddStore> {
  TextEditingController _controller = TextEditingController();
  List<StoreComposition> searchList = [];
  String errorText = "";
  String errorText2 = "";
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "리뷰를 작성할 가게를 검색해 주세요",
                style: TextStyle(fontSize: 18),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    width: MediaQuery.of(context).size.width - 100,
                    height: 30,
                    child: TextField(
                      controller: _controller,
                    ),
                  ),
                  Container(
                    height: 30,
                    padding: EdgeInsets.zero,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      splashRadius: 25,
                      onPressed: () async {
                        YumStorehttp _yumStorehttp = YumStorehttp();
                        List<StoreComposition> tmp =
                            await _yumStorehttp.getstorebyAlias(
                          storeAlias: _controller.text,
                        );
                        setState(() {
                          searchList = tmp;
                          if (searchList.length > 0) {
                            errorText = "";
                            errorText2 = "";
                          } else {
                            errorText = '등록된 가게가 없습니다';
                            errorText2 = '가게를 먼저 등록해주세요';
                          }
                        });
                      },
                      icon: Icon(
                        Icons.search,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              searchList.length > 0
                  ? Container(
                      height: MediaQuery.of(context).size.height -
                          MediaQuery.of(context).padding.top -
                          30 -
                          30 -
                          68,
                      child: ListView.builder(
                        itemCount: searchList.length,
                        itemBuilder: ((listViewContext, index) {
                          return GestureDetector(
                            onTap: () async {
                              YumMenuhttp _yumMenuttp = YumMenuhttp();
                              List<MenuByStore> menuList = [];
                              if (searchList.length > 0) {
                                menuList = await _yumMenuttp.menuByStore(
                                    searchList[index].storeId.toString());
                              }

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => YumAddStore(
                                      menuList: menuList,
                                      storeInfo: searchList[index]),
                                ),
                              );
                            },
                            child: Container(
                              margin:
                                  const EdgeInsets.only(left: 20, bottom: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    searchList[index].storeAlias.trimLeft(),
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(searchList[index].address)
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    )
                  : Container(
                      child: Text(
                        '$errorText\n$errorText2',
                        textAlign: TextAlign.center,
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
