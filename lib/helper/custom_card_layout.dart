import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pet_adoption_app/models/pet_model.dart';

class CustomCart {
  Widget cartWidget({required Pet pet}) {

    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: pet.imageUrl ?? '',
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 4),
            Text(
              'Owner: ${pet.owner}',
              style: const TextStyle(
                  fontFamily: 'AppFont', fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Name: ${pet.name}',
              style: const TextStyle(fontFamily: 'AppFont'),
            ),
            const SizedBox(height: 4),
            Text(
              'Type: ${pet.type}',
              style: const TextStyle(fontFamily: 'AppFont'),
            ),
            const SizedBox(height: 4),
            Text(
              'Subtype: ${pet.subType}',
              style: const TextStyle(fontFamily: 'AppFont'),
            ),
            const SizedBox(height: 4),
            Text(
              'Age: ${pet.age}',
              style: const TextStyle(fontFamily: 'AppFont'),
            ),
            const SizedBox(height: 4),
            Text(
              'Height: ${pet.height}',
              style: const TextStyle(fontFamily: 'AppFont'),
            ),
            const SizedBox(height: 4),
            Text(
              'Gender: ${pet.gender}',
              style: const TextStyle(fontFamily: 'AppFont'),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
