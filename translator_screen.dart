import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TranslatorScreen extends StatefulWidget {
  @override
  _TranslatorScreenState createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  final TextEditingController _textController = TextEditingController();
  String _selectedLanguage = 'es';
  String _translatedText = '';

  final List<String> _languages = [
    'es', 'fr', 'de', 'zh', 'ja', 'ar', 'hi', 'ru', 'it', 'pt'
  ];

  Future<void> _translateText() async {
    final response = await http.post(
      Uri.parse('https://api.mymemory.translated.net/get'),
      body: {
        'q': _textController.text,
        'langpair': 'en|$_selectedLanguage',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _translatedText = data['responseData']['translatedText'];
      });
    } else {
      setState(() {
        _translatedText = 'Translation error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(246, 255, 154, 23),
        elevation: 0,
        title: Text(
          'Translator',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.purple,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.purple),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black87, Colors.deepPurple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 30),
              Container(
                height: 150,  
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[100], 
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _textController,
                  maxLines: null, 
                  expands: true, 
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                    hintText: 'Enter text to translate',
                    hintStyle: TextStyle(color: Colors.grey[700]), 
                  ),
                ),
              ),
              SizedBox(height: 30),
              Container(
                height: 150,  
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[100], 
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(16),
                child: SingleChildScrollView( 
                  child: Text(
                    _translatedText.isEmpty ? 'Translation of text' : _translatedText,
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Spacer(), 
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromARGB(183, 254, 171, 63), 
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: DropdownButton<String>(
                        value: _selectedLanguage,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedLanguage = newValue!;
                          });
                        },
                        items: _languages.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _getLanguageName(value),
                                style: TextStyle(fontSize: 16, color: Colors.purple, fontWeight: FontWeight.w100),
                              ),
                            ),
                          );
                        }).toList(),
                        isExpanded: true,
                        underline: SizedBox(),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: _translateText,
                      child: Text('Translate'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.purple,
                        backgroundColor: Color.fromARGB(246, 255, 154, 23), 
                        padding: EdgeInsets.symmetric(vertical: 16),
                        textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w100),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'es':
        return 'Spanish';
      case 'fr':
        return 'French';
      case 'de':
        return 'German';
      case 'zh':
        return 'Chinese';
      case 'ja':
        return 'Japanese';
      case 'ar':
        return 'Arabic';
      case 'hi':
        return 'Hindi';
      case 'ru':
        return 'Russian';
      case 'it':
        return 'Italian';
      case 'pt':
        return 'Portuguese';
      default:
        return 'Unknown';
    }
  }
}
