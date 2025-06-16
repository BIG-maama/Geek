import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pro/BottomNavigator/Medicines/medic_&_catg_info.dart';
import 'package:pro/BottomNavigator/Medicines/medicine_details.dart';
import 'package:pro/BottomNavigator/Medicines/show_alternative_medic.dart';
import 'package:pro/widget/Global.dart';

class GroupedMedicinesCupertinoPage extends StatefulWidget {
  final CategoryInfo category;

  const GroupedMedicinesCupertinoPage({Key? key, required this.category})
    : super(key: key);

  @override
  State<GroupedMedicinesCupertinoPage> createState() =>
      _GroupedMedicinesCupertinoPageState();
}

class _GroupedMedicinesCupertinoPageState
    extends State<GroupedMedicinesCupertinoPage> {
  late Box<MedicInfo> medicineBox;

  @override
  void initState() {
    super.initState();
    medicineBox = Hive.box<MedicInfo>('medics');
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('أدوية: ${widget.category.name}'),
      ),
      child: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: medicineBox.listenable(),
          builder: (context, Box<MedicInfo> medBox, _) {
            final medicines =
                medBox.values
                    .where((med) => med.category.id == widget.category.id)
                    .toList();

            return ListView(
              children: [
                CupertinoListSection.insetGrouped(
                  header: Text(
                    widget.category.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  children:
                      medicines.isEmpty
                          ? const [
                            CupertinoListTile(
                              title: Text("لا توجد أدوية ضمن هذه الفئة."),
                            ),
                          ]
                          : medicines.map((med) {
                            return CupertinoListTile(
                              title: Text(med.name),
                              subtitle: Text(
                                "السعر: ${med.prices.supplierPrice} | الكمية: ${med.quantity}",
                              ),
                              leading: const Icon(
                                CupertinoIcons.info,
                                color: CupertinoColors.systemCyan,
                              ),
                              onTap: () {
                                CustomNavigator.push(
                                  context,
                                  MedicineDetailsPage(medicine: med),
                                );
                              },
                              trailing: CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: () async {
                                  CustomNavigator.push(
                                    context,
                                    AlternativeMedicinesPage(
                                      medicineId: med.id,
                                    ),
                                  );
                                },
                                child: const Icon(
                                  CupertinoIcons.link,
                                  color: CupertinoColors.darkBackgroundGray,
                                ),
                              ),
                            );
                          }).toList(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// class _GroupedMedicinesCupertinoPageState
//     extends State<GroupedMedicinesCupertinoPage> {
//   late Box<MedicInfo> medicineBox;
//   Set<int> expandedMedicineIds = {}; // لتتبع الأدوية المفتوحة

//   @override
//   void initState() {
//     super.initState();
//     medicineBox = Hive.box<MedicInfo>('medics');
//   }

//   List<MedicInfo> getAlternatives(MedicInfo med) {
//     // مثال: تفترض أنك تخزن البدائل داخل حقل attachments كـ IDs
//     List<int> altIds = med.attachments.cast<int>();
//     return medicineBox.values
//         .where((m) => altIds.contains(m.id))
//         .toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CupertinoPageScaffold(
//       navigationBar: CupertinoNavigationBar(
//         middle: Text('أدوية: ${widget.category.name}'),
//       ),
//       child: SafeArea(
//         child: ValueListenableBuilder(
//           valueListenable: medicineBox.listenable(),
//           builder: (context, Box<MedicInfo> medBox, _) {
//             final medicines = medBox.values
//                 .where((med) => med.category_id == widget.category.id)
//                 .toList();

//             return ListView(
//               children: [
//                 CupertinoListSection.insetGrouped(
//                   header: Text(
//                     widget.category.name,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                   children: medicines.isEmpty
//                       ? const [
//                           CupertinoListTile(
//                             title: Text("لا توجد أدوية ضمن هذه الفئة."),
//                           ),
//                         ]
//                       : medicines.expand((med) {
//                           final isExpanded = expandedMedicineIds.contains(med.id);
//                           final alternatives = getAlternatives(med);

//                           return [
//                             CupertinoListTile(
//                               title: Text(med.medicine_name),
//                               subtitle: Text(
//                                   "السعر: ${med.people_price} | الكمية: ${med.quantity}"),
//                               leading: const Icon(
//                                 CupertinoIcons.info,
//                                 color: CupertinoColors.systemCyan,
//                               ),
//                               onTap: () {
//                                 setState(() {
//                                   if (isExpanded) {
//                                     expandedMedicineIds.remove(med.id);
//                                   } else {
//                                     expandedMedicineIds.add(med.id);
//                                   }
//                                 });
//                               },
//                               trailing: Icon(
//                                 isExpanded
//                                     ? CupertinoIcons.chevron_up
//                                     : CupertinoIcons.chevron_down,
//                                 color: CupertinoColors.inactiveGray,
//                               ),
//                             ),
//                             if (isExpanded && alternatives.isNotEmpty)
//                               ...alternatives.map((alt) => Padding(
//                                     padding: const EdgeInsets.only(right: 32.0),
//                                     child: CupertinoListTile(
//                                       title: Text("🔁 ${alt.medicine_name}"),
//                                       subtitle: Text(
//                                           "السعر: ${alt.people_price} | الكمية: ${alt.quantity}"),
//                                       onTap: () {
//                                         CustomNavigator.push(
//                                           context,
//                                           MedicineDetailsPage(medicine: alt),
//                                         );
//                                       },
//                                     ),
//                                   )),
//                             if (isExpanded && alternatives.isEmpty)
//                               const Padding(
//                                 padding: EdgeInsets.only(right: 32.0),
//                                 child: CupertinoListTile(
//                                   title: Text("لا توجد أدوية بديلة"),
//                                 ),
//                               ),
//                           ];
//                         }).toList(),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
