import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_app/constant.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';

class AdminPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AdminPageState();
  }
}

class AdminPageState extends State<AdminPage> {
  final ImagePicker picker = ImagePicker();
  final TextEditingController publicationTitleController =
      TextEditingController();
  final TextEditingController publicationCoverImageController =
      TextEditingController();
  final TextEditingController publicationContentController =
      TextEditingController();
  final TextEditingController doctorNameController = TextEditingController();
  final TextEditingController doctorEmailController = TextEditingController();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  File? _selectedImage;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Admin Page"),
          bottom: TabBar(
            tabs: [
              Tab(text: "Publications"),
              Tab(text: "Doctors"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildPublicationsTab(),
            _buildDoctorsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorsTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Add New Doctor",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: d.pSH(10),
                ),
                // Add Doctor Form
                TextFormField(
                  controller: doctorNameController,
                  decoration: InputDecoration(labelText: "Name"),
                ),
                SizedBox(
                  height: d.pSH(10),
                ),
                //
                TextFormField(
                  controller: doctorEmailController,
                  decoration: InputDecoration(labelText: "Email"),
                ),
                SizedBox(
                  height: d.pSH(10),
                ),
                //
                ElevatedButton(
                  onPressed: () {
                    // Add doctor to Firestore
                    firestore.collection("doctors").add({
                      "name": doctorNameController.text,
                      "email": doctorEmailController.text,
                    });

                    // Clear the form
                    doctorNameController.clear();
                    doctorEmailController.clear();
                  },
                  child: Text("Add Doctor"),
                ),
                SizedBox(
                  height: d.pSH(20),
                ),
                Text(
                  "Doctors",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: d.pSH(10),
                ),
                //
                // List of Doctors
                StreamBuilder<QuerySnapshot>(
                  stream: firestore.collection("doctors").snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }
                    final doctors = snapshot.data!.docs;
                    List<Widget> doctorWidgets = [];
                    for (var doctor in doctors) {
                      final name = doctor['name'];
                      final email = doctor['email'];
                      final doctorCard = Card(
                        child: ListTile(
                          title: Text(name),
                          subtitle: Text(email),
                        ),
                      );
                      doctorWidgets.add(doctorCard);
                    }
                    return Column(children: doctorWidgets);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPublicationsTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "New Publication",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Show previous publications
                        // You can implement this functionality as needed
                      },
                      child: Text("View Previous"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_selectedImage == null) {
                          // Handle the case where no image is selected
                          return;
                        }

                        // Upload the selected image to Firebase Storage
                        final storageRef = firebase_storage
                            .FirebaseStorage.instance
                            .ref()
                            .child(
                                'publications/${DateTime.now().millisecondsSinceEpoch}.jpg');

                        await storageRef.putFile(_selectedImage!);

                        // Get the download URL of the uploaded image
                        final String imageUrl =
                            await storageRef.getDownloadURL();

                        // Add publication to Firestore with the image URL
                        firestore.collection("publications").add({
                          "title": publicationTitleController.text,
                          "coverImage": imageUrl, // Use the image URL here
                          "content": publicationContentController.text,
                        });

                        // Clear the form and selected image
                        publicationTitleController.clear();
                        publicationContentController.clear();
                        setState(() {
                          _selectedImage = null;
                        });
                      },
                      child: Text("Publish"),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    // Open the image picker to select an image
                    final pickedFile =
                        await picker.pickImage(source: ImageSource.gallery);

                    if (pickedFile != null) {
                      setState(() {
                        _selectedImage = File(pickedFile.path);
                      });
                    }
                  },
                  child: Text("Select Image from Gallery"),
                ),
                SizedBox(height: 16.0),
                Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: _selectedImage != null
                      ? Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                        )
                      : Center(
                          child: Text("Select Publication Cover Photo"),
                        ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: publicationTitleController,
                  decoration: InputDecoration(labelText: "Title"),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: publicationContentController,
                  decoration: InputDecoration(
                    labelText: "Content",
                    hintText: "Add your content here...",
                    alignLabelWithHint: true,
                  ),
                  maxLines: 6,
                ),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Old Publications",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: firestore.collection("publications").snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }
                    final publications = snapshot.data!.docs;
                    List<Widget> publicationWidgets = [];
                    for (var publication in publications) {
                      final title = publication['title'];
                      final coverImage = publication['coverImage'];
                      final publicationCard = Card(
                        child: ListTile(
                          leading: Image.network(
                            coverImage,
                            width: 80.0,
                            height: 80.0,
                            fit: BoxFit.cover,
                          ),
                          title: Text(title),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              // Delete the publication
                              firestore
                                  .collection("publications")
                                  .doc(publication.id)
                                  .delete();
                            },
                          ),
                        ),
                      );
                      publicationWidgets.add(publicationCard);
                    }
                    return Column(children: publicationWidgets);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
