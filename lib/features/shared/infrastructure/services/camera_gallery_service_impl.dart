import 'package:image_picker/image_picker.dart';
import 'package:teslo_shop/features/shared/domain/services/camera_gallery_service.dart';

class CameraGalleryServiceImpl extends CameraGallerService {
  final ImagePicker _imagePicker = ImagePicker();

  @override
  Future<String?> slectPhoto() async {
    final XFile? photo = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (photo == null) return null;

    return photo.path;
  }

  @override
  Future<String?> takePhoto() async {
    final XFile? photo = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (photo == null) return null;

    return photo.path;
  }
}
