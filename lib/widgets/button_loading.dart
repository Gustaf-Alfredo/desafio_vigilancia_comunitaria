import 'package:flutter/material.dart';

class ButtonLoading extends StatelessWidget {
  const ButtonLoading({
    super.key,
    required this.textButton,
    required this.textLoading,
    required this.validator,
    required this.onPressed,
  });
  final String textButton;
  final String textLoading;
  final bool validator;
  final Function onPressed;

  Widget _buildLoading(BuildContext context) {
    return SizedBox.square(
      dimension: 20.0,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        backgroundColor: Colors.red,
        color: Colors.white.withOpacity(0.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: FilledButton(
        child: Text(
          textButton,
        ),
        onPressed: () => onPressed,
      ),
      secondChild: FilledButton.icon(
        icon: _buildLoading(context),
        label:Text(textLoading),
        
        onPressed: () {},
      ),
      crossFadeState:
          validator ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 100),
    );
  }
}
