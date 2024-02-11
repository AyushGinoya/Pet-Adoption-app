import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomCart {
  Widget cartWidget(String name, int age, int height, String gender,
      String imageUrl, String type, String subType, String user) {
    Color buyc = const Color(0xFFFF9800);
    Color atc = const Color(0xFF4CAF50);

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
              Text(
                'Owner: $user',
                style: const TextStyle(fontFamily: 'AppFont'),
              ),
              Text(
                'Name: $name',
                style: const TextStyle(fontFamily: 'AppFont'),
              ),
              Text(
                'Type: $type',
                style: const TextStyle(fontFamily: 'AppFont'),
              ),
              Text(
                'Subtype: $subType',
                style: const TextStyle(fontFamily: 'AppFont'),
              ),
              Text(
                'Age: $age',
                style: const TextStyle(fontFamily: 'AppFont'),
              ),
              Text(
                'Height: $height',
                style: const TextStyle(fontFamily: 'AppFont'),
              ),
              Text(
                'Gender: $gender',
                style: const TextStyle(fontFamily: 'AppFont'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(buyc),
                      ),
                      child: const Text(
                        'Buy',
                        style: TextStyle(
                            fontFamily: 'AppFont', color: Colors.black),
                      )),
                  ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(atc),
                      ),
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
