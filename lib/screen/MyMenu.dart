import 'package:deanora/Widgets/LoginDataCtrl.dart';
import 'package:deanora/object/lecture.dart';
import 'package:deanora/object/user.dart';
import 'package:deanora/screen/nyanScreen/nyanMainScreen/myClass.dart';
import 'package:deanora/screen/nyanScreen/nyanSubScreen/Tutorial.dart';
import 'package:deanora/http/yumServer/yumHttp.dart';
import 'package:deanora/http/crawl/crawl.dart';
import 'package:deanora/http/crawl/customException.dart';
import 'package:deanora/main.dart';
import 'package:deanora/screen/MyKakaoLogin.dart';
import 'package:deanora/screen/MyYumMain.dart';
import 'package:deanora/screen/MyYumNickRegist.dart';
import 'package:deanora/screen/nyanScreen/nyanMainScreen/MyLogin.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:page_transition/page_transition.dart';
import 'tabs_page.dart';

class MyMenu extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  const MyMenu({required this.analytics, required this.observer, Key? key})
      : super(key: key);

  @override
  _MyMenuState createState() => _MyMenuState();
}

class _MyMenuState extends State<MyMenu> {
  // late FirebaseMessaging messaging;

  String _message = '';

  void setMessage(String message) {
    setState(() {
      _message = message;
    });
  }

  NyanUser userInfo = NyanUser('', '');
  List<Lecture> classesInfo = [];
  String saved_id = "", saved_pw = "";
  @override
  void initState() {
    super.initState();
  }

  Future<void> _sendAnalyticsEvent() async {
    await widget.analytics.logEvent(
      name: 'test_event',
      parameters: <String, dynamic>{
        'string': 'string',
        'int': 42,
        'long': 12345678910,
        'double': 42.0,
        // Only strings and numbers (ints & doubles) are supported for GA custom event parameters:
        // https://developers.google.com/analytics/devguides/collection/analyticsjs/custom-dims-mets#overview
        'bool': true.toString(),
        'items': [itemCreator()]
      },
    );
    setMessage('logEvent succeeded');
  }

  Future<void> _testSetUserId() async {
    await widget.analytics.setUserId(id: 'some-user');
    setMessage('setUserId succeeded');
  }

  Future<void> _testSetCurrentScreen() async {
    await widget.analytics.setCurrentScreen(
      screenName: 'Analytics Demo',
      screenClassOverride: 'AnalyticsDemo',
    );
    setMessage('setCurrentScreen succeeded');
  }

  Future<void> _testSetAnalyticsCollectionEnabled() async {
    await widget.analytics.setAnalyticsCollectionEnabled(false);
    await widget.analytics.setAnalyticsCollectionEnabled(true);
    setMessage('setAnalyticsCollectionEnabled succeeded');
  }

  Future<void> _testSetSessionTimeoutDuration() async {
    await widget.analytics
        .setSessionTimeoutDuration(const Duration(milliseconds: 20000));
    setMessage('setSessionTimeoutDuration succeeded');
  }

  Future<void> _testSetUserProperty() async {
    await widget.analytics.setUserProperty(name: 'regular', value: 'indeed');
    setMessage('setUserProperty succeeded');
  }

  AnalyticsEventItem itemCreator() {
    return AnalyticsEventItem(
      affiliation: 'affil',
      coupon: 'coup',
      creativeName: 'creativeName',
      creativeSlot: 'creativeSlot',
      discount: 2.22,
      index: 3,
      itemBrand: 'itemBrand',
      itemCategory: 'itemCategory',
      itemCategory2: 'itemCategory2',
      itemCategory3: 'itemCategory3',
      itemCategory4: 'itemCategory4',
      itemCategory5: 'itemCategory5',
      itemId: 'itemId',
      itemListId: 'itemListId',
      itemListName: 'itemListName',
      itemName: 'itemName',
      itemVariant: 'itemVariant',
      locationId: 'locationId',
      price: 9.99,
      currency: 'USD',
      promotionId: 'promotionId',
      promotionName: 'promotionName',
      quantity: 1,
    );
  }

