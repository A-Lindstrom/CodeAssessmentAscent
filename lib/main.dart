import 'package:flutter/material.dart';
import 'package:flutter_app_gallery/models/webImageList.dart';
import 'package:flutter_app_gallery/models/webimage.dart';
import 'package:flutter_app_gallery/network/endpoints.dart';
import 'package:flutter_app_gallery/network/imageService.dart';
import 'package:flutter_app_gallery/widgets/imageCard.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'My Gallery App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  EndPoints endPoints = EndPoints();
  final http.Client _client = http.Client();
  final ScrollController _scrollController = ScrollController();
  double _scrollPosition = 0.0;
  Timer? _scrollTimer;

  @override
  void initState() {
    super.initState();

    _scrollTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _scrollPosition += 250.0; 
      _scrollController.animateTo(
        _scrollPosition,
        duration: const Duration(milliseconds: 900), 
        curve: Curves.ease,
      );
      if (_scrollPosition >= _scrollController.position.maxScrollExtent) {
        _scrollPosition = 0.0;
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollTimer?.cancel(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ImageWebService imageService = ImageWebService(_client);
    return FutureBuilder<WebImageList>(
      future: imageService.fetchWebImageList(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(
            color: Colors.green
          );
      } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
      } else {
          List<WebImage> images = snapshot.data?.getWebImages() ?? [];
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: Text(widget.title),
            ),
             body: Column (
              children: [
             SizedBox (
        height: 450,  
        child: ListView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          children:<Widget>[
              for(var image in images )
              SizedBox(
              width: 250,
              child: ImageCard(authorName: image.author, imageUrl:image.download_url),
              ),
              ],
          ),
        ),
        const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_back_ios_rounded),
                  Icon(Icons.arrow_forward_ios_rounded),
                ],
              ),
        ],
        ),
      );
    }
    }//Builder
    )
  );
  }
}