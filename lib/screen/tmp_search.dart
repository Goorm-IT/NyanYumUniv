import 'package:deanora/provider/naver_search_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TmpSearch extends StatefulWidget {
  const TmpSearch({Key? key}) : super(key: key);

  @override
  State<TmpSearch> createState() => _TmpSearchState();
}

class _TmpSearchState extends State<TmpSearch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<NaverSearchProvider>(
          builder: (consumerContext, provider, consumerWidget) {
        print(provider.searchList.length);
        return Container(
            height: 600,
            child: ListView.builder(
                itemCount: provider.searchList.length,
                itemBuilder: (BuildContext classContext, int index) {
                  return Text('${provider.searchList[index].title}');
                }));
      }),
    );
  }
}