  Future<void> _testAllEventTypes() async {
    await widget.analytics.logAddPaymentInfo();
    await widget.analytics.logAddToCart(
      currency: 'USD',
      value: 123,
      items: [itemCreator(), itemCreator()],
    );
    await widget.analytics.logAddToWishlist();
    await widget.analytics.logAppOpen();
    await widget.analytics.logBeginCheckout(
      value: 123,
      currency: 'USD',
      items: [itemCreator(), itemCreator()],
    );
    await widget.analytics.logCampaignDetails(
      source: 'source',
      medium: 'medium',
      campaign: 'campaign',
      term: 'term',
      content: 'content',
      aclid: 'aclid',
      cp1: 'cp1',
    );
    await widget.analytics.logEarnVirtualCurrency(
      virtualCurrencyName: 'bitcoin',
      value: 345.66,
    );

    await widget.analytics.logGenerateLead(
      currency: 'USD',
      value: 123.45,
    );
    await widget.analytics.logJoinGroup(
      groupId: 'test group id',
    );
    await widget.analytics.logLevelUp(
      level: 5,
      character: 'witch doctor',
    );
    await widget.analytics.logLogin(loginMethod: 'login');
    await widget.analytics.logPostScore(
      score: 1000000,
      level: 70,
      character: 'tiefling cleric',
    );
    await widget.analytics
        .logPurchase(currency: 'USD', transactionId: 'transaction-id');
    await widget.analytics.logSearch(
      searchTerm: 'hotel',
      numberOfNights: 2,
      numberOfRooms: 1,
      numberOfPassengers: 3,
      origin: 'test origin',
      destination: 'test destination',
      startDate: '2015-09-14',
      endDate: '2015-09-16',
      travelClass: 'test travel class',
    );
    await widget.analytics.logSelectContent(
      contentType: 'test content type',
      itemId: 'test item id',
    );
    await widget.analytics.logSelectPromotion(
      creativeName: 'promotion name',
      creativeSlot: 'promotion slot',
      items: [itemCreator()],
      locationId: 'United States',
    );
    await widget.analytics.logSelectItem(
      items: [itemCreator(), itemCreator()],
      itemListName: 't-shirt',
      itemListId: '1234',
    );
    await widget.analytics.logScreenView(
      screenName: 'tabs-page',
    );
    await widget.analytics.logViewCart(
      currency: 'USD',
      value: 123,
      items: [itemCreator(), itemCreator()],
    );
    await widget.analytics.logShare(
      contentType: 'test content type',
      itemId: 'test item id',
      method: 'facebook',
    );
    await widget.analytics.logSignUp(
      signUpMethod: 'test sign up method',
    );
    await widget.analytics.logSpendVirtualCurrency(
      itemName: 'test item name',
      virtualCurrencyName: 'bitcoin',
      value: 34,
    );
    await widget.analytics.logViewPromotion(
      creativeName: 'promotion name',
      creativeSlot: 'promotion slot',
      items: [itemCreator()],
      locationId: 'United States',
      promotionId: '1234',
      promotionName: 'big sale',
    );
    await widget.analytics.logRefund(
      currency: 'USD',
      value: 123,
      items: [itemCreator(), itemCreator()],
    );
    await widget.analytics.logTutorialBegin();
    await widget.analytics.logTutorialComplete();
    await widget.analytics.logUnlockAchievement(id: 'all Firebase API covered');
    await widget.analytics.logViewItem(
      currency: 'usd',
      value: 1000,
      items: [itemCreator()],
    );
    await widget.analytics.logViewItemList(
      itemListId: 't-shirt-4321',
      itemListName: 'green t-shirt',
      items: [itemCreator()],
    );
    await widget.analytics.logViewSearchResults(
      searchTerm: 'test search term',
    );
    setMessage('All standard events logged successfully');
  }

