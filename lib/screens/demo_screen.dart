import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:kalahok_app/helpers/variables.dart';
import 'package:video_player/video_player.dart';

class DemoScreen extends StatefulWidget {
  const DemoScreen({Key? key,}) : super(key: key);

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  late VideoPlayerController _controller;
  late ChewieController _chewieController;
  late Future<void> _future;

  @override
  void initState() {
    _controller = VideoPlayerController.asset(AppConfig.demoVideo);
    _future = initVideoPlayer();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  Future<void> initVideoPlayer() async {
    await _controller.initialize();
    setState(() {
      _chewieController = ChewieController(
        videoPlayerController: _controller,
        aspectRatio: _controller.value.aspectRatio,
        autoPlay: true,
        looping: true,
        placeholder: _buildPlaceholderImage()
      );
    });
  }

  Widget _buildPlaceholderImage() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColor.linearGradient,
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildChewieImage() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColor.linearGradient,
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
      child: Center(
        child: Chewie(controller: _chewieController,),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Toolkit Demo")),
        body: FutureBuilder(
          future: _future,
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting) return _buildPlaceholderImage();
            return _buildChewieImage();
          },
        )
    );
  }
}
