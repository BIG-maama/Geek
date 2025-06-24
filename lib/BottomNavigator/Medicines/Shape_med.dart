import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:pro/widget/Global.dart';

class MedicineFormsPage extends StatefulWidget {
  @override
  _MedicineFormsPageState createState() => _MedicineFormsPageState();
}

class _MedicineFormsPageState extends State<MedicineFormsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  List<dynamic> _forms = [];
  List<dynamic> _trash = [];
  bool _isLoading = false;
  bool _showTrash = false;

  @override
  void initState() {
    super.initState();
    fetchMedicineForms();
  }

  Future<void> fetchMedicineForms() async {
    setState(() => _isLoading = true);
    try {
      final response = await Dio().get("$baseUrl/api/medicine-forms");
      if (response.statusCode == 200 && response.data['status'] == true) {
        setState(() {
          _forms = response.data['data'];
        });
      }
    } catch (e) {
      print('Error fetching forms: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> addMedicineForm() async {
    setState(() => _isLoading = true);
    try {
      final response = await Dio().post(
        "$baseUrl/api/medicine-forms",
        data: {
          "name": _nameController.text,
          "description": _descriptionController.text,
        },
      );
      if (response.statusCode == 200 && response.data['status'] == true) {
        await fetchMedicineForms();
        _nameController.clear();
        _descriptionController.clear();
      }
    } catch (e) {
      print('Error adding form: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> deleteMedicineForm(int id) async {
    try {
      final response = await Dio().delete("$baseUrl/api/medicine-forms/$id");
      if (response.statusCode == 200 && response.data['status'] == true) {
        await fetchMedicineForms();
      }
    } catch (e) {
      print('Error deleting form: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayedList = _showTrash ? _trash : _forms;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('إدارة الأشكال الدوائية'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text(_showTrash ? 'رجوع' : 'عرض السلة'),
          onPressed: () {
            setState(() => _showTrash = !_showTrash);
          },
        ),
      ),
      child: SafeArea(
        child:
            _isLoading
                ? Center(child: CupertinoActivityIndicator())
                : SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      CupertinoTextField(
                        controller: _nameController,
                        placeholder: 'اسم الشكل',
                      ),
                      SizedBox(height: 10),
                      CupertinoTextField(
                        controller: _descriptionController,
                        placeholder: 'الوصف',
                      ),
                      SizedBox(height: 16),
                      CupertinoButton.filled(
                        child: Text('إضافة'),
                        onPressed: addMedicineForm,
                      ),
                      SizedBox(height: 24),
                      Text(
                        _showTrash ? 'سلة المحذوفات' : 'قائمة الأشكال',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      ...displayedList.map(
                        (form) => AnimatedSlide(
                          offset: Offset(0, 0),
                          duration: Duration(milliseconds: 300),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: CupertinoColors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: CupertinoColors.systemGrey5,
                                    blurRadius: 5,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        CupertinoIcons.plus,
                                        color: CupertinoColors.systemBlue,
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          form['name'],
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      if (_showTrash)
                                        Row(
                                          children: [
                                            CupertinoButton(
                                              padding: EdgeInsets.zero,
                                              child: Icon(
                                                CupertinoIcons.refresh_circled,
                                                color:
                                                    CupertinoColors.activeGreen,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _forms.add(form);
                                                  _trash.remove(form);
                                                });
                                              },
                                            ),
                                            CupertinoButton(
                                              padding: EdgeInsets.zero,
                                              child: Icon(
                                                CupertinoIcons.delete_solid,
                                                color:
                                                    CupertinoColors
                                                        .destructiveRed,
                                              ),
                                              onPressed: () {
                                                deleteMedicineForm(form['id']);
                                                setState(() {
                                                  _trash.remove(form);
                                                });
                                              },
                                            ),
                                          ],
                                        )
                                      else
                                        CupertinoButton(
                                          padding: EdgeInsets.zero,
                                          child: Icon(
                                            CupertinoIcons.delete,
                                            color:
                                                CupertinoColors.destructiveRed,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _trash.add(form);
                                              _forms.remove(form);
                                            });
                                          },
                                        ),
                                    ],
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    form['description'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: CupertinoColors.systemGrey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}













































//http://localhost:8000/api/medicine-forms

// {
//     "status": true,
//     "message": "تم إضافة الشكل الدوائي بنجاح",
//     "status_code": 200,
//     "data": {
//         "name": "ji",
//         "description": "اقراص",
//         "updated_at": "2025-06-17T14:39:49.000000Z",
//         "created_at": "2025-06-17T14:39:49.000000Z",
//         "id": 1
//     }
// }


//http://localhost:8000/api/medicine-forms

// {
//     "status": true,
//     "status_code": 200,
//     "message": "تم جلب الأشكال الدوائية بنجاح",
//     "data": [
//         {
//             "id": 2,
//             "name": "ابر",
//             "description": "اقراص",
//             "medicines_count": 0
//         },
//         {
//             "id": 1,
//             "name": "اقراص",
//             "description": "اقراص",
//             "medicines_count": 0
//         },
//         {
//             "id": 3,
//             "name": "حبوب",
//             "description": "اقراص",
//             "medicines_count": 0
//         }
//     ]
// }




//http://localhost:8000/api/medicine-forms/1


// {
//     "status": true,
//     "message": "تم حذف الشكل الدوائي بنجاح",
//     "status_code": 200
// }