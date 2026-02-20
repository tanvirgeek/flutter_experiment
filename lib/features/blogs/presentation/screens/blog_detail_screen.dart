import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_experiment/core/Theme/theme_text_extension.dart';
import 'package:flutter_experiment/core/network/dio_interceptor.dart';
import 'package:flutter_experiment/features/blogs/data/models/blog_model.dart';
import 'package:flutter_experiment/features/blogs/presentation/bloc/blogs_bloc.dart';
import 'package:flutter_experiment/features/blogs/presentation/bloc/blogs_event.dart';
import 'package:flutter_experiment/features/blogs/presentation/bloc/blogs_state.dart';

class BlogDetailScreen extends StatelessWidget {
  final BlogModel blog;

  const BlogDetailScreen({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BlogBloc, BlogState>(
      listener: (context, state) {
        if (state is BlogDeleteSuccess) {
          Navigator.pop(context, true);
        }

        if (state is BlogDeleteFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        final isLoading = state is BlogLoading;

        return Scaffold(
          appBar: AppBar(
            title: const Text("Blog Details"),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: isLoading
                    ? null
                    : () {
                        context.read<BlogBloc>().add(
                          DeleteBlogEvent(id: blog.id),
                        );
                      },
              ),
            ],
          ),
          body: Stack(
            children: [
              SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.network(
                          DioSingleton.baseUrl + blog.imageUrl,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              blog.title,
                              style: context.headlineMediumOnSurface(),
                            ),
                            const SizedBox(height: 12),
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

              // Loading Overlay
              if (isLoading) const Center(child: CircularProgressIndicator()),
            ],
          ),
        );
      },
    );
  }
}
