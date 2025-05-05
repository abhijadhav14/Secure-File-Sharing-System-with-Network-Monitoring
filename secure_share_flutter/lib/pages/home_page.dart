import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../services/api_service.dart';
import 'login_page.dart'; // Replace with your actual login page file

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String message = '';
  List<String> uploadedFiles = [];

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  void _loadFiles() async {
    List<String> files = await ApiService.getFiles();
    setState(() {
      uploadedFiles = files;
    });
  }

  void _uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      bool success = await ApiService.uploadFile(file);

      setState(() {
        message = success ? '✅ Upload successful' : '❌ Upload failed';
      });

      _loadFiles(); // Refresh file list
    } else {
      setState(() {
        message = '⚠️ No file selected';
      });
    }
  }

  void _downloadFile(String filename) {
    ApiService.downloadFile(filename);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("📥 Opened download URL for $filename")),
    );
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Secure File Sharing'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _uploadFile,
              icon: Icon(Icons.cloud_upload),
              label: Text('Upload File'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
            SizedBox(height: 10),
            Text(
              message,
              style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Divider(),
            Text(
              '📁 Uploaded Files',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: uploadedFiles.isEmpty
                  ? Center(child: Text('simple.txt'))
                  : ListView.separated(
                      itemCount: uploadedFiles.length,
                      separatorBuilder: (_, __) => Divider(),
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Icon(Icons.insert_drive_file, color: Colors.deepPurple),
                          title: Text(uploadedFiles[index]),
                          trailing: IconButton(
                            icon: Icon(Icons.download_rounded),
                            onPressed: () => _downloadFile(uploadedFiles[index]),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
