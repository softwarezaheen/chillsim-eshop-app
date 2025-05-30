// import "dart:async";
//
// import "package:esim_open_source/domain/repository/services/contact_provider.dart";
// import "package:contacts_service/contacts_service.dart" as fc;
// import "package:flutter/cupertino.dart";
// import "package:flutter_native_contact_picker/model/contact.dart";
// import "package:permission_handler/permission_handler.dart";
//
// class ContactServiceImpl implements ContactService {
//   ContactServiceImpl.privateConstructor();
//
//   static ContactServiceImpl? _instance;
//   List<fc.Contact>? _contactList;
//
//   static ContactServiceImpl get instance {
//     if (_instance == null) {
//       _instance = ContactServiceImpl.privateConstructor();
//       _instance?._initialise();
//     }
//     return _instance!;
//   }
//
//   void _initialise() {}
//
//   @override
//   Future<Contact?> pickNumber({
//     required BuildContext context,
//     bool forcePermission = true,
//   }) async {
//     return null;
//
//     // final FlutterContactPicker contactPicker = FlutterContactPicker();
//     //
//     // PermissionStatus permissionStatus = await _getContactPermission();
//     // if (permissionStatus != PermissionStatus.granted) {
//     //   if (context.mounted) {
//     //     _handleInvalidPermissions(
//     //         permissionStatus: permissionStatus, context: context);
//     //   }
//     //   return null;
//     // }
//     // return await contextontactPicker.selectContact();
//   }
//
//   @override
//   Future<List<fc.Contact>?> loadContactsIntoMemory({
//     bool forceReload = false,
//     bool readonly = true,
//     bool withProperties = false,
//     bool withThumbnail = false,
//     bool withPhoto = false,
//     bool withGroups = false,
//     bool withAccounts = false,
//     bool sorted = true,
//     bool deduplicateProperties = true,
//   }) async {
//     PermissionStatus permissionStatus =
//         await _getContactPermission(withoutRequesting: true);
//     if (permissionStatus == PermissionStatus.granted) {
//       // Get all contacts on device
//       if (forceReload || (_contactList?.isEmpty ?? true)) {
//         _contactList = await fc.ContactsService.getContacts();
//       }
//     }
//     return _contactList;
//   }
//
//   // Get all contacts (lightly fetched)
//   @override
//   Future<List<fc.Contact>?> getAllContacts({
//     required BuildContext context,
//     bool forceReload = false,
//     bool readonly = true,
//     bool withProperties = false,
//     bool withThumbnail = false,
//     bool withPhoto = false,
//     bool withGroups = false,
//     bool withAccounts = false,
//     bool sorted = true,
//     bool deduplicateProperties = true,
//   }) async {
//     PermissionStatus permissionStatus = await _getContactPermission();
//     if (permissionStatus != PermissionStatus.granted) {
//       if (context.mounted) {
//         _handleInvalidPermissions(
//           permissionStatus: permissionStatus,
//           context: context,
//         );
//       }
//     }
//
//     if (context.mounted) {
//       return loadContactsIntoMemory(
//         forceReload: forceReload,
//         readonly: readonly,
//         withProperties: withProperties,
//         withThumbnail: withThumbnail,
//         withPhoto: withPhoto,
//         withGroups: withGroups,
//         withAccounts: withAccounts,
//         sorted: sorted,
//         deduplicateProperties: deduplicateProperties,
//       );
//     }
//     return null;
//   }
//
// // Get contact with specific ID (fully fetched)
//   @override
//   Future<fc.Contact?> getContactByID(
//     String id, {
//     bool withProperties = false,
//     bool withThumbnail = false,
//     bool withPhoto = false,
//     bool withGroups = false,
//     bool withAccounts = false,
//     bool deduplicateProperties = true,
//   }) async {
//     // bool granted = await fc.FlutterContacts.requestPermission(readonly: true);
//     // if (granted) {
//     //   fc.Contact? result = await fc.FlutterContacts.getContact(
//     //     id,
//     //     withAccounts: withAccounts,
//     //     withGroups: withGroups,
//     //     withPhoto: withPhoto,
//     //     withProperties: withProperties,
//     //     withThumbnail: withThumbnail,
//     //     deduplicateProperties: deduplicateProperties,
//     //   );
//     //   return result;
//     // }
//     return null;
//   }
//
//   Future<PermissionStatus> _getContactPermission({
//     bool withoutRequesting = false,
//   }) async {
//     PermissionStatus permission = await Permission.contacts.status;
//     if (permission != PermissionStatus.granted &&
//         permission != PermissionStatus.permanentlyDenied) {
//       if (withoutRequesting) {
//         return permission;
//       }
//       PermissionStatus permissionStatus = await Permission.contacts.request();
//       return permissionStatus;
//     } else {
//       return permission;
//     }
//   }
//
//   void _handleInvalidPermissions({
//     required BuildContext context,
//     required PermissionStatus permissionStatus,
//   }) {
//     if (permissionStatus == PermissionStatus.denied) {
//       unawaited(_showPermissionDeniedDialog(context));
//     } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
//       unawaited(_showPermissionDeniedDialog(context));
//     }
//   }
//
//   Future<void> _showPermissionDeniedDialog(BuildContext context) async =>
//       showCupertinoDialog<void>(
//         context: context,
//         builder: (BuildContext context) => CupertinoAlertDialog(
//           title: const Text("Permission Denied"),
//           content: const Text("Allow access to gallery and photos"),
//           actions: <CupertinoDialogAction>[
//             CupertinoDialogAction(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text("Cancel"),
//             ),
//             CupertinoDialogAction(
//               isDefaultAction: true,
//               onPressed: () async => openAppSettings(),
//               child: const Text("Settings"),
//             ),
//           ],
//         ),
//       );
// }
