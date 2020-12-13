import 'package:Vinkdriver/services/VinkFirebaseMessagingService.dart';

sendRejectMessageToPassenger(messageData) {
  var notificationData = {
    'title': "New Notification",
    'body':
        "Your request to joing join Trip rejected, click here for more details.",
    'notificationType': 'rejectedToJoinTrip'
  };
  var passengerId = messageData['from_user'];
  messageData['notificationType'] = 'rejectedToJoinTrip';
  deliverNotification(notificationData, messageData, passengerId);
}

sendAcceptedMessageToPassenger(messageData) {
  var notificationData = {
    'title': "New Notification",
    'body': "Your request to joing join Trip accepted, continue to pay.",
    'notificationType': 'acceptedToJoinTrip'
  };
  var passengerId = messageData['from_user'];
  messageData['notificationType'] = 'acceptedToJoinTrip';
  deliverNotification(notificationData, messageData, passengerId);
}

deliverNotification(notificationData, messageData, passengerId) {
  VinkFirebaseMessagingService()
      .buildAndReturnFcmMessageBody(notificationData, messageData, passengerId)
      .then((data) => {VinkFirebaseMessagingService().sendFcmMessage(data)});
}
