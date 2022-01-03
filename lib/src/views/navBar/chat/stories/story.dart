import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sellout_team/src/models/stories_model.dart';
import 'package:sellout_team/src/views/components/components.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/utils.dart';
import 'package:story_view/widgets/story_view.dart';

class Story extends StatefulWidget {
  late final StoriesModel storiesModel;

  Story(this.storiesModel);

  @override
  _StoryState createState() => _StoryState();
}

class _StoryState extends State<Story> {
  final StoryController controller = StoryController();
  List<StoryItem> storyItems = [];

  detectEx() {
    if (storyItems.length < widget.storiesModel.stories.length) {
      print('before ${storyItems.length}');
      for (String story in widget.storiesModel.stories) {
        for (String ex in widget.storiesModel.extensions) {
          if (ex == 'mp4') {
            if (storyItems.length < widget.storiesModel.stories.length) {
              storyItems
                  .add(StoryItem.pageVideo(story, controller: controller));
            }

            print('after adding videos ${storyItems.length}');
          } else {
            if (storyItems.length < widget.storiesModel.stories.length) {
              storyItems
                  .add(StoryItem.pageImage(url: story, controller: controller));
            }
            print('after adding images ${storyItems.length}');
          }
        }
        print('after ${storyItems.length}');
      }
    }
  }

  @override
  void initState() {
    detectEx();

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    detectEx();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(storyItems.length);

    return Scaffold(
      body: storyItems.length == widget.storiesModel.stories.length
          ? Stack(
              children: [
                StoryView(
                  storyItems: storyItems,
                  controller: controller,
                  onComplete: () {
                    Navigator.of(context).pop();
                  },
                  onVerticalSwipeComplete: (v) {
                    if (v == Direction.down) {
                      Navigator.pop(context);
                    }
                  },
                  onStoryShow: (storyItem) {},
                ),
                Positioned(
                  top: 50,
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundImage:
                          NetworkImage('${widget.storiesModel.userImage}'),
                    ),
                    title: Text(
                      '${widget.storiesModel.userName}',
                      style: Components.kBodyOne(context)
                          ?.copyWith(color: Colors.white),
                    ),
                    subtitle: Text(
                      '${DateFormat.jm().format(widget.storiesModel.date!.toDate())}',
                      style: Components.kCaption(context)
                          ?.copyWith(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            )
          : Container(),
    );
  }
}
