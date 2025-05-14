import 'package:gotale/app/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotale/app/controllers/game_controller.dart';
import 'package:gotale/app/ui/pages/login_screen.dart';

class ProfileScreen extends GetView<AuthController> {
  final gameController = Get.find<GameSelectionController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: controller.obx(
        // Success state
        (userProfile) => SafeArea(
          child: RefreshIndicator(
            color: theme.colorScheme.secondary,
            backgroundColor: theme.colorScheme.primary,
            onRefresh: () async => await controller.checkAuthStatus(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 16.0 : size.width * 0.1,
                  vertical: 24.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Header
                    Center(
                      child: Column(
                        children: [
                          Hero(
                            tag: 'profile_avatar',
                            child: userProfile?.photoUrl == null
                                ? CircleAvatar(
                                    radius: isSmallScreen ? 50 : 60,
                                    backgroundColor: theme.colorScheme.secondary
                                        .withOpacity(0.1),
                                    child: Text(
                                      (userProfile?.login.substring(0, 1) ??
                                              '?')
                                          .toUpperCase(),
                                      style: theme.textTheme.headlineMedium
                                          ?.copyWith(
                                        color: theme.colorScheme.secondary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: isSmallScreen ? 32 : 40,
                                      ),
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: isSmallScreen ? 50 : 60,
                                    backgroundImage:
                                        NetworkImage(userProfile!.photoUrl!),
                                    backgroundColor: Colors.transparent,
                                  ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            userProfile?.email ?? '',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            userProfile?.email ?? '',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.7),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Bio Section
                    if (userProfile?.bio?.isNotEmpty ?? false) ...[
                      Text(
                        'bio'.tr,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.cardTheme.color,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: theme.colorScheme.outline.withOpacity(0.1),
                          ),
                        ),
                        child: Text(
                          userProfile?.bio ?? '',
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],

                    // Stats Section
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
                      decoration: BoxDecoration(
                        color: theme.cardTheme.color,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: theme.colorScheme.outline.withOpacity(0.1),
                        ),
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Wrap(
                            alignment: WrapAlignment.spaceAround,
                            spacing: constraints.maxWidth * 0.05,
                            runSpacing: 24,
                            children: [
                              _buildStatItem(
                                context,
                                'games_played'.tr,
                                '${gameController.state == null ? 0 : gameController.state!.length}',
                                Icons.sports_esports,
                                isSmallScreen,
                              ),
                              _buildStatItem(
                                context,
                                'scenarios_created'.tr,
                                '0',
                                Icons.create,
                                isSmallScreen,
                              ),
                              _buildStatItem(
                                context,
                                'achievements'.tr,
                                '0',
                                Icons.emoji_events,
                                isSmallScreen,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Action Buttons
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => Get.toNamed('/profile/edit'),
                          icon: Icon(
                            Icons.edit,
                            size: 20,
                            color: theme.colorScheme.onSecondary,
                          ),
                          label: Text('edit_profile'.tr),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            backgroundColor: isDark
                                ? theme.colorScheme.secondary
                                : theme.colorScheme.primary,
                            foregroundColor: isDark
                                ? theme.colorScheme.onSecondary
                                : theme.colorScheme.onPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton.icon(
                          onPressed: () {
                            Get.dialog(
                              AlertDialog(
                                title: Text('confirm_logout'.tr),
                                content: Text('logout_confirmation_message'.tr),
                                actions: [
                                  TextButton(
                                    onPressed: () => Get.back(),
                                    child: Text(
                                      'cancel'.tr,
                                      style: TextStyle(
                                        color: theme.colorScheme.secondary,
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Get.back();
                                      controller.logout();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: theme.colorScheme.error,
                                      foregroundColor:
                                          theme.colorScheme.onError,
                                    ),
                                    child: Text('logout'.tr),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.logout,
                            size: 20,
                            color: theme.colorScheme.error,
                          ),
                          label: Text(
                            'logout'.tr,
                            style: TextStyle(
                              color: theme.colorScheme.error,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            backgroundColor: theme.colorScheme.errorContainer
                                .withOpacity(0.1),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Loading state
        onLoading: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: theme.colorScheme.secondary,
              ),
              const SizedBox(height: 16),
              Text(
                'loading_profile'.tr,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onBackground.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),

        // Empty state (not logged in)
        onEmpty: LoginScreen(),

        // Error state
        onError: (error) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  error ?? 'error_loading_profile'.tr,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => controller.checkAuthStatus(),
                  icon: Icon(
                    Icons.refresh,
                    color: theme.colorScheme.onSecondary,
                  ),
                  label: Text('retry'.tr),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextButton.icon(
                  onPressed: () {
                    Get.dialog(
                      AlertDialog(
                        title: Text('confirm_logout'.tr),
                        content: Text('logout_confirmation_message'.tr),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(),
                            child: Text(
                              'cancel'.tr,
                              style: TextStyle(
                                color: theme.colorScheme.secondary,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Get.back();
                              controller.logout();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.error,
                              foregroundColor: theme.colorScheme.onError,
                            ),
                            child: Text('logout'.tr),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.logout,
                    size: 20,
                    color: theme.colorScheme.error,
                  ),
                  label: Text(
                    'logout'.tr,
                    style: TextStyle(
                      color: theme.colorScheme.error,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor:
                        theme.colorScheme.errorContainer.withOpacity(0.1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'profile_settings_fab',
        onPressed: () => Get.toNamed('/settings'),
        backgroundColor: theme.colorScheme.primary,
        tooltip: 'settings'.tr,
        child: Icon(
          Icons.settings,
          color: theme.colorScheme.onPrimary,
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    bool isSmallScreen,
  ) {
    final theme = Theme.of(context);

    return Container(
      width: isSmallScreen ? null : 160,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: theme.colorScheme.secondary,
              size: isSmallScreen ? 24 : 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.secondary,
              fontSize: isSmallScreen ? 24 : 28,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
