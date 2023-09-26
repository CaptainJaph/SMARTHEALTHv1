import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../app_colors.dart';
import '../../constant.dart';

class Library extends StatefulWidget {
  const Library({super.key});

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  DateTime currentDate = DateTime.now();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool openCalendar = false;

  late TextEditingController searchController;

  @override
  void initState() {
    searchController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    d.init(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Library",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              height: d.pSH(1),
              color: AppColors.blackColorOne,
              fontSize: d.pSH(20)),
        ),

        // toolbarHeight: d.pSH(300),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                  color: AppColors.whiteColorOne,
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(d.pSH(5))),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: d.pSH(10), vertical: d.pSH(3)),
                    child: TextFormField(
                      controller: searchController,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          hintText: "Search",
                          border: InputBorder.none),
                    ),
                  )),
              SizedBox(
                height: d.pSH(20),
              ),
              Container(
                  padding: EdgeInsets.all(d.pSW(20)),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: firestore.collection("publications").snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      }
                      final publications = snapshot.data!.docs;

                      return GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200.0,
                          mainAxisSpacing: 10.0,
                          crossAxisSpacing: 10.0,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: publications.length,
                        itemBuilder: (BuildContext context, int index) {
                          final title = publications[index]['title'];
                          final coverImage = publications[index]['coverImage'];
                          final content = publications[index]['content'];
                          return LibraryItemCard(
                            title: title,
                            coverImage: coverImage,
                            content: content,
                          );
                        },
                      );
                    },
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class LibraryItemCard extends StatefulWidget {
  String title;
  String content;
  String coverImage;
  LibraryItemCard(
      {required this.title, required this.coverImage, required this.content});

  @override
  State<LibraryItemCard> createState() => _LibraryItemCardState();
}

class _LibraryItemCardState extends State<LibraryItemCard> {
  late PageController pageController;

  int _currentPage = 0;

  int totalPageNumber = 5;

  @override
  void initState() {
    // TODO: implement initState
    pageController = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return StatefulBuilder(builder: (context, setState) {
              return Container(
                height: d.getPhoneScreenHeight() * (5 / 6),
                padding: EdgeInsets.symmetric(
                    horizontal: d.pSH(10), vertical: d.pSW(15)),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: d.pSW(30),
                        height: d.pSH(2.5),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: AppColors.blackColorOne,
                            borderRadius: BorderRadius.circular(d.pSH(1))),
                        margin: EdgeInsets.only(right: d.pSW(0)),
                      ),
                    ),
                    SizedBox(
                      height: d.pSH(10),
                    ),
                    Center(
                      child: Text(
                        widget.title.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            height: d.pSH(1),
                            overflow: TextOverflow.ellipsis,
                            color: AppColors.blackColorOne,
                            fontSize: d.pSH(18)),
                      ),
                    ),
                    Expanded(
                        child: PageView.builder(
                      controller: pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: d.pSH(10)),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Text.rich(TextSpan(
                                    text: widget.content,
                                    style: TextStyle(
                                        fontSize: d.pSH(16),
                                        overflow: TextOverflow.ellipsis))),
                              ],
                            ),
                          ),
                        );
                      },
                    )),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: (d.getPhoneScreenWidth()) * (1 / 4),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              elevation: d.pSH(2),
                              backgroundColor: AppColors.greenColorOne,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(d.pSH(5))),
                              padding: EdgeInsets.all(d.pSH(0.5))),
                          child: Text(
                            "Read More",
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: d.pSH(15),
                                color: AppColors.whiteColorOne),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                            onPressed: () {
                              if (_currentPage != 0) {
                                setState(() {
                                  _currentPage--;
                                });
                              }
                              pageController.previousPage(
                                  duration: const Duration(microseconds: 600),
                                  curve: Curves.ease);
                            },
                            icon: const Icon(Icons.arrow_back_ios)),
                        Text(
                          "${_currentPage + 1}/$totalPageNumber",
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: d.pSH(15),
                              color: AppColors.blackColorOne),
                        ),
                        IconButton(
                            onPressed: () {
                              if (_currentPage != totalPageNumber - 1) {
                                setState(() {
                                  _currentPage++;
                                });
                              }
                              pageController.nextPage(
                                  duration: const Duration(microseconds: 600),
                                  curve: Curves.ease);
                            },
                            icon: const Icon(Icons.arrow_forward_ios))
                      ],
                    )
                  ],
                ),
              );
            });
          },
        );
      },
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(d.pSH(10))),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: AppColors.blackColorTwo,
              borderRadius: BorderRadius.circular(d.pSH(10))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                  radius: d.pSH(40),
                  backgroundImage: NetworkImage(widget.coverImage)),
              Text(widget.title),
            ],
          ),
        ),
      ),
    );
  }
}
