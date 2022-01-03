import 'package:flutter/material.dart';
import 'package:sellout_team/src/views/navBar/cart/explore.dart';
import 'package:sellout_team/src/views/navBar/cart/liveBids.dart';

import 'createLiveBid.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Cart', style: TextStyle(color: Colors.white),),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.red.shade800,
            bottom: TabBar(
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              tabs: [
                Tab(icon: Icon(Icons.live_tv_sharp), text: "Live Bid",),
                Tab(icon: Icon(Icons.explore), text: "Explore",),
                Tab(icon: Icon(Icons.live_tv_outlined), text: "Go LIve"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              LiveBid(),
              Explore(),
              CreateLiveBid(),
            ],
          ),
        ),
      );
  }
}
