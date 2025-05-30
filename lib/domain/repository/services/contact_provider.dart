// import "package:contacts_service/contacts_service.dart" as fc;
// // ignore: implementation_imports
// import "package:flutter/src/widgets/framework.dart";
// import "package:flutter_native_contact_picker/model/contact.dart";
//
// abstract class ContactService {
//   Future<Contact?> pickNumber({
//     required BuildContext context,
//     bool forcePermission = true,
//   });
//
//   // Get all contacts (lightly fetched)
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
//   });
//
//   // Load contacts into memory if permission given
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
//   });
//
// // Get contact with specific ID (fully fetched)
//   Future<fc.Contact?> getContactByID(
//     String id, {
//     bool withProperties = false,
//     bool withThumbnail = false,
//     bool withPhoto = false,
//     bool withGroups = false,
//     bool withAccounts = false,
//     bool deduplicateProperties = true,
//   });
// }
