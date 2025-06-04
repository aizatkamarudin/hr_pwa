import 'package:supabase_flutter/supabase_flutter.dart';

void saveNotes() async {
  await Supabase.instance.client.from('notes').insert([
    {
      'title': 'Note 1',
      'content': 'This is the content of note 1',
      'created_at': DateTime.now().toIso8601String(),
    },
    {
      'title': 'Note 2',
      'content': 'This is the content of note 2',
      'created_at': DateTime.now().toIso8601String(),
    },
  ]);
}

final _notesStream = Supabase.instance.client.from('notes').stream(primaryKey: ['id']).order('created_at', ascending: false);
