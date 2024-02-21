import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pet_adoption_app/models/pet.dart';

class CustomCart {
  Widget cartWidget({required Pet pet, required String user}) {
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
                  imageUrl: pet.imageUrl ?? '',
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
                'Name: ${pet.name}',
                style: const TextStyle(fontFamily: 'AppFont'),
              ),
              Text(
                'Type: ${pet.type}',
                style: const TextStyle(fontFamily: 'AppFont'),
              ),
              Text(
                'Subtype: ${pet.subType}',
                style: const TextStyle(fontFamily: 'AppFont'),
              ),
              Text(
                'Age: ${pet.age}',
                style: const TextStyle(fontFamily: 'AppFont'),
              ),
              Text(
                'Height: ${pet.height}',
                style: const TextStyle(fontFamily: 'AppFont'),
              ),
              Text(
                'Gender: ${pet.gender}',
                style: const TextStyle(fontFamily: 'AppFont'),
              ),
              Center(
                child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(atc),
                    ),
                    child: const Text(
                      'Connect',
                      style:
                          TextStyle(fontFamily: 'AppFont', color: Colors.black),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
