import 'package:flutter/material.dart';

void main() {
  runApp(const AbsorbPointerDemoApp());
}

class AbsorbPointerDemoApp extends StatelessWidget {
  const AbsorbPointerDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AbsorbPointer Widget Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        cardTheme: const CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
        ),
      ),
      home: const DemoHomePage(),
    );
  }
}

class DemoHomePage extends StatelessWidget {
  const DemoHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 375,
        height: 812,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Scaffold(
            appBar: AppBar(
              title: const Text('AbsorbPointer Demo'),
              centerTitle: true,
              elevation: 0,
            ),
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
          _buildDemoCard(
            Icons.touch_app,
            'Basic Example',
            'Toggle to enable/disable button interaction',
            const BasicExample(),
            Colors.blue,
          ),
          _buildDemoCard(
            Icons.assignment_turned_in,
            'Form Validation',
            'Disable form until validation passes',
            const FormExample(),
            Colors.green,
          ),
          _buildDemoCard(
            Icons.hourglass_empty,
            'Loading State',
            'Prevent interaction during loading',
            const LoadingExample(),
            Colors.orange,
          ),
          _buildDemoCard(
            Icons.widgets,
            'Nested Widgets',
            'Control interaction of child widgets',
            const NestedExample(),
            Colors.purple,
          ),
          _buildDemoCard(
            Icons.gesture,
            'Gesture Conflicts',
            'Handle competing gestures with AbsorbPointer',
            const GestureConflictExample(),
            Colors.red,
          ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDemoCard(IconData icon, String title, String description, Widget demo, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(description, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            demo,
          ],
        ),
      ),
    );
  }
}

// Example 1: Basic AbsorbPointer usage
class BasicExample extends StatefulWidget {
  const BasicExample({super.key});

  @override
  State<BasicExample> createState() => _BasicExampleState();
}

