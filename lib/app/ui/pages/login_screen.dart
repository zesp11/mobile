import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotale/app/controllers/auth_controller.dart';

/*
 BUG: the problem with LoginScreen showing retry button, is 
 because it's wrapped in ProfileScreen onEmpty if user is not 
 authenticated yet, but on failed login the LoginScreen throws 
 error, which causes parent to show ErrorScreen,
 because both (LoginScreen, ProfileScreen) share authController
 and manage one state.
 TODO: fix above but
 */
class LoginScreen extends GetView<AuthController> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: TweenAnimationBuilder(
              duration: Duration(milliseconds: 800),
              tween: Tween<double>(begin: 0, end: 1),
              builder: (context, double value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  Hero(
                    tag: 'welcome_text',
                    child: Text(
                      'welcome_back'.tr,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'login_subtitle'.tr,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onBackground.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Email input with animation
                  TweenAnimationBuilder(
                    duration: Duration(milliseconds: 600),
                    tween:
                        Tween<Offset>(begin: Offset(-0.2, 0), end: Offset.zero),
                    builder: (context, Offset offset, child) {
                      return Transform.translate(
                        offset: offset * 100,
                        child: child,
                      );
                    },
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'email'.tr,
                        hintText: 'enter_email'.tr,
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: theme.colorScheme.tertiary,
                        ),
                        filled: true,
                        fillColor: theme.cardTheme.color,
                        labelStyle: TextStyle(
                          color: theme.colorScheme.tertiary,
                        ),
                        floatingLabelStyle: TextStyle(
                          color: theme.colorScheme.secondary,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: theme.colorScheme.tertiary.withOpacity(0.2),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: theme.colorScheme.tertiary.withOpacity(0.2),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      style: theme.textTheme.bodyLarge,
                      cursorColor: theme.colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Password input with animation
                  TweenAnimationBuilder(
                    duration: Duration(milliseconds: 600),
                    tween:
                        Tween<Offset>(begin: Offset(0.2, 0), end: Offset.zero),
                    curve: Curves.easeOutCubic,
                    builder: (context, Offset offset, child) {
                      return Transform.translate(
                        offset: offset * 100,
                        child: child,
                      );
                    },
                    child: TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'password'.tr,
                        hintText: 'enter_password'.tr,
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: theme.colorScheme.tertiary,
                        ),
                        filled: true,
                        fillColor: theme.cardTheme.color,
                        labelStyle: TextStyle(
                          color: theme.colorScheme.tertiary,
                        ),
                        floatingLabelStyle: TextStyle(
                          color: theme.colorScheme.secondary,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: theme.colorScheme.tertiary.withOpacity(0.2),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: theme.colorScheme.tertiary.withOpacity(0.2),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                      obscureText: true,
                      style: theme.textTheme.bodyLarge,
                      cursorColor: theme.colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Error and Loading States
                  controller.obx(
                    onLoading: Center(
                      child: Column(
                        children: [
                          TweenAnimationBuilder(
                            duration: Duration(milliseconds: 400),
                            tween: Tween<double>(begin: 0, end: 1),
                            builder: (context, double value, child) {
                              return Transform.scale(
                                scale: value,
                                child: child,
                              );
                            },
                            child: CircularProgressIndicator(
                              color: theme.colorScheme.secondary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'logging_in'.tr,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    onError: (error) => TweenAnimationBuilder(
                      duration: Duration(milliseconds: 400),
                      tween: Tween<double>(begin: 0, end: 1),
                      builder: (context, double value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Opacity(
                            opacity: value,
                            child: child,
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: theme.colorScheme.error,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: theme.colorScheme.error,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'login_failed'.tr,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    onEmpty: const SizedBox.shrink(),
                    (state) => const SizedBox.shrink(),
                  ),

                  // Login Button with animation
                  TweenAnimationBuilder(
                    duration: Duration(milliseconds: 600),
                    tween: Tween<double>(begin: 0, end: 1),
                    curve: Curves.easeOut,
                    builder: (context, double value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                final email = emailController.text.trim();
                                final password = passwordController.text.trim();

                                if (email.isEmpty || password.isEmpty) {
                                  Get.snackbar(
                                    'error'.tr,
                                    'credentials_required'.tr,
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: theme.colorScheme.error
                                        .withOpacity(0.1),
                                    colorText: theme.colorScheme.error,
                                    margin: const EdgeInsets.all(16),
                                    borderRadius: 12,
                                  );
                                  return;
                                }

                                await controller.login(email, password);
                              },
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: isDark
                                    ? theme.colorScheme.secondary
                                    : theme.colorScheme.primary,
                                foregroundColor: isDark
                                    ? theme.colorScheme.onSecondary
                                    : theme.colorScheme.onPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'login'.tr,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    child: const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 24),

                  // Register Link with animation
                  TweenAnimationBuilder(
                    duration: Duration(milliseconds: 800),
                    tween: Tween<double>(begin: 0, end: 1),
                    curve: Curves.easeOut,
                    builder: (context, double value, child) {
                      return Opacity(
                        opacity: value,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: child,
                        ),
                      );
                    },
                    child: Center(
                      child: TextButton(
                        onPressed: () => Get.toNamed('/register'),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          '${'no_account_question'.tr} ${'register'.tr}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.secondary,
                            decoration: TextDecoration.underline,
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
      floatingActionButton: TweenAnimationBuilder(
        duration: Duration(milliseconds: 600),
        tween: Tween<double>(begin: 0, end: 1),
        curve: Curves.elasticOut,
        builder: (context, double value, child) {
          return Transform.scale(
            scale: value,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: child,
            ),
          );
        },
        child: FloatingActionButton(
          heroTag: 'login_settings_fab',
          onPressed: () => Get.toNamed('/settings'),
          backgroundColor: theme.colorScheme.secondary,
          elevation: 0,
          child: Icon(Icons.settings),
        ),
      ),
    );
  }
}
