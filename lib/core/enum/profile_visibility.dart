enum ProfileVisibility {
  circleOnly,
  everyone,
  friendsOfFriends,
}

extension ProfileVisibilityX on ProfileVisibility {
  String get label {
    switch (this) {
      case ProfileVisibility.circleOnly:
        return 'Circle Only';
      case ProfileVisibility.everyone:
        return 'Everyone';
      case ProfileVisibility.friendsOfFriends:
        return 'Friends of Friends';
    }
  }

  String get supabaseValue {
    switch (this) {
      case ProfileVisibility.circleOnly:
        return 'circle_only';
      case ProfileVisibility.everyone:
        return 'everyone';
      case ProfileVisibility.friendsOfFriends:
        return 'friends_of_friends';
    }
  }
}

ProfileVisibility profileVisibilityFromDb(String? value) {
  switch (value) {
    case 'circle_only':
      return ProfileVisibility.circleOnly;
    case 'friends_of_friends':
      return ProfileVisibility.friendsOfFriends;
    case 'everyone':
    default:
      return ProfileVisibility.everyone;
  }
}

