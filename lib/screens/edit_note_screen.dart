import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes/features/crud.dart';
import 'package:notes/features/toast.dart';

import '../features/image_process.dart';
import '../model/model.dart';

class EditNoteScreen extends StatefulWidget {
  final data;
  const EditNoteScreen({
    super.key,
    required this.data,
  });

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String? imageUrl;
  File? _imageFile;
  String storedUrl = "";

  bool _validate_title = false;
  bool _validate_description = false;
  bool _validate_image = false;
  bool flag = false;

  @override
  void dispose() {
    titleController.removeListener(() {});
    descriptionController.removeListener(() {});
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _logEditNotePageVisit();
    setState(() {
      titleController.text = widget.data['title'];
      descriptionController.text = widget.data['description'];
      imageUrl = widget.data['url'];
      storedUrl = widget.data['url'];
    });
    titleController.addListener(() {
      if (titleController.text.isNotEmpty) {
        setState(() {
          _validate_title = false;
        });
      }
    });
    descriptionController.addListener(() {
      if (descriptionController.text.isNotEmpty) {
        setState(() {
          _validate_description = false;
        });
      }
    });
    super.initState();
  }

  Future<void> _logEditNotePageVisit() async {
    await analytics.logEvent(name: 'Edit_note_page_visit', parameters: {
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.data['title']),
        backgroundColor: const Color.fromARGB(255, 117, 182, 214),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: titleController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                  hintText: 'Enter the title of the note',
                  errorText: _validate_title ? 'Title cannot be empty' : null,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: descriptionController,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                    labelText: 'Description',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                    hintText: 'Enter the description of the note',
                    errorText:
                        _validate_description ? 'Title cannot be empty' : null),
                maxLines: 5,
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: Icon(Icons.upload_file),
                label: Text("Upload image"),
              ),
              SizedBox(height: 20),
              _imageFile != null
                  ? Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: Image.file(
                        _imageFile!,
                        height: 200,
                      ))
                  : imageUrl != null
                      ? Image.network(
                          imageUrl!,
                          height: 200,
                        )
                      : Container(
                          height: 200,
                          color: Colors.grey[200],
                          child: Center(
                            child: Text('No image selected',
                                style: TextStyle(
                                    color: _validate_image
                                        ? Colors.red
                                        : Colors.black)),
                          ),
                        ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        titleController.text.isEmpty
                            ? _validate_title = true
                            : _validate_title = false;
                        descriptionController.text.isEmpty
                            ? _validate_description = true
                            : _validate_description = false;
                        _imageFile == null && imageUrl == null
                            ? _validate_image = true
                            : _validate_image = false;
                      });

                      if (!(_validate_title ||
                          _validate_description ||
                          _validate_image)) {
                        // Add update logic
                        String? url = imageUrl;
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        );
                        if (_imageFile != null) {
                          url = await replacneImage(imageUrl!, _imageFile!);
                          flag = true;
                        }
                        if (!flag) {
                          setState(() {
                            url = storedUrl;
                          });
                        }
                        final editNote = UserModel(
                          title: titleController.text,
                          description: descriptionController.text,
                          url: url,
                          id: widget.data['id'],
                        );
                        final DataService db = DataService();
                        setState(() {
                          db.updateData(editNote);
                          showCustomToast(context, "Successfully updated ",
                              editNote.title as String);
                          Navigator.pushNamedAndRemoveUntil(context, '/home',
                              (Route<dynamic> route) => false);
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 139, 224, 97),
                    ),
                    child: Text('Update'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 243, 224, 22),
                    ),
                    child: Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
