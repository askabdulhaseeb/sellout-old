import 'package:flutter/material.dart';

class Explore extends StatefulWidget {
  const Explore({Key? key}) : super(key: key);

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  List<String> categoryList = ["Beauty", "Fashion", "Furniture", "Electronics"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 60,
              child: ListView.builder(
                itemCount: categoryList.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, position) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            border: Border.all(color: Colors.grey.shade200),
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        child: Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 16.0),
                            child: Text(categoryList[position]),
                          ),
                        )),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: GridView.count(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
                padding: const EdgeInsets.all(4.0),
                mainAxisSpacing: 6.0,
                crossAxisSpacing: 6.0,
                children: <String>[
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQGtMS8U8FE19OdVF-lU6RPbdIfEv1Zukv-AQ&usqp=CAU',
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrozxW434AQ6DhDHKcRdjQB3CkiuYNuT792Q&usqp=CAU',
                  'https://media.nojoto.com/content/media/604490/2019/07/feed/13afd0ff73e9911f6a1f4fba637ba37d/13afd0ff73e9911f6a1f4fba637ba37d_default.jpg',
                ].map((String url) {
                  return GridTile(
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              child: Image.network(url, fit: BoxFit.cover))));
                }).toList()),
          ),
        ],
      ),
    );
  }
}
