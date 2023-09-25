import 'dart:io';

import 'package:flutter/material.dart';


class ImageCard extends StatelessWidget{
  final String authorName;
  final String imageUrl;
  //final List<WebImage> webimages will replace final String imageUrl

//change the requirements to take List<WebImage> this.webimages
  const ImageCard({super.key, required this.authorName,required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Colors.deepPurple,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Flex(
          direction: Axis.vertical,
          children: [ 
            Text(authorName,
                textAlign: TextAlign.center,
                ),
                Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     //use Image.asset to take the image from a list of WebImages???
                    Image.network(imageUrl)
                    ],
          ),
          ),
          ],
        ),
      )
    );
  }
}
  