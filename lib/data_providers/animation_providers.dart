import 'package:flutter_riverpod/flutter_riverpod.dart';

final startProgressBarAnimation = StateProvider<bool>((ref) => false);

final finishedProgressBarAnimation = StateProvider<bool>((ref) => false);