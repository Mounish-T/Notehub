import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class edit_note extends StatefulWidget {
  const edit_note(
      {super.key,
      required this.title,
      required this.description,
      // required this.image
      });
  final title, description;
  // final File image;

  @override
  State<edit_note> createState() => _edit_noteState();
}

class _edit_noteState extends State<edit_note> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  File? image;

  bool _validate_title = false;
  bool _validate_description = false;
  bool _validate_image = false;

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
    setState(() {
      titleController.text = widget.title;
      descriptionController.text = widget.description;
      // image = widget.image;
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

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
              image != null
                  ? Image.file(
                      image!,
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
                    onPressed: () {
                      setState(() {
                        titleController.text.isEmpty
                            ? _validate_title = true
                            : _validate_title = false;
                        descriptionController.text.isEmpty
                            ? _validate_description = true
                            : _validate_description = false;
                        image == null
                            ? _validate_image = true
                            : _validate_image = false;
                      });

                      if (_validate_title &&
                          _validate_description &&
                          _validate_image) {
                        print("Updated note");
                        // Add note logic
                      }
                    },
                    child: Text('Update'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 139, 224, 97),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 243, 224, 22),
                    ),
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
