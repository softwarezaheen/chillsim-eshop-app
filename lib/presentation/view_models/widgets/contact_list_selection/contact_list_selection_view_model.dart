// import "package:esim_open_source/presentation/enums/view_state.dart";
// import "package:esim_open_source/presentation/views/base/main_base_model.dart";
// import "package:contacts_service/contacts_service.dart" as fc;
// import "package:flutter/material.dart";
//
// class ContactListSelectionViewModel extends MainBaseModel {
//   ContactListSelectionViewModel({
//     void Function({required String displayName, required String number})?
//         onContactPressed,
//   }) : _onContactPressed = onContactPressed;
//   final void Function({required String displayName, required String number})?
//       _onContactPressed;
//
//   final TextEditingController _searchController = TextEditingController();
//   TextEditingController get searchController => _searchController;
//
//   List<fc.Contact> _fullContactList = <fc.Contact>[];
//   List<fc.Contact> _filteredContactList = <fc.Contact>[];
//
//   List<fc.Contact> get filteredContactList => _filteredContactList;
//
//   void onModelReady(BuildContext context) {
//     setViewState(ViewState.busy);
//     // Future.delayed(const Duration(milliseconds: 2000), () {
//     //
//     // });
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       // _fullContactList = await contactService.getAllContacts(
//       //       context: context,
//       //     ) ??
//       //     <fc.Contact>[];
//       // _fullContactList = _fullContactList
//       //     .where((fc.Contact element) => element.phones?.isNotEmpty ?? false)
//       //     .toList();
//       // _filteredContactList = _fullContactList;
//       setViewState(ViewState.idle);
//     });
//   }
//
//   void validateAndProceed() {}
//
//   void onSearchTextChanged(String value) {
//     if (_searchController.text.isNotEmpty) {
//       String searchText = _searchController.text.trim().toLowerCase();
//
//       Iterable<fc.Contact> fullResult =
//           _fullContactList.where((fc.Contact element) {
//         // this.displayName,
//         // this.givenName,
//         // this.middleName,
//         // this.prefix,
//         // this.suffix,
//         // this.familyName,
//         // this.company,
//         // this.jobTitle,
//         // this.emails,
//         // this.phones,
//         // this.postalAddresses,
//         // this.avatar,
//         // this.birthday,
//         // this.androidAccountType,
//         // this.androidAccountTypeRaw,
//         // this.androidAccountName,
//         if ((element.displayName?.toLowerCase().contains(searchText) ??
//                 false) ||
//             (element.givenName?.toLowerCase().contains(searchText) ?? false) ||
//             (element.middleName?.toLowerCase().contains(searchText) ?? false) ||
//             (element.familyName?.toLowerCase().contains(searchText) ?? false) ||
//             (element.androidAccountName?.toLowerCase().contains(searchText) ??
//                 false)) {
//           return true;
//         }
//
//         List<fc.Item>? result = element.phones?.where((fc.Item element1) {
//           if (element1.value?.toUpperCase().contains(searchText) ?? false) {
//             return true;
//           }
//           return false;
//         }).toList();
//
//         if (result?.isNotEmpty ?? false) {
//           return true;
//         }
//
//         return false;
//       });
//
//       _filteredContactList = fullResult.toList();
//     } else {
//       _filteredContactList = _fullContactList;
//     }
//
//     notifyListeners();
//   }
//
//   void userNumberPressed(int index) {
//     fc.Contact selectedContact = _filteredContactList[index];
//     _onContactPressed?.call(
//       number: selectedContact.phones?.first.value ?? "",
//       displayName: selectedContact.displayName ?? "",
//     );
//   }
// }
