import 'dart:async';

import 'package:deanora/model/yum_store_list_composition.dart';
import 'package:flutter/material.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';

class NaverMapInDetail extends StatefulWidget {
  final StoreComposition storeInfo;
  const NaverMapInDetail({required this.storeInfo, Key? key}) : super(key: key);

  @override
  State<NaverMapInDetail> createState() => _NaverMapInDetailState();
}

class _NaverMapInDetailState extends State<NaverMapInDetail> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Completer<NaverMapController> _controller = Completer();

  void _onMapCreated(NaverMapController controller) {
    if (_controller.isCompleted) _controller = Completer();
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      child: Container(
        height: 150,
        width: MediaQuery.of(context).size.width,
        child: NaverMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: LatLng(37.394614, 126.923451),
            zoom: 17,
          ),
          markers: [
            Marker(
                captionText: widget.storeInfo.storeAlias,
                captionOffset: -45,
                width: 23,
                height: 30,
                markerId: widget.storeInfo.storeAlias,
                position: LatLng(37.394614, 126.923451))
          ],
        ),
      ),
    );
  }
}
