import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Shared [FlutterSecureStorage] configuration for every datasource that
/// persists sensitive data.
///
/// Nothing stored through it needs to survive a restore onto another device,
/// and it is only ever read in the foreground, so the strictest
/// non-biometric Keychain accessibility applies on iOS/macOS.
const FlutterSecureStorage hardenedSecureStorage = FlutterSecureStorage(
  iOptions: IOSOptions(
    accessibility: KeychainAccessibility.unlocked_this_device,
  ),
);
