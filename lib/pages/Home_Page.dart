// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
// import 'package:to_do_app/widgets/appbar.dart';

// import 'Detail_Page.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   List items = ["atharva", "yash", "gaurav", "ninad"];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         child: AppbarWidget("Home Page"),
//         preferredSize: const Size.fromHeight(50),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10),
//         child: ListView.builder(
//             itemCount: items.length,
//             itemBuilder: (context, index) => Card(
//                   elevation: 3,
//                   child: ListTile(
//                     title: Text(items[index]),
//                     onTap: ()=>{
//                       Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => DetailScreen(item: items[index]),
//                     ),)
//                     },
//                   ),
//                 )),
//       ),
//     );
//   }
// }