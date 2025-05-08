import 'package:flutter/material.dart';
import 'package:gotale/app/controllers/auth_controller.dart';
import 'package:gotale/app/controllers/profile_controller.dart';
import 'package:get/get.dart';
import 'package:gotale/app/routes/app_routes.dart';
import 'package:gotale/app/ui/pages/error_screen.dart';

class UserProfileScreen extends GetView<ProfileController> {
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final String userId = Get.parameters['id']!;
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    // Redirect to '/profile' if the user views their own profile
    if (authController.state?.id.toString() == userId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.toNamed(AppRoutes.profile);
      });
    }

    // Fetch the user profile if it's not already loaded
    if (controller.state?.id.toString() != userId) {
      controller.fetchUserProfile(userId);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'user_profile'.tr,
          style: theme.textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: controller.obx(
        // Success state
        (userProfile) {
          if (userProfile == null) {
            return Center(
              child: Text(
                'user_not_found'.tr,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            );
          }

          return RefreshIndicator(
            color: theme.colorScheme.secondary,
            backgroundColor: theme.colorScheme.primary,
            onRefresh: () async => await controller.fetchUserProfile(userId),
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
                          CircleAvatar(
                            radius: isSmallScreen ? 50 : 60,
                            backgroundColor:
                                theme.colorScheme.secondary.withOpacity(0.1),
                            foregroundImage: userProfile.photoUrl != null
                                ? NetworkImage(userProfile.photoUrl!)
                                : null,
                            child: userProfile.photoUrl == null
                                ? Text(
                                    userProfile.login
                                        .substring(0, 1)
                                        .toUpperCase(),
                                    style: theme.textTheme.headlineMedium
                                        ?.copyWith(
                                      color: theme.colorScheme.secondary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: isSmallScreen ? 32 : 40,
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            userProfile.login,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (userProfile.email.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              userProfile.email,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.7),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Bio Section
                    if (userProfile.bio != null &&
                        userProfile.bio!.isNotEmpty) ...[
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
                          userProfile.bio!,
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
                                '${0}',
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
                  ],
                ),
              ),
            ),
          );
        },
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
        onEmpty: Center(
          child: Text(
            'user_not_found'.tr,
            style: theme.textTheme.titleMedium,
          ),
        ),
        onError: (error) => Center(
          child: ErrorScreen(
            error: error ?? 'error_loading_profile'.tr,
            onRetry: () => controller.fetchUserProfile(userId),
          ),
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
