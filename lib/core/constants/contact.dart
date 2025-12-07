
final List<Contact> masterContactList = <Contact>[
  Contact(contactFirstName: 'Chai Talks', ),
  Contact(contactFirstName: 'Chai Talks', ),
  Contact(contactFirstName: 'Knitting Away my lifeaasasasaasa', ),
];

class Contact {
  String contactFirstName;

  bool favourite;
  final List<String> tags;
  Contact({
    required this.contactFirstName,

    this.favourite = false,
    List<String>? tags,     
  }) : tags = tags ?? const ['Tea', 'Tea', 'Friends']; 
}