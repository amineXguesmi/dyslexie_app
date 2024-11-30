import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screens/score.dart';
import 'models/tile.dart';
import 'models/tile_part.dart';
import 'models/touch_slice.dart';
import 'slice_painter.dart';

class CanvasArea extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CanvasAreaState();
  }
}

class _CanvasAreaState extends State<CanvasArea> {
  int score = 0;
  TouchSlice? touchSlice;
  List<Tile> tiles = [];
  List<TilePart> tileParts = [];
  var _random = Random();
  String randomLetterToShow = "";
  Timer? scoreTimer;
  int timerDuration = 60;

  @override
  void initState() {
    super.initState();
    _setRandomLetterForTop();
    _spawnRandomTile();
    _tick();

    scoreTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timerDuration > 0) {
        setState(() {
          timerDuration--;
        });
      } else {
        scoreTimer?.cancel();
      }
    });

    Timer(Duration(seconds: 60), () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Score(score: score,)));
    });
  }

  void _setRandomLetterForTop() {
    const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    randomLetterToShow = alphabet[_random.nextInt(alphabet.length)];
  }

  void _spawnRandomTile() {
    String letter = _getRandomLetter();

    tiles.add(Tile(
      position: Offset(0, 0),
      width: 80,
      height: 80,
      additionalForce: Offset(3 + Random().nextDouble() * 5, Random().nextDouble() * -10),
      rotation: Random().nextDouble() / 3 - 0.16,
      letter: letter,
    ));
  }

  String _getRandomLetter() {
    const letters = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];
    return letters[Random().nextInt(letters.length)];
  }

  void _tick() {
    setState(() {
      for (Tile tile in tiles) {
        tile.applyGravity();
      }
      for (TilePart tilePart in tileParts) {
        tilePart.applyGravity();
      }

      if (Random().nextDouble() > 0.97) {
        _spawnRandomTile();
      }
    });

    Future.delayed(Duration(milliseconds: 30), _tick);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: _getStack());
  }

  List<Widget> _getStack() {
    List<Widget> widgetsOnStack = [];

    widgetsOnStack.add(_getBackground());
    widgetsOnStack.add(_getSlice());
    widgetsOnStack.addAll(_getTileParts());
    widgetsOnStack.addAll(_getTiles());
    widgetsOnStack.add(_getGestureDetector());
    widgetsOnStack.add(Positioned(
      top: 16,
      left: 0,
      right: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  'Time: ${timerDuration}s',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Text(
                  'Score: $score',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            'Slice the letter: "$randomLetterToShow" to get 100',
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    ));

    return widgetsOnStack;
  }

  Container _getBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF7971B3).withOpacity(0.6), Color(0xFF453D7E).withOpacity(0.9)],
        ),
      ),
    );
  }

  Widget _getSlice() {
    if (touchSlice == null) {
      return Container();
    }

    return CustomPaint(
        size: Size.infinite,
        painter: SlicePainter(
          pointsList: touchSlice!.pointsList,
        ));
  }

  List<Widget> _getTiles() {
    List<Widget> list = [];

    for (Tile tile in tiles) {
      list.add(Positioned(
        top: tile.position.dy,
        left: tile.position.dx,
        child: Transform.rotate(
          angle: tile.rotation * pi * 2,
          child: _getLetterContainer(tile),
        ),
      ));
    }

    return list;
  }

  List<Widget> _getTileParts() {
    List<Widget> list = [];

    for (TilePart tilePart in tileParts) {
      list.add(Positioned(
        top: tilePart.position.dy,
        left: tilePart.position.dx,
        child: _getLetterCutEffect(tilePart),
      ));
    }

    return list;
  }

  Widget _getLetterCutEffect(TilePart tilePart) {
    return Transform.rotate(
        angle: tilePart.rotation * pi * 2,
        child: Image.asset(
          tilePart.isLeft ? 'assets/Cut.png' : 'assets/Cut_Right.png',
          height: 80,
          fit: BoxFit.fitHeight,
        ));
  }

  Widget _getLetterContainer(Tile tile) {
    return Container(
      width: tile.width,
      height: tile.height,
      color: Colors.pink, // Pink color for the letter container
      alignment: Alignment.center,
      child: Text(
        tile.letter,
        style: GoogleFonts.poppins(
          textStyle: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _getGestureDetector() {
    return GestureDetector(
      onScaleStart: (details) {
        setState(() {
          _setNewSlice(details);
        });
      },
      onScaleUpdate: (details) {
        setState(() {
          _addPointToSlice(details);
          _checkCollision();
        });
      },
      onScaleEnd: (details) {
        setState(() {
          _resetSlice();
        });
      },
    );
  }

  _checkCollision() {
    if (touchSlice == null) {
      return;
    }

    for (Tile tile in List.from(tiles)) {
      bool firstPointOutside = false;
      bool secondPointInside = false;

      for (Offset point in touchSlice!.pointsList) {
        if (!firstPointOutside && !tile.isPointInside(point)) {
          firstPointOutside = true;
          continue;
        }

        if (firstPointOutside && tile.isPointInside(point)) {
          secondPointInside = true;
          continue;
        }

        if (secondPointInside && !tile.isPointInside(point)) {
          tiles.remove(tile);
          _turnTileIntoParts(tile);

          if (tile.letter == randomLetterToShow) {
            score += 100;  // Correct slice
          } else {
            score += 10;   // Incorrect slice
          }
          break;
        }
      }
    }
  }

  void _turnTileIntoParts(Tile hit) {
    TilePart leftTilePart = TilePart(
      position: Offset(hit.position.dx - hit.width / 8, hit.position.dy),
      width: hit.width / 2,
      height: hit.height,
      isLeft: true,
      gravitySpeed: hit.gravitySpeed,
      additionalForce: Offset(hit.additionalForce.dx - 1, hit.additionalForce.dy - 5),
      rotation: hit.rotation,
    );

    TilePart rightTilePart = TilePart(
      position: Offset(hit.position.dx + hit.width / 4 + hit.width / 8, hit.position.dy),
      width: hit.width / 2,
      height: hit.height,
      isLeft: false,
      gravitySpeed: hit.gravitySpeed,
      additionalForce: Offset(hit.additionalForce.dx + 1, hit.additionalForce.dy - 5),
      rotation: hit.rotation,
    );

    tileParts.add(leftTilePart);
    tileParts.add(rightTilePart);
  }

  void _resetSlice() {
    setState(() {
      touchSlice = null;
    });
  }

  void _setNewSlice(ScaleStartDetails details) {
    touchSlice = TouchSlice(
      pointsList: [details.localFocalPoint],
    );
  }

  void _addPointToSlice(ScaleUpdateDetails details) {
    if (touchSlice == null) return;

    touchSlice!.pointsList.add(details.localFocalPoint);
  }
}
