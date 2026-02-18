import 'package:flutter/material.dart';
import 'package:flutter_experiment/core/Theme/theme_text_extension.dart';
import 'package:flutter_experiment/core/network/dio_interceptor.dart';
import 'package:flutter_experiment/features/blogs/data/models/blog_model.dart';

class BlogDetailScreen extends StatelessWidget {
  final BlogModel blog;

  const BlogDetailScreen({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Blog Details")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Blog Image
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  DioSingleton.baseUrl +
                      blog.imageUrl, // make sure your model has imageUrl
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.broken_image, size: 50),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Content Padding
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(blog.title, style: context.headlineMediumOnSurface()),

                    const SizedBox(height: 12),

                    // Description
                    Text(
                      blog.content,
                      style: context.bodyMediumOnSurfaceVariant(),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
