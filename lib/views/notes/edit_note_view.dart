import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mynotes/services/crud/notes_service.dart';

class EditNoteView extends StatefulWidget {
  final int noteId;

  const EditNoteView({
    super.key,
    required this.noteId,
  });

  @override
  State<EditNoteView> createState() => _EditNoteViewState();
}

class _EditNoteViewState extends State<EditNoteView> {
  late final NotesService _notesService;
  late final TextEditingController _textController;
  DatabaseNote? _note;
  bool _isLoading = true;
  Timer? _saveDebounce;

  @override
  void initState() {
    super.initState();
    _notesService = NotesService();
    _textController = TextEditingController();
    _loadNote();
  }

  Future<void> _loadNote() async {
    final note = await _notesService.getNote(id: widget.noteId);

    if (!mounted) return;

    setState(() {
      _note = note;
      _textController.text = note.text;
      _isLoading = false;
    });

    _textController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    _saveDebounce?.cancel();
    _saveDebounce = Timer(const Duration(milliseconds: 500), () {
      unawaited(_saveCurrentText());
    });
  }

  Future<void> _saveCurrentText() async {
    final note = _note;
    if (note == null) return;

    await _notesService.updateNote(
      note: note,
      text: _textController.text,
    );
  }

  Future<void> _saveNote() async {
    _saveDebounce?.cancel();
    await _saveCurrentText();

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _saveDebounce?.cancel();
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Note'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: TextField(
        controller: _textController,
        autofocus: true,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        decoration: const InputDecoration(
          hintText: 'Write your note',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
        ),
      ),
    );
  }
}