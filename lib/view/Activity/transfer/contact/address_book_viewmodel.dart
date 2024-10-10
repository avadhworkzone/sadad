import 'package:contacts_service/contacts_service.dart';
import 'package:get/get.dart';

class AddressBookViewModel extends GetxController {
  List<Contact> mobileFilterList = [];
  String _selectedString = "";

  String get selectedString => _selectedString;

  set selectedString(String value) {
    _selectedString = value;
    update();
  }

  set initSelectedString(String value) {
    _selectedString = value;
  }

  void addSearchMobileResult(Contact contact) {
    mobileFilterList.add(contact);
    update();
  }

  bool _isSearch = false;

  bool get isSearch => _isSearch;

  void setIsSearch(bool value) {
    _isSearch = value;
    update();
  }

  bool _isContactLoading = true;

  bool get isContactLoading => _isContactLoading;

  set isContactLoading(bool value) {
    _isContactLoading = value;
    update();
  }

  List<Contact> _contactList = [];

  List<Contact> get contactList => _contactList;

  set contactList(List<Contact> value) {
    _contactList = value;
    // update();
  }

  List<Contact> pageNationContactList = [];
  bool isContactFirstLoading = true, _isContactMoreLoading = false;
  get isContactMoreLoading => _isContactMoreLoading;

  Future<void> pagenationGetContactList({
    bool? initLoad = true,
  }) async {
    if (pageNationContactList.isNotEmpty) {
      _isContactMoreLoading = true;
    }
    if (initLoad == true) {
      update();
    }

    _isContactLoading = true;
    _contactList = await ContactsService.getContacts(
        withThumbnails: false,
        photoHighResolution: false,
        iOSLocalizedLabels: false,
        androidLocalizedLabels: false);
    _contactList;

    pageNationContactList.addAll(contactList);
    _isContactMoreLoading = false;
    isContactFirstLoading = false;

    update();
  }
}
