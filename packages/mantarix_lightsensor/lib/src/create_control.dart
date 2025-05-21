import 'package:mantarix/mantarix.dart';

import 'lightsensor.dart';

CreateControlFactory createControl = (CreateControlArgs args) {
  switch (args.control.type) {
    case "light_sensor":
      return LightSensor(
        parent: args.parent,
        control: args.control,
        backend: args.backend
      );
    default:
      return null;
  }
};

void ensureInitialized() {
  // nothing to initialize
}