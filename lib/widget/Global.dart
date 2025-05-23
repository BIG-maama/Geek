List<Map<String, dynamic>> viewUserDetails = [];
List<Map<String, dynamic>> createUser = [];
List<Map<String, dynamic>> showAllUsers = [];
List<Map<String, dynamic>> globalRoles = [];
const String baseUrl = "http://192.168.1.106:8000";
//create user
// {
//     "status": "success",
//     "message": "✅ تم إنشاء المستخدم بنجاح!",
//     "user": {
//         "name": "Soso",
//         "email": "noro223@gmail.com",
//         "phone": "09887766021",
//         "gender": "male",
//         "updated_at": "2025-05-23T12:23:31.000000Z",
//         "created_at": "2025-05-23T12:23:31.000000Z",
//         "id": 5,
//         "roles": [
//             {
//                 "id": 2,
//                 "name": "yahia",
//                 "guard_name": "web",
//                 "created_at": "2025-05-23T07:20:05.000000Z",
//                 "updated_at": "2025-05-23T07:20:05.000000Z",
//                 "pivot": {
//                     "model_type": "App\\Models\\User",
//                     "model_id": 5,
//                     "role_id": 2
//                 }
//             }
//         ]
//     },
//     "assigned_roles": [
//         "yahia"
//     ],
//     "status_code": 201
// }

//show user
// {
//     "status": "success",
//     "data": {
//         "id": 5,
//         "name": "Soso",
//         "email": "noro223@gmail.com",
//         "email_verified_at": null,
//         "phone": "09887766021",
//         "gender": "male",
//         "verification_code": null,
//         "is_verified": 0,
//         "social_id": null,
//         "social_type": null,
//         "created_at": "2025-05-23T12:23:31.000000Z",
//         "updated_at": "2025-05-23T12:23:31.000000Z",
//         "roles": [
//             {
//                 "id": 2,
//                 "name": "yahia",
//                 "guard_name": "web",
//                 "created_at": "2025-05-23T07:20:05.000000Z",
//                 "updated_at": "2025-05-23T07:20:05.000000Z",
//                 "pivot": {
//                     "model_type": "App\\Models\\User",
//                     "model_id": 5,
//                     "role_id": 2
//                 }
//             }
//         ]
//     },
//     "assigned_roles": [
//         "yahia"
//     ],
//     "status_code": 200
// }

//update user
// {
//     "status": "success",
//     "message": "✅ User updated successfully!",
//     "updated_user": {
//         "id": 5,
//         "name": "updated_user",
//         "email": "update@gmail.com",
//         "phone": "1111111111",
//         "gender": "female",
//         "roles": [
//             "yahia",
//             "norman"
//         ]
//     },
//     "status_code": 200
//}

//show all user
// {
//     "status": "success",
//     "data": [
//         {
//             "id": 6,
//             "name": "Soso",
//             "email": "noro823@gmail.com",
//             "phone": "09887766022",
//             "gender": "male",
//             "roles": [
//                 "yahia"
//             ]
//         },
//         {
//             "id": 5,
//             "name": "updated_user",
//             "email": "update@gmail.com",
//             "phone": "1111111111",
//             "gender": "female",
//             "roles": [
//                 "yahia",
//                 "norman"
//             ]
//         }
//     ],
//     "local": "ar",
//     "meta": {
//         "total": 2,
//         "per_page": 5,
//         "current_page": 1,
//         "last_page": 1
//     },
//     "status_code": 200
// }
