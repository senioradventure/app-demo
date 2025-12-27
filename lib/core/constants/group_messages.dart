final List<Map<String, dynamic>> groupMessages = [
  {
    "id": "1",
    "senderId": "alice-id",
    "senderName": "Alice",
    "avatar": "https://i.pravatar.cc/150?img=1",
    "text": "Hello everyone!",
    "time": "10:00 AM",
    "replies": [
      {
        "id": "1-1",
        "senderId": "santra-id",
        "senderName": "Santra",
        "avatar": "...",
        "text": "Good morning!",
        "time": "10:05 AM",
        "replies": [],
        "reactions": {},
      },
    ],
    "reactions": {
      "👍": ["me-id", "bob-id"],
      "❤️": ["me-id", "alice-id"],
      "😂": ["bob-id"],
    },
  },
  {
    "id": "2",
    "senderId": "me-id",
    "senderName": "You",
    "avatar": "...",
    "text": "Hi Alice!",
    "time": "10:02 AM",
    "replies": [],
    "reactions": {
      "😂": ["alice-id"],
    },
  },
  {
    "id": "3",
    "senderId": "santra-id",
    "senderName": "Santra",
    "avatar": "...",
    "text": "Good morning!",
    "time": "10:05 AM",
    "replies": [],
    "reactions": {},
  },
];
