import 'package:flutter/material.dart';

class AnimatedButton extends StatefulWidget {
  final GestureTapCallback onPressed;
  final Widget child;
  final bool enabled;
  final Color color;
  final double height;
  final double width;
  final ShadowDegree shadowDegree;
  final int duration;
  final BoxShape shape;

  const AnimatedButton(
      {Key? key,
        required this.onPressed,
        required this.child,
        this.enabled = true,
        this.color = Colors.blue,
        this.height = 64,
        this.shadowDegree = ShadowDegree.light,
        this.width = 200,
        this.duration = 70,
        this.shape = BoxShape.rectangle})
      : assert(child != null),
        super(key: key);

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  static const Curve _curve = Curves.easeIn;
  static const double _shadowHeight = 8;
  double _position = 8;
  Color buttonUpColor = const Color(0xffeb6100);
  Color buttonDownColor = const Color(0xff873800);
  Color buttonColor = const Color(0xffeb6100);

  @override
  Widget build(BuildContext context) {
    final double _height = widget.height - _shadowHeight;


    return GestureDetector(
      // width here is required for centering the button in parent
      child: Container(
        width: widget.width,
        height: _height + _shadowHeight,
        child: Stack(
          children: <Widget>[
            // background shadow serves as drop shadow
            // width is necessary for bottom shadow
            Positioned(
              bottom: 0,
              child: Container(
                height: _height,
                width: widget.width,
                decoration: BoxDecoration(
                    color: widget.enabled
                        ? darken(buttonColor, widget.shadowDegree)
                        : darken(Colors.grey, widget.shadowDegree),
                    borderRadius: widget.shape != BoxShape.circle
                        ? BorderRadius.all(
                      Radius.circular(16),
                    )
                        : null,
                    shape: widget.shape),
              ),
            ),
            AnimatedPositioned(
              curve: _curve,
              duration: Duration(milliseconds: widget.duration),
              bottom: _position,
              child: Container(
                height: _height,
                width: widget.width,
                decoration: BoxDecoration(
                    color: widget.enabled ? buttonColor : Colors.grey,
                    borderRadius: widget.shape != BoxShape.circle
                        ? BorderRadius.all(
                      Radius.circular(16),
                    )
                        : null,
                    shape: widget.shape),
                child: Center(
                  child: widget.child,
                ),
              ),
            ),
          ],
        ),
      ),
      onTapDown: widget.enabled ? _pressed : null,
      onTapUp: widget.enabled ? _unPressedOnTapUp : null,
      onTapCancel: widget.enabled ? _unPressed : null,
    );
  }

  void _pressed(_) {
    setState(() {
      _position = 0;
      buttonColor = darken(buttonColor, widget.shadowDegree);
    });
  }

  void _unPressedOnTapUp(_) => _unPressed();

  void _unPressed() {
    setState(() {
      _position = 8;
      buttonColor = buttonUpColor;
    });
    widget.onPressed();
  }
}

// Get a darker color from any entered color.
// Thanks to @NearHuscarl on StackOverflow
Color darken(Color color, ShadowDegree degree) {
  double amount = degree == ShadowDegree.dark ? 0.3 : 0.12;
  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

enum ShadowDegree { light, dark }