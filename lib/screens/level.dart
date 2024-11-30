import 'package:dyslexislash/fast.dart';
import 'package:dyslexislash/initial_screen.dart';
import 'package:dyslexislash/puzzule_words.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Levels extends StatefulWidget {
  @override
  _LevelsState createState() => _LevelsState();
}

class _LevelsState extends State<Levels> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF7971B3).withOpacity(0.6), Color(0xFF453D7E).withOpacity(0.9)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 60,
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Text(
                      "Select Level",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: Color(0xff5CA6A6),
                          fontSize: 37,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 90,
                        width: MediaQuery.of(context).size.width / 1.1,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => WordPuzzleScreen()));
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.amber.shade200,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            padding: EdgeInsets.all(10.0),
                          ),
                          child: Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Image.asset('assets/Puzzle.png', height: 80, width: 80),
                                Text(
                                  "word puzzle",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: Colors.amber,
                                      fontSize: 37,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 60),
                      Container(
                        height: 90,
                        width: MediaQuery.of(context).size.width / 1.1,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => InitialScreen()));
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Color(0xffB9FFA0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            padding: EdgeInsets.all(10.0),
                          ),
                          child: Container(
                            padding: EdgeInsets.only(left: 10, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Image.asset('assets/slow.png', height: 80, width: 80),
                                Text(
                                  "slash slow ",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: Color(0xff6DBA52),
                                      fontSize: 37,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 60),
                      Container(
                        height: 90,
                        width: MediaQuery.of(context).size.width / 1.1,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => Fast()));
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Color(0xffF5CDCD),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            padding: EdgeInsets.all(10.0),
                          ),
                          child: Container(
                            padding: EdgeInsets.only(left: 10, right: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Image.asset('assets/fast.png', height: 80, width: 80),
                                Text(
                                  "slash fast",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: Color(0xffFF8C8C),
                                      fontSize: 37,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
