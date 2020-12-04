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
  onboardingModel.setTitle("Request or Find a Ride");
  onboardingModel.setDescription(
      "With Vink, your destination is at the palm of your hands. Just open the app and join the trip to same destination or enter where you want to go and a driver will help you get there safe and reliable.");
  slides.add(onboardingModel);

  onboardingModel = new OnboardingModel();

  //List tile two
  onboardingModel.setImageAssetsPath("assets/images/safe_trip.png");
  onboardingModel.setTitle("Trips Going Same Direction");
  onboardingModel.setDescription(
      "Ride with good people going your destination, no need to change routes or direction. Its better than the taxi and more convenient than the bus.");
  slides.add(onboardingModel);

  onboardingModel = new OnboardingModel();

  //List tile three
  onboardingModel.setImageAssetsPath("assets/images/my_location.png");
  onboardingModel.setTitle("Share Live Location");
  onboardingModel.setDescription(
      "As we pride ourselves with your safety, we went a step further. Vink allows you to  choose to share your live location with family or friends for added security");
  slides.add(onboardingModel);

  onboardingModel = new OnboardingModel();

  //List tile three
  onboardingModel.setImageAssetsPath("assets/images/security.png");
  onboardingModel.setTitle("Safe Ride Sharing");
  onboardingModel.setDescription(
      "Your safety is our big feature on Vink. We track all the cars that are on the road travelling with Vink. This information is only known by us and both the driver and the passenger.");
  slides.add(onboardingModel);

  onboardingModel = new OnboardingModel();

  return slides;
}
