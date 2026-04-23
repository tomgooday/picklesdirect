import 'package:equatable/equatable.dart';

/// Authenticated vendor user entity.
final class User extends Equatable {
  const User({
    required this.id,
    required this.email,
    required this.displayName,
    required this.status,
    this.businessName,
    this.abn,
    this.phone,
    this.tcVersionAccepted,
    this.privacyVersionAccepted,
  });

  final String id;
  final String email;
  final String displayName;
  final UserStatus status;
  final String? businessName;
  final String? abn;
  final String? phone;
  final String? tcVersionAccepted;
  final String? privacyVersionAccepted;

  bool get isActive => status == UserStatus.active;
  bool get hasAcceptedCurrentTc => tcVersionAccepted != null;
  bool get hasAcceptedPrivacy => privacyVersionAccepted != null;

  @override
  List<Object?> get props => [
        id,
        email,
        displayName,
        status,
        businessName,
        abn,
        tcVersionAccepted,
        privacyVersionAccepted,
      ];
}

enum UserStatus {
  active,
  pendingApproval,
  suspended,
  closed;

  static UserStatus fromString(String value) => switch (value.toLowerCase()) {
        'active' => UserStatus.active,
        'pending_approval' || 'pending' => UserStatus.pendingApproval,
        'suspended' => UserStatus.suspended,
        'closed' => UserStatus.closed,
        _ => UserStatus.pendingApproval,
      };
}
