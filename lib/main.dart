import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Choose Answer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const ChooseAnswerScreen(),
    );
  }
}

class ChooseAnswerScreen extends StatefulWidget {
  const ChooseAnswerScreen({super.key});

  @override
  State<ChooseAnswerScreen> createState() => _ChooseAnswerScreenState();
}

class _ChooseAnswerScreenState extends State<ChooseAnswerScreen> {
  String? _selectedAnswer;
  bool _showConfirmation = false;

  void _onAnswerSelected(String answer) {
    setState(() {
      _selectedAnswer = answer;
      _showConfirmation = true;
    });

    // Hide confirmation after 1.5 seconds
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _showConfirmation = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Dark title bar
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 20,
              bottom: 25,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF2D2D3A),
                  Color(0xFF1A1A24),
                ],
              ),
            ),
            child: Center(
              child: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Choose ',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    TextSpan(
                      text: 'your answer',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFB0B0B0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Answer buttons grid
          Expanded(
            child: Container(
              color: const Color(0xFFF5F5F5),
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: GridView.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            AnswerButton(
                              label: 'A',
                              color: const Color(0xFF4CAF50),
                              isSelected: _selectedAnswer == 'A',
                              onTap: () => _onAnswerSelected('A'),
                            ),
                            AnswerButton(
                              label: 'B',
                              color: const Color(0xFF3F51B5),
                              isSelected: _selectedAnswer == 'B',
                              onTap: () => _onAnswerSelected('B'),
                            ),
                            AnswerButton(
                              label: 'C',
                              color: const Color(0xFFD4A732),
                              isSelected: _selectedAnswer == 'C',
                              onTap: () => _onAnswerSelected('C'),
                            ),
                            AnswerButton(
                              label: 'D',
                              color: const Color(0xFFC0392B),
                              isSelected: _selectedAnswer == 'D',
                              onTap: () => _onAnswerSelected('D'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Confirmation text
                  AnimatedOpacity(
                    opacity: _showConfirmation ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade600,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Text(
                        'Selection registered',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AnswerButton extends StatefulWidget {
  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const AnswerButton({
    super.key,
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<AnswerButton> createState() => _AnswerButtonState();
}

class _AnswerButtonState extends State<AnswerButton> {
  bool _isPressed = false;

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
  }

  void _onTap() {
    // Trigger haptic feedback (vibration)
    HapticFeedback.mediumImpact();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate highlight color (brighter when selected or pressed)
    final bool isHighlighted = _isPressed || widget.isSelected;
    final Color displayColor = isHighlighted
        ? Color.lerp(widget.color, Colors.white, 0.3)!
        : widget.color;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: _onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: displayColor,
            borderRadius: BorderRadius.circular(16),
            border: widget.isSelected
                ? Border.all(color: Colors.white, width: 4)
                : null,
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: widget.isSelected ? 0.5 : 0.3),
                blurRadius: widget.isSelected ? 16 : 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              widget.label,
              style: const TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
