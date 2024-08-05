import 'package:desafio/pages/check/check_page.dart';
import 'package:desafio/pages/feed/feed_page.dart';
import 'package:desafio/pages/map/map_page.dart';
import 'package:desafio/pages/post/post_create_page.dart';
import 'package:desafio/pages/settings/settings_page.dart';
import 'package:desafio/utils/my_colors.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;
  late PageController pc;

  @override
  void initState() {
    super.initState();
    pc = PageController(initialPage: currentPage);
  }

  setCurrentPage(page) {
    setState(() {
      currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Vigilância comunitária"),
        leadingWidth: 100,
        backgroundColor: MyColors.primaryColor,
        automaticallyImplyLeading: false,
      ),
      body: PageView(
        controller: pc,
        onPageChanged: setCurrentPage,
        children: const [
          FeedPage(),
          CheckPage(),
          MapPage(),
          SettingsPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: MyColors.primaryColor,
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.check),
              label: 'Check',
              backgroundColor: MyColors.primaryColor),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
              backgroundColor: MyColors.primaryColor)
        ],
        onTap: (page) {
          pc.animateToPage(page,
              duration: const Duration(milliseconds: 400), curve: Curves.ease);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const PostCreatePage()));
        },
        tooltip: "New complaint",
        backgroundColor: MyColors.secondaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
