import 'package:event_bus/event_bus.dart';

var eventBus = EventBus();

var eventBusSync = EventBus(sync: true);

class AddEvent {}
