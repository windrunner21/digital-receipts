import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import '../mlkitreceipt.dart';

class AddReceiptsPage extends StatefulWidget {
  @override
  _AddReceiptsPageState createState() => _AddReceiptsPageState();
}

class _AddReceiptsPageState extends State<AddReceiptsPage> {
  File pickedImage;
  String text = '';
  bool imageLoaded = false;
  bool analysisStarted = false;

  var extractedMap = {
    "issueDate": "",
    "companyName": "",
    "companyVKN": -1,
    "category": "Restaurants & Food",
    "receiptType": "",
    "ettn": "",
    "paymentTypeCode": -1,
    "paymentTypeNote": "",
    "totalKDV": -1,
    "totalPrice": -1,
    "currency": "TRY",
    "city": "Ankara",
    "faturaNo": "",
    "newUser": false,
    "items": []
  };

  var items = [];

  Future pickImagefromGallery() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      pickedImage = tempImage;
      imageLoaded = true;
    });
  }

  Future pickImagefromCamera() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      pickedImage = tempImage;
      imageLoaded = true;
    });
  }

  Future readImage() async {
    FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(pickedImage);
    TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
    VisionText visionText = await textRecognizer.processImage(visionImage);

    // variables for storing extracted text
    String companyName = "";
    String date = "";
    String time = "";
    String receiptType = "";
    String receiptNumber = "";
    String ettn = "";
    String vkn = "";
    String itemprice = "";
    String itemdescription = "";
    String itemquantity = "";
    String itemName = "";
    String itemKDV = "";
    String totalKDV = "";
    String totalPrice = "";
    String paymentTypeNote = "";
    int paymentTypeCode = 0;

    for (int i = 0; i < visionText.blocks.length; i++) {
      for (int j = 0; j < visionText.blocks[i].lines.length; j++) {
        for (int k = 0;
            k < visionText.blocks[i].lines[j].elements.length;
            k++) {
          // getting company name from first block, first line
          if (i == 0 && j == 0) {
            if (k + 1 == visionText.blocks[i].lines[j].elements.length) {
              companyName =
                  companyName + visionText.blocks[0].lines[0].elements[k].text;
            } else {
              companyName = companyName +
                  visionText.blocks[0].lines[0].elements[k].text +
                  " ";
            }
          }

          // getting the date of the receipt
          if (visionText.blocks[i].lines[j].elements[k].text == "Tarih") {
            date = visionText.blocks[i].lines[j].elements[k + 2].text;
          }

          // getting the time of the receipt ============= MAY BE INACCURACIES IN THE FUTURE
          if (visionText.blocks[i].lines[j].elements[k].text == "Saat") {
            time =
                visionText.blocks[i].lines[j].elements[k + 1].text.substring(1);
          }

          // getting type of the receipt
          if (visionText.blocks[i].lines[j].elements[k].text == "TÜR") {
            for (var k = 1;
                k < visionText.blocks[i].lines[j].elements.length;
                k++) {
              receiptType = receiptType +
                  " " +
                  visionText.blocks[i].lines[j].elements[k].text;
            }
          }

          // getting the number of the receipt
          if (visionText.blocks[i].lines[j].elements[k].text == "Fatura") {
            receiptNumber = visionText.blocks[i].lines[j].elements[k + 3].text;
          }

          // getting ettn number
          if (visionText.blocks[i].lines[j].elements[k].text == "ETTN") {
            ettn =
                visionText.blocks[i].lines[j].elements[k + 1].text.substring(1);
          }

          // getting vkn of the seller from receipt
          if (visionText.blocks[i].lines[j].elements[k].text.contains("VKN")) {
            vkn = visionText.blocks[i].lines[j].elements[k].text.substring(9);
          }

          // // getting information about items - price and complicated description later divided into more parts
          if (visionText.blocks[i].lines[j].elements[k].text
                  .contains(RegExp('[0-9]')) &&
              visionText.blocks[i].lines[j].elements[k].text.contains('t')) {
            //
            // price get here
            itemprice = visionText.blocks[i].lines[j].elements[k].text;

            // complicated description get here
            for (int x = 0;
                x < visionText.blocks[i + 1].lines[j].elements.length;
                x++) {
              if (x + 1 == visionText.blocks[i + 1].lines[j].elements.length) {
                itemdescription = itemdescription +
                    visionText.blocks[i + 1].lines[j].elements[x].text;
              } else {
                itemdescription = itemdescription +
                    visionText.blocks[i + 1].lines[j].elements[x].text +
                    " ";
              }
            }
          }

          // getting total kdv from the receipt
          if (visionText.blocks[i].lines[j].elements[k].text == "TOPKDV") {
            totalKDV = visionText.blocks[i + 1].lines[j].elements[k].text;
          }

          // getting total price from the receipt
          if (visionText.blocks[i].lines[j].elements[k].text == "TOPLAM") {
            totalPrice = visionText.blocks[i + 1].lines[j].elements[k].text;
          }

          // getting payment type code and note together from the receipt
          if (visionText.blocks[i].lines[j].elements[k].text == "Nakit") {
            paymentTypeCode = 10;
            paymentTypeNote = "Nakit";
          } else if (visionText.blocks[i].lines[j].elements[k].text
              .contains("Kredi")) {
            paymentTypeCode = 20;
            paymentTypeNote = "Kredi Karti";
          }

          setState(() {
            text = text + visionText.blocks[i].lines[j].elements[k].text + ' ';
          });
        }

        text = text + '\n';
      }
    }

    // decomposing itemdescription that was established above into item parts
    for (String elem in itemdescription.split(" ")) {
      if (elem.contains('x') && !elem.contains(RegExp('[%]'))) {
        itemquantity = elem.substring(0, elem.indexOf('x'));
      }

      if (elem.contains(RegExp('[A-Za-z]')) &&
          !elem.contains(RegExp('[0-9]'))) {
        itemName = itemName + elem + " ";
      }

      if (elem.contains(RegExp('[0-9%]')) &&
          !elem.contains(RegExp('[A-Za-z]'))) {
        if (!elem.contains('%')) {
          itemKDV = elem;
        }
      }
    }

    // adding items to an array of the items inside map
    items.add({
      "name": itemName.substring(0, itemName.length - 1),
      "amount": itemquantity,
      "priceWithoutTax": double.parse(itemprice.replaceAll(
          RegExp("[@#%\$^&*()_+\\-=\\[\\]{};':\"\\\\|,<>\\/?A-Za-z]"), "")),
      "percent": double.parse(itemKDV),
      "tax": (double.parse(itemKDV) / 100) *
          double.parse(itemprice.replaceAll(
              RegExp("[@#%\$^&*()_+\\-=\\[\\]{};':\"\\\\|,<>\\/?A-Za-z]"), ""))
    });

    // assigning values to the map
    extractedMap['companyName'] = companyName;
    extractedMap['issueDate'] = date.split("-")[2] +
        "-" +
        date.split("-")[1] +
        "-" +
        date.split("-")[0] +
        "T" +
        time +
        ":00.578Z";
    extractedMap['receiptType'] = receiptType.substring(2);
    extractedMap['faturaNo'] = receiptNumber;
    extractedMap['ettn'] = ettn;
    extractedMap['companyVKN'] = int.parse(vkn.substring(0, 4));
    extractedMap['items'] = items;
    extractedMap['totalKDV'] = double.parse(totalKDV);
    extractedMap['totalPrice'] = double.parse(totalPrice);
    extractedMap['paymentTypeCode'] = paymentTypeCode;
    extractedMap['paymentTypeNote'] = paymentTypeNote;

    textRecognizer.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Digitize Receipts"),
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          SizedBox(height: 20.0),
          imageLoaded
              ? Container(
                  margin: EdgeInsets.only(bottom: 30, left: 5, right: 5),
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(blurRadius: 20),
                    ],
                  ),
                  child: Image.file(
                    pickedImage,
                    fit: BoxFit.cover,
                  ),
                )
              : Container(
                  margin: EdgeInsets.all(30),
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.black)),
                  child: Center(
                      child: Column(
                    children: [
                      IconButton(
                        iconSize: 50,
                        icon: Icon(
                          Icons.photo,
                        ),
                        onPressed: () async {
                          pickImagefromGallery();
                        },
                      ),
                      Text("Open Photos",
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1)),
                      Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 2),
                          child: Text("or",
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 15,
                                  color: Colors.grey[800]))),
                      IconButton(
                        iconSize: 50,
                        icon: Icon(
                          Icons.camera,
                        ),
                        onPressed: () async {
                          pickImagefromCamera();
                        },
                      ),
                      Text("Open Camera",
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1))
                    ],
                  ))),
          Align(
              alignment: Alignment.center,
              child: Text(
                "How to obtain Digital Receipts",
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  letterSpacing: 1,
                  decoration: TextDecoration.underline,
                ),
              )),
          SizedBox(height: 10),
          Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                      "1. Upload your receipt from a Photo Library or take a photo of your receipt using Camera."))),
          Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                      "2. After successful completion of the first step press 'Analyze Receipt' button to start the process of digitalization."))),
          Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                      "3. After digitalization is completed, your receipt will be automatically added to your Receipts list."))),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(50, 20, 50, 30),
        child: analysisStarted
            ? LinearProgressIndicator()
            : RaisedButton(
                child: Text('Analyze Receipt'),
                elevation: 8.0,
                color: Colors.deepPurple,
                disabledTextColor: Colors.white60,
                textColor: Colors.white,
                onPressed: imageLoaded
                    ? () async {
                        readImage();
                        setState(() {
                          analysisStarted = true;
                        });
                        Timer(const Duration(milliseconds: 4000), () {
                          setState(() {
                            analysisStarted = false;
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MLKITReceiptPage(
                                      processedText: extractedMap,
                                    )),
                          );
                        });
                      }
                    : null),
      ),
    );
  }
}
