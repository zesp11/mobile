// Suggests games based on user preferences.
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goadventure/app/controllers/game_controller.dart';
import 'package:goadventure/app/ui/widgets/section_widget.dart';

class RecommendedGamesWidget extends StatelessWidget {
  final GameSelectionController controller = Get.find();

  RecommendedGamesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SectionWidget(
      title: "recommended_games".tr,
      child: Obx(() {
        if (controller.isAvailableGamebooksLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: Color(0xFFFA802F),
            ),
          );
        }

        if (controller.availableGamebooks.isEmpty) {
          return Center(
            child: Text(
              "no_recommended_games".tr,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF9C8B73).withOpacity(0.6),
              ),
            ),
          );
        }

        return Column(
          children: controller.availableGamebooks.map((gamebook) {
            return Container(
              height: 90, // Reduced height for single-line layout
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: Color(0xFF9C8B73).withOpacity(0.2),
                    width: 1,
                  ),
                ),
                elevation: 2,
                color:
                    Color(0xFFF3E8CA).withOpacity(0.7), // Brighter background
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => Get.toNamed('/scenario/${gamebook.id}'),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        // Icon Container
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Color(0xFFFA802F).withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.auto_awesome,
                            color: Color(0xFFFA802F),
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 16),
                        // Title and Rating
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      gamebook.title,
                                      style: TextStyle(
                                        fontSize: 18, // Larger text
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF322505),
                                        height: 1.2,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Color(0xFFFA802F),
                                          size: 18,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          "9.1",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF9C8B73),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Arrow aligned with title
                              Padding(
                                padding: EdgeInsets.only(left: 12),
                                child: Icon(
                                  Icons.arrow_forward,
                                  color: Color(0xFF9C8B73).withOpacity(0.6),
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      }),
    );
  }
}
