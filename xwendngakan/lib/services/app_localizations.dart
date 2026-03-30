import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class S {
  static String of(BuildContext context, String key, [Map<String, String>? params]) {
    final lang = context.read<AppProvider>().language;
    return get(lang, key, params);
  }

  static String get(String lang, String key, [Map<String, String>? params]) {
    String text = _translations[key]?[lang] ?? _translations[key]?['ku'] ?? key;
    if (params != null) {
      params.forEach((k, v) {
        text = text.replaceAll('{$k}', v);
      });
    }
    return text;
  }

  static const Map<String, Map<String, String>> _translations = {
    // ─── App ───
    'appName': {
      'ku': 'خوێندنگاکانم',
      'ar': 'مؤسساتي التعليمية',
      'en': 'My Schools',
    },

    // ─── Nav ───
    'navHome': {
      'ku': 'سەرەکی',
      'ar': 'الرئيسية',
      'en': 'Home',
    },
    'navSearch': {
      'ku': 'گەڕان',
      'ar': 'بحث',
      'en': 'Search',
    },
    'navRegister': {
      'ku': 'تۆمارکردن',
      'ar': 'تسجيل',
      'en': 'Register',
    },
    'navSettings': {
      'ku': 'ڕێکخستن',
      'ar': 'الإعدادات',
      'en': 'Settings',
    },
    'navMap': {
      'ku': 'نەخشە',
      'ar': 'الخريطة',
      'en': 'Map',
    },
    'mapView': {
      'ku': 'نەخشەی دامەزراوەکان',
      'ar': 'خريطة المؤسسات',
      'en': 'Institutions Map',
    },
    'all': {
      'ku': 'هەمووی',
      'ar': 'الكل',
      'en': 'All',
    },
    'unknown': {
      'ku': 'نادیار',
      'ar': 'غير معروف',
      'en': 'Unknown',
    },

    // ─── Home ───
    'defaultUser': {
      'ku': 'بەکارهێنەر',
      'ar': 'مستخدم',
      'en': 'User',
    },
    'institution': {
      'ku': 'دامەزراوە',
      'ar': 'مؤسسة',
      'en': 'institution',
    },
    'searchInInstitutions': {
      'ku': 'گەڕان لە نێو {count} دامەزراوە...',
      'ar': 'البحث في {count} مؤسسة...',
      'en': 'Search in {count} institutions...',
    },
    'noResults': {
      'ku': 'هیچ ئەنجامێک نەدۆزرایەوە',
      'ar': 'لم يتم العثور على نتائج',
      'en': 'No results found',
    },
    'changeFilters': {
      'ku': 'فلتەرەکان بگۆڕە یان بە ناوێکی تر بگەڕێ',
      'ar': 'غيّر الفلاتر أو ابحث باسم آخر',
      'en': 'Change filters or search with another name',
    },
    'clearFilters': {
      'ku': 'پاککردنەوەی فلتەرەکان',
      'ar': 'مسح الفلاتر',
      'en': 'Clear filters',
    },
    'filter': {
      'ku': 'فلتەرکردن',
      'ar': 'تصفية',
      'en': 'Filter',
    },
    'findFavorite': {
      'ku': 'دۆزینەوەی خوێندنگای دڵخواز',
      'ar': 'ابحث عن مؤسستك المفضلة',
      'en': 'Find your favorite institution',
    },
    'clear': {
      'ku': 'پاککردنەوە',
      'ar': 'مسح',
      'en': 'Clear',
    },
    'institutionType': {
      'ku': 'جۆری دامەزراوە',
      'ar': 'نوع المؤسسة',
      'en': 'Institution type',
    },
    'allTypes': {
      'ku': 'هەموو جۆرەکان',
      'ar': 'جميع الأنواع',
      'en': 'All types',
    },
    'city': {
      'ku': 'شار',
      'ar': 'مدينة',
      'en': 'City',
    },
    'allCities': {
      'ku': 'هەموو شارەکان',
      'ar': 'جميع المدن',
      'en': 'All cities',
    },
    'apply': {
      'ku': 'جێبەجێکردن',
      'ar': 'تطبيق',
      'en': 'Apply',
    },

  
'greeting': {
      'ku': 'سڵاو',
      'ar': 'مرحباً',
      'en': 'Hello',
    },    'greetingSubtitle': {
      'ku': 'خوێندنگای دڵخوازت بدۆزەوە',
      'ar': 'ابحث عن مؤسستك المفضلة',
      'en': 'Find your favorite institution',
    },

    // ─── Search ───
    'searchHint': {
      'ku': 'ناوی خوێندنگا بنووسە...',
      'ar': 'اكتب اسم المؤسسة...',
      'en': 'Type institution name...',
    },
    'popularSearches': {
      'ku': 'گەڕانی باو',
      'ar': 'عمليات بحث شائعة',
      'en': 'Popular searches',
    },
    'categories': {
      'ku': 'جۆرەکان',
      'ar': 'الأنواع',
      'en': 'Categories',
    },
    'featured': {
      'ku': 'هەڵبژێردراو',
      'ar': 'مميز',
      'en': 'Featured',
    },
    'seeAll': {
      'ku': 'هەموو ببینە',
      'ar': 'عرض الكل',
      'en': 'See all',
    },
    'searchDifferent': {
      'ku': 'بە وشەیەکی تر بگەڕێ',
      'ar': 'ابحث بكلمة أخرى',
      'en': 'Try a different search',
    },
    'resultCount': {
      'ku': '{count} ئەنجام',
      'ar': '{count} نتيجة',
      'en': '{count} results',
    },

    // ─── Settings ───
    'settings': {
      'ku': 'ڕێکخستنەکان',
      'ar': 'الإعدادات',
      'en': 'Settings',
    },
    'appearance': {
      'ku': 'ڕووکار',
      'ar': 'المظهر',
      'en': 'Appearance',
    },
    'darkMode': {
      'ku': 'دۆخی تاریک',
      'ar': 'الوضع الداكن',
      'en': 'Dark mode',
    },
    'lightMode': {
      'ku': 'دۆخی ڕوناک',
      'ar': 'الوضع الفاتح',
      'en': 'Light mode',
    },
    'changeAppTheme': {
      'ku': 'گۆڕینی ڕووکاری ئەپلیکەیشن',
      'ar': 'تغيير مظهر التطبيق',
      'en': 'Change app theme',
    },
    'about': {
      'ku': 'دەربارە',
      'ar': 'حول',
      'en': 'About',
    },
    'appDescription': {
      'ku': 'ئەم ئەپلیکەیشنە دلیلێکی گشتگیرە بۆ هەموو دامەزراوە پەروەردەیی و خوێندنییەکانی عێراق و کوردستان. لێرەوە دەتوانیت زانکۆ، پەیمانگە، قوتابخانە، باخچەی منداڵان و زۆر شتی تر ببینیت و بەراوردیان بکەیت.',
      'ar': 'هذا التطبيق دليل شامل لجميع المؤسسات التعليمية في العراق وكوردستان. يمكنك من هنا مشاهدة ومقارنة الجامعات والمعاهد والمدارس ورياض الأطفال وأكثر.',
      'en': 'This app is a comprehensive guide for all educational institutions in Iraq and Kurdistan. Here you can view and compare universities, institutes, schools, kindergartens and more.',
    },
    'developer': {
      'ku': 'گەشەپێدەر',
      'ar': 'المطور',
      'en': 'Developer',
    },
    'language': {
      'ku': 'زمان',
      'ar': 'اللغة',
      'en': 'Language',
    },
    'chooseLanguage': {
      'ku': 'زمان هەڵبژێرە',
      'ar': 'اختر اللغة',
      'en': 'Choose language',
    },
    'kurdish': {
      'ku': 'کوردی',
      'ar': 'الكوردية',
      'en': 'Kurdish',
    },
    'arabic': {
      'ku': 'العربية',
      'ar': 'العربية',
      'en': 'Arabic',
    },
    'english': {
      'ku': 'English',
      'ar': 'الإنجليزية',
      'en': 'English',
    },
    'active': {
      'ku': 'چالاک',
      'ar': 'نشط',
      'en': 'Active',
    },
    'notLoggedIn': {
      'ku': 'چوونەژوورەوە نەکراوە',
      'ar': 'لم يتم تسجيل الدخول',
      'en': 'Not logged in',
    },
    'loginForFeatures': {
      'ku': 'بۆ بەکارهێنانی تایبەتمەندییەکان بچۆرە ژوورەوە',
      'ar': 'سجّل الدخول لاستخدام الميزات',
      'en': 'Log in to use features',
    },
    'login': {
      'ku': 'چوونەژوورەوە',
      'ar': 'تسجيل الدخول',
      'en': 'Log in',
    },
    'logout': {
      'ku': 'دەرچوون',
      'ar': 'تسجيل الخروج',
      'en': 'Log out',
    },
    'logoutConfirm': {
      'ku': 'دڵنیایت دەتەوێت لە ئەکاونتەکەت بچیتە دەرەوە؟',
      'ar': 'هل أنت متأكد أنك تريد تسجيل الخروج؟',
      'en': 'Are you sure you want to log out?',
    },
    'no': {
      'ku': 'نەخێر',
      'ar': 'لا',
      'en': 'No',
    },
    'yesLogout': {
      'ku': 'بەڵێ، دەرچوون',
      'ar': 'نعم، خروج',
      'en': 'Yes, log out',
    },
    'loggedOutSuccess': {
      'ku': 'بە سەرکەوتوویی دەرچوویت',
      'ar': 'تم تسجيل الخروج بنجاح',
      'en': 'Logged out successfully',
    },
    'loading': {
      'ku': 'چاوەڕوانبە...',
      'ar': 'انتظر...',
      'en': 'Loading...',
    },

    // ─── Detail ───
    'aboutTab': {
      'ku': 'دەربارە',
      'ar': 'حول',
      'en': 'About',
    },
    'college': {
      'ku': 'کۆلێژ',
      'ar': 'كلية',
      'en': 'College',
    },
    'department': {
      'ku': 'بەش',
      'ar': 'قسم',
      'en': 'Department',
    },
    'locationTab': {
      'ku': 'شوێن',
      'ar': 'الموقع',
      'en': 'Location',
    },
    'contactTab': {
      'ku': 'پەیوەندی',
      'ar': 'اتصال',
      'en': 'Contact',
    },
    'socialTab': {
      'ku': 'سۆشیال',
      'ar': 'التواصل',
      'en': 'Social',
    },
    'email': {
      'ku': 'ئیمەیڵ',
      'ar': 'البريد الإلكتروني',
      'en': 'Email',
    },
    'website': {
      'ku': 'وێبسایت',
      'ar': 'الموقع الإلكتروني',
      'en': 'Website',
    },
    'noAboutInfo': {
      'ku': 'هیچ زانیاریەک لەسەر دەربارە نییە',
      'ar': 'لا توجد معلومات',
      'en': 'No information available',
    },
    'noDepartments': {
      'ku': 'هیچ بەشێک زیاد نەکراوە',
      'ar': 'لم تتم إضافة أقسام',
      'en': 'No departments added',
    },
    'collegesAndDepts': {
      'ku': 'کۆلێژ و بەشەکان',
      'ar': 'الكليات والأقسام',
      'en': 'Colleges & Departments',
    },
    'departments': {
      'ku': 'بەشەکان',
      'ar': 'الأقسام',
      'en': 'Departments',
    },
    'collegeCount': {
      'ku': '{count} کۆلێژ',
      'ar': '{count} كلية',
      'en': '{count} colleges',
    },
    'deptCount': {
      'ku': '{count} بەش',
      'ar': '{count} قسم',
      'en': '{count} depts',
    },
    'colleges': {
      'ku': 'کۆلێژەکان',
      'ar': 'الكليات',
      'en': 'Colleges',
    },
    'noContactInfo': {
      'ku': 'هیچ زانیاریەکی پەیوەندی نییە',
      'ar': 'لا توجد معلومات اتصال',
      'en': 'No contact information',
    },
    'phone': {
      'ku': 'ژمارەی تەلەفۆن',
      'ar': 'رقم الهاتف',
      'en': 'Phone number',
    },
    'openMap': {
      'ku': 'کردنەوەی نەخشە',
      'ar': 'فتح الخريطة',
      'en': 'Open map',
    },
    'noSocial': {
      'ku': 'هیچ سۆشیالێک زیاد نەکراوە',
      'ar': 'لم تتم إضافة حسابات تواصل',
      'en': 'No social media added',
    },
    'socialMedia': {
      'ku': 'سۆشیال میدیا',
      'ar': 'وسائل التواصل',
      'en': 'Social media',
    },
    'facebook': {
      'ku': 'فەیسبووک',
      'ar': 'فيسبوك',
      'en': 'Facebook',
    },
    'whatsapp': {
      'ku': 'واتساپ',
      'ar': 'واتساب',
      'en': 'WhatsApp',
    },

    // ─── Register ───
    'registerInstitution': {
      'ku': 'تۆمارکردنی دامەزراوە',
      'ar': 'تسجيل مؤسسة',
      'en': 'Register Institution',
    },
    'adminApprovalNotice': {
      'ku': 'دوای ناردن، ئەدمین پەسەندی دەکات.',
      'ar': 'بعد الإرسال، سيوافق المشرف.',
      'en': 'After submission, admin will approve.',
    },
    'mainInfo': {
      'ku': 'زانیاری سەرەکی',
      'ar': 'المعلومات الأساسية',
      'en': 'Main information',
    },
    'institutionName': {
      'ku': 'ناوی دامەزراوە *',
      'ar': 'اسم المؤسسة *',
      'en': 'Institution name *',
    },
    'institutionNameHint': {
      'ku': 'ناوی دامەزراوەکە...',
      'ar': 'اسم المؤسسة...',
      'en': 'Institution name...',
    },
    'cityHint': {
      'ku': 'بۆ نموونە: هەولێر',
      'ar': 'مثال: أربيل',
      'en': 'e.g. Erbil',
    },
    'typeRequired': {
      'ku': 'جۆر *',
      'ar': 'النوع *',
      'en': 'Type *',
    },
    'addressRequired': {
      'ku': 'ناونیشان *',
      'ar': 'العنوان *',
      'en': 'Address *',
    },
    'addressHint': {
      'ku': 'ناونیشانی دامەزراوەکە...',
      'ar': 'عنوان المؤسسة...',
      'en': 'Institution address...',
    },
    'moreInfo': {
      'ku': 'زانیاری زیاتر',
      'ar': 'معلومات إضافية',
      'en': 'More info',
    },
    'englishName': {
      'ku': 'ناوی ئینگلیزی',
      'ar': 'الاسم بالإنجليزية',
      'en': 'English name',
    },
    'aboutInstitution': {
      'ku': 'دەربارەی دامەزراوەکە',
      'ar': 'حول المؤسسة',
      'en': 'About the institution',
    },
    'aboutHint': {
      'ku': 'کورتەیەک لەسەر دامەزراوەکە...',
      'ar': 'نبذة عن المؤسسة...',
      'en': 'Brief about the institution...',
    },
    'addCollege': {
      'ku': 'زیادکردنی کۆلێژ',
      'ar': 'إضافة كلية',
      'en': 'Add college',
    },
    'addDept': {
      'ku': 'زیادکردنی بەش',
      'ar': 'إضافة قسم',
      'en': 'Add department',
    },
    'extraInfo': {
      'ku': 'زانیاری زیادە',
      'ar': 'معلومات إضافية',
      'en': 'Extra info',
    },
    'admissionAge': {
      'ku': 'تەمەنی وەرگرتن',
      'ar': 'سن القبول',
      'en': 'Admission age',
    },
    'admissionAgeHint': {
      'ku': 'بۆ نموونە: ٣ - ٦ ساڵ',
      'ar': 'مثال: ٣ - ٦ سنة',
      'en': 'e.g. 3 - 6 years',
    },
    'workHours': {
      'ku': 'کاتی کار',
      'ar': 'أوقات العمل',
      'en': 'Work hours',
    },
    'workHoursHint': {
      'ku': 'بۆ نموونە: ٨:٠٠ - ٢:٠٠',
      'ar': 'مثال: ٨:٠٠ - ٢:٠٠',
      'en': 'e.g. 8:00 - 2:00',
    },
    'contact': {
      'ku': 'پەیوەندی',
      'ar': 'اتصال',
      'en': 'Contact',
    },
    'social': {
      'ku': 'سۆشیال',
      'ar': 'التواصل الاجتماعي',
      'en': 'Social',
    },
    'submitToAdmin': {
      'ku': 'ناردن بۆ ئەدمین',
      'ar': 'إرسال للمشرف',
      'en': 'Submit to admin',
    },
    'iraq': {
      'ku': 'عێراق',
      'ar': 'العراق',
      'en': 'Iraq',
    },
    'addLogo': {
      'ku': 'وێنەی دامەزراوەکەت زیاد بکە',
      'ar': 'أضف شعار المؤسسة',
      'en': 'Add institution logo',
    },
    'changeLogo': {
      'ku': 'گۆڕینی وێنە',
      'ar': 'تغيير الصورة',
      'en': 'Change image',
    },
    'loginRequired': {
      'ku': 'پێویستە لۆگین بکەیت',
      'ar': 'يجب تسجيل الدخول',
      'en': 'Login required',
    },
    'loginRequiredDesc': {
      'ku': 'بۆ تۆمارکردنی دامەزراوەی نوێ، تکایە سەرەتا بچۆ ژوورەوە.',
      'ar': 'لتسجيل مؤسسة جديدة، يرجى تسجيل الدخول أولاً.',
      'en': 'To register a new institution, please log in first.',
    },
    'goToLogin': {
      'ku': 'چوونە ژوورەوە',
      'ar': 'تسجيل الدخول',
      'en': 'Go to login',
    },
    'errorNameRequired': {
      'ku': 'تکایە ناوی دامەزراوەکە بنووسە',
      'ar': 'يرجى كتابة اسم المؤسسة',
      'en': 'Please enter the institution name',
    },
    'errorTypeRequired': {
      'ku': 'تکایە جۆری دامەزراوە هەڵبژێرە',
      'ar': 'يرجى اختيار نوع المؤسسة',
      'en': 'Please select institution type',
    },
    'errorAddressRequired': {
      'ku': 'تکایە ناونیشان دیاری بکە',
      'ar': 'يرجى تحديد العنوان',
      'en': 'Please provide an address',
    },
    'errorLoginFirst': {
      'ku': 'تکایە سەرەتا لۆگین بکە',
      'ar': 'يرجى تسجيل الدخول أولاً',
      'en': 'Please log in first',
    },
    'submitSuccess': {
      'ku': 'زۆر سوپاس! داواکارییەکەت نێردرا بۆ ئەدمین.',
      'ar': 'شكراً! تم إرسال طلبك للمشرف.',
      'en': 'Thank you! Your request has been sent to admin.',
    },
    'errorOccurred': {
      'ku': 'هەڵەیەک ڕوویدا',
      'ar': 'حدث خطأ',
      'en': 'An error occurred',
    },
    'submitFailed': {
      'ku': 'نەتوانرا بنێردرێت',
      'ar': 'فشل الإرسال',
      'en': 'Failed to submit',
    },
    'collegeN': {
      'ku': 'کۆلێژی {n}',
      'ar': 'كلية {n}',
      'en': 'College {n}',
    },
    'deptN': {
      'ku': 'بەشی {n}',
      'ar': 'قسم {n}',
      'en': 'Department {n}',
    },
    'collegeNameHint': {
      'ku': 'ناوی کۆلێژ...',
      'ar': 'اسم الكلية...',
      'en': 'College name...',
    },
    'deptNameHint': {
      'ku': 'ناوی بەش...',
      'ar': 'اسم القسم...',
      'en': 'Department name...',
    },
    'subDeptHint': {
      'ku': 'ناوی لق...',
      'ar': 'اسم الفرع...',
      'en': 'Branch name...',
    },
    'addSubDept': {
      'ku': 'زیادکردنی لق',
      'ar': 'إضافة فرع',
      'en': 'Add branch',
    },

    // ─── GPS/Location ───
    'enableGPS': {
      'ku': 'تکایە GPS چالاک بکە',
      'ar': 'يرجى تفعيل GPS',
      'en': 'Please enable GPS',
    },
    'enableLocationService': {
      'ku': 'تکایە GPS/لۆکەیشن سەرڤیس لە ئامێرەکەت چالاک بکە',
      'ar': 'يرجى تفعيل خدمة الموقع في جهازك',
      'en': 'Please enable location service on your device',
    },
    'locationPermissionNeeded': {
      'ku': 'ڕێگەپێدان بۆ لۆکەیشن پێویستە',
      'ar': 'مطلوب إذن الوصول للموقع',
      'en': 'Location permission is required',
    },
    'enableLocationSettings': {
      'ku': 'ڕێگەپێدانی لۆکەیشن لە ڕێکخستنەکان چالاکی بکەرەوە',
      'ar': 'فعّل إذن الموقع من الإعدادات',
      'en': 'Enable location permission in settings',
    },
    'locationError': {
      'ku': 'نەتوانرا لۆکەیشنەکە بدۆزرێتەوە',
      'ar': 'تعذر تحديد الموقع',
      'en': 'Could not determine location',
    },

    // ─── Login ───
    'welcomeLogin': {
      'ku': 'بەخێربێیت! بچۆ ناو ئەکاونتەکەت',
      'ar': 'مرحباً! سجّل الدخول إلى حسابك',
      'en': 'Welcome! Log into your account',
    },
    'password': {
      'ku': 'وشەی نهێنی',
      'ar': 'كلمة المرور',
      'en': 'Password',
    },
    'forgotPassword': {
      'ku': 'وشەی نهێنیت لەبیرکردووە؟',
      'ar': 'نسيت كلمة المرور؟',
      'en': 'Forgot password?',
    },
    'enterEmailPassword': {
      'ku': 'تکایە ئیمەیڵ و وشەی نهێنی بنووسە',
      'ar': 'يرجى إدخال البريد وكلمة المرور',
      'en': 'Please enter email and password',
    },
    'loginSuccess': {
      'ku': 'بە سەرکەوتوویی چوویتە ژوورەوە!',
      'ar': 'تم تسجيل الدخول بنجاح!',
      'en': 'Logged in successfully!',
    },
    'loginError': {
      'ku': 'ئیمەیڵ یان وشەی نهێنی هەڵەیە',
      'ar': 'البريد أو كلمة المرور خاطئة',
      'en': 'Incorrect email or password',
    },
    'noAccount': {
      'ku': 'ئەکاونتت نییە؟',
      'ar': 'ليس لديك حساب؟',
      'en': "Don't have an account?",
    },
    'createAccount': {
      'ku': 'ئەکاونت دروست بکە',
      'ar': 'أنشئ حساباً',
      'en': 'Create account',
    },
    'continueWithout': {
      'ku': 'بەبێ ئەکاونت بەردەوام بە',
      'ar': 'المتابعة بدون حساب',
      'en': 'Continue without account',
    },

    // ─── Signup ───
    'signupTitle': {
      'ku': 'ئەکاونت دروست بکە',
      'ar': 'إنشاء حساب',
      'en': 'Create account',
    },
    'signupSubtitle': {
      'ku': 'زانیاریەکانت بنووسە بۆ دروستکردنی ئەکاونت',
      'ar': 'أدخل معلوماتك لإنشاء حساب',
      'en': 'Enter your info to create an account',
    },
    'fullName': {
      'ku': 'ناوی تەواو',
      'ar': 'الاسم الكامل',
      'en': 'Full name',
    },
    'fullNameHint': {
      'ku': 'ناوی تەواوت بنووسە',
      'ar': 'أدخل اسمك الكامل',
      'en': 'Enter your full name',
    },
    'minChars': {
      'ku': 'لانیکەم ٦ پیت',
      'ar': 'على الأقل ٦ أحرف',
      'en': 'At least 6 characters',
    },
    'enterName': {
      'ku': 'تکایە ناوت بنووسە',
      'ar': 'يرجى إدخال اسمك',
      'en': 'Please enter your name',
    },
    'enterEmail': {
      'ku': 'تکایە ئیمەیڵت بنووسە',
      'ar': 'يرجى إدخال بريدك',
      'en': 'Please enter your email',
    },
    'enterPassword': {
      'ku': 'تکایە وشەی نهێنی بنووسە',
      'ar': 'يرجى إدخال كلمة المرور',
      'en': 'Please enter a password',
    },
    'passwordMinLength': {
      'ku': 'وشەی نهێنی دەبێ لانیکەم ٦ پیت بێ',
      'ar': 'يجب أن تكون كلمة المرور ٦ أحرف على الأقل',
      'en': 'Password must be at least 6 characters',
    },
    'signupSuccess': {
      'ku': 'ئەکاونتەکەت بە سەرکەوتوویی دروست کرا!',
      'ar': 'تم إنشاء حسابك بنجاح!',
      'en': 'Account created successfully!',
    },
    'connectionError': {
      'ku': 'کێشەیەک هەیە لە کۆنێکشن',
      'ar': 'مشكلة في الاتصال',
      'en': 'Connection error',
    },
    'haveAccount': {
      'ku': 'ئەکاونتت هەیە؟',
      'ar': 'لديك حساب؟',
      'en': 'Have an account?',
    },
    'goToLoginLink': {
      'ku': 'بچۆ ژوورەوە',
      'ar': 'سجّل الدخول',
      'en': 'Log in',
    },

    // ─── Map Picker ───
    'pickLocation': {
      'ku': 'شوێن هەڵبژێرە',
      'ar': 'اختر الموقع',
      'en': 'Pick location',
    },
    'confirm': {
      'ku': 'دیاریکردن',
      'ar': 'تأكيد',
      'en': 'Confirm',
    },
    'selectedLocation': {
      'ku': 'شوێنی هەڵبژێردراو',
      'ar': 'الموقع المختار',
      'en': 'Selected location',
    },

    // ─── Edit Screen ───
    'editAdmin': {
      'ku': '✏️ دەستکاریکردن — ئەدمین',
      'ar': '✏️ تعديل — المشرف',
      'en': '✏️ Edit — Admin',
    },
    'adminNotice': {
      'ku': '⚙️ ئەم بەشە تەنها بۆ ئەدمینە. دەتوانیت ناو، شار و زانیارییەکان بگۆڕیت.',
      'ar': '⚙️ هذا القسم للمشرف فقط. يمكنك تعديل الأسماء والمدينة والمعلومات.',
      'en': '⚙️ This section is admin-only. You can edit names, city and info.',
    },
    'kurdishName': {
      'ku': 'ناوی کوردی',
      'ar': 'الاسم بالكوردية',
      'en': 'Kurdish name',
    },
    'arabicName': {
      'ku': 'ناوی عەرەبی',
      'ar': 'الاسم بالعربية',
      'en': 'Arabic name',
    },
    'cityDropdownHint': {
      'ku': 'شار...',
      'ar': 'المدينة...',
      'en': 'City...',
    },
    'save': {
      'ku': 'پاشەکەوتکردن',
      'ar': 'حفظ',
      'en': 'Save',
    },
    'delete': {
      'ku': 'سڕینەوە',
      'ar': 'حذف',
      'en': 'Delete',
    },
    'deleteConfirm': {
      'ku': 'دڵنیایت دەتەوێت ئەم دامەزراوەیە بسڕیتەوە؟',
      'ar': 'هل أنت متأكد أنك تريد حذف هذه المؤسسة؟',
      'en': 'Are you sure you want to delete this institution?',
    },
    'yesDelete': {
      'ku': 'بەڵێ، بسڕەوە',
      'ar': 'نعم، احذف',
      'en': 'Yes, delete',
    },
    'savedSuccess': {
      'ku': 'زانیارییەکان پاشەکەوتکران.',
      'ar': 'تم حفظ المعلومات.',
      'en': 'Information saved.',
    },
    'deletedSuccess': {
      'ku': 'دامەزراوەکە سڕایەوە.',
      'ar': 'تم حذف المؤسسة.',
      'en': 'Institution deleted.',
    },
    'logoUrl': {
      'ku': 'لۆگۆ (URL)',
      'ar': 'الشعار (URL)',
      'en': 'Logo (URL)',
    },
    'imageUrl': {
      'ku': 'وێنە (URL)',
      'ar': 'الصورة (URL)',
      'en': 'Image (URL)',
    },

    // ─── Stats ───
    'total': {
      'ku': 'کۆی گشتی',
      'ar': 'الإجمالي',
      'en': 'Total',
    },
    'government': {
      'ku': 'حکومی',
      'ar': 'حكومي',
      'en': 'Government',
    },
    'private': {
      'ku': 'تایبەت',
      'ar': 'خاص',
      'en': 'Private',
    },
    'institute': {
      'ku': 'پەیمانگە',
      'ar': 'معهد',
      'en': 'Institute',
    },
    'school': {
      'ku': 'قوتابخانە',
      'ar': 'مدرسة',
      'en': 'School',
    },
    'kindergarten': {
      'ku': 'باخچە',
      'ar': 'روضة',
      'en': 'Kindergarten',
    },

    // ─── Signup Form Header ───
    'signupFormHeader': {
      'ku': 'دروستکردنی ئەکاونت',
      'ar': 'إنشاء حساب',
      'en': 'Create Account',
    },
    'enableGPSService': {
      'ku': 'تکایە GPS/لۆکەیشن سەرڤیس چالاک بکە',
      'ar': 'يرجى تفعيل خدمة الموقع',
      'en': 'Please enable GPS/Location service',
    },
    'sections': {
      'ku': 'بەشەکان',
      'ar': 'الأقسام',
      'en': 'Departments',
    },
    'addDeptSub': {
      'ku': 'زیادکردنی بەش',
      'ar': 'إضافة قسم',
      'en': 'Add department',
    },
    'addBranch': {
      'ku': 'زیادکردنی لق',
      'ar': 'إضافة فرع',
      'en': 'Add branch',
    },

    // ─── Snackbar ───
    'success': {
      'ku': 'سەرکەوتوو!',
      'ar': 'نجاح!',
      'en': 'Success!',
    },
    'error': {
      'ku': 'هەڵە!',
      'ar': 'خطأ!',
      'en': 'Error!',
    },
    'warning': {
      'ku': 'ئاگاداری!',
      'ar': 'تنبيه!',
      'en': 'Warning!',
    },
    'info': {
      'ku': 'زانیاری',
      'ar': 'معلومة',
      'en': 'Info',
    },
    'back': {
      'ku': 'گەڕانەوە',
      'ar': 'رجوع',
      'en': 'Go back',
    },

    // ─── Validation ───
    'confirmPassword': {
      'ku': 'دووبارەکردنەوەی وشەی نهێنی',
      'ar': 'تأكيد كلمة المرور',
      'en': 'Confirm password',
    },
    'passwordMismatch': {
      'ku': 'وشەی نهێنی یەک ناگرنەوە',
      'ar': 'كلمتا المرور غير متطابقتين',
      'en': 'Passwords do not match',
    },
    'invalidEmail': {
      'ku': 'ئیمەیڵەکە دروست نیە',
      'ar': 'البريد الإلكتروني غير صالح',
      'en': 'Invalid email address',
    },
    'invalidPhone': {
      'ku': 'ژمارەی مۆبایل دروست نیە',
      'ar': 'رقم الهاتف غير صالح',
      'en': 'Invalid phone number',
    },
    'invalidUrl': {
      'ku': 'لینکەکە دروست نیە',
      'ar': 'الرابط غير صالح',
      'en': 'Invalid URL',
    },
    'networkError': {
      'ku': 'کێشەیەک لە تۆڕەکەدا ڕوویدا',
      'ar': 'حدث خطأ في الشبكة',
      'en': 'A network error occurred',
    },
    'retry': {
      'ku': 'هەوڵبدەرەوە',
      'ar': 'إعادة المحاولة',
      'en': 'Retry',
    },
    'locationFailed': {
      'ku': 'شوێنەکە نەدۆزرایەوە',
      'ar': 'تعذر تحديد الموقع',
      'en': 'Location not found',
    },
    'filterResults': {
      'ku': 'فلتەرکردن',
      'ar': 'تصفية',
      'en': 'Filter',
    },

    // ─── Favorites ───
    'favorites': {
      'ku': 'دڵخوازەکان',
      'ar': 'المفضلة',
      'en': 'Favorites',
    },
    'noFavorites': {
      'ku': 'هیچ دڵخوازێکت نییە',
      'ar': 'لا توجد مفضلات',
      'en': 'No favorites yet',
    },
    'noFavoritesDesc': {
      'ku': 'خوێندنگای دڵخوازت پاشەکەوت بکە بۆ ئەوەی لێرە ببینیت',
      'ar': 'احفظ مؤسساتك المفضلة لتراها هنا',
      'en': 'Save your favorite institutions to see them here',
    },
    'addedToFavorites': {
      'ku': 'زیادکرا بۆ دڵخوازەکان',
      'ar': 'أُضيف إلى المفضلة',
      'en': 'Added to favorites',
    },
    'removedFromFavorites': {
      'ku': 'لابرا لە دڵخوازەکان',
      'ar': 'أُزيل من المفضلة',
      'en': 'Removed from favorites',
    },

    // ─── Password Reset ───
    'enterValidEmail': {
      'ku': 'تکایە ئیمەیڵێکی دروست بنووسە',
      'ar': 'يرجى إدخال بريد إلكتروني صالح',
      'en': 'Please enter a valid email',
    },
    'codeSent': {
      'ku': 'کۆدەکە نێردرا بۆ ئیمەیڵەکەت',
      'ar': 'تم إرسال الرمز إلى بريدك',
      'en': 'Code sent to your email',
    },
    'enterValidCode': {
      'ku': 'تکایە کۆدی ٦ ژمارەیی بنووسە',
      'ar': 'يرجى إدخال الرمز المكون من ٦ أرقام',
      'en': 'Please enter the 6-digit code',
    },
    'invalidCode': {
      'ku': 'کۆدەکە هەڵەیە',
      'ar': 'الرمز خاطئ',
      'en': 'Invalid code',
    },
    'passwordTooShort': {
      'ku': 'وشەی نهێنی دەبێت لانیکەم ٦ پیت بێت',
      'ar': 'يجب أن تكون كلمة المرور ٦ أحرف على الأقل',
      'en': 'Password must be at least 6 characters',
    },
    'passwordsDoNotMatch': {
      'ku': 'وشەی نهێنییەکان یەک ناگرنەوە',
      'ar': 'كلمتا المرور غير متطابقتين',
      'en': 'Passwords do not match',
    },
    'passwordResetSuccess': {
      'ku': 'وشەی نهێنی بە سەرکەوتوویی گۆڕدرا',
      'ar': 'تم تغيير كلمة المرور بنجاح',
      'en': 'Password reset successfully',
    },
    'enterEmailForReset': {
      'ku': 'ئیمەیڵەکەت بنووسە',
      'ar': 'أدخل بريدك الإلكتروني',
      'en': 'Enter your email',
    },
    'enterEmailDescription': {
      'ku': 'کۆدێکت بۆ دەنێرین بۆ گۆڕینی وشەی نهێنی',
      'ar': 'سنرسل لك رمزاً لإعادة تعيين كلمة المرور',
      'en': 'We will send you a code to reset your password',
    },
    'enterCode': {
      'ku': 'کۆدەکە بنووسە',
      'ar': 'أدخل الرمز',
      'en': 'Enter code',
    },
    'enterCodeDescription': {
      'ku': 'کۆدەکە نێردراوە بۆ ئیمەیڵەکەت',
      'ar': 'تم إرسال الرمز إلى بريدك الإلكتروني',
      'en': 'The code has been sent to your email',
    },
    'resendCode': {
      'ku': 'دووبارە ناردنی کۆد',
      'ar': 'إعادة إرسال الرمز',
      'en': 'Resend code',
    },
    'enterNewPassword': {
      'ku': 'وشەی نهێنی نوێ بنووسە',
      'ar': 'أدخل كلمة مرور جديدة',
      'en': 'Enter new password',
    },
    'enterNewPasswordDescription': {
      'ku': 'وشەیەکی نهێنی بە هێز هەڵبژێرە',
      'ar': 'اختر كلمة مرور قوية',
      'en': 'Choose a strong password',
    },
    'newPassword': {
      'ku': 'وشەی نهێنی نوێ',
      'ar': 'كلمة المرور الجديدة',
      'en': 'New password',
    },
    'sendCode': {
      'ku': 'ناردنی کۆد',
      'ar': 'إرسال الرمز',
      'en': 'Send code',
    },
    'verifyCode': {
      'ku': 'پشتڕاستکردنەوەی کۆد',
      'ar': 'التحقق من الرمز',
      'en': 'Verify code',
    },
    'resetPassword': {
      'ku': 'گۆڕینی وشەی نهێنی',
      'ar': 'إعادة تعيين كلمة المرور',
      'en': 'Reset password',
    },

    // ─── Onboarding ───
    'skip': {
      'ku': 'بازدان',
      'ar': 'تخطي',
      'en': 'Skip',
    },
    'next': {
      'ku': 'دواتر',
      'ar': 'التالي',
      'en': 'Next',
    },
    'getStarted': {
      'ku': 'دەست پێ بکە',
      'ar': 'ابدأ الآن',
      'en': 'Get Started',
    },
    'onboarding1Title': {
      'ku': 'خوێندنگاکانی کوردستان و عێراق',
      'ar': 'مؤسسات كوردستان والعراق',
      'en': 'Kurdistan & Iraq Institutions',
    },
    'onboarding1Desc': {
      'ku': 'هەموو زانکۆ، پەیمانگە، قوتابخانە و باخچەکان لەیەک شوێندا',
      'ar': 'جميع الجامعات والمعاهد والمدارس والروضات في مكان واحد',
      'en': 'All universities, institutes, schools and kindergartens in one place',
    },
    'onboarding2Title': {
      'ku': 'گەڕان و دۆزینەوە',
      'ar': 'البحث والاستكشاف',
      'en': 'Search & Discover',
    },
    'onboarding2Desc': {
      'ku': 'بە ئاسانی بگەڕێ و خوێندنگای گونجاوت بدۆزەوە',
      'ar': 'ابحث بسهولة وابحث عن المؤسسة المناسبة لك',
      'en': 'Easily search and find the right institution for you',
    },
    'onboarding3Title': {
      'ku': 'نەخشەی شوێنەکان',
      'ar': 'خريطة المواقع',
      'en': 'Location Map',
    },
    'onboarding3Desc': {
      'ku': 'شوێنی خوێندنگاکان ببینە لەسەر نەخشە',
      'ar': 'شاهد مواقع المؤسسات على الخريطة',
      'en': 'See institution locations on the map',
    },
    'onboarding4Title': {
      'ku': 'پاشەکەوتکردن',
      'ar': 'حفظ المفضلات',
      'en': 'Save Favorites',
    },
    'onboarding4Desc': {
      'ku': 'خوێندنگای دڵخوازت پاشەکەوت بکە بۆ دواتر',
      'ar': 'احفظ مؤسساتك المفضلة للرجوع إليها لاحقاً',
      'en': 'Save your favorite institutions for later',
    },

    // ─── Report ───
    'reportInstitution': {
      'ku': 'ڕاپۆرتکردن',
      'ar': 'الإبلاغ',
      'en': 'Report',
    },
    'selectReportType': {
      'ku': 'جۆری ڕاپۆرت هەڵبژێرە',
      'ar': 'اختر نوع البلاغ',
      'en': 'Select report type',
    },
    'additionalDetails': {
      'ku': 'وردەکارییەکانی زیادە',
      'ar': 'تفاصيل إضافية',
      'en': 'Additional details',
    },
    'additionalDetailsOptional': {
      'ku': 'ئارەزوومەندانە - بۆ باشترکردنی ڕاپۆرتەکەت',
      'ar': 'اختياري - لتحسين بلاغك',
      'en': 'Optional - to improve your report',
    },
    'describeIssue': {
      'ku': 'کێشەکە شرۆڤە بکە...',
      'ar': 'اشرح المشكلة...',
      'en': 'Describe the issue...',
    },
    'submitReport': {
      'ku': 'ناردنی ڕاپۆرت',
      'ar': 'إرسال البلاغ',
      'en': 'Submit report',
    },
    'reportSubmitted': {
      'ku': 'سوپاس! ڕاپۆرتەکەت نێردرا',
      'ar': 'شكراً! تم إرسال بلاغك',
      'en': 'Thanks! Your report has been submitted',
    },

    // ─── Force Update ───
    'updateAvailable': {
      'ku': 'نوێکردنەوەی نوێ بەردەستە',
      'ar': 'تحديث جديد متاح',
      'en': 'Update Available',
    },
    'version': {
      'ku': 'وەشان',
      'ar': 'الإصدار',
      'en': 'Version',
    },
    'forceUpdateDesc': {
      'ku': 'پێویستە ئەپلیکەیشنەکە نوێ بکەیتەوە بۆ بەردەوامبوون',
      'ar': 'يجب تحديث التطبيق للاستمرار',
      'en': 'You must update the app to continue',
    },
    'updateDesc': {
      'ku': 'وەشانی نوێ بەردەستە بۆ تایبەتمەندی و چاکسازی باشتر',
      'ar': 'إصدار جديد متاح بميزات وإصلاحات أفضل',
      'en': 'A new version is available with better features and fixes',
    },
    'whatsNew': {
      'ku': 'چی نوێیە؟',
      'ar': 'ما الجديد؟',
      'en': "What's new?",
    },
    'updateNow': {
      'ku': 'نوێکردنەوە',
      'ar': 'تحديث الآن',
      'en': 'Update Now',
    },
    'later': {
      'ku': 'دواتر',
      'ar': 'لاحقاً',
      'en': 'Later',
    },

    // ─── Nearby ───
    'nearbyTitle': {
      'ku': 'نزیکترینەکان',
      'ar': 'الأقرب',
      'en': 'Nearby',
    },
    'nearbyDiscover': {
      'ku': 'نزیکترین خوێندنگاکان بدۆزەرەوە',
      'ar': 'اكتشف أقرب المؤسسات',
      'en': 'Discover nearby institutions',
    },
    'nearbyDiscoverDesc': {
      'ku': 'دەستگەیشتن بە GPS بۆ بینینی نزیکترینەکان',
      'ar': 'اسمح بالوصول إلى GPS لرؤية الأقرب',
      'en': 'Allow GPS access to see nearest ones',
    },
    'nearbyLoading': {
      'ku': 'شوێنەکەت دەدۆزرێتەوە...',
      'ar': 'جارٍ البحث عن موقعك...',
      'en': 'Finding your location...',
    },
    'nearbyMap': {
      'ku': 'لە ماپ',
      'ar': 'الخريطة',
      'en': 'Map',
    },

    // ─── Posts ───
    'postsTab': {
      'ku': 'پۆستەکان',
      'ar': 'المنشورات',
      'en': 'Posts',
    },
    'noPosts': {
      'ku': 'هیچ پۆستێک نییە',
      'ar': 'لا توجد منشورات',
      'en': 'No posts yet',
    },
    'noPostsDesc': {
      'ku': 'هێشتا پۆستێک بڵاو نەکراوەتەوە',
      'ar': 'لم يتم نشر أي منشور بعد',
      'en': 'No posts have been published yet',
    },
    'writePost': {
      'ku': 'نووسینی پۆست',
      'ar': 'كتابة منشور',
      'en': 'Write a post',
    },
    'postTitle': {
      'ku': 'بابەت',
      'ar': 'العنوان',
      'en': 'Title',
    },
    'postTitleHint': {
      'ku': 'بابەتی پۆستەکە...',
      'ar': 'عنوان المنشور...',
      'en': 'Post title...',
    },
    'postContent': {
      'ku': 'ناوەڕۆک',
      'ar': 'المحتوى',
      'en': 'Content',
    },
    'postContentHint': {
      'ku': 'ناوەڕۆکی پۆستەکە بنووسە...',
      'ar': 'اكتب محتوى المنشور...',
      'en': 'Write your post content...',
    },
    'publishPost': {
      'ku': 'بڵاوکردنەوە',
      'ar': 'نشر',
      'en': 'Publish',
    },
    'postPublished': {
      'ku': 'پۆستەکەت بڵاوکرایەوە!',
      'ar': 'تم نشر منشورك!',
      'en': 'Your post has been published!',
    },
    'postAwaitingApproval': {
      'ku': 'پۆستەکەت نێردرا و چاوەڕوانی پەسەندکردنە',
      'ar': 'تم إرسال منشورك وينتظر الموافقة',
      'en': 'Your post has been sent and is awaiting approval',
    },
    'deletePost': {
      'ku': 'سڕینەوەی پۆست',
      'ar': 'حذف المنشور',
      'en': 'Delete post',
    },
    'deletePostConfirm': {
      'ku': 'دڵنیایت دەتەوێت ئەم پۆستە بسڕیتەوە؟',
      'ar': 'هل أنت متأكد أنك تريد حذف هذا المنشور؟',
      'en': 'Are you sure you want to delete this post?',
    },
    'postDeleted': {
      'ku': 'پۆستەکە سڕایەوە',
      'ar': 'تم حذف المنشور',
      'en': 'Post deleted',
    },
    'addImage': {
      'ku': 'زیادکردنی وێنە',
      'ar': 'إضافة صورة',
      'en': 'Add image',
    },
    'ago': {
      'ku': 'لەمەوبەر',
      'ar': 'منذ',
      'en': 'ago',
    },

    // ─── Admin Dashboard ───
    'adminDashboard': {
      'ku': 'داشبۆردی ئەدمین',
      'ar': 'لوحة الإدارة',
      'en': 'Admin Dashboard',
    },
    'adminPosts': {
      'ku': 'بەڕێوەبردنی پۆستەکان',
      'ar': 'إدارة المنشورات',
      'en': 'Manage Posts',
    },
    'adminPostsDesc': {
      'ku': 'پەسەندکردن و بەڕێوەبردنی هەموو پۆستەکان',
      'ar': 'الموافقة على المنشورات وإدارتها',
      'en': 'Approve and manage all posts',
    },
    'allPosts': {
      'ku': 'هەموو پۆستەکان',
      'ar': 'جميع المنشورات',
      'en': 'All Posts',
    },
    'pendingPosts': {
      'ku': 'چاوەڕوانی پەسەند',
      'ar': 'بانتظار الموافقة',
      'en': 'Pending',
    },
    'approvedPosts': {
      'ku': 'پەسەندکراو',
      'ar': 'تمت الموافقة',
      'en': 'Approved',
    },
    'approvePost': {
      'ku': 'پەسەندکردن',
      'ar': 'موافقة',
      'en': 'Approve',
    },
    'rejectPost': {
      'ku': 'ڕەتکردنەوە',
      'ar': 'رفض',
      'en': 'Reject',
    },
    'postApproved': {
      'ku': 'پۆستەکە پەسەندکرا',
      'ar': 'تمت الموافقة على المنشور',
      'en': 'Post approved',
    },
    'postRejected': {
      'ku': 'پۆستەکە ڕەتکرایەوە',
      'ar': 'تم رفض المنشور',
      'en': 'Post rejected',
    },
    'adminInstitutions': {
      'ku': 'بەڕێوەبردنی دامەزراوەکان',
      'ar': 'إدارة المؤسسات',
      'en': 'Manage Institutions',
    },
    'adminInstitutionsDesc': {
      'ku': 'سەیرکردن و دەستکاری دامەزراوەکان',
      'ar': 'عرض وتعديل المؤسسات',
      'en': 'View and edit institutions',
    },
    'totalPosts': {
      'ku': 'کۆی پۆستەکان',
      'ar': 'إجمالي المنشورات',
      'en': 'Total Posts',
    },
    'pending': {
      'ku': 'چاوەڕوان',
      'ar': 'معلق',
      'en': 'Pending',
    },
    'approved': {
      'ku': 'پەسەندکراو',
      'ar': 'موافق عليه',
      'en': 'Approved',
    },
    'institutionName2': {
      'ku': 'ناوی دامەزراوە',
      'ar': 'اسم المؤسسة',
      'en': 'Institution',
    },
    'like': {
      'ku': 'پەسەند',
      'ar': 'إعجاب',
      'en': 'Like',
    },
    'comment': {
      'ku': 'کۆمێنت',
      'ar': 'تعليق',
      'en': 'Comment',
    },
    'shareLabel': {
      'ku': 'هاوبەش',
      'ar': 'مشاركة',
      'en': 'Share',
    },
  };
}
