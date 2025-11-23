import 'package:flutter/material.dart';
import '../../shared/scale.dart';

class ProfileHeaderSection extends StatelessWidget {
  final String? profilePicUrl;
  final String displayName;
  final bool isEditing;
  final VoidCallback onChangePhoto;

  const ProfileHeaderSection({
    super.key,
    required this.profilePicUrl,
    required this.displayName,
    required this.isEditing,
    required this.onChangePhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: dp(context, 50),
                backgroundColor: Colors.white,
                child: profilePicUrl == null
                    ? Icon(
                        Icons.person,
                        size: dp(context, 48),
                        color: Colors.grey,
                      )
                    : ClipOval(
                        child: Image.network(
                          profilePicUrl!,
                          width: dp(context, 100),
                          height: dp(context, 100),
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) =>
                              progress == null
                                  ? child
                                  : const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.person,
                            size: dp(context, 48),
                          ),
                        ),
                      ),
              ),
              Visibility(
                visible: isEditing,
                child: GestureDetector(
                  onTap: onChangePhoto,
                  child: Container(
                    width: dp(context, 32),
                    height: dp(context, 32),
                    decoration: const BoxDecoration(
                      color: Colors.blueAccent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: dp(context, 12)),
        Center(
          child: Text(
            displayName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
