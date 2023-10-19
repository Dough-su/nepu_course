import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sliding_box/flutter_sliding_box.dart';



class qingjiapage extends StatelessWidget {
  const qingjiapage({super.key});

  static const ThemeMode themeMode = ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Flutter Sliding Box - Example App",
      theme: MyTheme.call(themeMode: themeMode),
      home: const SlidingBoxExamplePage(),
    );
  }
}

class SlidingBoxExamplePage extends StatefulWidget {
  const SlidingBoxExamplePage({super.key});

  @override
  State<SlidingBoxExamplePage> createState() => _SlidingBoxExamplePageState();
}

class _SlidingBoxExamplePageState extends State<SlidingBoxExamplePage> {
  final BoxController boxController = BoxController();
  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textEditingController.addListener(() {
      boxController.setSearchBody(
          child: Center(
            child: Text(
              textEditingController.text != ""
                  ? textEditingController.value.text
                  : "Empty",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground, fontSize: 20),
            ),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarIconBrightness:
      qingjiapage.themeMode == ThemeMode.light
          ? Brightness.dark
          : Brightness.light,
      systemNavigationBarColor: Theme.of(context).colorScheme.background,
    ));
    //
    double bottomNavigationBarHeight =
    (MediaQuery.of(context).viewInsets.bottom > 0) ? 0 : 50;
    double appBarHeight = MediaQuery.of(context).size.height * 0.1;
    if (appBarHeight < 95) appBarHeight = 95;
    double minHeightBox =
        MediaQuery.of(context).size.height * 0.3 - bottomNavigationBarHeight;
    double maxHeightBox = MediaQuery.of(context).size.height -
        appBarHeight -
        bottomNavigationBarHeight;
    //
    return Scaffold(
      body: SlidingBox(
        controller: boxController,
        minHeight: minHeightBox,
        maxHeight: maxHeightBox,
        color: Theme.of(context).colorScheme.background,
        style: BoxStyle.sheet,
        backdrop: Backdrop(
          fading: true,
          overlay: false,
          color: Theme.of(context).colorScheme.secondary,
          body: _backdrop(),
          appBar: BackdropAppBar(
              title: Container(
                margin: const EdgeInsets.only(left: 15),
                child: Text(
                  "App Name",
                  style: TextStyle(
                    fontSize: 22,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
              leading: Icon(
                Icons.menu,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 30,
              ),
              searchBox: SearchBox(
                controller: textEditingController,
                color: Theme.of(context).colorScheme.background,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 18),
                body: Center(
                  child: Text(
                    "Search Result",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 20),
                  ),
                ),
                draggableBody: true,
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: SizedBox.fromSize(
                    size: const Size.fromRadius(25),
                    child: IconButton(
                      iconSize: 27,
                      icon: Icon(
                        Icons.search_rounded,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      onPressed: () {
                        textEditingController.text = "";
                        boxController.showSearchBox();
                      },
                    ),
                  ),
                ),
              ]),
        ),
        bodyBuilder: (sc, pos) => _body(sc, pos),
        collapsedBody: _collapsedBody(),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.zero,
        height: bottomNavigationBarHeight,
        color: Theme.of(context).colorScheme.background,
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              border: Border(
                top: BorderSide(
                  width: 0.5,
                  color:
                  Theme.of(context).colorScheme.onBackground.withAlpha(100),
                ),
              )),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    CupertinoIcons.chat_bubble_text,
                    color: Theme.of(context).colorScheme.onBackground,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    CupertinoIcons.phone,
                    color: Theme.of(context).colorScheme.onBackground,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    CupertinoIcons.plus_app,
                    color: Theme.of(context).colorScheme.onBackground,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    CupertinoIcons.photo_camera,
                    color: Theme.of(context).colorScheme.onBackground,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    CupertinoIcons.profile_circled,
                    color: Theme.of(context).colorScheme.onBackground,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  _backdrop() {
    return Container(
      padding: const EdgeInsets.only(top: 60, bottom: 40),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          MaterialListItem(
              icon: const Icon(
                CupertinoIcons.house,
                size: 21,
                color: Color(0xffeeeeee),
              ),
              child: const Text(
                "Home",
                style: TextStyle(color: Color(0xffeeeeee), fontSize: 18),
              ),
              onPressed: () {}),
          MaterialListItem(
              icon: const Icon(
                Icons.person_outline,
                size: 26,
                color: Color(0xffeeeeee),
              ),
              child: const Text(
                "Contacts",
                style: TextStyle(color: Color(0xffeeeeee), fontSize: 18),
              ),
              onPressed: () {}),
          MaterialListItem(
              icon: const Icon(
                CupertinoIcons.camera,
                size: 22,
                color: Color(0xffeeeeee),
              ),
              child: const Text(
                "Camera",
                style: TextStyle(color: Color(0xffeeeeee), fontSize: 18),
              ),
              onPressed: () {}),
          MaterialListItem(
              icon: const Icon(
                Icons.image_outlined,
                size: 24,
                color: Color(0xffeeeeee),
              ),
              child: const Text(
                "Album",
                style: TextStyle(color: Color(0xffeeeeee), fontSize: 18),
              ),
              onPressed: () {}),
          MaterialListItem(
              icon: const Icon(
                Icons.person_add_alt_outlined,
                size: 25,
                color: Color(0xffeeeeee),
              ),
              child: const Text(
                "Invite Friends",
                style: TextStyle(color: Color(0xffeeeeee), fontSize: 18),
              ),
              onPressed: () {}),
          MaterialListItem(
              icon: const Icon(
                Icons.bookmark_border_rounded,
                size: 26,
                color: Color(0xffeeeeee),
              ),
              child: const Text(
                "Bookmarks",
                style: TextStyle(color: Color(0xffeeeeee), fontSize: 18),
              ),
              onPressed: () {}),
          MaterialListItem(
              icon: const Icon(
                Icons.alarm,
                size: 25,
                color: Color(0xffeeeeee),
              ),
              child: const Text(
                "Set Alarm",
                style: TextStyle(color: Color(0xffeeeeee), fontSize: 18),
              ),
              onPressed: () {}),
          MaterialListItem(
              icon: const Icon(
                CupertinoIcons.person_2,
                size: 25,
                color: Color(0xffeeeeee),
              ),
              child: const Text(
                "Add Group",
                style: TextStyle(color: Color(0xffeeeeee), fontSize: 18),
              ),
              onPressed: () {}),
          MaterialListItem(
              icon: const Icon(
                Icons.contacts_outlined,
                size: 25,
                color: Color(0xffeeeeee),
              ),
              child: const Text(
                "Contacts",
                style: TextStyle(color: Color(0xffeeeeee), fontSize: 18),
              ),
              onPressed: () {}),
          MaterialListItem(
              icon: const Icon(
                Icons.video_camera_front_outlined,
                size: 26,
                color: Color(0xffeeeeee),
              ),
              child: const Text(
                "Video Call",
                style: TextStyle(color: Color(0xffeeeeee), fontSize: 18),
              ),
              onPressed: () {}),
          MaterialListItem(
              icon: const Icon(
                Icons.add_location_alt_outlined,
                size: 25,
                color: Color(0xffeeeeee),
              ),
              child: const Text(
                "Add Location",
                style: TextStyle(color: Color(0xffeeeeee), fontSize: 18),
              ),
              onPressed: () {}),
          MaterialListItem(
              icon: const Icon(
                Icons.shopping_cart_outlined,
                size: 25,
                color: Color(0xffeeeeee),
              ),
              child: const Text(
                "Checkout Cart",
                style: TextStyle(color: Color(0xffeeeeee), fontSize: 18),
              ),
              onPressed: () {}),
          MaterialListItem(
              icon: const Icon(
                Icons.settings_outlined,
                size: 25,
                color: Color(0xffeeeeee),
              ),
              child: const Text(
                "Settings",
                style: TextStyle(color: Color(0xffeeeeee), fontSize: 18),
              ),
              onPressed: () {}),
          MaterialListItem(
              icon: const Icon(
                Icons.help_outline,
                size: 25,
                color: Color(0xffeeeeee),
              ),
              child: const Text(
                "Helps",
                style: TextStyle(color: Color(0xffeeeeee), fontSize: 18),
              ),
              onPressed: () {}),
        ],
      ),
    );
  }

  _body(ScrollController sc, double pos) {
    sc.addListener(() {
      print("scrollController position: ${sc.position.pixels}");
    });
    return const Column(
      children: [
        SizedBox(
          height: 10,
        ),
        MyListItem(),
        MyListItem(),
        MyListItem(),
        MyListItem(),
        MyListItem(),
        MyListItem(),
        MyListItem(),
        MyListItem(),
        MyListItem(),
        MyListItem(),
      ],
    );
  }

  _collapsedBody() {
    return Center(
      child: Text(
        "Collapsed Body",
        style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 25,
            color: Theme.of(context).colorScheme.onBackground),
      ),
    );
  }
}

