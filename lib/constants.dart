import 'package:cloud_firestore/cloud_firestore.dart';

const kHorizintalPadding = 16.0;
const kIsOnBoardingViewSeen = 'isOnBoardingViewSeen';
const kIsUserStateSelected = 'isUserStateSelected';
const kisFirstTimeCustomProfileAppBar = 'isFirstTimeCustomProfileAppBar';
// const supabaseUrl = 'https://nymgkcbjfuwigfahlbsr.supabase.co';
// const supabaseKey =
//     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im55bWdrY2JqZnV3aWdmYWhsYnNyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzM1OTg1OTAsImV4cCI6MjA0OTE3NDU5MH0.S9PmafZ2bjjXSsRc5NF6REvNe2GjCw5qQbc_KV1oCjM';
const kUserData = 'userData';
final kFirebaseFirestore = FirebaseFirestore.instance;
const kagreementKeywords = [
  // كلماتك الأصلية (المهمة)
  'اتفقنا', 'موافق', 'تمام', 'تم', 'أكد', 'انتهى', 'مؤكد', 'حاضر',
  'agree', 'agreed', 'ok', 'fine', 'yes', 'done', 'confirmed', 'accepted',

  // الإضافات "المصرية" لرفع الدقة
  'خلاص', // الكلمة رقم 1 للاتفاق
  'ماشي', // موافقة عامة
  'قشطة', // موافقة شبابية
  'قشطه', // البديل الإملائي
  'اعتمد', // تأكيد نهائي
  'خلصانة', // تأكيد نهائي
  'خلصانه', // البديل الإملائي
  'بيس', // موافقة (Peace)
  'أمين', // موافقة دارجة
  'يلا', // تشجيع على البدء
  'توكلنا', // بداية الاتفاق الفعلي
  'العنوان', // مؤشر على التحرك الفعلي
  'لوكيشن', // مؤشر على التحرك الفعلي
  'اللوكيشن',
  'جاي', // تأكيد الحضور
  'خلاص ماشي',
];
