import 'package:flutter/foundation.dart';

const factor = kIsWeb ? 2.5 : 1.5;
const actualWidthMin = 30.0;
const actualHeightMin = 47.0;
const playerWidth = actualWidthMin * factor;
const playerHeight = actualHeightMin * factor;
const production = false;