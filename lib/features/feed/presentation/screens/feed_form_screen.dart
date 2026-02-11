import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/feed_providers.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/constants/app_strings.dart';

class FeedFormScreen extends ConsumerStatefulWidget {
  final String? postId; // null for create, id for edit

  const FeedFormScreen({super.key, this.postId});

  @override
  ConsumerState<FeedFormScreen> createState() => _FeedFormScreenState();
}

class _FeedFormScreenState extends ConsumerState<FeedFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _imageUrlController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
    _imageUrlController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  bool get isEditing => widget.postId != null;

  @override
  Widget build(BuildContext context) {
    // If editing, load existing post
    if (isEditing) {
      final postQuery = ref.watch(postDetailProvider(widget.postId!));

      return postQuery.when(
        data: (post) {
          // Populate fields once
          if (_titleController.text.isEmpty) {
            _titleController.text = post.title;
            _contentController.text = post.content;
            _imageUrlController.text = post.imageUrl ?? '';
          }
          return _buildForm();
        },
        loading: () => const Scaffold(body: LoadingIndicator()),
        error: (error, stack) => Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: Center(child: Text('Error loading post: $error')),
        ),
      );
    }

    return _buildForm();
  }

  Widget _buildForm() {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Post' : 'New Post'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                controller: _titleController,
                label: 'Post Title',
                prefixIcon: Icons.title,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.fieldRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _contentController,
                label: 'Content',
                prefixIcon: Icons.article,
                maxLines: 10,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.fieldRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _imageUrlController,
                label: 'Image URL (optional)',
                prefixIcon: Icons.image,
              ),
              const SizedBox(height: 32),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : AppButton.primary(
                      onPressed: _savePost,
                      text: isEditing ? 'Update Post' : 'Publish Post',
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _savePost() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final data = {
      'title': _titleController.text,
      'content': _contentController.text,
      'imageUrl':
          _imageUrlController.text.isEmpty ? null : _imageUrlController.text,
    };

    try {
      if (isEditing) {
        final updateMutation =
            ref.read(updatePostProvider({'id': widget.postId!, ...data}));
        await updateMutation;
      } else {
        final createMutation = ref.read(createPostProvider(data));
        await createMutation;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(isEditing ? 'Post updated' : 'Post published')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
