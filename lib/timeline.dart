import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sprintf/sprintf.dart';

class TimeLine extends StatefulWidget {

  Map<String, dynamic>? timeline;

  TimeLine({this.timeline});

  @override
  State<StatefulWidget> createState() {
    return TimeLineState();
  }

}

class TimeLineState extends State<TimeLine> {

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: TimeLinePainter(widget),
      child: Container(
        height:80,
      )
    );
  }
}

class TimeLinePainter extends CustomPainter {

  TimeLine _timeLine;

  TimeLinePainter(this._timeLine);

  @override
  void paint(Canvas canvas, Size size) {
    double middleHeight = ((size.height - 30) / 2) + 30;
    var paint = Paint()
      ..color = Colors.black12;
    final RRect rrect1 = RRect.fromLTRBAndCorners(3, 3, size.width - 2, size.height - 2, topLeft: Radius.circular(5), topRight: Radius.circular(5), bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5));
    final RRect rrect2 = RRect.fromLTRBAndCorners(2, 2, size.width - 6, size.height - 6, topLeft: Radius.circular(5), topRight: Radius.circular(5), bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5));
    canvas.drawRRect(rrect1, paint);
    paint.color = Colors.white;
    canvas.drawRRect(rrect2, paint);
    paint.color = Colors.black26;
    paint.style = PaintingStyle.stroke;
    canvas.drawRRect(rrect2, paint);

    double v = size.width / _timeLine.timeline!["total_length"];
    v *= _timeLine.timeline!["past_length"] as double ;
    double left = v + .0;

    paint.color = Color(0xff954FF17);
    paint.strokeWidth = 3;
    canvas.drawLine(Offset(4, middleHeight), Offset(size.width - 8, middleHeight), paint);
    paint.color = Color(0xffa1a1a1);
    canvas.drawLine(Offset(4, middleHeight), Offset(left + 2 > size.width - 8 ? size.width - 8 : left + 2, middleHeight), paint);

    var path = Path();
    path.moveTo(left + 2, middleHeight + 10);
    path.lineTo(left + 2, middleHeight - 10);
    path.lineTo(left + 20, middleHeight);
    path.close();
    paint.style = PaintingStyle.fill;
    paint.color = Colors.yellow;
    canvas.drawPath(path, paint);
    paint.style = PaintingStyle.stroke;
    paint.color = Colors.black38;
    paint.strokeWidth = 1;
    canvas.drawPath(path, paint);

    double length_left = (_timeLine.timeline!["total_length"] - _timeLine.timeline!["past_length"]) / 1000;
    if (length_left < 0) {
      length_left = 0;
    }
    TextSpan span = new TextSpan(style: new TextStyle(color: Colors.black, fontSize: 20), text: sprintf("%.1f km", [length_left]));
    TextPainter tp = TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
    tp.layout(minWidth: 0, maxWidth: size.width,);
    tp.paint(canvas, Offset(4, 2));

    TextSpan span2 = new TextSpan(style: TextStyle(color: Colors.blue[800], fontSize: 20, fontWeight: FontWeight.w700), text: _timeLine.timeline!["arrival_time"]);
    RenderParagraph renderParagraph = RenderParagraph(span2, textDirection: TextDirection.ltr,   maxLines: 1,);
    TextPainter tp2 = TextPainter(text: span2, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
    tp2.layout(minWidth: 0, maxWidth: size.width,);
    tp2.paint(canvas, Offset((size.width / 2) - (renderParagraph.getMinIntrinsicWidth(20).ceilToDouble() / 2) , 2));

    TextSpan span3 = new TextSpan(style: TextStyle(color: Colors.blue[800], fontSize: 20, fontWeight: FontWeight.w700), text: _timeLine.timeline!["travel_time"]);
    renderParagraph = RenderParagraph(span3, textDirection: TextDirection.ltr,   maxLines: 1,);
    TextPainter tp3 = TextPainter(text: span3, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
    tp3.layout(minWidth: 0, maxWidth: size.width,);
    tp3.paint(canvas, Offset(size.width - 8 - renderParagraph.getMinIntrinsicWidth(20).ceilToDouble() , 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}