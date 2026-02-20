import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_experiment/features/blogs/data/models/blog_model.dart';
import 'package:flutter_experiment/features/blogs/presentation/bloc/blogs_bloc.dart';
import 'package:flutter_experiment/features/blogs/presentation/bloc/blogs_event.dart';
import 'package:flutter_experiment/features/blogs/presentation/bloc/blogs_state.dart';
import 'package:flutter_experiment/features/blogs/presentation/screens/blog_detail_screen.dart';
import 'package:image_picker/image_picker.dart';

class BlogsScreen extends StatefulWidget {
  const BlogsScreen({super.key});

  @override
  State<BlogsScreen> createState() => _BlogsScreenState();
}

class _BlogsScreenState extends State<BlogsScreen> {
  final ScrollController _scrollController = ScrollController();
  static const int _limit = 10;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BlogBloc>().add(FetchBlogsEvent(page: 1, limit: _limit));
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<BlogBloc>().add(LoadMoreBlogsEvent());
    }
  }

  void _gotoBlogDetailScreen(BlogModel blog) async {
    final blogBloc = context.read<BlogBloc>();

    final deleted = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: blogBloc,
          child: BlogDetailScreen(blog: blog),
        ),
      ),
    );

    if (deleted == true) {
      // Re-fetch blogs when a blog was deleted
      blogBloc.add(FetchBlogsEvent(page: 1, limit: _limit));
    }
  }

  void _openCreateBlogModal() {
    final blogBloc = context.read<BlogBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) =>
          BlocProvider.value(value: blogBloc, child: const _CreateBlogModal()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blogs"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _openCreateBlogModal,
          ),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogCreateSuccess) {
            Navigator.pop(context); // close modal
            context.read<BlogBloc>().add(
              FetchBlogsEvent(page: 1, limit: _limit),
            );
          }

          if (state is BlogCreateFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is BlogError) {
            return Center(child: Text(state.message));
          }

          if (state is BlogLoaded || state is BlogCreating) {
            final loadedState = state is BlogLoaded ? state : null;

            final blogs = loadedState?.blogs ?? [];

            return Stack(
              children: [
                ListView.builder(
                  controller: _scrollController,
                  itemCount: blogs.length + 1,
                  itemBuilder: (context, index) {
                    if (index < blogs.length) {
                      final blog = blogs[index];
                      return ListTile(
                        onTap: () {
                          _gotoBlogDetailScreen(blog);
                        },
                        title: Text(blog.title),
                        subtitle: Text(blog.content),
                      );
                    }

                    if (loadedState?.isLoadingMore == true) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    return const SizedBox();
                  },
                ),
                if (state is BlogCreating)
                  const Center(child: CircularProgressIndicator()),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}

class _CreateBlogModal extends StatefulWidget {
  const _CreateBlogModal();

  @override
  State<_CreateBlogModal> createState() => _CreateBlogModalState();
}

class _CreateBlogModalState extends State<_CreateBlogModal> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  File? _selectedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  void _submit() {
    context.read<BlogBloc>().add(
      CreateBlogEvent(
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        imagePath: _selectedImage?.path,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Create Blog", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: "Content"),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            if (_selectedImage != null)
              Image.file(_selectedImage!, height: 120),
            TextButton(
              onPressed: _pickImage,
              child: const Text("Upload Image"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _submit, child: const Text("Create")),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
