import 'package:deanora/http/yumServer/yumHttp.dart';
import 'package:deanora/model/yum_store_list_composition.dart';
import 'package:deanora/model/yum_user.dart';
import 'package:deanora/provider/storeInfo_provider.dart';
import 'package:deanora/screen/yumScreen/yum_my_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class MyYumMain extends StatefulWidget {
  MyYumMain();
  @override
  _MyYumMainState createState() => _MyYumMainState();
}

class _MyYumMainState extends State<MyYumMain> {
  _MyYumMainState();
  int init = 1;
  @override
  void initState() {
    super.initState();
  }

  late StoreInfoProvider _storeInfoProvider;
  @override
  Widget build(BuildContext context) {
    _storeInfoProvider = Provider.of<StoreInfoProvider>(context, listen: false);
    _storeInfoProvider.loadStoreInfo(init, 10);
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Consumer<StoreInfoProvider>(
              builder: (context, provider, widget) {
                if (provider.storeInfo != null &&
                    provider.storeInfo.length > 0) {
                  return Container(
                    height: 400,
                    child: ListView.builder(
                      itemCount: provider.storeInfo.length,
                      itemBuilder: ((context, index) {
                        return Container(
                          child: Text(provider.storeInfo[index].storeAlias),
                        );
                      }),
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  init += 10;
                });
                _storeInfoProvider.loadStoreInfo(init, 10);
              },
              child: Text("테스트"),
            ),
          ],
        ),
      ),
    );
  }
}