class _BasicExampleState extends State<BasicExample> with TickerProviderStateMixin {
  bool _absorbing = false;
  int _counter = 0;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Switch(
                value: _absorbing,
                onChanged: (value) {
                  setState(() => _absorbing = value);
                  if (value) {
                    _animationController.forward();
                  } else {
                    _animationController.reverse();
                  }
                },
              ),
              const SizedBox(width: 8),
              const Text('Absorb Pointer Events'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _absorbing ? _scaleAnimation.value : 1.0,
              child: AbsorbPointer(
                absorbing: _absorbing,
                child: ElevatedButton.icon(
                  onPressed: () => setState(() => _counter++),
                  icon: const Icon(Icons.touch_app),
                  label: Text('Clicked $_counter times'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _absorbing ? Colors.grey : Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: (_absorbing ? Colors.red : Colors.green).withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _absorbing ? Colors.red : Colors.green,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _absorbing ? Icons.block : Icons.check_circle,
                color: _absorbing ? Colors.red : Colors.green,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                _absorbing ? 'Button is disabled' : 'Button is enabled',
                style: TextStyle(
                  color: _absorbing ? Colors.red : Colors.green,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

// Example 2: Form validation scenario
class FormExample extends StatefulWidget {
  const FormExample({super.key});

  @override
  State<FormExample> createState() => _FormExampleState();
}

class _FormExampleState extends State<FormExample> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_validateForm);
    _emailController.addListener(_validateForm);
  }

  void _validateForm() {
    setState(() {
      _isValid = _nameController.text.isNotEmpty && 
                 _emailController.text.contains('@');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: 'Name',
            prefixIcon: const Icon(Icons.person),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.grey[50],
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            prefixIcon: const Icon(Icons.email),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.grey[50],
          ),
        ),
        const SizedBox(height: 20),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          child: AbsorbPointer(
            absorbing: !_isValid,
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: 8),
                        Text('Form submitted successfully!'),
                      ],
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              icon: const Icon(Icons.send),
              label: const Text('Submit Form'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isValid ? Colors.green : Colors.grey,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: (_isValid ? Colors.green : Colors.orange).withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isValid ? Colors.green : Colors.orange,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _isValid ? Icons.check_circle : Icons.warning,
                color: _isValid ? Colors.green : Colors.orange,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                _isValid ? 'Form is valid' : 'Please fill all fields correctly',
                style: TextStyle(
                  color: _isValid ? Colors.green : Colors.orange,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}

// Example 3: Loading state
class LoadingExample extends StatefulWidget {
  const LoadingExample({super.key});

  @override
  State<LoadingExample> createState() => _LoadingExampleState();
}

class _LoadingExampleState extends State<LoadingExample> {
  bool _isLoading = false;

  Future<void> _simulateNetworkCall() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 3));
    setState(() => _isLoading = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data loaded successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AbsorbPointer(
          absorbing: _isLoading,
          child: Column(
            children: [
              ElevatedButton(
                onPressed: _simulateNetworkCall,
                child: const Text('Load Data'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Another Button'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (_isLoading)
          const Column(
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 8),
              Text('Loading... All interactions disabled'),
            ],
          ),
      ],
    );
  }
}

// Example 4: Nested widgets
class NestedExample extends StatefulWidget {
  const NestedExample({super.key});

  @override
  State<NestedExample> createState() => _NestedExampleState();
}

class _NestedExampleState extends State<NestedExample> {
  bool _absorbing = false;
  int _button1Count = 0;
  int _button2Count = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Checkbox(
              value: _absorbing,
              onChanged: (value) => setState(() => _absorbing = value!),
            ),
            const Text('Disable entire container'),
          ],
        ),
        const SizedBox(height: 16),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          child: AbsorbPointer(
            absorbing: _absorbing,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _absorbing 
                    ? [Colors.red.withOpacity(0.1), Colors.red.withOpacity(0.05)]
                    : [Colors.green.withOpacity(0.1), Colors.green.withOpacity(0.05)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: _absorbing ? Colors.red : Colors.green,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _absorbing ? Icons.block : Icons.widgets,
                        color: _absorbing ? Colors.red : Colors.green,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Container ${_absorbing ? "DISABLED" : "ENABLED"}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _absorbing ? Colors.red : Colors.green,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => setState(() => _button1Count++),
                        icon: const Icon(Icons.add),
                        label: Text('Button 1\n($_button1Count)'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => setState(() => _button2Count++),
                        icon: const Icon(Icons.star),
                        label: Text('Button 2\n($_button2Count)'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Example 5: Gesture Conflicts
class GestureConflictExample extends StatefulWidget {
  const GestureConflictExample({super.key});

  @override
  State<GestureConflictExample> createState() => _GestureConflictExampleState();
}

class _GestureConflictExampleState extends State<GestureConflictExample> {
  bool _absorbTap = false;
  bool _absorbDrag = false;
  String _lastGesture = 'None';
  Offset _position = const Offset(100, 100);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Controls
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Switch(
                    value: _absorbTap,
                    onChanged: (value) => setState(() => _absorbTap = value),
                  ),
                  const SizedBox(width: 8),
                  const Text('Block Tap Gestures'),
                ],
              ),
              Row(
                children: [
                  Switch(
                    value: _absorbDrag,
                    onChanged: (value) => setState(() => _absorbDrag = value),
                  ),
                  const SizedBox(width: 8),
                  const Text('Block Drag Gestures'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        // Gesture Area
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.withOpacity(0.1), Colors.purple.withOpacity(0.1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Stack(
            children: [
              // Background tap detector
              GestureDetector(
                onTap: () {
                  setState(() => _lastGesture = 'Background Tapped');
                },
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.transparent,
                ),
              ),
              
              // Draggable widget with AbsorbPointer
              Positioned(
                left: _position.dx,
                top: _position.dy,
                child: AbsorbPointer(
                  absorbing: _absorbTap,
                  child: AbsorbPointer(
                    absorbing: _absorbDrag,
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _lastGesture = 'Circle Tapped');
                      },
                      onPanUpdate: (details) {
                        setState(() {
                          _position = Offset(
                            (_position.dx + details.delta.dx).clamp(0, 250),
                            (_position.dy + details.delta.dy).clamp(0, 120),
                          );
                          _lastGesture = 'Circle Dragged';
                        });
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.orange, Colors.red],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.touch_app,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Status display
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.indigo.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.indigo),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.info, color: Colors.indigo, size: 20),
              const SizedBox(width: 8),
              Text(
                'Last Gesture: $_lastGesture',
                style: const TextStyle(
                  color: Colors.indigo,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 8),
        
        Text(
          'Try tapping the background, tapping the circle, or dragging the circle.\nUse switches to block specific gestures.',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}