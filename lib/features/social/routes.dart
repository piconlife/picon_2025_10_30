import 'package:flutter/material.dart';
import 'package:flutter_app_navigator/app_navigator.dart';

import '../../routes/paths.dart';
import 'view/pages/create_a_memory.dart';
import 'view/pages/create_a_note.dart';
import 'view/pages/create_a_story.dart';
import 'view/pages/create_a_video.dart';
import 'view/pages/search_feed.dart';

Map<String, RouteBuilder> get mSocialRoutes {
  return {
    Routes.createAMemory: _createAMemory,
    Routes.createANote: _createANote,
    Routes.createAStory: _createAStory,
    Routes.createAVideo: _createAVideo,
    Routes.searchFeeds: _searchFeeds,
  };
}

Widget _createAMemory(BuildContext context, Object? args) {
  return const CreateAMemoryPage();
}

Widget _createANote(BuildContext context, Object? args) {
  return const CreateANotePage();
}

Widget _createAStory(BuildContext context, Object? args) {
  return const CreateAStoryPage();
}

Widget _createAVideo(BuildContext context, Object? args) {
  return const CreateAVideoPage();
}

Widget _searchFeeds(BuildContext context, Object? args) {
  return const SearchFeedsPage();
}
