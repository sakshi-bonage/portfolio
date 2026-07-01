import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../services/email_service.dart';

class ContactSection extends StatefulWidget {
  final GlobalKey sectionKey;

  const ContactSection({required this.sectionKey, super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  // Controllers matching EmailJS template variables: {{name}}, {{email}}, {{message}}
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  final ValueNotifier<bool> _isButtonHovered = ValueNotifier(false);
  final ValueNotifier<bool> _isCardHovered = ValueNotifier(false);
  final ValueNotifier<bool> _isSending = ValueNotifier(false);

  double _targetX = 0.0;
  double _targetY = 0.0;
  double _lerpX = 0.0;
  double _lerpY = 0.0;
  late AnimationController _physicsController;

  @override
  void initState() {
    super.initState();
    _physicsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16),
    )..addListener(_applySmoothInterpolation);
  }

  void _applySmoothInterpolation() {
    if (!mounted) return;
    setState(() {
      _lerpX = _lerpX + (_targetX - _lerpX) * 0.12;
      _lerpY = _lerpY + (_targetY - _lerpY) * 0.12;
    });
    if (_isCardHovered.value &&
        ((_targetX - _lerpX).abs() > 0.001 ||
            (_targetY - _lerpY).abs() > 0.001)) {
      _physicsController.forward(from: 0.0);
    }
  }

  void _updateGestureOffset(PointerEvent details, Size size) {
    _targetX = (0.5 - details.localPosition.dy / size.height) * 0.12;
    _targetY = (details.localPosition.dx / size.width - 0.5) * 0.12;
    if (!_physicsController.isAnimating) {
      _physicsController.forward(from: 0.0);
    }
  }

  void _resetGestureOffset() {
    _targetX = 0.0;
    _targetY = 0.0;
    if (!_physicsController.isAnimating) {
      _physicsController.forward(from: 0.0);
    }
  }

