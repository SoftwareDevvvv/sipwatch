import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path_utils;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/drink_image.dart';

class DrinkImageController extends GetxController {
  late SharedPreferences _prefs;
  final String _storageKey = 'drink_images';
  final RxList<DrinkImage> drinkImages = <DrinkImage>[].obs;
  final ImagePicker _picker = ImagePicker();

  final RxBool isLoading = false.obs;
  final RxString selectedImageId = ''.obs;
  @override
  void onInit() {
    super.onInit();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    isLoading.value = true;
    _prefs = await SharedPreferences.getInstance();
    await _loadImages();
    // Ensure we clear any asset-based images
    await clearAssetImages();
    isLoading.value = false;
  }

  Future<void> _loadImages() async {
    try {
      final imagesJson = _prefs.getStringList(_storageKey) ?? [];
      final images = imagesJson
          .map((json) => DrinkImage.fromJson(jsonDecode(json)))
          .where((image) => !image.isAsset) // Filter out asset images
          .toList();

      drinkImages.value = images;
      if (drinkImages.isNotEmpty) {
        selectedImageId.value = drinkImages.first.id;
      }
    } catch (e) {
      print('Error loading images: $e');
      drinkImages.value = [];
    }
  }

  Future<void> _saveImages() async {
    try {
      final imagesJson =
          drinkImages.map((image) => jsonEncode(image.toJson())).toList();
      await _prefs.setStringList(_storageKey, imagesJson);
    } catch (e) {
      print('Error saving images: $e');
    }
  }

  // Add a new drink image
  Future<void> addDrinkImage(DrinkImage image) async {
    drinkImages.add(image);
    await _saveImages();
  } // Remove a drink image

  Future<void> removeDrinkImage(String id) async {
    drinkImages.removeWhere((image) => image.id == id);
    await _saveImages();
  }

  // Get a drink image by id
  DrinkImage? getDrinkImageById(String id) {
    try {
      return drinkImages.firstWhere((image) => image.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get image by ID
  DrinkImage? getImageById(String id) {
    try {
      return drinkImages.firstWhere((image) => image.id == id);
    } catch (e) {
      print('Error getting image by ID $id: $e');
      return null;
    }
  }

  // Pick an image from gallery
  Future<DrinkImage?> pickImage(DrinkType type) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile == null) return null;

      // Get documents directory
      final directory = await getApplicationDocumentsDirectory();
      final String fileName = path_utils.basename(pickedFile.path);
      final String newPath = path_utils.join(
          directory.path, '${DateTime.now().millisecondsSinceEpoch}_$fileName');

      // Copy the file to a new path
      final File savedImage = await File(pickedFile.path).copy(newPath);

      // Create a new DrinkImage
      final newImage = DrinkImage.file(
        id: const Uuid().v4(),
        path: savedImage.path,
        type: type,
      );

      // Add to list and save
      await addDrinkImage(newImage);
      selectImage(newImage.id);
      return newImage;
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }

  // Add image from gallery
  Future<DrinkImage?> addImageFromGallery(DrinkType type) async {
    return await _pickImageFromSource(type, ImageSource.gallery);
  }

  // Add image from camera
  Future<DrinkImage?> addImageFromCamera(DrinkType type) async {
    return await _pickImageFromSource(type, ImageSource.camera);
  }

  // Helper method to pick image from a specific source
  Future<DrinkImage?> _pickImageFromSource(
      DrinkType type, ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (pickedFile == null) return null;

      // Get documents directory
      final directory = await getApplicationDocumentsDirectory();
      final String fileName = path_utils.basename(pickedFile.path);
      final String newPath = path_utils.join(
          directory.path, '${DateTime.now().millisecondsSinceEpoch}_$fileName');

      // Copy the file to a new path
      final File savedImage = await File(pickedFile.path).copy(newPath);

      // Create a new DrinkImage
      final newImage = DrinkImage.file(
        id: const Uuid().v4(),
        path: savedImage.path,
        type: type,
      );

      // Add to list and save
      await addDrinkImage(newImage);
      selectImage(newImage.id);
      return newImage;
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }

  // Select an image (sets the selectedImageId)
  void selectImage(String id) {
    selectedImageId.value = id;
    update(); // Force update to ensure all widgets using this controller are rebuilt
  }

  // Set selected image
  void setSelectedImage(String id) {
    selectedImageId.value = id;
    update(); // Force update to ensure all widgets using this controller are rebuilt
  }

  // Get all images of a specific type
  List<DrinkImage> getImagesOfType(DrinkType type) {
    return drinkImages.where((image) => image.type == type).toList();
  }

  // Get all images of a specific type (alias for getImagesOfType)
  List<DrinkImage> getImagesByType(DrinkType type) {
    return getImagesOfType(type);
  }

  // Clear all asset images
  Future<void> clearAssetImages() async {
    drinkImages.removeWhere((image) => image.isAsset);
    await _saveImages();
  }
}
