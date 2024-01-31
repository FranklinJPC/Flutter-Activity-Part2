import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Place_Pages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ecuador Tourist Sites'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/fondo.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance
              .collection('lugares_turisticos')
              .get()
              .then((QuerySnapshot querySnapshot) {
            List<Map<String, dynamic>> places = [];
            querySnapshot.docs.forEach((doc) {
              places.add(doc.data() as Map<String, dynamic>);
            });
            return places;
          }),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Column(
                      children: [
                        TitleSection(
                          name: snapshot.data![index]['nombre_sitio'],
                        ),
                        ImagenSection(
                          image: snapshot.data![index]['imagen_sitio'],
                        ),
                        TextSection(
                          description: snapshot.data![index]
                              ['descripcion_sitio'],
                        ),
                      ],
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
class TitleSection extends StatelessWidget {
  TitleSection({
    super.key,
    required this.name,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            // 1
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 2
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  'Turismo Ecuador',
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TextSection extends StatelessWidget {
  const TextSection({
    super.key,
    required this.description,
  });

  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Text(
        description,
        softWrap: true,
      ),
    );
  }
}

class ImagenSection extends StatelessWidget {
  const ImagenSection({
    super.key,
    required this.image,
  });

  final String image;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      image,
      width: 600,
      height: 240,
      fit: BoxFit.cover,
    );
  }
}
