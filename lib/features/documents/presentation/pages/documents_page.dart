import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:crm_kurchudashboard/core/constants/app_colors.dart';
import 'package:crm_kurchudashboard/core/di/injection.dart';
import 'package:crm_kurchudashboard/features/documents/data/services/document_service.dart';
import 'package:crm_kurchudashboard/features/documents/data/models/document_model.dart';

class DocumentsPage extends StatefulWidget {
  const DocumentsPage({Key? key}) : super(key: key);

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  bool _isLoading = true;
  String? _error;
  List<DocumentModel> _documents = [];

  @override
  void initState() {
    super.initState();
    _loadDocuments();
  }

  Future<void> _loadDocuments() async {
    try {
      final docService = getIt<DocumentService>();
      final docs = await docService.getDocuments();
      if (!mounted) return;
      setState(() {
        _documents = docs;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteDocument(String id) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final docService = getIt<DocumentService>();
      final success = await docService.deleteDocument(id);
      if (success) {
        _loadDocuments();
      } else {
        setState(() {
          _isLoading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to delete document')),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  IconData _getIconForType(String type) {
    switch (type.toUpperCase()) {
      case 'PDF': return Iconsax.document;
      case 'ZIP': return Iconsax.folder_2;
      case 'IMAGE': return Iconsax.image;
      default: return Iconsax.document_text;
    }
  }

  Color _getColorForType(String type) {
    switch (type.toUpperCase()) {
      case 'PDF': return AppColors.error;
      case 'ZIP': return AppColors.iconOrange;
      case 'IMAGE': return AppColors.iconBlue;
      default: return AppColors.textSecondary;
    }
  }

  void _showAddDocumentDialog(BuildContext context) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) => const AddDocumentDialog(),
    );

    if (result != null && mounted) {
      setState(() {
        _isLoading = true;
      });
      try {
        final docService = getIt<DocumentService>();
        final newDoc = await docService.createDocument(result);
        if (newDoc != null) {
          _loadDocuments();
        } else {
          setState(() {
            _isLoading = false;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to add document')),
            );
          });
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Text('Error loading documents: $_error', style: const TextStyle(color: AppColors.error)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Documents',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Manage all uploaded files and customer attachments.',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => _showAddDocumentDialog(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.iconPurple,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: const [
                        Icon(Iconsax.document_upload, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text('Upload', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: _documents.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(48.0),
                      child: Center(
                        child: Text(
                          'No documents found. Click upload to add new files.',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _documents.length,
                      separatorBuilder: (context, index) => const Divider(color: AppColors.border, height: 1),
                      itemBuilder: (context, index) {
                        final document = _documents[index];
                        return ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              _getIconForType(document.type),
                              color: _getColorForType(document.type),
                            ),
                          ),
                          title: Text(
                            document.name,
                            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                          subtitle: Text(
                            document.size,
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                          ),
                          trailing: PopupMenuButton<String>(
                            icon: const Icon(Iconsax.more, color: AppColors.textSecondary),
                            onSelected: (val) {
                              if (val == 'delete') {
                                _deleteDocument(document.id);
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
                              ),
                            ],
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

class AddDocumentDialog extends StatefulWidget {
  const AddDocumentDialog({Key? key}) : super(key: key);

  @override
  State<AddDocumentDialog> createState() => _AddDocumentDialogState();
}

class _AddDocumentDialogState extends State<AddDocumentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _sizeController = TextEditingController(text: '1.2 MB');
  final _urlController = TextEditingController(text: 'https://kurchucrm.com/uploads/');

  String _selectedType = 'PDF';

  @override
  void dispose() {
    _nameController.dispose();
    _sizeController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: const Text('Upload Document', style: TextStyle(color: AppColors.textPrimary)),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Document Name',
                  labelStyle: TextStyle(color: AppColors.textSecondary),
                  border: OutlineInputBorder(),
                  hintText: 'e.g. Manali_Brochure.pdf',
                ),
                style: const TextStyle(color: AppColors.textPrimary),
                validator: (val) => val == null || val.isEmpty ? 'Please enter a name' : null,
              ),
              const SizedBox(height: 16),

              // File Size
              TextFormField(
                controller: _sizeController,
                decoration: const InputDecoration(
                  labelText: 'File Size',
                  labelStyle: TextStyle(color: AppColors.textSecondary),
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(color: AppColors.textPrimary),
                validator: (val) => val == null || val.isEmpty ? 'Please enter a size' : null,
              ),
              const SizedBox(height: 16),

              // Type Selector
              const Text('Document Type', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                dropdownColor: AppColors.surface,
                style: const TextStyle(color: AppColors.textPrimary),
                value: _selectedType,
                items: const [
                  DropdownMenuItem(value: 'PDF', child: Text('PDF Document')),
                  DropdownMenuItem(value: 'ZIP', child: Text('ZIP Folder')),
                  DropdownMenuItem(value: 'IMAGE', child: Text('Image file')),
                  DropdownMenuItem(value: 'OTHER', child: Text('Other file')),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedType = val;
                    });
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
              const SizedBox(height: 16),

              // URL Path
              TextFormField(
                controller: _urlController,
                decoration: const InputDecoration(
                  labelText: 'File URL / Path',
                  labelStyle: TextStyle(color: AppColors.textSecondary),
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(color: AppColors.textPrimary),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Please enter a URL';
                  if (!val.startsWith('http://') && !val.startsWith('https://')) {
                    return 'Please enter a valid HTTP/HTTPS URL';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.iconPurple),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context, {
                'name': _nameController.text.trim(),
                'size': _sizeController.text.trim(),
                'type': _selectedType,
                'url': _urlController.text.trim(),
              });
            }
          },
          child: const Text('Upload', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
