enum ProfileVisibility {
  everyone,
  friendsOfFriends,
  circleOnly,
}

extension ProfileVisibilityX on ProfileVisibility {
  String get supabaseValue {
    switch (this) {
      case ProfileVisibility.everyone:
        return 'everyone';
      case ProfileVisibility.friendsOfFriends:
        return 'friends_of_friends';
      case ProfileVisibility.circleOnly:
        return 'circles_only';
    }
  }

  String get label {
    switch (this) {
      case ProfileVisibility.everyone:
        return 'Everyone';
      case ProfileVisibility.friendsOfFriends:
        return 'Friends of Friends';
      case ProfileVisibility.circleOnly:
        return 'Circles only';
    }
  }
}

ProfileVisibility profileVisibilityFromDb(String? value) {
  switch (value) {
    case 'circles_only':
      return ProfileVisibility.circleOnly;
    case 'friends_of_friends':
      return ProfileVisibility.friendsOfFriends;
    case 'everyone':
    default:
      return ProfileVisibility.everyone;
  }
}