  Widget build(BuildContext context) {
    var windowHeight = MediaQuery.of(context).size.height;
    var windowWidth = MediaQuery.of(context).size.width;

    Widget contentsMenu(_ontapcontroller, image, title, descrition) {
      return InkWell(
        onTap: () async {
          await _ontapcontroller();
        },
        child: Center(
          child: Container(
            width: windowWidth - 60,
            child: Column(
              children: [
                Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      child: Image.asset('assets/images/$image.png'),
                    )),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30))),
                    child: Container(
                      padding: EdgeInsets.only(left: 20, top: 15, bottom: 14),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              title,
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                            Text(descrition, style: TextStyle(fontSize: 13))
                          ]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return MaterialApp(
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<TabsPage>(
                settings: const RouteSettings(name: TabsPage.routeName),
                builder: (BuildContext context) {
                  return TabsPage(widget.observer);
                },
              ),
            );
          },
          child: const Icon(Icons.tab),
        ),
        resizeToAvoidBottomInset: false,
        body: Container(
          // color: Colors.black,
          child: SafeArea(
              bottom: false,
              child: Container(
                margin: EdgeInsets.only(top: 30, left: 30, right: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          MaterialButton(
                            onPressed: _sendAnalyticsEvent,
                            child: const Text('Test logEvent'),
                          ),
                          MaterialButton(
                            onPressed: _testAllEventTypes,
                            child: const Text('Test standard event types'),
                          ),
                          MaterialButton(
                            onPressed: _testSetUserId,
                            child: const Text('Test setUserId'),
                          ),
                          MaterialButton(
                            onPressed: _testSetCurrentScreen,
                            child: const Text('Test setCurrentScreen'),
                          ),
                          MaterialButton(
                            onPressed: _testSetAnalyticsCollectionEnabled,
                            child: const Text(
                                'Test setAnalyticsCollectionEnabled'),
                          ),
                          MaterialButton(
                            onPressed: _testSetSessionTimeoutDuration,
                            child: const Text('Test setSessionTimeoutDuration'),
                          ),
                          MaterialButton(
                            onPressed: _testSetUserProperty,
                            child: const Text('Test setUserProperty'),
                          ),
                          Text(
                            _message,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 0, 155, 0)),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text("냥냠대 컨텐츠",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25)),
                          SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          contentsMenu(nyanLogintest, "nyanTitle", "냥대 - 내 강의실",
                              "각 과목의 과제 정보와 학사 일정을 확인"),
                          SizedBox(
                            height: 30,
                          ),
                          contentsMenu(isYumLogin, "yumTitle", "냠대 - 맛집 정보",
                              "안양대생만의 숨은 꿀 맛집 정보를 공유"),
                          SizedBox(
                            height: 18,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  nyanLogintest() async {
    var ctrl = new LoginDataCtrl();
    var assurance = await ctrl.loadLoginData();
    saved_id = assurance["user_id"] ?? "";
    saved_pw = assurance["user_pw"] ?? "";
    Crawl.id = saved_id;
    Crawl.pw = saved_pw;
    var crawl = new Crawl();
    try {
      try {
        userInfo = GetIt.I<NyanUser>(instanceName: "userInfo");
        classesInfo = GetIt.I<List<Lecture>>(instanceName: "classesInfo");
        print(userInfo);
      } catch (e) {
        await crawl.crawlUser();
        await crawl.crawlClasses();
        userInfo = GetIt.I<NyanUser>(instanceName: "userInfo");
        classesInfo = GetIt.I<List<Lecture>>(instanceName: "classesInfo");
      }
      Navigator.push(
          context,
          PageTransition(
            duration: Duration(milliseconds: 250),
            type: PageTransitionType.fade,
            child: MyClass(
              saved_id,
              saved_pw,
            ),
          ));
    } on CustomException {
      Navigator.push(
        context,
        PageTransition(
          duration: Duration(milliseconds: 800),
          type: PageTransitionType.fade,
          alignment: Alignment.topCenter,
          child: isviewed != 0 ? Tutorial() : MyLogin(),
        ),
      );
    }
  }

  isYumLogin() async {
    if (await AuthApi.instance.hasToken()) {
      print("여기는 바로 가능");
      try {
        // await UserApi.instance.loginWithKakaoAccount();
        print('카카오계정으로 로그인 성공');
        User _user = await UserApi.instance.me();
        String _email =
            _user.kakaoAccount!.profile?.toJson()['nickname'].toString() ?? "";
        var yumHttp = new YumUserHttp(_email);
        var yumLogin = await yumHttp.yumLogin();
        if (yumLogin == 200) {
          //로그인 성공
          var yumInfo = await yumHttp.yumInfo();
          print(yumInfo);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MyYumMain(yumInfo[0]["nickName"], _email)),
          );
        } else if (yumLogin == 400) {
          // 로그인 실패, 회원가입 으로
          print("닉네임 설정 해야함 토큰은 있음");
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => MyYumNickRegist(_email)));
        } else {
          // 기타 에러
          print(yumLogin);
        }
      } catch (e) {
        if (e is KakaoException && e.isInvalidTokenError()) {
          print('토큰 만료 $e');
        } else {
          print('토큰 정보 조회 실패 $e');
        }
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MyKakaoLogin()));
      }
    } else {
      print("토큰 없음");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyKakaoLogin()));
    }
  }
}



    // messaging = FirebaseMessaging.instance;
    // messaging.getToken().then((value) {
    //   print(value);
    // });
    // FirebaseMessaging.onMessage.listen((RemoteMessage event) {
    //   print("message recieved");
    //   print(event.notification!.body);
    //   showDialog(
    //       context: context,
    //       builder: (context) {
    //         return AlertDialog(
    //           contentPadding:
    //               const EdgeInsets.symmetric(vertical: 24, horizontal: 40),
    //           buttonPadding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
    //           shape: RoundedRectangleBorder(
    //               borderRadius: BorderRadius.all(Radius.circular(18))),
    //           title: Center(
    //               child: Text(
    //             event.notification!.title!,
    //             style: TextStyle(fontWeight: FontWeight.w900),
    //           )),
    //           content: Container(
    //               child: Text(
    //             event.notification!.body!,
    //             textAlign: TextAlign.center,
    //           )),
    //           actions: [
    //             Container(
    //               alignment: Alignment.center,
    //               decoration: BoxDecoration(
    //                   border: Border(
    //                       top: BorderSide(
    //                           color: Color(0xffd2d2d5), width: 1.0))),
    //               child: TextButton(
    //                   onPressed: () {
    //                     Navigator.of(context).pop();
    //                   },
    //                   child: Container(
    //                     child: Text(
    //                       "확인",
    //                       style: TextStyle(color: Color(0xff755FE7)),
    //                     ),
    //                   )),
    //             )
    //           ],
    //         );
    // });
    // });
    // FirebaseMessaging.onMessageOpenedApp.listen((message) {
    //   print('Message clicked!');
    // });