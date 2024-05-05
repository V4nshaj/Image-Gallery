import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_gallery/Util/debounce.dart';
import 'package:image_gallery/constant/pixa_api.dart';
import 'package:image_gallery/model/photo_model.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:image_gallery/constant/columns_caln.dart';

class ImageScreen extends StatefulWidget {
  static const String id = 'image_screen';

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  TextEditingController _controller = TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool _showSpinner = true; // Flag to control spinner visibility
  String query = '';
  List<PhotoModel> imageList = [];
  late Debouncer _debouncer;
  int pageNumber = 1;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(handleControllerChange);

    DataHelper.fetchData(pageNumber).then((value) => setState(() {
          imageList.addAll(value);
          _showSpinner = false;
        }));

    _debouncer = Debouncer(milliseconds: 400);
  }

  handleControllerChange() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      setState(() {
        _showSpinner = true;
      });
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        DataHelper.fetchData(++pageNumber).then((value) => setState(() {
              imageList.addAll(value);
              _showSpinner = false;
            }));
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollController.removeListener(handleControllerChange);
    super.dispose();
  }

  void _searchQuery(String val) {
    _debouncer.run(() {
      setState(() {
        query = val;
      });
    });
  }

  void _handleTap(int index, PhotoModel photo) {
    Navigator.push(
        context,
        PageRouteBuilder(
            opaque: false,
            barrierDismissible: false,
            pageBuilder: (context, _, __) {
              return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        color:
                            Colors.black.withOpacity(0.7), // Background overlay
                        child: Hero(
                          tag: photo.id,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              image: DecorationImage(
                                image: NetworkImage(photo.imageUrl),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    )
                  ],
                ),
              );
            }));
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final int columns = calculateColumns(screenWidth);

    return Scaffold(
      // Use Scaffold for top-level layout
      appBar: AppBar(
        title: Center(
          child: SizedBox(
            width: screenWidth / 2,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 2), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      // Perform search action
                      _searchQuery(_controller.text);
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onChanged: _searchQuery,
                      decoration: InputDecoration(
                        hintText: 'Search on Gallery',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      _controller.clear();
                      _searchQuery('');
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Builder(builder: (context) {
          var list = query.isNotEmpty
              ? imageList.where((element) {
                  var l1 = element.tags.map((e) => e.trim().toLowerCase());
                  for (var res in l1) {
                    if (res.contains(query.trim().toLowerCase())) {
                      return true;
                    }
                  }
                  return false;
                }).toList()
              : imageList;
          return MasonryGridView.builder(
            controller: _scrollController,
            itemCount: list.length,
            itemBuilder: (context, index) {
              var item = list[index];
              return GestureDetector(
                onTap: () => _handleTap(index, item),
                child: Container(
                  height: MediaQuery.of(context).size.height / 3,
                  width: MediaQuery.of(context).size.width / columns,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 5.8,
                            blurStyle: BlurStyle.outer)
                      ]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Hero(
                          tag: item.id,
                          child: Image.network(
                            item.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.thumb_up_rounded)),
                          Text(
                            '${item.likes}',
                            // '5',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: screenWidth / 90,
                            ),
                          ),
                          SizedBox(
                            width: screenWidth / 10,
                          ),
                          Text(
                            '${item.views} views',
                            // ' views',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: screenWidth / 90,
                            ),
                          ),
                        ],
                      ),
                      Center(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: item.tags
                                  .map((e) => Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 3.0, vertical: 4.0),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 6.0, vertical: 8.0),
                                        decoration: BoxDecoration(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            borderRadius:
                                                BorderRadius.circular(7.0)),
                                        child: Text(
                                          e,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: screenWidth / 90,
                                          ),
                                        ),
                                      ))
                                  .toList()),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns, // Number of columns
            ),
            crossAxisSpacing: 20.0, // Spacing between columns
            mainAxisSpacing: 20.0, // Spacing between rows
          );
        }),
      ),
    );
  }
}
