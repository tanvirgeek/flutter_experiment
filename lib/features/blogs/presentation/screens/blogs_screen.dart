import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_experiment/features/blogs/presentation/bloc/blogs_bloc.dart';
import 'package:flutter_experiment/features/blogs/presentation/bloc/blogs_event.dart';
import 'package:flutter_experiment/features/blogs/presentation/bloc/blogs_state.dart';

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

    context.read<BlogBloc>().add(FetchBlogsEvent(page: 1, limit: _limit));

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<BlogBloc>().add(LoadMoreBlogsEvent());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Blogs")),
      body: BlocBuilder<BlogBloc, BlogState>(
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is BlogError) {
            return Center(child: Text(state.message));
          }

          if (state is BlogLoaded) {
            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _scrollController,
              itemCount: state.blogs.length + 1,
              itemBuilder: (context, index) {
                if (index < state.blogs.length) {
                  final blog = state.blogs[index];
                  return ListTile(
                    title: Text(blog.title),
                    subtitle: Text(blog.content),
                  );
                }

                if (state.isLoadingMore) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                return const SizedBox();
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
