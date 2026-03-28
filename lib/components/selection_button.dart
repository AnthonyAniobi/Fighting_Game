import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart'
    show Colors, TextStyle, FontWeight, Paint, Color, PaintingStyle;

class SelectionButton extends PositionComponent with HasVisibility {
  String text = 'Hello';
  Color backgroundColor = Colors.orange;
  final void Function()? onPressed;
  late ButtonComponent buttonComponent;

  SelectionButton({this.onPressed});

  @override
  Future<void> onLoad() async {
    super.onLoad();
    buttonComponent = ButtonComponent(
      anchor: Anchor.bottomCenter,
      button: RectangleComponent(
        size: Vector2(200, 50),
        paint: Paint()
          ..color = backgroundColor
          ..style = PaintingStyle.fill
          ..strokeWidth = 2.0,
      ),
      onPressed: onPressed,
      children: [
        TextComponent(
          text: text,
          textRenderer: TextPaint(
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          position: Vector2(100, 25),
          anchor: Anchor.center,
          priority: 20,
        ),
      ],
    );
    add(buttonComponent);
  }

  void hide() {
    isVisible = false;
  }

  void show() {
    isVisible = true;
  }
}
