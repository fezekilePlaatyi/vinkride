class OnboardingModel {
  String imagePath;
  String title;
  String description;

  OnboardingModel({this.imagePath, this.title, this.description});

  void setImageAssetsPath(String getImagePath) {
    imagePath = getImagePath;
  }

  void setTitle(String getTitle) {
    title = getTitle;
  }

  void setDescription(String getDescription) {
    description = getDescription;
  }

  String getImageAssetsPath() {
    return imagePath;
  }

  String getTitle() {
    return title;
  }

  String getDescription() {
    return description;
  }
}

List<OnboardingModel> getSlides() {
  List<OnboardingModel> slides = new List<OnboardingModel>();
  OnboardingModel onboardingModel = new OnboardingModel();

  //List tile one
  onboardingModel.setImageAssetsPath("assets/images/find_car.png");
  onboardingModel.setTitle("Find Ride");
  onboardingModel.setDescription(
      "The Frontend Developer is part of the technical team at the Innovation.");
  slides.add(onboardingModel);

  onboardingModel = new OnboardingModel();

  //List tile two
  onboardingModel.setImageAssetsPath("assets/images/safe_trip.png");
  onboardingModel.setTitle("Trips Going Same Direction");
  onboardingModel.setDescription(
      "Hub and is responsible to design and implements the frontend data analytics.");
  slides.add(onboardingModel);

  onboardingModel = new OnboardingModel();

  //List tile three
  onboardingModel.setImageAssetsPath("assets/images/my_location.png");
  onboardingModel.setTitle("Share Live Location");
  onboardingModel.setDescription(
      "The Frontend deals with medium to advanced business issues that have medium.");
  slides.add(onboardingModel);

  onboardingModel = new OnboardingModel();

  //List tile three
  onboardingModel.setImageAssetsPath("assets/images/security.png");
  onboardingModel.setTitle("Safe Ride Sharing");
  onboardingModel.setDescription(
      "Knowledge of advanced analytics, statistics and machine learning methods is a plus .");
  slides.add(onboardingModel);

  onboardingModel = new OnboardingModel();

  return slides;
}