  Future<void> _sendEmail() async {
    if (!_formKey.currentState!.validate()) return;

    _isSending.value = true;
    try {
      await EmailService.sendEmail(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        message: _messageController.text.trim(),
      );

      if (!mounted) return;
      _formKey.currentState!.reset();
      _nameController.clear();
      _emailController.clear();
      _messageController.clear();
      _showSnackBar('Message sent successfully!', isError: false);
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('Failed to send message. Please try again.', isError: true);
    } finally {
      _isSending.value = false;
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline_rounded : Icons.check_circle_outline_rounded,
              color: isError ? Colors.redAccent : const Color(0xFF45F3FF),
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF141D26),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(24),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    _isButtonHovered.dispose();
    _isCardHovered.dispose();
    _isSending.dispose();
    _physicsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 950;

    return Container(
      key: widget.sectionKey,
      width: double.infinity,
      color: const Color(0xFF0D0E12),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 140,
        vertical: isMobile ? 80 : 120,
      ),
      child: Flex(
        direction: isMobile ? Axis.vertical : Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // LEFT: Contact info
          Expanded(
            flex: isMobile ? 0 : 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Get In Touch',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Let's work together!",
                  style: TextStyle(
                    color: Color(0xFF45F3FF),
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1.0,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "I'm currently looking for new opportunities. Whether you have a question or just want to say hi, I'll try my best to get back to you!",
                  style: TextStyle(
                    color: Color(0xFF9EAFBC),
                    fontSize: 15,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 48),
                _buildInfoTile(
                  icon: Icons.mail_outline_rounded,
                  title: 'Email',
                  data: 'sakshibonage22@gmail.com',
                  onTap: () => _launchUrl('mailto:sakshibonage22@gmail.com'),
                ),
                const SizedBox(height: 28),
                _buildInfoTile(
                  icon: Icons.link_rounded,
                  title: 'LinkedIn',
                  data: 'linkedin.com/in/sakshi-bonage-6102a8347',
                  onTap: () => _launchUrl(
                      'https://www.linkedin.com/in/sakshi-bonage-6102a8347/'),
                ),
                const SizedBox(height: 28),
                _buildInfoTile(
                  icon: Icons.code_rounded,
                  title: 'GitHub',
                  data: 'github.com/sakshi-bonage',
                  onTap: () =>
                      _launchUrl('https://github.com/sakshi-bonage'),
                ),
              ],
            ),
          ),

          if (!isMobile) const SizedBox(width: 80),
          if (isMobile) const SizedBox(height: 56),

          // RIGHT: Contact form
          Expanded(
            flex: isMobile ? 0 : 5,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final cardSize =
                    Size(constraints.maxWidth, constraints.maxHeight);
                return MouseRegion(
                  onEnter: (_) => _isCardHovered.value = true,
                  onHover: (e) => _updateGestureOffset(e, cardSize),
                  onExit: (_) {
                    _isCardHovered.value = false;
                    _resetGestureOffset();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutCubic,
                    padding: EdgeInsets.all(isMobile ? 24 : 40),
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateX(_lerpX)
                      ..rotateY(_lerpY),
                    decoration: BoxDecoration(
                      color: const Color(0xFF13151A),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: _isCardHovered.value
                            ? const Color(0xFF45F3FF).withValues(alpha: 0.2)
                            : Colors.white.withValues(alpha: 0.02),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _isCardHovered.value
                              ? const Color(0xFF45F3FF).withValues(alpha: 0.04)
                              : Colors.black38,
                          blurRadius: _isCardHovered.value ? 40 : 25,
                          offset:
                              Offset(0, _isCardHovered.value ? 16 : 10),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Send Message',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 28),

                          // {{name}}
                          _buildFormLabel('Name'),
                          const SizedBox(height: 8),
                          _buildTextField(
                            controller: _nameController,
                            hint: 'Your Name',
                            validator: (val) => (val == null || val.trim().isEmpty)
                                ? 'Name is required.'
                                : null,
                          ),
                          const SizedBox(height: 20),

                          // {{email}}
                          _buildFormLabel('Email'),
                          const SizedBox(height: 8),
                          _buildTextField(
                            controller: _emailController,
                            hint: 'your.email@example.com',
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'Email is required.';
                              }
                              if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')
                                  .hasMatch(val.trim())) {
                                return 'Enter a valid email address.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // {{message}}
                          _buildFormLabel('Message'),
                          const SizedBox(height: 8),
                          _buildTextField(
                            controller: _messageController,
                            hint: 'Write your message here...',
                            maxLines: 5,
                            validator: (val) => (val == null || val.trim().isEmpty)
                                ? 'Message is required.'
                                : null,
                          ),
                          const SizedBox(height: 32),

                          // Send button
                          MouseRegion(
                            onEnter: (_) => _isButtonHovered.value = true,
                            onExit: (_) => _isButtonHovered.value = false,
                            child: ValueListenableBuilder<bool>(
                              valueListenable: _isSending,
                              builder: (context, sending, _) {
                                return ValueListenableBuilder<bool>(
                                  valueListenable: _isButtonHovered,
                                  builder: (context, hovered, _) {
                                    return SizedBox(
                                      width: double.infinity,
                                      height: 52,
                                      child: ElevatedButton(
                                        onPressed:
                                            sending ? null : _sendEmail,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: hovered
                                              ? const Color(0xFF00B4D8)
                                              : const Color(0xFF45F3FF),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          elevation: 0,
                                        ),
                                        child: sending
                                            ? const SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 2,
                                                ),
                                              )
                                            : Text(
                                                'Send Message',
                                                style: TextStyle(
                                                  color: hovered
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String data,
    required VoidCallback onTap,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF141D26),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.03)),
          ),
          child: Icon(icon, size: 20, color: const Color(0xFF45F3FF)),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              RichText(
                text: TextSpan(
                  text: data,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = onTap,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFormLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required String? Function(String?) validator,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
        filled: true,
        fillColor: const Color(0xFF0B0C10),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: Color(0xFF45F3FF), width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
    );
  }
}
