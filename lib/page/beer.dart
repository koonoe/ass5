import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class Wine extends StatefulWidget {
  const Wine({super.key});

  @override
  State<Wine> createState() => _BeerState();
}

class _BeerState extends State<Wine> {
  late List<dynamic> _coffees;
  late Dio _dio;

  @override
  void initState() {
    super.initState();
    _dio = Dio();
    _fetchCoffees();
  }

  Future<void> _fetchCoffees() async {
    try {
      final response = await _dio.get('https://api.sampleapis.com/coffee/hot');
      if (response.statusCode == 200) {
        setState(() {
          _coffees = response.data;
        });
      } else {
        throw Exception('Failed to load coffees');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void _showCoffeeDetails(
      String description, List<dynamic> ingredients, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Coffee Details"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30), // เพิ่มระยะห่างด้านบน
              imageUrl.isNotEmpty
                  ? Center(
                      child: Image.network(
                        imageUrl,
                        height: 200, // กำหนดความสูงของรูป
                        width: 200, // กำหนดความกว้างเต็มรูป
                        fit: BoxFit
                            .cover, // ให้รูปภาพทำการปรับขนาดให้เต็มพื้นที่ที่กำหนด
                      ),
                    )
                  : SizedBox.shrink(), // ถ้าไม่มี URL ของรูปภาพ ให้ไม่แสดงรูป
              SizedBox(height: 30), // เพิ่มระยะห่างระหว่างรูปภาพกับคำอธิบาย
              Text("Description: $description"),
              SizedBox(
                  height:
                      20), // เพิ่มระยะห่างระหว่างคำอธิบายกับส่วน Ingredients
              Text("Ingredients:"),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: ingredients
                    .map((ingredient) => Padding(
                          padding: EdgeInsets.only(
                              left: 20), // เพิ่มระยะห่างด้านซ้าย
                          child: Text("- $ingredient"),
                        ))
                    .toList(),
              ),
              SizedBox(height: 10), // เพิ่มระยะห่างด้านล่าง
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hot Coffees',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 145, 109, 96),
      ),
      body: _coffees == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.separated(
              itemCount: _coffees.length,
              separatorBuilder: (BuildContext context, int index) =>
                  Divider(), // เพิ่ม divider ระหว่างรายการ
              itemBuilder: (context, index) {
                final coffeeName = _coffees[index]['title'];
                return ListTile(
                  title: Text(coffeeName),
                  onTap: () {
                    _showCoffeeDetails(
                        _coffees[index]['description'],
                        _coffees[index]['ingredients'],
                        _coffees[index]['image']);
                  },
                );
              },
            ),
    );
  }
}
