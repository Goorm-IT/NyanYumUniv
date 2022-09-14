import 'package:deanora/Widgets/custom_loading_image.dart';
import 'package:deanora/http/yumServer/yumHttp.dart';
import 'package:deanora/model/review_by_store.dart';
import 'package:flutter/material.dart';

class YumMyReview extends StatefulWidget {
  YumMyReview({Key? key}) : super(key: key);

  @override
  State<YumMyReview> createState() => _YumMyReviewState();
}

class _YumMyReviewState extends State<YumMyReview> {
  @override
  Widget build(BuildContext context) {
    YumReviewhttp _yumReviewhttp = YumReviewhttp();
    return Scaffold(
      body: Container(
        child: FutureBuilder(
          future: _yumReviewhttp.reviewbyUser(),
          builder: (BuildContext futureContext,
              AsyncSnapshot<List<ReviewByStore>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: ((context, index) {
                  return Container(
                    child: Text(snapshot.data![index].content),
                  );
                }),
              );
            } else {
              return Container(
                child: Center(child: CustomLoadingImage()),
              );
            }
          },
        ),
      ),
    );
  }
}
