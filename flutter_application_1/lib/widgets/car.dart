import 'dart:async';
import 'dart:ui' as ui; 
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_application_1/objects/game_state.dart';
import 'package:flutter_application_1/widgets/obstacle.dart';

class Car extends StatefulWidget {
  final int rows;
  final int columns;
  final double cellSize;
  final double yAxis;
  final GameState state;

  Car(
      {Key? key,
      required this.state,
      required this.rows,
      required this.columns,
      required this.cellSize,
      required this.yAxis})
      : super(key: key);

     
  

  @override
  State<StatefulWidget> createState() => CarState();
}

class CarState extends State<Car> {
  late Timer _timer;
  late ui.Image carImage;
  bool isImageloaded = false;
 
  @override
  void initState() {
    super.initState();
    init();
    
    _timer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      setState(() {
        _moveCar();
      });
    });
    widget.state.carTimer = _timer;
  }
  Future<Null> init() async{
    final ByteData data = await rootBundle.load('assets/car.png');
    carImage = await loadImage(new Uint8List.view(data.buffer));
  }

  Future<ui.Image> loadImage(Uint8List img) async {
    final Completer<ui.Image> completer = new Completer();
    ui.decodeImageFromList(img, (ui.Image img) {
      setState(() {
        isImageloaded = true;
      });
      return completer.complete(img);
    });
    return completer.future;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _moveCar() {
    int direction = -widget.yAxis.sign.toInt();
    widget.state.moveCar(direction);
  }

  Widget _buildImage(){
    if(this.isImageloaded){
      return new CustomPaint(
        painter: CarPainter(widget.state, widget.cellSize, carImage)
      );
    } else{
      return new Center(child: Text('loading'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildImage();
    
  }

  

}



class CarPainter extends CustomPainter {
  final GameState? state;
  final double cellSize;
  final ui.Image carImg;

  CarPainter(this.state, this.cellSize, this.carImg);

  void paintCar(Canvas canvas, Size size) {
    final carPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final roadLineColor = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;
    /*
    final obstaclePaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;
    */
    final carPos = state!.carPos;
    final a = Offset(carPos.x * cellSize, carPos.y * cellSize);
    final b = Offset((carPos.x + 1) * cellSize, (carPos.y + 1) * cellSize);

    //canvas.drawRect(Rect.fromPoints(a, b), carPaint);
    canvas.drawImage(carImg, a, carPaint);
    //print(carImg);
    canvas.drawRect(
        Rect.fromPoints(size.topCenter(b), size.topCenter(a)), roadLineColor);
  }
  
  @override
  void paint(Canvas canvas, Size size) {
    final carPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    final carPos = state!.carPos;
    final a = Offset(carPos.x * cellSize, (carPos.y) * cellSize);
    final b = Offset((carPos.x + 4) * cellSize, (carPos.y + 6) * cellSize);
    canvas.drawImageRect(carImg, Rect.fromLTRB(600, 250, 1410, 1630), Rect.fromPoints(a, b), carPaint);
    
    //canvas.drawRect(Rect.fromPoints(a, b), carPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

