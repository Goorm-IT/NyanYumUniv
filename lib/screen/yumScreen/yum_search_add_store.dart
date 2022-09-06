import 'package:flutter/material.dart';

class YumSearchAddStore extends StatefulWidget {
  const YumSearchAddStore({Key? key}) : super(key: key);

  @override
  State<YumSearchAddStore> createState() => _YumSearchAddStoreState();
}

class _YumSearchAddStoreState extends State<YumSearchAddStore> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
                      onPressed: () {},
                      icon: Icon(
                        Icons.search,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
