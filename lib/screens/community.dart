import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';

class CommunityPage extends StatefulWidget {
  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final List<Post> _posts = [
    Post(
      username: "John Doe",
      experience: "Great experience with the new medication. It really helped with my symptoms!",
      imagePath: 'assets/med1.jpeg',
    ),
    Post(
      username: "Jane Smith",
      experience: "Had some side effects, but overall it worked well.",
      imagePath: 'assets/uncle.jpeg',
    ),
    Post(
      username: "Alice Johnson",
      experience: "Not satisfied with the treatment, didn't see much improvement.",
    ),
  ];

  final TextEditingController _postController = TextEditingController();
  File? _imageFile;

  // Color scheme
  final primaryColor = const Color(0xFF4CAF50); // Green
  final backgroundColor = Colors.white;
  final secondaryColor = const Color(0xFF1A237E); // Dark Blue

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Image Source'),
          actions: [
            TextButton(
              child: Text('Camera'),
              onPressed: () async {
                image = await _picker.pickImage(source: ImageSource.camera);
                Navigator.of(context).pop();
                _handleImagePick(image);
              },
            ),
            TextButton(
              child: Text('Gallery'),
              onPressed: () async {
                image = await _picker.pickImage(source: ImageSource.gallery);
                Navigator.of(context).pop();
                _handleImagePick(image);
              },
            ),
          ],
        );
      },
    );
  }

  void _handleImagePick(XFile? image) {
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  void _addPost(String experience) {
    setState(() {
      _posts.insert(0, Post(username: "Aditya", experience: experience, imagePath: _imageFile?.path));
      _postController.clear();
      _imageFile = null;
    });
  }

  void _toggleLike(Post post
  
  
  ) {
    setState(() {
      post.isLiked = !post.isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Community Experience',
          style: GoogleFonts.ubuntu(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _posts.length,
                itemBuilder: (context, index) {
                  final post = _posts[index];
                  return _buildPostCard(post);
                },
              ),
            ),
            SizedBox(height: 16),
            _buildImagePreview(),
            _buildPostInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildPostCard(Post post) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  child: Text(post.username[0], style: TextStyle(color: Colors.white)),
                  backgroundColor: secondaryColor,
                ),
                SizedBox(width: 12),
                Text(
                  post.username,
                  style: GoogleFonts.ubuntu(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: secondaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              post.experience,
              style: GoogleFonts.ubuntu(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            if (post.imagePath != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _isAssetImage(post.imagePath!)
                      ? Image.asset(
                          post.imagePath!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 200,
                        )
                      : Image.file(
                          File(post.imagePath!),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 200,
                        ),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  icon: Icon(
                    post.isLiked ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
                    color: post.isLiked ? primaryColor : Colors.grey,
                  ),
                  label: Text(
                    post.isLiked ? 'Liked' : 'Like',
                    style: GoogleFonts.ubuntu(
                      color: post.isLiked ? primaryColor : Colors.grey,
                    ),
                  ),
                  onPressed: () => _toggleLike(post),
                ),
                TextButton.icon(
                  icon: Icon(Icons.comment_outlined, color: secondaryColor),
                  label: Text(
                    'Comment',
                    style: GoogleFonts.ubuntu(color: secondaryColor),
                  ),
                  onPressed: () {
                    // Implement comment functionality
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return _imageFile != null
        ? Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                _imageFile!,
                fit: BoxFit.cover,
                height: 150,
              ),
            ),
          )
        : Container();
  }

  Widget _buildPostInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _postController,
                decoration: InputDecoration(
                  hintText: 'Share your experience...',
                  border: InputBorder.none,
                  hintStyle: GoogleFonts.ubuntu(color: Colors.grey[500]),
                ),
                maxLines: 3,
              ),
            ),
            IconButton(
              icon: Icon(Icons.attach_file, color: secondaryColor),
              onPressed: _pickImage,
            ),
            IconButton(
              icon: Icon(Icons.send, color: primaryColor),
              onPressed: () {
                if (_postController.text.isNotEmpty) {
                  _addPost(_postController.text);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  bool _isAssetImage(String imagePath) {
    return !imagePath.startsWith('/'); // Assuming asset paths don't start with '/' and file paths do.
  }
}

class Post {
  String username;
  String experience;
  bool isLiked;
  String? imagePath;

  Post({
    required this.username,
    required this.experience,
    this.isLiked = false,
    this.imagePath,
  });
}
