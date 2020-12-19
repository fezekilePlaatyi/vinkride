class Constants {
  static const GMAPS_API_KEY = 'AIzaSyAYI_WMsyJw3RqMcqv939GBFHy8HHPPNl4';

  static const FCM_SERVER_TOKEN =
      'AAAAfYh_87E:APA91bExovcGf1hqDDszhtZbIsiHDouiKeciBFfeYnFU4721uuzy_nwXFlyX5IZoxDuIHP7OG9tpy7bpQJOa4Rdg6_bRNd4iWuGY9LDlZMfYVziTKARL0tZ900dzP2cbr3gU3buk4K6_';

  static const PAYMENT_SERVER_ADDRESS =
      'https://us-central1-vink8-za.cloudfunctions.net';

  static const INTERCITY_PROJECT_KEY =
      "AIzaSyDllEaUio-wy0QxBhf2gzoAOD6LnyvmOR0";

  static const DYNAMIC_LINKS_CREATE_URL =
      "https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=$INTERCITY_PROJECT_KEY";

  static const GOOGLE_MAPS_URL = "https://www.google.com/maps/place/";

  static const VINK_USER_LOCATION_SUBJECT = "Hey, here's my location";

  static const VINK_SHARE_TEXT =
      "Hello,Please check out this new exciting app for ridesharing when travelling between cities or towns. It eliminates the need for hiking spots and is great for passengers. You can use it to earn extra money on your next travel. I'm also using it too. Use the links below to download it on the app stores: : \n ANDROID: https://play.google.com/store/apps/details?id=com.vinkride.driver \n IOS: https://play.google.com/store/apps/details?id=com.vinkride.driver";
}

class TripConst {
  static const RIDE_OFFER = 'rideOffer';
  static const RIDE_REQUEST = 'rideRequest';
  static const ACTIVE_TRIP = 'active';
  static const ONCOMING_TRIP = 'oncoming';
  static const COMPLETED_TRIP = 'completed';
  static const TRIP_JOIN_REQUEST = 'requestToJoinTrip';
  static const TRIP_JOIN_ACCEPTED = 'acceptedToJoinTrip';
  static const TRIP_JOIN_REJECTED = 'rejectedToJoinTrip';
  static const TRIP_REQUEST_ACCEPTED_STRING =
      "Your request to join Trip accepted, continue to pay.";

  static const TRIP_REQUEST_REJECTED_STRING =
      "Your request to join Trip rejected.";
}

class UserType {
  static const DRIVER = 'driver';
  static const PASSENGER = 'passenger';
}
