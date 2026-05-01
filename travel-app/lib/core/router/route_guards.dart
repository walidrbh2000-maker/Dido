import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voyageur/providers/auth/auth_provider.dart';
import 'package:voyageur/providers/auth/auth_state.dart';

final authGuardProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState is AuthAuthenticated;
});
