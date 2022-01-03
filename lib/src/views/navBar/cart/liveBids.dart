import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellout_team/src/blocs/live/live_cubit/live_cubit.dart';
import 'package:sellout_team/src/blocs/live/live_states/live_states.dart';
import 'package:sellout_team/src/constants/constants.dart';
import 'package:sellout_team/src/models/getliveBid.dart';
import 'package:sellout_team/src/views/components/components.dart';
import 'package:http/http.dart' as http;

class LiveBid extends StatefulWidget {
  const LiveBid({Key? key}) : super(key: key);

  @override
  _LiveBidState createState() => _LiveBidState();
}

class _LiveBidState extends State<LiveBid> {
  bool isLoading = true;

  List<GetLiveBidData> liveBidDataList = [];

  getLiveBids() async {
    var url = baseURL + kGetLiveBids;

    try {
      String username = 'kamleshRahul';
      String password = 'paramSoft@123';

      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$password'));
      final response = await http.post(Uri.parse(url), body: {
        "UserId": kUserModel!.id.toString()
      }, headers: {
        'authorization': basicAuth,
        'Accept': 'application/json',
        "Authorization": "Basic a2FtbGVzaFJhaHVsOnBhcmFtU29mdEAxMjM=",
        "X-API-KEY": "708ea968-1013-4828-a2b2-b010f08205d5"
      });
      final responseData = json.decode(response.body);

      if (responseData["status"] == false) {
        setState(() {
          isLoading = false;
        });
        throw HttpException(responseData["message"]);
      } else {
        GetLiveBidModel getLiveBidModel =
            new GetLiveBidModel.fromJson(responseData);
        setState(() {
          isLoading = false;
          liveBidDataList = getLiveBidModel.data!;
        });
      }
    } catch (error) {}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLiveBids();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LiveCubit, LiveStates>(listener: (context, state) {
      if (state is LiveLoadingState) {}
      if (state is LiveSuccessState) {
        // setState(() {
        //   isLoading = false;
        // });
        // Components.navigateTo(context,
        //     LiveBidScreen(channelName: state.channelName,
        //       userName: kUserModel!.name.toString(),
        //       isBroadcaster: true,
        //       liveBidId: state.id,
        //       bidName: bidNameController.text.toString(),));

      }
      if (state is LiveFailure) {
        print(state.error);
        Components.kSnackBar(context, '${state.error}');
      }
    }, builder: (context, state) {
      var cubit = LiveCubit.get(context);
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              // Text(
              //   "Suggested",
              //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // SizedBox(
              //   height: 90,
              //   child: ListView.builder(
              //     itemCount: livePersonName.length,
              //     shrinkWrap: true,
              //     scrollDirection: Axis.horizontal,
              //     itemBuilder: (context, position) {
              //       return Row(
              //         children: [
              //           SizedBox(
              //             height: 90,
              //             width: 90,
              //             child: CircleAvatar(
              //               backgroundColor: Colors.red.shade800,
              //               child: Padding(
              //                 padding: const EdgeInsets.all(2.0),
              //                 child: ClipRRect(
              //                   borderRadius:
              //                       BorderRadius.all(Radius.circular(100)),
              //                   child: Image.network(livePersonImage[position],
              //                       height: 90, width: 90, fit: BoxFit.cover),
              //                 ),
              //               ),
              //             ),
              //           ),
              //           SizedBox(
              //             width: 10,
              //           )
              //         ],
              //       );
              //     },
              //   ),
              // ),
              // SizedBox(
              //   height: 30,
              // ),
              isLoading == true
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : liveBidDataList.length == 0
                      ? Center(
                          child: Text("No data found"),
                        )
                      : ListView.builder(
                          itemCount: liveBidDataList.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, position) {
                            GetLiveBidData getLiveBidData =
                                liveBidDataList[position];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 90,
                                    width: 90,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.red.shade800,
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(100)),
                                          child: Image.network(
                                              getLiveBidData.userImage
                                                  .toString(),
                                              height: 90,
                                              width: 90,
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        getLiveBidData.userName.toString(),
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        color: Colors.red.shade800,
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Text(
                                            "Live",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                        ),
            ],
          ),
        ),
      );
    });
  }
}
