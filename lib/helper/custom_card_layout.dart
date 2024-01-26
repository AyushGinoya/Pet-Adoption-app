import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomCart {
  Widget cartWidget(String name, int age, int height, String gender,
      String imageUrl, String user) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Text('Owner: $user'),
              Text('Name: $name'),
              Text('Age: $age'),
              Text('Height: $height'),
              Text('Gender: $gender'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      onPressed: () {},
                      child: const Text(
                        'Buy',
                        style: TextStyle(
                            fontFamily: 'AppFont', color: Colors.black),
                      )),
                  ElevatedButton(
                      onPressed: () {},
                      child: const Text(
                        'Add to cart',
                        style: TextStyle(
                            fontFamily: 'AppFont', color: Colors.black),
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
