enum ProfileVisibility {
  public,
  private,
}

extension ProfileVisibilityX on ProfileVisibility {
  String get label {
    switch (this) {
      case ProfileVisibility.public:
        return 'Public';
      case ProfileVisibility.private:
        return 'Private';
    }
  }
}
