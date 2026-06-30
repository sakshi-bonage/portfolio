import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:emailjs/emailjs.dart' as emailjs;

class ContactSection extends StatefulWidget {
  final bool isMobile;
  final GlobalKey sectionKey;

  const ContactSection({
    super.key,
    required this.isMobile,
    required this.sectionKey,
  });

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> with TickerProviderStateMixin {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final subjectController = TextEditingController();
  final messageController = TextEditingController();

  final ValueNotifier<bool> _isSendingNotifier = ValueNotifier(false);
  final ValueNotifier<bool> _isSubmitHovered = ValueNotifier(false);

  // 3D Animation Controllers and States
  late AnimationController _hoverController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  double _rotateX = 0.0;
  double _rotateY = 0.0;
  bool _isCardHovered = false;

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-.]+@([\w-]+.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> sendEmail() async {
    // Basic Form Validations to prevent blank submissions
    if (nameController.text.trim().isEmpty) {
      _showCustomSnackBar("Please enter your name", isError: true);
      return;
    }
    if (emailController.text.trim().isEmpty) {
      _showCustomSnackBar("Please enter your email address", isError: true);
      return;
    }
    if (!_isValidEmail(emailController.text.trim())) {
      _showCustomSnackBar("Please enter a valid email address", isError: true);
      return;
    }
    if (messageController.text.trim().isEmpty) {
      _showCustomSnackBar("Please enter a message description", isError: true);
      return;
    }

    _isSendingNotifier.value = true;

    try {
      await emailjs.send(
        'service_v88gjq9',
        'template_6nl26f6',
        {
          'from_name': nameController.text.trim(),
          'from_email': emailController.text.trim(),
          'subject': subjectController.text.trim().isEmpty 
              ? 'Portfolio Message' 
              : subjectController.text.trim(),
          'message': messageController.text.trim(),
        },
        const emailjs.Options(publicKey: 'h7HErSc8CO4hMHOCU'),
      );

      if (!mounted) return;

      _showCustomSnackBar("Message delivered successfully!", isError: false);

      nameController.clear();
      emailController.clear();
      subjectController.clear();
      messageController.clear();
    } catch (e) {
      _showCustomSnackBar(
        "Failed to route message. Please try again.",
        isError: true,
      );
    } finally {
      _isSendingNotifier.value = false;
    }
  }

  void _showCustomSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError
                  ? Icons.error_outline_rounded
                  : Icons.check_circle_outline_rounded,
              color: isError ? Colors.redAccent : const Color(0xFF45F3FF),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
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

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0.0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOutCubic),
    );

    _hoverController.forward();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    subjectController.dispose();
    messageController.dispose();
    _isSendingNotifier.dispose();
    _isSubmitHovered.dispose();
    _hoverController.dispose();
    super.dispose();
  }

  void _updateCardPerspective(PointerHoverEvent event, RenderBox box) {
    if (widget.isMobile) {
      return;
    }

    final size = box.size;
    final localPosition = box.globalToLocal(event.position);
    
    final percentX = (localPosition.dx / size.width) - 0.5;
    final percentY = (localPosition.dy / size.height) - 0.5;

    setState(() {
      _rotateX = -percentY * 0.15;
      _rotateY = percentX * 0.15;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool useMobileLayout = widget.isMobile;

    return Container(
      key: widget.sectionKey,
      width: double.infinity,
      color: const Color(0xFF0B0C10), 
      padding: EdgeInsets.symmetric(
        horizontal: useMobileLayout ? 24 : 80,
        vertical: useMobileLayout ? 60 : 100,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Flex(
                direction: useMobileLayout ? Axis.vertical : Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // LEFT COLUMN - Contact Details
                  Expanded(
                    flex: useMobileLayout ? 0 : 1,
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: useMobileLayout ? 0 : 60, 
                        bottom: useMobileLayout ? 48 : 0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Get In Touch",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            "Let's work together!",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF45F3FF), 
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "I'm currently looking for new opportunities. Whether you have a question or just want to say hi, I'll try my best to get back to you!",
                            style: TextStyle(
                              color: Color(0xFF9CA3AF),
                              fontSize: 15,
                              height: 1.5,
                        ),
                      ),
                          const SizedBox(height: 48),
                          
                          _buildInfoItem(
                            icon: Icons.mail_outline_rounded,
                            label: "Email",
                            value: "sakshibonage22@gmail.com",
                            delay: 100,
                          ),
                          const SizedBox(height: 24),
                          _buildInfoItem(
                            icon: Icons.link_rounded,
                            label: "LinkedIn",
                            value: "://linkedin.com",
                            delay: 200,
                          ),
                          const SizedBox(height: 24),
                          _buildInfoItem(
                            icon: Icons.code_rounded,
                            label: "GitHub",
                            value: "://github.com",
                            delay: 300,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // RIGHT COLUMN - 3D Form Card
                  Expanded(
                    flex: useMobileLayout ? 0 : 1,
                    child: MouseRegion(
                      onEnter: (_) => setState(() => _isCardHovered = true),
                      onExit: (_) => setState(() {
                        _isCardHovered = false;
                        _rotateX = 0.0;
                        _rotateY = 0.0;
                      }),
                      onHover: (event) {
                        final box = context.findRenderObject() as RenderBox?;
                        if (box != null) _updateCardPerspective(event, box);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.easeOutCubic,
                        transformAlignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateX(_rotateX)
                        ..rotateY(_rotateY),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: const Color(0xFF141D26),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: _isCardHovered
                                  ? const Color(0xFF45F3FF).withValues(alpha: 0.3)
                                  : const Color(0xFF1F2937),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: _isCardHovered
                                    ? const Color(0xFF45F3FF).withValues(alpha: 0.08)
                                    : Colors.black.withValues(alpha: 0.2),
                                blurRadius: _isCardHovered ? 30 : 15,
                                offset: _isCardHovered
                                    ? const Offset(0, 10)
                                    : const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Send Message",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 24),
                              _buildTextField(
                                label: "Name",
                                hint: "Your Name",
                                controller: nameController,
                              ),
                              const SizedBox(height: 16),
                              _buildTextField(
                                label: "Email",
                                hint: "your.email@example.com",
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 16),
                              _buildTextField(
                                label: "Subject (Optional)",
                                hint: "Message subject",
                                controller: subjectController,
                              ),
                              const SizedBox(height: 16),
                              _buildTextField(
                                label: "Message",
                                hint: "Write your message here...",
                                controller: messageController,
                                maxLines: 5,
                              ),
                              const SizedBox(height: 24),

                              // Submit Button Module
                              MouseRegion(
                                onEnter: (_) => _isSubmitHovered.value = true,
                                onExit: (event) => _isSubmitHovered.value = false,
                                child: ValueListenableBuilder(
                                  valueListenable: _isSendingNotifier,
                                  builder: (context, isSending, child) {
                                    return ValueListenableBuilder(
                                      valueListenable: _isSubmitHovered,
                                      builder: (context, isHovered, child) {
                                        return AnimatedContainer(
                                          duration: const Duration(milliseconds: 200),
                                          width: double.infinity,
                                          height: 48,
                                          decoration: BoxDecoration(
                                            color: isSending
                                                ? const Color(0xFF1B1E26)
                                                : isHovered
                                                    ? const Color(0xFF3CD2DC)
                                                    : const Color(0xFF45F3FF),
                                            borderRadius: BorderRadius.circular(8),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0xFF45F3FF)
                                                    .withValues(alpha: isHovered ? 0.3 : 0.1),
                                                blurRadius: 12,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: ElevatedButton(
                                            onPressed: isSending ? null : sendEmail,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.transparent,
                                              shadowColor: Colors.transparent,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: child!,
                                          ),
                                        );
                                      },
                                      child: ValueListenableBuilder(
                                        valueListenable: _isSendingNotifier,
                                        builder: (context, sending, _) {
                                          if (sending) {
                                            return const Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 16,
                                                  height: 16,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2.5,
                                                    color: Color(0xFF0B0C10),
                                                  ),
                                                ),
                                                SizedBox(width: 12),
                                                Text(
                                                  "SENDING MESSAGE...",
                                                  style: TextStyle(
                                                    color: Color(0xFF0B0C10),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                          return const Text(
                                            "Send Message",
                                            style: TextStyle(
                                              color: Color(0xFF0B0C10),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required int delay,
  }) {
    final ValueNotifier<bool> isLinkHovered = ValueNotifier(false);
    return TweenAnimationBuilder(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + delay),
      curve: Curves.easeOut,
      builder: (context, animValue, child) {
        return Transform.translate(
          offset: Offset((1.0 - animValue) * -20, 0),
          child: Opacity(
            opacity: animValue,
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: () async {
          final Uri url;
          if (label.toLowerCase() == "email") {
            url = Uri(scheme: 'mailto', path: value);
          } else {
            final String cleanUrl = value.startsWith('http') ? value : 'https://$value';
            url = Uri.parse(cleanUrl);
          }
          try {
            await launchUrl(url, mode: LaunchMode.externalApplication);
          } catch (e) {
            if (context.mounted) {
              _showCustomSnackBar("Could not resolve action for: $value", isError: true);
            }
          }
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (event) => isLinkHovered.value = true,
          onExit: (event) => isLinkHovered.value = false,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF141D26),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF1F2937),
                    width: 1,
                  ),
                ),
                child: Icon(icon, color: const Color(0xFF45F3FF), size: 18),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        color: Color(0xFF9CA3AF),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 2),
                    ValueListenableBuilder(
                      valueListenable: isLinkHovered,
                      builder: (context, hovered, _) {
                        return AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            color: hovered ? const Color(0xFF45F3FF) : Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          child: Text(value),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF9CA3AF),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          cursorColor: const Color(0xFF45F3FF),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF4A5568), fontSize: 14),
            filled: true,
            fillColor: const Color(0xFF1C2733),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF2D3748), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF45F3FF), width: 1),
            ),
          ),
        ),
      ],
    );
  }
}
