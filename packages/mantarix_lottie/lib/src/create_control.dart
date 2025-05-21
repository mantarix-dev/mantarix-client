import 'package:mantarix/mantarix.dart';

import 'lottie.dart';

CreateControlFactory createControl = (CreateControlArgs args) {
  switch (args.control.type) {
    case "lottie":
      return LottieControl(
          parent: args.parent,
          control: args.control,
          nextChild: args.nextChild,
          backend: args.backend);
    default:
      return null;
  }
};

void ensureInitialized() {
  // nothing to initialize
}