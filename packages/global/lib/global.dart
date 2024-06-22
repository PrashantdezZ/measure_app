library global;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
export 'package:bloc/bloc.dart';
export 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide AsyncError;
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:hasura_connect/hasura_connect.dart' as h;
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
export 'data/models/session_info_model.dart';
export 'package:logger/logger.dart';
export 'package:flutter_screenutil/flutter_screenutil.dart';
export 'package:dio/dio.dart';
export 'package:flutter_card_swiper/flutter_card_swiper.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

export 'package:image_picker/image_picker.dart';
export 'package:go_router/go_router.dart';
export 'dart:async';
export 'package:flutter_riverpod/flutter_riverpod.dart' hide AsyncError;
export 'package:google_fonts/google_fonts.dart';
export 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/flutter_svg.dart';
import  'package:intl/intl.dart';
export 'package:carousel_slider/carousel_slider.dart';
export 'package:smooth_page_indicator/smooth_page_indicator.dart';
export 'dart:io' hide interface;
// export 'package:firebase_auth/firebase_auth.dart';
export 'package:path_provider/path_provider.dart';
export  'package:flutter_typeahead/flutter_typeahead.dart';
export 'package:expandable/expandable.dart';
import 'package:expandable/expandable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
export 'package:pinput/pinput.dart';

export 'dart:math' hide interface;

part 'domain/entity/api_constant.dart';
part 'domain/entity/assets_constant.dart';
part 'domain/entity/ui_constants.dart';
part 'data/models/property_model.dart';


part 'data/services/user_services.dart';
part 'data/services/firestore_services.dart';

part 'data/models/user_model.dart';
part 'data/models/patient_model.dart';
part 'data/models/assessment_model.dart';

part 'data/blocs/users_bloc/users_bloc.dart';
part 'data/blocs/users_bloc/users_event.dart';
part 'data/blocs/users_bloc/users_state.dart';

part 'data/blocs/assessment_bloc/assessment_bloc.dart';
part 'data/blocs/assessment_bloc/assessment_event.dart';
part 'data/blocs/assessment_bloc/assessment_state.dart';
part 'data/blocs/questionnaire_bloc/questionnaire_bloc.dart';
part 'data/blocs/questionnaire_bloc/questionnaire_event.dart';
part 'data/blocs/questionnaire_bloc/questionnaire_state.dart';