class MyListItem extends StatelessWidget {
  const MyListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      height: 80,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onBackground.withAlpha(40),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onBackground.withAlpha(60),
              borderRadius: const BorderRadius.all(Radius.circular(60)),
            ),
          ),
          Expanded(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10, top: 5),
                    height: 20,
                    decoration: BoxDecoration(
                      color:
                      Theme.of(context).colorScheme.onBackground.withAlpha(60),
                      borderRadius: const BorderRadius.all(Radius.circular(7)),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10, top: 9),
                    height: 13,
                    decoration: BoxDecoration(
                      color:
                      Theme.of(context).colorScheme.onBackground.withAlpha(40),
                      borderRadius: const BorderRadius.all(Radius.circular(7)),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}

class MaterialListItem extends StatelessWidget {
  final Icon? icon;
  final Widget child;
  final VoidCallback onPressed;

  const MaterialListItem(
      {super.key, this.icon, required this.child, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    double iconSizeHeight = 50;
    return SizedBox(
      height: iconSizeHeight,
      child: MaterialButton(
        padding: const EdgeInsets.all(0),
        minWidth: MediaQuery.of(context).size.height,
        splashColor: Colors.white.withAlpha(150),
        highlightColor: Colors.white.withAlpha(150),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        onPressed: onPressed,
        child: Row(
          children: [
            if (icon != null)
              SizedBox(
                width: iconSizeHeight + 10,
                height: iconSizeHeight,
                child: icon,
              ),
            child,
          ],
        ),
      ),
    );
  }
}

class MyTheme {
  static call({required ThemeMode themeMode}) {
    if (themeMode == ThemeMode.light) {
      return ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          background: Color(0xFFFFFFFF),
          onBackground: Color(0xFF222222),
          primary: Color(0xff607D8B),
          onPrimary: Color(0xFFFFFFFF),
          secondary: Color(0xff607D8B),
          onSecondary: Color(0xFFFFFFFF),
          error: Color(0xFFFF5252),
          onError: Color(0xFFFFFFFF),
          surface: Color(0xff607D8B),
          onSurface: Color(0xFFFFFFFF),
        ),
      );
    } else {
      return ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          background: Color(0xFF222222),
          onBackground: Color(0xFFEEEEEE),
          primary: Color(0xff324148),
          onPrimary: Color(0xFFEEEEEE),
          secondary: Color(0xff41555e),
          onSecondary: Color(0xff324148),
          error: Color(0xFFFF5252),
          onError: Color(0xFFEEEEEE),
          surface: Color(0xff324148),
          onSurface: Color(0xFFEEEEEE),
        ),
      );
    }
  }
}