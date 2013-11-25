library contacts;
import 'package:dart_web_toolkit/ui.dart' as ui;

class Contact implements Comparable {
  String name;
  String phone;
  String e_mail;

  Contact(this.name, this.phone, this.e_mail);

  Contact.fromJson(Map<String, Object> contactMap) {
    name = contactMap['name'];
    phone = contactMap['phone'];
    e_mail = contactMap['e_mail'];
  }

  Map<String, Object> toJson() {
    var contactMap = new Map<String, Object>();
    contactMap['name'] = name;
    contactMap['phone'] = e_mail;
    contactMap['e_mail'] = e_mail;
    return contactMap;
  }

  String toString() {
    return '{name: ${name}, phone: ${phone}, e_mail: ${e_mail}}';
  }

  /**
   * Compares two contacts based on their names.
   * If the result is less than 0 then the first link is less than the second,
   * if it is equal to 0 they are equal and
   * if the result is greater than 0 then the first is greater than the second.
   */
  int compareTo(Contact contact) {
    if (name != null && contact.name != null) {
      return name.compareTo(contact.name);
    } else {
      throw new Exception('a contact name must be present');
    }
  }
}

class Contacts {
  var _list = new List<Contact>();

  Iterator<Contact> get iterator => _list.iterator;
  bool get isEmpty => _list.isEmpty;

  List<Contact> get internalList => _list;
  set internalList(List<Contact> observableList) => _list = observableList;

  bool add(Contact newContact) {
    if (newContact == null) {
      throw new Exception('a new conatct must be present');
    }
    for (Contact contact in this) {
      if (newContact.name == contact.name) return false;
    }
    _list.add(newContact);
    return true;
  }

  Contact find(String name) {
    for (Contact contact in _list) {
      if (contact.name == name) return contact;
    }
    return null;
  }

  bool remove(Contact contact) {
    return _list.remove(contact);
  }

  sort() {
    _list.sort();
  }
  
  int length() {
    return _list.length;
  }
  
}

class Links {
  var _list = new List<ui.Hyperlink>();

  Iterator<ui.Hyperlink> get iterator => _list.iterator;
  bool get isEmpty => _list.isEmpty;

  List<ui.Hyperlink> get internalList => _list;
  set internalList(List<ui.Hyperlink> observableList) => _list = observableList;

  bool add(ui.Hyperlink newLink) {
    if (newLink == null) {
      throw new Exception('a new link must be present');
    }
    for (ui.Hyperlink link in this) {
      if (newLink.text == link.text) return false;
    }
    _list.add(newLink);
    return true;
  }

  ui.Hyperlink find(String name) {
    for (ui.Hyperlink link in _list) {
      if (link.text == name) return link;
    }
    return null;
  }

  bool remove(ui.Hyperlink link) {
    return _list.remove(link);
  }

  sort() {
    _list.sort();
  }
  
  int length() {
    return _list.length;
  }
  
  clear() {
    return _list.clear();
  }
}

class Model {
  var contacts = new Contacts();

  // singleton design pattern: http://en.wikipedia.org/wiki/Singleton_pattern
  static Model model;
  Model.private();
  static Model get one {
    if (model == null) {
      model = new Model.private();
    }
    return model;
  }
  // singleton

  init() {
    Contact contact0 = new Contact('Marcelle Melone', '4182557152', 'marcelle@yahoo.fr');
    Contact contact1 = new Contact('Thierry Marc', '4182557153', 'thierry@yahoo.fr');
    Contact contact2 = new Contact('Franck Axel', '4182557154', 'franck@yahoo.fr');
    Model.one.contacts..add(contact0)..add(contact1)..add(contact2);
  }

  List<Map<String, Object>> toJson() {
    var contactList = new List<Map<String, Object>>();
    for (Contact contact in contacts) {
      contactList.add(contact.toJson());
    }
    return contactList;
  }

  fromJson(List<Map<String, Object>> contactList) {
    if (!contacts.isEmpty) {
      throw new Exception('contacts are not empty');
    }
    for (Map<String, Object> contactMap in contactList) {
      Contact contact = new Contact.fromJson(contactMap);
      contacts.add(contact);
    }
  }
}

