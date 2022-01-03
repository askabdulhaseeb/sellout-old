import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:sellout_team/src/blocs/live/live_cubit/live_cubit.dart';
import 'package:sellout_team/src/blocs/live/live_states/live_states.dart';
import 'package:sellout_team/src/constants/constants.dart';
import 'package:sellout_team/src/views/components/components.dart';
import 'package:sellout_team/src/views/liveBid/liveBidScreen.dart';
import 'package:sellout_team/src/views/widgets/auth/default_button_widget.dart';
import 'package:sellout_team/src/views/widgets/auth/text_form_field_widget.dart';

class CreateLiveBid extends StatefulWidget {
  const CreateLiveBid({Key? key}) : super(key: key);

  @override
  _CreateLiveBidState createState() => _CreateLiveBidState();
}

class _CreateLiveBidState extends State<CreateLiveBid> {
  final bidNameController = TextEditingController();
  final itemDescriptionController = TextEditingController();
  final startingPriceController = TextEditingController();

  int _stackIndex = 0;

  String _singleValue = "Text alignment right";
  String _verticalGroupValue = "Public";

  List<String> _status = ["Public", "Supporters", "Private"];

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LiveCubit, LiveStates>(listener: (context, state) {
      if (state is LiveLoadingState) {
        setState(() {
          isLoading = true;
        });
      }
      if (state is LiveSuccessState) {
        setState(() {
          isLoading = false;
        });
        Components.navigateTo(context,
            LiveBidScreen(channelName: state.channelName,
          userName: kUserModel!.name.toString(),
          isBroadcaster: true,
          liveBidId: state.id,
            bidName: bidNameController.text.toString(),));

      }
      if (state is LiveFailure) {
        print(state.error);
        Components.kSnackBar(context, '${state.error}');
      }

    }, builder: (context, state) {
    var cubit = LiveCubit.get(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Bid Name",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormFieldWidget(
                    controller: bidNameController,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Item Description",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormFieldWidget(
                    controller: itemDescriptionController,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Starting Price",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormFieldWidget(
                    controller: startingPriceController,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Privacy",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  RadioGroup<String>.builder(
                    direction: Axis.horizontal,
                    groupValue: _verticalGroupValue,
                    activeColor: Colors.red.shade800,
                    onChanged: (value) => setState(() {
                      _verticalGroupValue = value!;
                    }),
                    items: _status,
                    itemBuilder: (item) => RadioButtonBuilder(
                      item,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  isLoading == true? CircularProgressIndicator(): DefaultButtonWidget(
                    text: 'Live',
                    isTextWeightThick: false,
                    isSmallerHeight: true,
                    function: () {
                      cubit.createLiveBid(
                          itemDescriptionController.text.toString(),
                          bidNameController.text.toString(), startingPriceController.text.toString(),
                          _verticalGroupValue == "Public" ? "0" : _verticalGroupValue == "Supporters" ? "1" : "2");
                    },
                    color: kPrimaryColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    });
  }
}
