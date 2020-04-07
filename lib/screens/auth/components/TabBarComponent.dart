import 'package:e_doctor/constants/colors.dart';
import 'package:flutter/material.dart';

class TabBarComponent extends StatelessWidget {
  TabBarComponent({@required this.tabs, @required this.tabViews, this.labelColor = PALE_ORANGE});

  final Color labelColor;
  final List<String> tabs;
  final List<Widget> tabViews;

  @override
  Widget build(BuildContext context) => body(context);

  Widget body(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(5000),
          child: Container(
              height: 90.0,
              decoration: containerDecoration(),
              padding: EdgeInsets.only(top: 20),
              child: tabBarComponent()),
        ),
        body: tabBarViews(),
      ),
    );
  }

  Decoration containerDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(25),
        bottomRight: Radius.circular(25),
      ),
      boxShadow: [
        BoxShadow(
          color: BLACK_COLOR.withOpacity(.1),
          blurRadius: 16,
          offset: Offset(0, 4),
        )
      ],
    );
  }

  Widget tabBarComponent() {
    return TabBar(
      labelColor: labelColor,
      unselectedLabelColor: Color(0xFFB6B6B6),
      indicator: CustomTabIndicator(labelColor: labelColor),
      labelStyle: TextStyle(
          fontSize: 18, fontFamily: 'Roboto', fontWeight: FontWeight.w500),
      tabs: tabs.map((tab) => Tab(text: tab)).toList(),
    );
  }

  Widget tabBarViews() {
    return TabBarView(
      physics: BouncingScrollPhysics(),
      children: tabViews,
    );
  }
}

/* ---------------------CUSTOM_PAINTER------------------------ */
class CustomTabIndicator extends Decoration {
  CustomTabIndicator({this.labelColor});

  final Color labelColor;

  @override
  _CustomPainter createBoxPainter([VoidCallback onChanged]) =>
      _CustomPainter(this, onChanged, labelColor);
}

class _CustomPainter extends BoxPainter {
  final CustomTabIndicator decoration;
  final Color labelColor;

  _CustomPainter(this.decoration, VoidCallback onChanged, this.labelColor)
      : assert(decoration != null),
        super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration != null);
    assert(configuration.size != null);

    final Rect rect = Rect.fromLTWH(
        configuration.size.width / 2 + offset.dx - 35, offset.dy + 65, 75, 5);
    final Paint paint = Paint();
    paint.color = labelColor;
    paint.style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        rect,
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
      paint,
    );
  }
}