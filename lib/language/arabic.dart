Map<String, String> ar = {
//   'hello': 'Hellosss',
//   //home    الرئيسية
//   'dashboard': 'لوحة التحكم ',
//   'payment': 'الدفع ',
//   'E-Payment': 'الدفع الإلكتروني ',
//   'pos': 'أجهزة نقاط البيع ',
//   'wallet': 'المحفظة ',
//   'more': 'أكثر ',
//   'Please fill 6 digit OTP': 'من فضلك أدخل 6 أرقام لكلمة المرور لمره واحدة ',
//   'Can’t receive the OTP?': 'لم أتمكن من استلام كلمة المرور ?',
//   'OTP is valid upto': 'كلمة المرور صالحة ل',
//   'seconds': 'ثواني ',
//   'Create Quick Invoice': 'إنشاء فاتورة سريعة ',
//   'Quick Invoice': 'فاتورة سريعة',
//   'Invoice Amount': 'قيمة الفاتورة',
//   'Product Link': 'رابط منتج ',
//   'enabled': 'ممكن',
//   'disabled': 'غير ممكن',
//   ' Authentication': ' المصادقة',
//
//   'Enter 6 digit OTP': 'أدخل كلمة المرور لمرة واحدة (OTP) المكون من 6 أرقام',
//   'We just sent the OTP to your mobile number':
//       'لقد أرسلنا للتو OTP إلى رقم هاتفك المحمول',
//
//   //dashboard لوحة التحكم
//   'Activate product link': 'تفعيل رابط المنتج',
//   'create Invoice': 'إنشاء فاتورة',
//   'create QR Code': "إنشاء كود",
//   'Pending to Deliver': "في انتظار التسليم",
//   'create Subscription': "إنشاء إشتراك",
//   'create Product': "إنشاء منتج",
//   'amount': "قيمة",
//   'count': "عدد",
//   'Master Card': "ماستر كارد",
//   'Visa Card': "فيزا كارد",
//   'Apple Pay': "أبل باي",
//   'Sadad Wallet': "محفظة سداد",
//   'Today': 'اليوم',
//   'Yesterday': "أمس",
//   'Week': "أسبوع",
//   'Month': "شهر",
//   'Year': "سنة",
//   'Custom': "تخصيص",
//   'hi': 'مرحبا ',
//   'محمود': 'Mahmoud',
//   'Welcome Back,': 'مرحبا بعودتك,',
//   'scan': 'مسح',
//   'Total Available Balance': 'إجمالي الرصيد المتاح',
//   'settlement': 'التسوية',
//   'Withdraw': 'سحب',
//   'charts': 'مخططات بيانية',
//   'We are Sorry for your inconvenience. unable to fetch Data':
//       'لا توجد سجلات للمدة المحددة والمعايير!',
//   'success': 'ناجحة',
//   'failure': 'فاشلة',
//   'transaction Source': 'مصدر العملية',
//   'paymentMethod': 'طريقة الدفع ',
//   'Fast Invoice': 'فاتورة سريعة',
//   'Create fast invoice with full amount only':
//       'إنشاء فاتورة سريعة بكامل المبلغ فقط ',
//   'Detailed Invoice': 'فاتورة مفصلة',
//   'Create detailed Invoice with product & services':
//       'إنشاء فاتورة مفصلة مع المنتج و الخدمات ',
//   'Please Select Correct Date': 'من فضلك اختر التاريخ الصحيح',
//   'Date Should be 1 year': ' يجب أن يكون التاريخ سنة واحدة',
//   'Select the balance': 'حدد الرصيد',
//
//   //fast Invoice فاتورة سريعة
//   "Create Fast Invoice": "إنشاء فاتورة سريعة",
//   "Mobile Number": "رقم الهاتف",
//   "Number cannot be empty": "لا يمكن أن يكون الرقم فارغًا",
//   "Customer Name": "أسم العميل ",
//   "Name cannot be empty": "لا يمكن أن يكون الاسم فارغًا ",
//   "Invoice Amount": "قيمة الفاتورة",
//   "Amount cannot be empty": "لا يمكن أن يكون المبلغ فارغًا ",
//   "Descriptions": "الوصف",
//   "Save Draft": "حفظ كمسودة",
//   "Send Invoice": "إرسال الفاتورة",
//   'Save draft successFully': "تم الحفظ كمسودة بنجاح",
//   "Something wrong please check data":
//       "هناك شيئاً خطأ الرجاء التحقق من  البيانات",
//
//   //Detail Invoice تفاصيل الفاتورة
//   "Invoice Items": "بنود الفاتورة",
//   "Add Items": "إضافة بنود",
//   "Items": "البنود",
//   "You don’t added any product or Items yet":
//       " لم تقم بإضافة أي بنود أو منتجات",
//   "Sub amount": "المبلغ الفرعي",
//   "Discount": "الخصم",
//   "Add Discount": "إضافة خصم ",
//   "Net amount": "المبلغ الصافي",
//   "Create Detailed Invoice": "إنشاء فاتورة مفصلة ",
//   "Notify Once the Invoice is Viewed": "تنبيهي بمجرد رؤية الفاتورة",
//   "Add Description": "إضافة وصف",
//   "Number should be 10 digit": "يجب أن يتكون الرقم من 10 أرقام ",
//   "Save Invoice": "حفظ الفاتورة",
//   "Success": "ناجحة",
//   "Invoice save successFully": "تم حفظ الفاتورة بنجاح",
//   "error": "خطأ",
//   "Please select item": "الرجاء إختيار بند",
//   "please fill data": "الرجاء تعبئة البيانات",
//   "Invoice Send SuccessFully": "تم إرسال الفاتورة بنجاح",
//   "Draft Invoice SuccessFully": "تم حفظ الفاتورة كمسودة بنجاح ",
//
// //payment screen شاشة الدفع
//   'Successful Transactions': 'العمليات الناجحة',
//   'Payout Received': 'الإيداعات المستلمة',
//   'Subscriptions Amount': ' قيمة الاشتراكات ',
//   'Product Sold Amount': 'قيمة المنتج المباع ',
//   'Invoices': 'الفواتير ',
//   'Products': 'المنتجات',
//   'Store': 'المتجر',
//   'Subscriptions': 'الاشتراكات',
//   'Transactions': 'العمليات ',
//   'Orders': 'الطلبات',
//   'Reports': 'التقارير',
//   'Online Payment': 'الدفع الإلكتروني',
//   'Invoices, Products, Subscriptions , Transaction, Order, ':
//       'الفواتير , المنتجات , الاشتراكات  , العملية , الطلب , ',
//   'Services': 'الخدمات',
//   'warning': 'تحذير',
//   'E-Commerce': 'التجارة الإلكترونية',
//   'Please select range in 12 month': 'الرجاء تحديد النطاق في 12 شهر ',
//
//   //add item invoice إضافة بند للفاتورة
//   'Add Product': 'إضافة منتج ',
//   'abc': 'ا,ب , ت ',
//   'New Item': 'بند جديد',
//   'Item Name': 'اسم البند',
//   'Item Name cannot be empty': 'لا يمكن أن يكون اسم البند  فارغًا',
//   'Item Price': 'سعر البند',
//   'Price cannot be empty': 'لايمكن أن يكون السعر فارغًا',
//   'Quantity': 'الكمية',
//   'Quantity cannot be empty': 'لا يمكن أن تكون الكمية فارغة',
//   'Add': 'إضافة',
//   'Update': 'تحديث',
//   'Session Expire': 'انتهاء الجلسة',
//   //add product اضافة منتج
//   'Items Selected': 'البنود المحددة',
//   'Search': 'بحث',
//   'All Products': 'كل المنتجات ',
//   'Something Wrong': 'هناك شيئاً خطأ',
//   'Please Select Items': 'الرجاء إختيار البنود ',
//   'Cancel': 'إلغاء',
//   //Invoice Detail تفاصيل الفاتورة
//   'Edit': 'تعديل',
//   'Copy link': 'نسخ الرابط',
//   'Share': 'مشاركة ',
//   'Send notification': 'إرسال إشعار ',
//   'Delete': 'حذف',
//   'Set as Default': 'تعيين إفتراضي',
//   'Customer name': 'إسم العميل ',
//   'Customer Mobile no.': 'رقم هاتف العميل .',
//   'UserName': 'إسم المستخدم',
//   'Customer email': 'البريد الإلكتروني للعميل ',
//   'Transaction ID': 'رقم العملية ',
//   'Upload': 'تحميل',
//   'Invoice no': 'رقم الفاتورة ',
//   'Total Invoice amount': 'إجمالي قيمة الفاتورة',
//   'Invoice Details': 'تفاصيل الفاتورة',
//   'delete successFully': 'تم الحذف بنجاح',
//   'YES': 'نعم',
//   'NO': 'لا`',
//   'Notification': 'الإشعارات',
//   //login screen شاشة الدخول
//   'Login': 'تسجيل الدخول ',
//   'Can\'t login?': 'لا أستطيع الدخول ?',
//   'Log in': 'تسجيل الدخول ',
//   'Login by isometric': 'تسجيل الدخول بالبصمة ',
//   'Don\'t have an account?': 'ليس لدي حساب?',
//   'Register': 'تسجيل',
//
//   //password screen شاشة كلمة المرور
//   'Enter your account password': 'أدخل كلمة المرور للحساب ',
//   'Password': ' كلمة المرور ',
//   'OTP Send Successfully': 'تم إرسال كلمة المرور لمرة واحدة بنجاح ',
//   'check data': 'التحقق من البيانات',
//   'Login Failed check data': 'فشل في تسجيل الدخول ,, تحقق من البيانات',
//   'Next': 'التالي',
//
//   //OTP screen شاشة كلمة المرور لمرة واحدة
//   'Enter the OTP': 'أدخل كلمة المرور لمرة واحدة ',
//   'We have sent the OTP to the number':
//       'تم إرسال كلمة المرور لمرة واحدة إلى الرقم ',
//   'Don\'t receive the OTP?': 'لم يتم استلام كلمة المرور لمرة واحدة  ?',
//   'Resend': 'إعادة إرسال',
//   'Please fill OTP': 'من فضلك قم بتعبئة  كلمة المرور لمرة واحدة',
//   'Otp verified successfully': 'تم التحقق من كلمة المرور لمرة واحدة بنجاح ',
//   'Please check OTP': 'الرجاء التحقق من كلمة المرور لمره واحدة ',
//
//   //invoice list قائمة الفواتير
//   'No data found': 'لاتوجد بيانات',
//   'No Data Found': 'لا توجد بيانات ',
//   'Draft': 'مسودة',
//   'Unpaid': 'غير مدفوعة',
//   'Paid': 'مدفوعة',
//   'Overdue': 'متأخرة',
//   'Rejected': 'مرفوضة',
//   'Paid Invoices': 'الفواتير المدفوعة',
//   'Unpaid Invoices': 'الفواتير الغير مدفوعة ',
//   'Created Invoices': 'إنشاء الفواتير ',
//   'All': 'الكل',
//   'Select Dates': 'حدد التاريخ ',
//   'SelectedDates: ': 'التواريخ المحددة : ',
//   'Select': 'حدد',
//
//   //filter screen invoice
//   'Filter': 'تصنيف',
//   'Sort by': 'تصنيف حسب',
//   'Created date': 'تاريخ الإنشاء',
//   'Customer ID': 'رقم العميل ',
//   'Invoice ID': 'رقم الفاتورة',
//   'Invoice amount': 'قيمة الفاتورة',
//   'Clear Filter': 'مسح التصنيف',
//   'by Amount': 'بواسطة القيمة',
//
//   //order Screen شاشة الطلبات
//   'Total Orders Received': 'إجمالي الطلبات المستلمة ',
//   'Orders Delivered': 'تسليم الطلبات',
//   'Orders Pending': 'الطلبات المعلقة ',
//   'ex. customer name,phone,invoice no,amount,id......':
//       'ex. اسم العميل ,الهاتف,رقم الفاتورة ,القيمة ,رقم  ........',
//
//   //createProductScreen شاشة  إنشاء المنتج
//   'Edit Product': 'تعديل  منتج ',
//   'Create Product': 'إنشاء منتج ',
//   'Max Image dimension 500px X 500px, MAX 1MB':
//       'Max Image dimension 500px X 500px, MAX 1MB',
//   'Add Product image': 'أضف صورة المنتج ',
//   'Add Water mark to the Image': 'إضافة علامة مائية للصورة ',
//   'Product Name': 'إسم المنتج ',
//
//   'Unit Priced': 'سعر الوحدة ',
//   'price cannot be empty': 'لا يمكن أن يكون السعر فارغًا',
//   'value must be under 20000': 'يجب أن تكون القيمة أقل من 20000',
//   'Available Quantity': 'الكمية المتاحة',
//   'quantity cannot be empty': 'لا يمكن أن تكون الكمية فارغة',
//   'Expected Delivery Days': 'يوم التسليم المتوقع ',
//   'Item & Description': 'Iالبند و الوصف ',
//   'description cannot be empty': 'لايمكن أن يكون الوصف فارغًا',
//   'description length at list 5': 'يجب أن لا يقل الوصف عن 5 أحرف ',
//   'Add to Product list': 'قم بإضافة المنتج للقائمة ',
//   'Unlimited Product Quantity': 'كمية غير محدودة من المنتج ',
//   'Allow only once purchase per cell Number':
//       'السماح بالشراء مرة واحدة فقط لكل رقم هاتف ',
//   'Show Product on store': 'عرض المنتج في المتجر ',
//   'please check Image File': 'الرجاء التحقق من صورة الملف',
//   'file should be in png, jpg,pdf format':
//       'يجب أن يكون الملف بتنسيق png ، jpg ، pdf ',
//   'Please fill Data': 'الرجاء تعبئة البيانات ',
//   'Please select Days': 'الرجاء إختيار اليوم ',
//   'Immediate': 'في الحال ',
//   '1 to 2 Days': 'من يوم الى يومين ',
//   '3 to 5 Days': 'من 3 أيام الي 5 أيام ',
//   '1 Week': 'أسبوع واحد',
//   ' Weeks': '2-4 أ،2-4 أسابيع ',
//   ' Month': '1 شهر واحد',
//   ' Month': '2 شهرين ',
//   'Delivered': 'مستلمة ',
//   'Pending': 'معلق',
//   'Please Check data or product name already exist':
//       'الرجاء التحقق من البيانات او إسم المنتج موجود بالفعل ',
//   'Product Created SuccessFully': 'تم إنشاء المنتج بنجاح ',
//   'Product detail are updated': 'تم تحديث بيانات المنتج ',
//   'Description is required!': 'الوصف مطلوب!',
//   'Text Need To Be Atleast 5 Character': 'يجب أن يكون النص على الأقل 5 أحرف',
//   'Description is too long. Maximum 5000 characters allowed.':
//       'يجب أن يكون النص على الأقل 5 أحرف',
//   'Activity': 'نشاط',
//   'Merchant details will be verified and it will be activate automatically.':
//       'سيتم التحقق من تفاصيل التاجر وسيتم تفعيلها تلقائيًا.',
//
//   //my productScreen شاشة المنتجات الخاصة بي
//   'Select all': 'حدد الكل ',
//   'My Products': 'منتجاتي ',
//   'Export': 'تصدير ',
//   'Remove From Store': 'إزالة من المتجر ',
//   'Add to store': 'إضافة الي المتجر ',
//   'Add to new invoice': 'إضافة الي فاتورة جديدة',
//   'Download Options': 'خيارات التنزيل ',
//   'Select Format': 'حدد التنسيق ',
//   'Send Email to': 'أرسل البريد الالكتروني الي ',
//   'DownLoad': 'تنزيل',
//   'Download': 'تنزيل',
//
//   //orderDetail Screen
//   'Order Details': 'تفاصيل الطلب ',
//   'Order No.': 'رقم الطلب .',
//   'Details': 'التفاصيل ',
//
//   //product detail تفاصيل المنتج
//   'Sold': 'مباع',
//   'Show in E-store': 'عرض في المتجر الإلكتروني ',
//   'Expected delivery': 'التسليم المتوقع ',
//   'day after': 'بعد يوم ',
//
//   //transaction filter تصنيف العمليات
//   'Refund status': 'حالة استرجاع الاموال ',
//   'Transaction status': 'حالة العملية ',
//   'Payment methods': 'طريقة الدفع',
//   'Transaction Modes': 'وضع العملية',
//   'Transaction Sources': 'مصدر العملية',
//   'Refunded': 'تم الإسترجاع ',
//   'Requested': 'تم الطلب ',
//   'From': 'من ',
//   'Transactions details': 'تفاصيل العمليات',
//   //transaction screen
//   'InProgress': 'تحت الإجراء ',
//   'Failed': 'فاشلة ',
//   'On-Hold': 'معلقة ',
//   'Please Select Report Type': 'الرجاء تحديد نوع التقرير ',
//   //refund detail تفاصيل الإسترجاع
//   'Refund Details': 'تفاصيل الإسترجاع',
//   'Refund ID.': 'رقم الإسترجاع .',
//   'Inprogress': 'تحت الاجراء ',
//   'Refund': 'استرجاع الأموال',
//   'Onhold': 'معلق ',
//   'Transaction Type': 'نوع العملية',
//   'Refund amount': 'قيمة الإسترجاع',
//   'Refund type': 'نوع الإسترجاع',
//   'Partial': 'جزئي',
//   'Full': 'كلي ',
//   'Remaining amount': 'المبلغ المتبقي ',
//   'Sadad charges': 'عمولة سداد ',
//   'Refund reason': 'سبب استرجاع الأموال ',
//   'Transaction ID.': 'رقم العملية.',
//   'Transaction amount': 'قيمة العملية',
//   'Transaction response code': 'كود إستجابة  العملية',
//   'Transaction response message': 'رسالة استجابة العملية ',
//   'Auth Number': 'رقم التفويض',
//   'Payment Method': 'طريقة الدفع ',
//   'Card number': 'رقم البطاقة ',
//   'Card holder name': 'إسم حامل البطاقة',
//   'Customer Email ID': 'عنوان البريد الإلكتروني للعميل ',
//   'Dispute ID': 'رقم الشكوى ',
//   'Guest User': 'مستخدم زائر',
//   'Enter the refund Full Amount': 'أدخل المبلغ المسترد بالكامل',
//   //search screen
//   'Payments': 'المدفوعات',
//   'Refunds': 'الإسترجاع',
//   'Disputes': 'النزاعات',
//   'Search Result': 'نتيجة البحث',
//   'Download Receipt': 'تنزيل الإيصال',
//   'Refund Amount': 'قيمة الإسترجاع',
//   'Full refund': 'استرداد كامل',
//   'Partial refund': 'رد جزئي',
//
//   //transaction detail screen شاشة تفاصيل المعاملات
//   'Transaction Details': 'تقاصيل العملية',
//   'OPEN': 'فتح',
//   'UNDER REVIEW': 'قيد المراجعة',
//   'CLOSED': 'اغلاق',
//   'Purchase': 'شراء ',
//   'Sadad Charges': 'عمولة سداد ',
//   'Transaction Source': 'مصدر المعاملة',
//   'Invoice': 'فاتورة ',
//   'Subscription': 'إشتراك ',
//   'Add Funds': 'إضافة أموال',
//   'Withdrawal': 'سحب الأموال ',
//   'Transfer': 'تحويل',
//   'Store link': 'رابط المتجر ',
//   'PG API': 'بوابة الدفع API ',
//   'AJAX Transaction': 'عملية AJAX ',
//   'Mawaid': 'موعد',
//   'Reward': 'مكافئات',
//   'Reward Add Funds': 'إضافة المكافئات',
//   'Partner Reward': 'مكافئة الشريك',
//   'Manual Service Charge': 'رسوم الخدمة اليدوية',
//   'POS Transaction': 'عمليات نقاط البيع,',
//   'Other': 'أخري',
//   'Source ID': 'رقم المصدر ',
//
//   //report screen  شاشة التقارير
//   'View and Download\nOnline Payment Reports':
//       'عرض وتنزيل تقارير المدفوعات الإلكترونية',
//   'Select your Report': 'حدد التقرير ',
//   'From': 'من',
//   'To': 'إلى ',
//   'Waring': 'تحذير',
//   'Please Select Type': 'الرجاء تحديد النوع ',
//   'Please Select Dates': 'الرجاء تحديد التواريخ',
//   'View result': 'عرض النتائج',
//   'Settlement Details': 'تفاصيل التسوية',
//   'Invoice Payments Details': 'تفاصيل فاتورة الدفع ',
//   'Subscription Payments Details': 'تفاصيل مدفوعات الاشتراك',
//   'Store Orders Details': 'تفاصيل طلبات المتجر ',
//   'Are you sure you want to cancel this withdraw Request ?':
//       'هل أنت متأكد أنك تريد إلغاء طلب السحب هذا؟',
//   //report detail screen شاشة تفاصيل التقارير
//
//   'Download': 'تنزيل',
//   'Transaction Method': 'طريقة العملية',
//   'Transaction Amount': 'قيمة العملية',
//   'Transaction Status': 'حالة العملية',
//   'Transaction Status': 'حالة العملية',
//   'Coming soon': 'قريبآ سيآتي',
//   'Transaction': 'العملية',
//
//   //pos screen شاشة أجهزة نقاط البيع
//   'POS Balance': 'رصيد جهاز نقاط البيع ',
//   'Live Terminal': 'الجهاز النشط ',
//   'View your live terminal location': 'عرض موقع الجهاز النشط ',
//   'Filter cleared': 'مسح التصفية',
//   'Dispute Type': 'نوع النزاع ',
//   'Active': 'نشط',
//   'InActive': 'غير نشط ',
//   'Preauth Complete': 'Preauth Complete',
//   'Preauth': 'Preauth',
//   'Reversal': 'انعكاس',
//   'ManualEntry Purchase': 'شراء بالإدخال اليدوي ',
//   'Card Verification': 'التحقق من البطاقة ',
//   'Chip': 'الشريحة ',
//   'Magstripe': 'Magstripe',
//   'Contactless': 'بدون لمس',
//   'Fallback': 'تراجع',
//   'Manual Entry': 'الإدخال اليدوي',
//   'Open': 'افتح',
//   'Under Review': 'قيد المراجعة ',
//   'Close': 'مغلق',
//   'ChargeBack': 'استرجاع مبلغ مدفوع',
//   'Fraud': 'احتيال',
//   'Disputes Status': 'حالة النزاع ',
//   'Card Entry Type': 'نوع إدخال البطاقة',
//   'Transaction Types': 'أنواع العمليات',
//   'Refund Status': 'حالة الإسترجاع',
//   'Rental Payment Status': 'حالة دفع الإيجار',
//   'Dispute Details': 'تفاصيل النزاع',
//   'Dispute ID.': 'رقم الشكوى.',
//   'Dispute amount': 'قيمة النزاع',
//   'Dispute': 'النزاع',
//   'Comment': 'تعليق',
//   'Terminal Id': 'رقم الجهاز ',
//   'Terminal Name:': 'إسم الجهاز:',
//   'Device ID': 'رقم الجهاز',
//   'Transaction mode': 'وضع العملية',
//   'PosRental Details': 'تفاصيل تأجير نقاط البيع',
//   'Invoice No.': 'رقم الفاتورة.',
//   'Pos Rental': 'إيجار جهاز نقاط البيع ',
//   'Description': 'الوصف ',
//   'We have charged the rental amount for following terminals.':
//       'تم دفع قيمة الإيجار للأجهزة التالية .',
//   'Device Type': 'نوع الجهاز',
//   'Quantities': 'الكمية',
//   'Setup fees': 'رسوم التأسيس ',
//   'Rental amount': 'قيمة الأيجار ',
//   'Additional amount': 'مبلغ إضافي',
//   'Sub Total': 'المجموع الفرعي  ',
//   'Transactions Details': 'تفاصيل العمليات',
//   'Transactions ID.': 'الرقم التعريفي للعمليات',
//   'Transactions Amount': 'قيمة العمليات',
//   'Transactions Type': 'نوع العمليات',
//   'Transactions Mode': 'وضع العمليات',
//   'Card Number': 'رقم البطاقة',
//   'Terminal Name': 'إسم الجهاز',
//   'Terminal Location': 'موقع الجهاز',
//   'Device Serial Number': 'الرقم التسلسلي للجهاز ',
//   'Refund Id': 'رقم الاسترجاع',
//   'Rental': 'الإيجار',
//   'POS Rental': 'إيجار جهاز نقاط البيع',
//   'Total Success Transaction(Amount)': 'إجمالي صفقة النجاح (المبلغ)',
//   'Total Success Transactions (Count)': 'إجمالي المعاملات الناجحة (العدد)',
//   'Devices': 'الأجهزة ',
//   'Rental Amount': 'قيمة الإيجار',
//   'Device Details': 'تفاصيل الجهاز',
//   'Device Id.': 'رقم الجهاز .',
//   'Terminal Type': 'نوع الجهاز ',
//   'Device status': 'حالة الجهاز',
//   'Setup Fees': 'رسوم التاسيس',
//   'Rental Start Date': 'تاريخ بدأ الإيجار ',
//   'Device Activated Date': 'تاريخ تنشيط الجهاز ',
//   'Terminal ID': 'رقم الجهاز',
//   'Sim  Number': 'رقم الشريحة',
//   'IMEI Number': 'IMEI رقم',
//   'Total Success Transaction (AMOUNT)': 'إجمالي العمليات الناجحة  (قيمة)',
//   'Total Success Transaction (Count)': 'إجمالي العمليات الناجحة (عدد)',
//   'Last Transaction Date': 'تاريخ أخر عملية',
//   'Currency': 'العملة',
//   'View and Download POS Reports': 'عرض وتنزيل تقارير نقاط البيع',
//   'POS Transaction Details': 'تفاصيل عملية نقاط البيع',
//   'POS Terminals Summary': 'ملخص أجهزة نقاط البيع',
//   'POS Devices Summary': 'ملخص أجهزة نقاط البيع',
//   'Terminals Details': 'تفاصيل الأجهزة',
//   'Terminal ID.': 'رقم الجهاز',
//   'Date & time': 'التارخ و الوقت',
//   'Current Device ID': 'رقم الجهاز الحالي  ',
//   'Previous Device ID': 'رقم الجهاز السابق ',
//   'Previous Device Serial Number': 'الرقم التسلسلي للجهاز السابق ",',
//   'Payment Methods': 'طريقة الدفع ',
//   'City': 'المدينة',
//   'Total Success Transaction(AMOUNT)': 'إجمالي العمليات الناجحة(قيمة )',
//   'Total Success Transactions (Values)': 'إجمالي العمليات الناجحة (قيم)',
//   'Transaction Mode': 'وضع العملية',
//   'Terminals': 'الأجهزة',
//   'Terminal ID:': 'رقم الجهاز :',
//   'Settlement': 'التسوية ',
//
//   //store screen شاشة المتجر
//   'Store Products': 'منتجات المتجر ',
//   'Copy Link': 'نسخ الرابط ',
//   'Store Product': 'منتج المتجر ',
//   'Store Orders': 'طلبات المتجر',
//   'Store Orders Amount': 'كمية طلبات المتجر',
//   'Deactive': 'غير نشط',
//   'Active Products': 'منتجات نشطة',
//   'Deactivated Products': 'منتجات غير نشطة ',
//   'Product': 'منتج',
//   'Create Product with unlimited featured': 'إنشاء منتج بمميزات غير محدودة',
//   'Download Invoice': 'تحميل فاتورة',
//   // more screen  شاشات اكثر
//   'Add your bank account details to transfer your account amount to it.':
//       "أدخل تفاصيل الحساب البنكي الخاص بك لتحويل المبالغ اليه .",
//   'Bank Account': 'الحساب البنكي',
//   'files added': 'تم إضافة الملفات',
//   'Select Language': 'حدد اللغة',
//   'Active User': 'مستخدم نشط',
//   'POS Devices': 'أجهزة نقاط البيع ',
//   'Notifications': 'الإشعارات',
//   'Update Setting': 'تحديث الإعدادات ',
//   'You have to add the blow documents to verify\nyour account.':
//       'يجب إضافة المستندات أدناة لتفعيل حسابك .',
//   'The image of Computer card is not correct,\nkindly upload the correct one.':
//       'صورة بطاقة قيد المنشأة غير صحيحة الرجاء تحميل الصورة بشكل صحيح .',
//   'ex. invoice description': 'السابق. وصف الفاتورة',
//   //Login screen
//
//   'Mobile number': 'رقم الهاتف',
//   "can't login?": ' لاأستطيع الدخول?',
//   'Number should be 8 digit': 'يجب أن يتكون الرقم من 8 أرقام',
//   'Fingerprint': 'بصمة',
//   'Face': 'وجه',
//   'Authentication required': 'يستلزم التوثيق',
//   'Verify identity': 'تحقق من الهوية',
//   'Scan your Face to authenticate': 'امسح وجهك للمصادقة',
//   'Scan your fingerprint to authenticate': 'امسح بصمة إصبعك للمصادقة',
//   'We have sent the OTP to your phone number': 'لقد أرسلنا OTP إلى رقم هاتفك',
//   'Face': 'وجه',
//
//   //Register Screen
//   'Select your account type': 'حدد نوع حسابك  ',
//   'Business Account': 'حساب تجاري',
//   'Personal Account': 'حساب فردي',
//
//   //Business Account
//
//   'Create new business account': 'إنشاء حساب تجاري جديد',
//   'Fill the below inputs': 'املأ البيانات أدناه',
//   'Business name*': 'الاسم التجاري*',
//   'Email*': 'البريد الالكتروني*',
//   'I agree to the Sadad': 'انا أوافق على سداد',
//   'Terms and conditions': 'الشروط والاحكام',
//   'Name should not be empty': 'يجب ألا يكون الاسم فارغًا',
//   'max characters allowed are 512': 'الحد الأقصى للأحرف المسموح بها هو 512',
//   'Enter a valid email address': 'أدخل عنوان بريد إلكتروني صالح',
//   //Enter phone number screen
//   'Payouts': 'المدفوعات',
//   'Enter your phone number': 'ادخل رقم هاتفك ',
//   'we have sent the OTP to the number':
//       'تم إرسال كلمة المرور لمرة واحده الي الرقم ',
//   ' & Privacy policy.': '& سياسة الخصوصية.',
//
//   // set your password screen
//   "set your account password": ' قم بتعيين كلمة مرور حسابك  ',
//   'Password*': 'كلمة المرور *',
//   'Password requirements': 'متطلبات كلمة المرور ',
//   "12at least 12 characters": ':  حرفاً على الأقل',
//   'A mixture of both uppercase and lowercase letters.':
//       'مزيج من الأحرف الكبيرة والصغيرة.',
//   'A mixture of letters and numbers.': 'مزيج من الحروف والأرقام.',
//   'Inclusion of at lease one spacial character, e.g ! @ # ? ]':
//       'تتضمن علي الاقل أحد الرموز الاتيه, e.g ! @ # ? ]',
//
//   //Signature Screen
//   'E-Signature': 'توقيع الكتروني ',
//   'Please, provide you E-Signature in the below box':
//       'الرجاء ، تزويدنا بالتوقيع الإلكتروني في المربع أدناه',
//   'Clear': 'مسح',
//   'Finish': 'إنتهاء ',
//
//   //Link your Fingerprint
//   'Link your Fingerprint?': 'اربط بصمة إصبعك?',
//   'Skip, for later': 'تخطي ، في وقت لاحق',
//   'Link': 'ربط',
//   'Fingerprint': 'بصمة',
//   'Face': 'وجه',
//   'Authentication required': 'يلزم التوثيق',
//   'verify identity': 'التحقق من الهوية',
//   'Scan your fingerprint to authenticate': 'امسح بصمة اصبعك للمصادقة',
//   'Scan your face to authenticate': 'امسح بصمة الوجه للمصادقة ',
//
//   //password screen
//   'Forgot Password?': 'نسيت كلمة المرور?',
//
//   //Forgot Password screen
//   'we have sent OTP to the number':
//       'تم ارسال كلمة المرور لمرة واحدة الي الرقم ',
//
//   //Dashboard screen
//   "Hi,": 'مرحبا ,',
//   'Create Invoice': 'إنشاء فاتورة ',
//   'Create Subscription': 'إنشاء إشتراك ',
//   'Create QR Code': 'إنشاء رمز الاستجابة السريعة ',
//   'POS Payment': 'دفع نقاط البيع',
//
//   //E-commerce payment
//   'Success Rate': 'معدل النجاح',
//   'Refund Accepted': 'تم قبول إسترجاع الاموال ',
//   'Product sold Amount': 'قيمة المنتج المباع',
//   'Calendly': 'التقويم',
//   'Refunds Accepted': 'المبالغ المعادة مقبولة',
//
//   //POS screen
//   'Sadad POS': 'اجهزة نقاط البيع سداد ',
//   'Active Terminals': 'أجهزة نشطة',
//   'Inactive Terminals': 'أجهزة غير نشطة',
//
//   //success Rate Dialog
//   'Total successful transactions received out of total transactions including failed and successful.':
//       'إجمالي العمليات الناجحة المستلمة من إجمالي العمليات بما في ذلك العمليات الفاشلة والناجحة.',
//
//   //settlement screen
//   'Settlement Reports': 'تقارير التسوية',
//   'Withdrawals': 'سحوبات الأموال ',
//   'Payout': 'الإيداعات',
//
//   //notification screen
//   'Mark All as read': 'ضع علامة علي الكل كمقروء',
//
//   //invoice create
//   'Notify once the Invoice is Viewed': 'تنبيهي بمجرد مشاهدة الفاتورة',
//   'Max Image dimension 500px X 500px, MAX 1 MB':
//       'الحد الاقصي لابعاد الصورة  500px X 500px, MAX 1 MB',
//   'Unlimited product Quantity': 'كمية غير محدودة من المنتجات ',
//
//   //withdrawal detail screen
//   'Withdrawal ID': 'رقم عملية سحب الاموال ',
//   'Withdrawal Type': 'نوع سحب الاموال ',
//   'Withdrawal Amount': 'قيمة سحب الاموال ',
//   'Balance At Withdrawal Request': 'الرصيد عند طلب سحب الأموال',
//   'Bank Name': 'إسم البنك',
//   'Payout Status': 'حالات الإيداع',
//   'Withdrawal Details': 'تفاصيل سحب الأموال ',
//   'Amount': 'مقدار',
//   //payout detail screen
//   'Payout Details': 'تفاصيل الإيداع',
//   'Payout ID': 'رقم الإيداع ',
//   'Payout Amount': 'قيمة الإيداع',
//   'Payout charges': 'عمولة الإيداع',
//   'Bank Number(IBAN)': 'رقم البنك(رقم الايبان الدولي)',
//   'Bank reference No': 'الرقم المرجعي للبنك,',
//   'Rejection Reason': 'سبب الرفض',
//
//   // Withdrawal Screen
//   'Auto Withdrawal': 'سحب تلقائي',
//   'Set your auto withdrawal on then select withdrawal period.':
//       'قم بضبط السحب التلقائي الخاص بك ثم حدد فترة السحب.',
//   'Set Auto withdrawal on': 'ضبط سحب الاموال التلقائي على',
//   'Manual Withdrawal': 'سحب يدوي',
//   'Withdrawal amount': 'قيمة سحب الأموال ',
//   'choose your bank': 'اختر البنك',
//   'Choose withdrawal Request Period': 'اختر فترة طلب سحب الأموال',
//   'Daily': 'يومي',
//   'Weekly': 'اسبوعي ',
//   'Monthly': 'شهري',
//   'Auto Withdrawal Request': 'طلب سحب تلقائي ',
//   'Submit': 'تقديم',
//   'Select Bank': 'حدد البنك',
//   'Set Auto Withdrawal on': 'اضبط السحب التلقائي على',
//   'Choose your bank': 'اختر البنك الذي تتعامل معه',
//   'Active Users': 'المستخدمين النشطين',
//   'My QRcode': 'QRcode الخاص بي',
//   'Business informations': 'المعلومات التجارية',
//   'Signed contract': 'عقد موقع',
//   'Personal Information': 'معلومات شخصية',
//   'Settings': 'إعدادات',
//   'Logout': 'تسجيل خروج',
//   'Business details': 'تفاصيل العمل',
//   'Business name': 'الاسم التجاري',
//   'Business Registration Number': 'رقم التسجيل التجاري',
//   'Email ID': 'عنوان الايميل',
//   'Address': 'تبوك',
//   'Zone': 'منطقة',
//   'Business Documents': 'وثائق العمل',
//   'Street no.': 'رقم الشارع.',
//   'Bldg.no.': 'مبنى رقم.',
//   'Unit no.': 'رقم الوحدة.',
//   'Default Account': 'الحساب الافتراضي',
//   'Account status': 'حالة الحساب',
//   'Actions': 'أجراءات',
//   'The Authorization letter is not right, kindly check it an upload another one.':
//       'خطاب التفويض غير صحيح ، يرجى التحقق منه وتحميله مرة أخرى.',
//   'Bank': 'بنك',
//   'Add bank account': 'إضافة حساب مصرفي',
//   'Bank Account details': 'تفاصيل الحساب المصرفي',
//   'Bank IBAN': 'بنك IBAN',
//   'Account Name': 'أسم الحساب',
//   'Note: You have to add below documents to verify your account':
//       'ملاحظة: يجب عليك إضافة المستندات أدناه للتحقق من حسابك',
//   'IBAN number cannot be empty': 'لا يمكن أن يكون رقم IBAN فارغًا',
//   "IBAN number can't less then 4 digit":
//       "لا يمكن أن يكون رقم IBAN أقل من 4 أرقام",
//   'Account Name cannot be empty': 'لا يمكن أن يكون اسم الحساب فارغًا',
//   'Authorization letter': 'خطاب تفويض',
//   'Upload the bank authorization letter': 'قم بتحميل خطاب التفويض البنكي',
//   'Expiration date': 'تاريخ إنتهاء الصلاحية',
//   'You have to add the below documents to verify\nyour account.':
//       'يجب عليك إضافة المستندات أدناه للتحقق\nالحساب الخاص بك',
//   'Your account status': 'حالة حسابك',
//   'Requirement Documents': 'المستندات المطلوبة',
//   'You can uploading following document for business registration certificate:':
//       'يمكنك تحميل المستند التالي لشهادة تسجيل الأعمال:',
//   'Commercial registration': 'التسجيل التجاري',
//   'Commercial license': 'رخصة تجارية',
//   'Computer card': 'بطاقة كمبيوتر',
//   "Owner's ID card": "بطاقة هوية المالك",
//   'Zone cannot be empty': 'لا يمكن أن تكون المنطقة فارغة',
//   'Street cannot be empty': 'لا يمكن أن يكون الشارع فارغًا',
//   'Bldg cannot be empty': 'لا يمكن أن يكون المبنى فارغًا',
//   'Unit cannot be empty': 'لا يمكن أن تكون الوحدة فارغة',
//   'Scan QRCODE or copy the below code': 'امسح QRCODE أو انسخ الكود أدناه',
//   'Sadad ID': 'معرف سداد',
//   'My Name': 'اسمي',
//   'Change Password': 'غير كلمة السر',
//   'Status': 'حالة',
//   'Admin': 'مسؤل',
//   'Language': 'لغة',
//   'Login and security': 'تسجيل الدخول والأمان',
//   'Face detection': 'الكشف عن الوجه',
//   'App ver': 'إصدار التطبيق',
//   'Current password*': 'كلمة المرور الحالية*',
//   'Password cannot be empty': 'لا يمكن أن تكون كلمة المرور فارغة',
//   'Current Password not valid': 'كلمة المرور الحالية غير صالحة',
//   "Current password and new password can't be same":
//       "لا يمكن أن تكون كلمة المرور الحالية وكلمة المرور الجديدة متطابقتين",
//   'Enter valid password': 'أدخل كلمة مرور صالحة',
//   'Confirm Password*': 'تأكيد كلمة المرور*',
//   'New password and confirm password does not match':
//       'كلمة المرور الجديدة وتأكيد كلمة المرور غير متطابقين',
//   'Please enter password': 'الرجاء إدخال كلمة المرور',
//   'Play Sound': 'تشغيل الصوت',
//   'Receive order': 'إستقبال الأوامر',
//   'Received payment': 'تم استلام المبلغ',
//   'When I get notification': 'عندما أحصل على إشعار',
//   'Receive in Arabic Language': 'تلقي باللغة العربية',
//   'When i receive alert message': 'عندما أتلقى رسالة تنبيه',
//   'Are you sure you want to Logout ?': 'هل أنت متأكد أنك تريد تسجيل الخروج ؟',
//   'You are add there to follow below terms and conditions by clicking "I agree",\n\n1. The auto withdrawal would be generated based on the chosen request frequency.\n2. You are not allowed to cancel the auto withdrawal request.\n3. You can’t get refund for the auto withdrawal request. \n4. Your auto withdrawal would be on hold. ':
//       'أنت تضيف هناك لمتابعة البنود والشروط أدناه بالنقر فوق "أوافق" ،\n\n1. سيتم إنشاء السحب التلقائي بناءً على تردد الطلب المختار. \n2. لا يُسمح لك بإلغاء طلب السحب التلقائي.3.\n لا يمكنك استرداد أموال طلب السحب التلقائي. \n 4. سيكون السحب التلقائي معلقًا.',
//   'If the primary bank account details are changed and not verified by SADAD Admin.\nIf the sufficient amount is not maintained in your SADAD wallet account which is less than the set auto withdrawal amount.\nIf subscribed services (POS Rental, SADAD paid services) charges are due and not cleared from your SADAD wallet account ':
//       'إذا تم تغيير تفاصيل الحساب المصرفي الأساسي ولم يتم التحقق منها من قبل مسؤول سداد. \n إذا لم يتم الاحتفاظ بالمبلغ الكافي في حساب محفظة سداد الخاص بك وهو أقل من مبلغ السحب التلقائي المحدد. \n في حالة الاشتراك في الخدمات (تأجير نقاط البيع ، خدمات سداد المدفوعة) الرسوم مستحقة ولم يتم تسويتها من حساب محفظة سداد الخاص بك',
//   'Selected Dates: ': 'التواريخ المحددة:',
//   'Edit terminal name': 'تحرير اسم المحطة',
//   'View by': 'عرض بواسطة',
//   'In stock': 'في الأوراق المالية',
//   'Out of stock': 'إنتهى من المخزن',
//   'Product View': 'عرض المنتج',
//   'Price': 'سعر',
//   'Name': 'اسم',
//   'Form': 'استمارة',
//   'Product Link has been': 'رابط المنتج كان',
//   'Please select Format!': 'الرجاء تحديد تنسيق!',
//   'ex. device Id...': 'السابق. معرّف الجهاز ...',
//
//   //pos req
//   'Kindly fill up POS Terminal request details':
//       'يرجى تعبئة تفاصيل طلب جهاز نقاط البيع',
//   'Transaction Volume': 'حجم الصفقة',
//   'Choose Transaction Volume': 'اختر حجم المعاملة',
//   'more than 500000': 'أكثر من 500000',
//   'You can not add more than 10 quantity!!':
//       'لا يمكنك إضافة أكثر من 10 كمية !!',
//   'I accept the ': 'أقبل',
//   'Terms and conditions & Privacy policy.': 'الشروط والأحكام وسياسة الخصوصية.',
//   'Please choose Transaction volume': 'الرجاء اختيار حجم المعاملات',
//   'Please select valid quantity of Terminal device!!':
//       'الرجاء تحديد كمية صالحة من الجهاز الطرفي !!',
//   'Please accept terms and conditions': 'الرجاء قبول الشروط والأحكام',
//   'Your request sent successfully': 'تم إرسال طلبك بنجاح',
//   'We will contact with you soon': 'سوف نتواصل معك قريبا',
//   'terminals': 'محطات',
//   'Mobile number is invalid': 'رقم الجوال غير صحيح',
//   'New Password*': 'كلمة السر الجديدة*',
//   'Confirm New Password*': 'تأكيد كلمة المرور الجديدة*',
//   'Upload your valid Commercial Registration copy as issued by the Ministry of Economy & Commerce and enter CR number':
//       'قم بتحميل نسخة سارية المفعول من السجل التجاري الخاص بك كما هو صادر عن وزارة الاقتصاد والتجارة وأدخل رقم السجل التجاري',
//   'Upload your valid Commercial License copy as issued by the Ministry of Municipality and enter License number':
//       'قم بتحميل نسخة من الرخصة التجارية سارية المفعول كما صادرة عن وزارة البلدية وأدخل رقم الترخيص',
//   'Upload your valid Company Computer card and enter computer card number':
//       'قم بتحميل بطاقة كمبيوتر الشركة الصالحة وأدخل رقم بطاقة الكمبيوتر',
//   "Upload your authorized persion or owner's valid Residency ID card and enter ID card number":
//       "قم بتحميل النسخة المصرح بها أو بطاقة هوية صاحب الإقامة السارية وأدخل رقم بطاقة الهوية",
//   'Company Registration Certificate': 'شهادة تسجيل الشركة',
//   'No': 'رقم',
//   'Yes': "نعم",
  'hello': 'Hellosss',
//home    الرئيسية
  'dashboard': 'لوحة التحكم ',
  'payment': 'الدفع ',
  'E-Payment': 'الدفع الإلكتروني ',
  'pos': 'أجهزة نقاط البيع ',
  'wallet': 'المحفظة ',
  'more': 'أكثر ',
  'Please fill 6 digit OTP': 'من فضلك أدخل 6 أرقام لكلمة المرور لمره واحدة ',
  'Can’t receive the OTP?': 'لم أتمكن من استلام كلمة المرور ?',
  'OTP is valid upto': 'كلمة المرور صالحة ل',
  'seconds': 'ثواني ',
  'Create Quick Invoice': 'إنشاء فاتورة سريعة ',
  'Quick Invoice': 'فاتورة سريعة',
  'Invoice Amount': 'قيمة الفاتورة',
  'Product Link': 'رابط منتج ',
  'enabled': 'ممكن',
  'disabled': 'غير ممكن',
  ' Authentication': ' المصادقة',

  'Enter 6 digit OTP': 'أدخل كلمة المرور لمرة واحدة (OTP) المكون من 6 أرقام',
  'We just sent the OTP to your mobile number':
      'لقد أرسلنا للتو OTP إلى رقم هاتفك المحمول',

//dashboard لوحة التحكم
  'Activate product link': 'تفعيل رابط المنتج',
  'create Invoice': 'إنشاء فاتورة',
  'create QR Code': "إنشاء كود",
  'Pending to Deliver': "في انتظار التسليم",
  'create Subscription': "إنشاء إشتراك",
  'create Product': "إنشاء منتج",
  'amount': "قيمة",
  'count': "عدد",
  'Master Card': "ماستر كارد",
  'Visa Card': "فيزا كارد",
  'Apple Pay': "أبل باي",
  'Sadad Wallet': "محفظة سداد",
  'Today': 'اليوم',
  'Yesterday': "أمس",
  'Week': "أسبوع",
  'Month': "شهر",
  'Year': "سنة",
  'Custom': "تخصيص",
  'hi': 'مرحبا ',
  'محمود': 'Mahmoud',
  'Welcome Back,': 'مرحبا بعودتك,',
  'scan': 'مسح',
  'Total Available Balance': 'إجمالي الرصيد المتاح',
  'settlement': 'التسوية',
  'Withdraw': 'سحب',
  'charts': 'مخططات بيانية',
  'We are Sorry for your inconvenience. unable to fetch Data':
      'عذرآ لا يوجد بيانات !',
  'success': 'ناجحة',
  'Failure': 'فاشلة',
  'transaction Source': 'مصدر العملية',
  'paymentMethod': 'طريقة الدفع ',
  'Fast Invoice': 'فاتورة سريعة',
  'Create fast invoice with full amount only':
      'إنشاء فاتورة سريعة بكامل المبلغ فقط ',
  'Detailed Invoice': 'فاتورة مفصلة',
  'Create detailed Invoice with product & services':
      'إنشاء فاتورة مفصلة مع المنتج و الخدمات ',
  'Please Select Correct Date': 'من فضلك اختر التاريخ الصحيح',
  'Date Should be 1 year': ' يجب أن يكون التاريخ سنة واحدة',
  'Select the balance': 'حدد الرصيد',
  'Delivery date is required!!': 'تاريخ التسليم مطلوب !!',

//fast Invoice فاتورة سريعة
  "Create Fast Invoice": "إنشاء فاتورة سريعة",
  "Mobile Number": "رقم الهاتف",
  "Number cannot be empty": "لا يمكن أن يكون الرقم فارغًا",
  "Customer Name": "أسم العميل ",
  "Name cannot be empty": "لا يمكن أن يكون الاسم فارغًا ",
  "Invoice Amount": "قيمة الفاتورة",
  "Amount cannot be empty": "لا يمكن أن يكون المبلغ فارغًا ",
  "Descriptions": "الوصف",
  "Save Draft": "حفظ كمسودة",
  "Send Invoice": "إرسال الفاتورة",
  'Save draft successFully': "تم الحفظ كمسودة بنجاح",
  "Something wrong please check data":
      "هناك شيئاً خطأ الرجاء التحقق من  البيانات",

//Detail Invoice تفاصيل الفاتورة
  "Invoice Items": "بنود الفاتورة",
  "Add Items": "إضافة بنود",
  "Items": "البنود",
  "You don’t added any product or Items yet":
      " لم تقم بإضافة أي بنود أو منتجات",
  "Sub amount": "المبلغ الفرعي",
  "Discount": "الخصم",
  "Add Discount": "إضافة خصم ",
  "Net amount": "المبلغ الصافي",
  "Create Detailed Invoice": "إنشاء فاتورة مفصلة ",
  "Notify Once the Invoice is Viewed": "تنبيهي بمجرد رؤية الفاتورة",
  "Add Description": "إضافة وصف",
  "Number should be 10 digit": "يجب أن يتكون الرقم من 10 أرقام ",
  "Save Invoice": "حفظ الفاتورة",
  "Success": "ناجحة",
  "Invoice save successFully": "تم حفظ الفاتورة بنجاح",
  "error": "خطأ",
  "Please select item": "الرجاء إختيار بند",
  "please fill data": "الرجاء تعبئة البيانات",
  "Invoice Send SuccessFully": "تم إرسال الفاتورة بنجاح",
  "Draft Invoice SuccessFully": "تم حفظ الفاتورة كمسودة بنجاح ",

//payment screen شاشة الدفع
  'Successful Transactions': 'العمليات الناجحة',
  'Payout Received': 'الإيداعات المستلمة',
  'Subscriptions Amount': ' قيمة الاشتراكات ',
  'Product Sold Amount': 'قيمة المنتج المباع ',
  'Invoices': 'الفواتير ',
  'Products': 'المنتجات',
  'Store': 'المتجر',
  'Subscriptions': 'الاشتراكات',
  'Transactions': 'العمليات ',
  'Orders': 'الطلبات',
  'Reports': 'التقارير',
  'Online Payment': 'الدفع الإلكتروني',
  'Invoices, Products, Subscriptions , Transaction, Order, ':
      'الفواتير , المنتجات , الاشتراكات  , العملية , الطلب , ',
  'Services': 'الخدمات',
  'warning': 'تحذير',
  'E-Commerce': 'التجارة الإلكترونية',
  'Please select range in 12 month': 'الرجاء تحديد النطاق في 12 شهر ',

//add item invoice إضافة بند للفاتورة
  'Add Product': 'إضافة منتج ',
  'abc': 'ا,ب , ت ',
  'New Item': 'بند جديد',
  'Item Name': 'اسم البند',
  'Item Name cannot be empty': 'لا يمكن أن يكون اسم البند  فارغًا',
  'Item Price': 'سعر البند',
  'Price cannot be empty': 'لايمكن أن يكون السعر فارغًا',
  'Quantity': 'الكمية',
  'Quantity cannot be empty': 'لا يمكن أن تكون الكمية فارغة',
  'Add': 'إضافة',
  'Update': 'تحديث',
  'Session Expire': 'انتهاء الجلسة',
//add product اضافة منتج
  'Items Selected': 'البنود المحددة',
  'Search': 'بحث',
  'All Products': 'كل المنتجات ',
  'Something Wrong': 'هناك شيئاً خطأ',
  'Please Select Items': 'الرجاء إختيار البنود ',
  'Cancel': 'إلغاء',
//Invoice Detail تفاصيل الفاتورة
  'Edit': 'تعديل',
  'Copy link': 'نسخ الرابط',
  'Share': 'مشاركة ',
  'Send notification': 'إرسال إشعار ',
  'Delete': 'حذف',
  'Set as Default': 'تعيين إفتراضي',
  'Customer name': 'إسم العميل ',
  'Customer Mobile no.': 'رقم هاتف العميل .',
  'UserName': 'إسم المستخدم',
  'Customer email': 'البريد الإلكتروني للعميل ',
  'Transaction ID': 'رقم العملية ',
  'Upload': 'تحميل',
  'Invoice no': 'رقم الفاتورة ',
  'Total Invoice amount': 'إجمالي قيمة الفاتورة',
  'Invoice Details': 'تفاصيل الفاتورة',
  'delete successFully': 'تم الحذف بنجاح',
  'YES': 'نعم',
  'NO': 'لا`',
  'Notification': 'الإشعارات',
//login screen شاشة الدخول
  'Login': 'تسجيل الدخول ',
  'Can\'t login?': 'لا أستطيع الدخول ?',
  'Log in': 'تسجيل الدخول ',
  'Login by isometric': 'تسجيل الدخول بالبصمة ',
  'Don\'t have an account?': 'ليس لدي حساب?',
  'Register': 'تسجيل',
  'login successfully': 'تسجيل الدخول بنجاح',
  'Invalid mobile number': 'رقم الجوال غير صالح',

//password screen شاشة كلمة المرور
  'Enter your account password': 'أدخل كلمة المرور للحساب ',
  'Password': ' كلمة المرور ',
  'OTP Send Successfully': 'تم إرسال كلمة المرور لمرة واحدة بنجاح ',
  'check data': 'التحقق من البيانات',
  'Login Failed check data': 'فشل في تسجيل الدخول ,, تحقق من البيانات',
  'Next': 'التالي',

//OTP screen شاشة كلمة المرور لمرة واحدة
  'Enter the OTP': 'أدخل كلمة المرور لمرة واحدة ',
  'We have sent the OTP to the number':
      'تم إرسال كلمة المرور لمرة واحدة إلى الرقم ',
  'Don\'t receive the OTP?': 'لم يتم استلام كلمة المرور لمرة واحدة  ?',
  'Resend': 'إعادة إرسال',
  'Please fill OTP': 'من فضلك قم بتعبئة  كلمة المرور لمرة واحدة',
  'Otp verified successfully': 'تم التحقق من كلمة المرور لمرة واحدة بنجاح ',
  'Please check OTP': 'الرجاء التحقق من كلمة المرور لمره واحدة ',

//invoice list قائمة الفواتير
  'No data found': 'لاتوجد بيانات',
  'No Data Found': 'لا توجد بيانات ',
  'Draft': 'مسودة',
  'Unpaid': 'غير مدفوعة',
  'Paid': 'مدفوعة',
  'Overdue': 'متأخرة',
  'Rejected': 'مرفوضة',
  'Paid Invoices': 'الفواتير المدفوعة',
  'Unpaid Invoices': 'الفواتير الغير مدفوعة ',
  'Created Invoices': 'إجمالي الفواتير  ',
  'All': 'الكل',
  'Select Dates': 'حدد التاريخ ',
  'SelectedDates: ': 'التواريخ المحددة : ',
  'Select': 'حدد',

//filter screen invoice
  'Filter': 'تصنيف',
  'Sort by': 'تصنيف حسب',
  'Created date': 'تاريخ الإنشاء',
  'Customer name': 'اسم الزبون',
  'Invoice ID': 'رقم الفاتورة',
  'Invoice amount': 'قيمة الفاتورة',
  'Clear Filter': 'مسح التصنيف',
  'by Amount': 'بواسطة القيمة',

//order Screen شاشة الطلبات
  'Total Orders Received': 'إجمالي الطلبات المستلمة ',
  'Orders Delivered': 'تسليم الطلبات',
  'Orders Pending': 'الطلبات المعلقة ',
  'ex. customer name,phone,invoice no,amount,id......':
      'ex. اسم العميل ,الهاتف,رقم الفاتورة ,القيمة ,رقم  ........',

//createProductScreen شاشة  إنشاء المنتج
  'Edit Product': 'تعديل  منتج ',
  'Create Product': 'إنشاء منتج ',
  'Max Image dimension 500px X 500px, MAX 1MB':
      'الحد الأقصى لأبعاد الصورة 500 بكسل × 500 بكسل ، بحد أقصى 1 ميجابايت',
  'Add Product image': 'أضف صورة المنتج ',
  'Add image': 'إضافة صورة',
  'Add Water mark to the Image': 'إضافة علامة مائية للصورة ',
  'Product Name': 'إسم المنتج ',

  'Unit Priced': 'سعر الوحدة ',
  'price cannot be empty': 'لا يمكن أن يكون السعر فارغًا',
  'value must be under 20000': 'يجب أن تكون القيمة أقل من 20000',
  'Available Quantity': 'الكمية المتاحة',
  'quantity cannot be empty': 'لا يمكن أن تكون الكمية فارغة',
  'Expected Delivery Days': 'يوم التسليم المتوقع ',
  'Item & Description': 'Iالبند و الوصف ',
  'description cannot be empty': 'لايمكن أن يكون الوصف فارغًا',
  'description length at list 5': 'يجب أن لا يقل الوصف عن 5 أحرف ',
  'Add to Product list': 'قم بإضافة المنتج للقائمة ',
  'Unlimited Product Quantity': 'كمية غير محدودة من المنتج ',
  'Allow only once purchase per cell Number':
      'السماح بالشراء مرة واحدة فقط لكل رقم هاتف ',
  'Show Product on store': 'عرض المنتج في المتجر ',
  'please check Image File': 'الرجاء التحقق من صورة الملف',
  'file should be in png, jpg,pdf format':
      'يجب أن يكون الملف بتنسيق png ، jpg ، pdf ',
  'Please fill Data': 'الرجاء تعبئة البيانات ',
  'Please select Days': 'الرجاء إختيار اليوم ',
  'Immediate': 'في الحال ',
  '1 to 2 Days': 'من يوم الى يومين ',
  '3 to 5 Days': 'من 3 أيام الي 5 أيام ',
  '1 Week': 'أسبوع واحد',
  ' Weeks': '2-4 أ،2-4 أسابيع ',
  ' Month': '1 شهر واحد',
  ' Month': '2 شهرين ',
  'Delivered': 'مستلمة ',
  'Pending': 'معلق',
  'Please Check data or product name already exist':
      'الرجاء التحقق من البيانات او إسم المنتج موجود بالفعل ',
  'Product Created SuccessFully': 'تم إنشاء المنتج بنجاح ',
  'Product detail are updated': 'تم تحديث بيانات المنتج ',
  'Description is required!': 'الوصف مطلوب!',
  'Text Need To Be Atleast 5 Character': 'يجب أن يكون النص على الأقل 5 أحرف',
  'Description is too long. Maximum 5000 characters allowed.':
      'يجب أن يكون النص على الأقل 5 أحرف',
  'Activity': 'نشاط',
  'Merchant details will be verified and it will be activate automatically.':
      'سيتم التحقق من تفاصيل التاجر وسيتم تفعيلها تلقائيًا.',

//my productScreen شاشة المنتجات الخاصة بي
  'Select all': 'حدد الكل ',
  'My Products': 'منتجاتي ',
  'Export': 'تصدير ',
  'Remove From Store': 'إزالة من المتجر ',
  'Add to store': 'إضافة الي المتجر ',
  'Add to new invoice': 'إضافة الي فاتورة جديدة',
  'Download Options': 'خيارات التنزيل ',
  'Select Format': 'حدد التنسيق ',
  'Send Email to': 'أرسل البريد الالكتروني الي ',
  'DownLoad': 'تنزيل',
  'Download': 'تنزيل',
  "Remove": "يزيل",
  "Owner’s ID card": "بطاقة أنا المالك",

//orderDetail Screen
  'Order Details': 'تفاصيل الطلب ',
  'Order No.': 'رقم الطلب .',
  'Details': 'التفاصيل ',

//product detail تفاصيل المنتج
  'Sold': 'مباع',
  'Show in E-store': 'عرض في المتجر الإلكتروني ',
  'Expected delivery': 'التسليم المتوقع ',
  'day after': 'بعد يوم ',

//transaction filter تصنيف العمليات
  'Refund status': 'حالة استرجاع الاموال ',
  'Transaction status': 'حالة العملية ',
  'Payment methods': 'طريقة الدفع',
  'Transaction Modes': 'وضع العملية',
  'Transaction Sources': 'مصدر العملية',
  'Refunded': 'تم الإسترجاع ',
  'Requested': 'تم الطلب ',
  'From': 'من ',
  'Transactions details': 'تفاصيل العمليات',
//transaction screen
  'InProgress': 'تحت الإجراء ',
  'Failed': 'فاشلة ',
  'On-Hold': 'معلقة ',
  'Please Select Report Type': 'الرجاء تحديد نوع التقرير ',
  'SUCCESS': 'النجاح',
//refund detail تفاصيل الإسترجاع
  'Refund Details': 'تفاصيل الإسترجاع',
  'Refund ID.': 'رقم الإسترجاع .',
  'Inprogress': 'تحت الاجراء ',
  'Refund': 'استرجاع الأموال',
  'Onhold': 'معلق ',
  'Transaction Type': 'نوع العملية',
  'Refund amount': 'قيمة الإسترجاع',
  'Refund type': 'نوع الإسترجاع',
  'Partial': 'جزئي',
  'Full': 'كلي ',
  'Remaining amount': 'المبلغ المتبقي ',
  'Sadad charges': 'عمولة سداد ',
  'Refund reason': 'سبب استرجاع الأموال ',
  'Transaction ID.': 'رقم العملية.',
  'Transaction amount': 'قيمة العملية',
  'Transaction response code': 'كود إستجابة  العملية',
  'Transaction response message': 'رسالة استجابة العملية ',
  'Auth Number': 'رقم التفويض',
  'Payment Method': 'طريقة الدفع ',
  'Card number': 'رقم البطاقة ',
  'Card holder name': 'إسم حامل البطاقة',
  'Customer Email ID': 'عنوان البريد الإلكتروني للعميل ',
  'Dispute ID': 'رقم الشكوى ',
  'Guest User': 'مستخدم زائر',
  'Enter the refund Full Amount': 'أدخل المبلغ المسترد بالكامل',
//search screen
  'Payments': 'المدفوعات',
  'Refunds': 'الإسترجاع',
  'Disputes': 'النزاعات',
  'Search Result': 'نتيجة البحث',
  'Download Receipt': 'تنزيل الإيصال',
  'Refund Amount': 'قيمة الإسترجاع',
  'Full refund': 'استرداد كامل',
  'Partial refund': 'رد جزئي',

//transaction detail screen شاشة تفاصيل المعاملات
  'Transaction Details': 'تقاصيل العملية',
  'OPEN': 'فتح',
  'UNDER REVIEW': 'قيد المراجعة',
  'CLOSED': 'اغلاق',
  'Purchase': 'شراء ',
  'Sadad Charges': 'عمولة سداد ',
  'Transaction Source': 'مصدر المعاملة',
  'Invoice': 'فاتورة ',
  'Subscription': 'إشتراك ',
  'Add Funds': 'إضافة أموال',
  'Withdrawal': 'سحب الأموال ',
  'Transfer': 'تحويل',
  'Store link': 'رابط المتجر ',
  'PG API': 'بوابة الدفع API ',
  'AJAX Transaction': 'عملية AJAX ',
  'Mawaid': 'موعد',
  'Reward': 'مكافئات',
  'Reward Add Funds': 'إضافة المكافئات',
  'Partner Reward': 'مكافئة الشريك',
  'Manual Service Charge': 'رسوم الخدمة اليدوية',
  'POS Transaction': 'عمليات نقاط البيع,',
  'Other': 'أخري',
  'Source ID': 'رقم المصدر ',
  'Integration Type': 'نوع التكامل',

//report screen  شاشة التقارير
  'View and Download\nOnline Payment Reports':
      'عرض وتنزيل تقارير المدفوعات الإلكترونية',
  'Select your Report': 'حدد التقرير ',
  'From': 'من',
  'To': 'إلى ',
  'Waring': 'تحذير',
  'Please Select Type': 'الرجاء تحديد النوع ',
  'Please Select Dates': 'الرجاء تحديد التواريخ',
  'View result': 'عرض النتائج',
  'Settlement Details': 'تفاصيل التسوية',
  'Invoice Payments Details': 'تفاصيل فاتورة الدفع ',
  'Subscription Payments Details': 'تفاصيل مدفوعات الاشتراك',
  'Store Orders Details': 'تفاصيل طلبات المتجر ',
  'Are you sure you want to cancel this withdraw Request ?':
      'هل أنت متأكد أنك تريد إلغاء طلب السحب هذا؟',
//report detail screen شاشة تفاصيل التقارير

  'Download': 'تنزيل',
  'Transaction Method': 'طريقة العملية',
  'Transaction Amount': 'قيمة العملية',
  'Transaction Status': 'حالة العملية',
  'Transaction Status': 'حالة العملية',
  'Coming soon': 'قريبآ سيآتي',
  'Transaction': 'العملية',

//pos screen شاشة أجهزة نقاط البيع
  'POS Balance': 'رصيد جهاز نقاط البيع ',
  'Live Terminal': 'الجهاز النشط ',
  'View your live terminal location': 'عرض موقع الجهاز النشط ',
  'Filter cleared': 'مسح التصفية',
  'Dispute Type': 'نوع النزاع ',
  'Active': 'نشط',
  'InActive': 'غير نشط ',
  'Preauth Complete': 'Preauth Complete',
  'Preauth': 'Preauth',
  'Reversal': 'انعكاس',
  'ManualEntry Purchase': 'شراء بالإدخال اليدوي ',
  'Card Verification': 'التحقق من البطاقة ',
  'Chip': 'الشريحة ',
  'Magstripe': 'Magstripe',
  'Contactless': 'بدون لمس',
  'Fallback': 'تراجع',
  'Manual Entry': 'الإدخال اليدوي',
  'Open': 'افتح',
  'Under Review': 'قيد المراجعة ',
  'Close': 'مغلق',
  'ChargeBack': 'استرجاع مبلغ مدفوع',
  'Fraud': 'احتيال',
  'Disputes Status': 'حالة النزاع ',
  'Card Entry Type': 'نوع إدخال البطاقة',
  'Transaction Types': 'أنواع العمليات',
  'Refund Status': 'حالة الإسترجاع',
  'Rental Payment Status': 'حالة دفع الإيجار',
  'Dispute Details': 'تفاصيل النزاع',
  'Dispute ID.': 'رقم الشكوى.',
  'Dispute amount': 'قيمة النزاع',
  'Dispute': 'النزاع',
  'Comment': 'تعليق',
  'Terminal Id': 'رقم الجهاز ',
  'Terminal Name:': 'إسم الجهاز:',
  'Device ID': 'رقم الجهاز',
  'Transaction mode': 'وضع العملية',
  'PosRental Details': 'تفاصيل تأجير نقاط البيع',
  'Automatic': 'تلقائي',
  'Manual': 'يدوي',
  'Invoice No.': 'رقم الفاتورة.',
  'Pos Rental': 'إيجار جهاز نقاط البيع ',
  'Description': 'الوصف ',
  'We have charged the rental amount for following terminals.':
      'تم دفع قيمة الإيجار للأجهزة التالية .',
  'Device Type': 'نوع الجهاز',
  'Quantities': 'الكمية',
  'Setup fees': 'رسوم التأسيس ',
  'Rental amount': 'قيمة الأيجار ',
  'Rental Frequency': 'عدد مرات التأجير',
  'Periodical Rental': 'الإيجار الدوري',
  'Additional amount': 'مبلغ إضافي',
  'Sub Total': 'المجموع الفرعي  ',
  'Transactions Details': 'تفاصيل العمليات',
  'Transactions ID.': 'الرقم التعريفي للعمليات',
  'Transactions Amount': 'قيمة العمليات',
  'Transactions Type': 'نوع العمليات',
  'Transactions Mode': 'وضع العمليات',
  'Card Number': 'رقم البطاقة',
  'Terminal Name': 'إسم الجهاز',
  'Terminal Location': 'موقع الجهاز',
  'Device Serial Number': 'الرقم التسلسلي للجهاز ',
  'Refund Id': 'رقم الاسترجاع',
  'Rental': 'الإيجار',
  'POS Rental': 'إيجار جهاز نقاط البيع',
  'Total Success Transaction(Amount)': 'إجمالي صفقة النجاح (المبلغ)',
  'Total Success Transactions (Count)': 'إجمالي المعاملات الناجحة (العدد)',
  'Devices': 'الأجهزة ',
  'Rental Amount': 'قيمة الإيجار',
  'Device Details': 'تفاصيل الجهاز',
  'Device Id.': 'رقم الجهاز .',
  'Terminal Type': 'نوع الجهاز ',
  'Device status': 'حالة الجهاز',
  'Setup Fees': 'رسوم التاسيس',
  'Rental Start Date': 'تاريخ بدأ الإيجار ',
  'Device Activated Date': 'تاريخ تنشيط الجهاز ',
  'Terminal ID': 'رقم الجهاز',
  'Sim  Number': 'رقم الشريحة',
  'IMEI Number': 'IMEI رقم',
  'Total Success Transaction (AMOUNT)': 'إجمالي العمليات الناجحة  (قيمة)',
  'Total Success Transaction (Count)': 'إجمالي العمليات الناجحة (عدد)',
  'Last Transaction Date': 'تاريخ أخر عملية',
  'Currency': 'العملة',
  'View and Download POS Reports': 'عرض وتنزيل تقارير نقاط البيع',
  'POS Transaction Details': 'تفاصيل عملية نقاط البيع',
  'POS Terminals Summary': 'ملخص أجهزة نقاط البيع',
  'POS Devices Summary': 'ملخص أجهزة نقاط البيع',
  'Terminals Details': 'تفاصيل الأجهزة',
  'Terminal ID.': 'رقم الجهاز',
  'Date & time': 'التارخ و الوقت',
  'Current Device ID': 'رقم الجهاز الحالي  ',
  'Previous Device ID': 'رقم الجهاز السابق ',
  'Previous Device Serial Number': 'الرقم التسلسلي للجهاز السابق ",',
  'Payment Methods': 'طريقة الدفع ',
  'City': 'المدينة',
  'Total Success Transaction (Amount)': 'إجمالي العمليات الناجحة(قيمة )',
  'Total Success Transactions (Values)': 'إجمالي العمليات الناجحة (قيم)',
  'Transaction Mode': 'وضع العملية',
  'Terminals': 'الأجهزة',
  'Terminal ID:': 'رقم الجهاز :',
  'Settlement': 'التسوية ',

//store screen شاشة المتجر
  'Store Products': 'منتجات المتجر ',
  'Copy Link': 'نسخ الرابط ',
  'Store Product': 'منتج المتجر ',
  'Store Orders': 'طلبات المتجر',
  'Store Orders Amount': 'كمية طلبات المتجر',
  'Deactive': 'غير نشط',
  'Active Products': 'منتجات نشطة',
  'Deactivated Products': 'منتجات غير نشطة ',
  'Product': 'منتج',
  'Create Product with unlimited featured': 'إنشاء منتج بمميزات غير محدودة',
  'Download Invoice': 'تحميل فاتورة',
// more screen  شاشات اكثر
  'Add your bank account details to transfer your account amount to it.':
      "أدخل تفاصيل الحساب البنكي الخاص بك لتحويل المبالغ اليه .",
  'Bank Account': 'الحساب البنكي',
  'files added': 'تم إضافة الملفات',
  'Select Language': 'حدد اللغة',
  'Active User': 'مستخدم نشط',
  'POS Devices': 'أجهزة نقاط البيع ',
  'Notifications': 'الإشعارات',
  'Update Setting': 'تحديث الإعدادات ',
  'You have to add the blow documents to verify\nyour account.':
      'يجب إضافة المستندات أدناة لتفعيل حسابك .',
  'The image of Computer card is not correct,\nkindly upload the correct one.':
      'صورة بطاقة قيد المنشأة غير صحيحة الرجاء تحميل الصورة بشكل صحيح .',
  'ex. invoice description': 'السابق. وصف الفاتورة',
  'Verified': 'تم التحقق',
  'Need Action': 'بحاجة للعمل',
  'Under Review': 'قيد المراجعة',
  'Rejected': 'مرفوض',
  'Pending': 'قيد الانتظار',
  'Select Date': 'حدد تاريخ',
  'At least 8 characters': '8 حرفًا على الأقل',
  'A mixture of both uppercase and lowercase letter.':
      'مزيج من الأحرف الكبيرة والصغيرة.',
  'A mixture of letters and numbers.': 'مزيج من الحروف والأرقام.',
  'Inclusion of at least one spacial character. e.g.!@#?]':
      'تضمين طابع مكاني واحد على الأقل. مثال :!@#؟]',
  'At least one document should there.':
      'يجب أن تكون هناك وثيقة واحدة على الأقل.',
  'Please upload letter': 'الرجاء تحميل الخطاب',
  'Please enter account name': 'الرجاء إدخال اسم الحساب',
  'Invalid IBAN number': 'رقم IBAN غير صحيح',

//Login screen

  'Mobile number': 'رقم الهاتف',
  "can't login?": ' لاأستطيع الدخول?',
  'Number should be 8 digit': 'يجب أن يتكون الرقم من 8 أرقام',
  'Fingerprint': 'بصمة',
  'Face': 'وجه',
  'Authentication required': 'يستلزم التوثيق',
  'Verify identity': 'تحقق من الهوية',
  'Scan your Face to authenticate': 'امسح وجهك للمصادقة',
  'Scan your fingerprint to authenticate': 'امسح بصمة إصبعك للمصادقة',
  'We have sent the OTP to your phone number': 'لقد أرسلنا OTP إلى رقم هاتفك',
  'Face': 'وجه',

//Register Screen
  'Select your account type': 'حدد نوع حسابك  ',
  'Business Account': 'حساب تجاري',
  'Personal Account': 'حساب فردي',
  'Not allowed': 'غير مسموح',
  'Not allowed to register outside of Qartar': 'غير مسموح بالتسجيل خارج قرطار',
  'Okay': 'تمام',

//Business Account

  'Create new business account': 'إنشاء حساب تجاري جديد',
  'Fill the below inputs': 'املأ البيانات أدناه',
  'Business name*': 'الاسم التجاري*',
  'Email*': 'البريد الالكتروني*',
  'I agree to the Sadad': 'انا أوافق على سداد',
  'Terms and conditions': 'الشروط والاحكام',
  'Name should not be empty': 'يجب ألا يكون الاسم فارغًا',
  'max characters allowed are 512': 'الحد الأقصى للأحرف المسموح بها هو 512',
  'Enter a valid email address': 'أدخل عنوان بريد إلكتروني صالح',
//Enter phone number screen
  'Payouts': 'المدفوعات',
  'Enter your phone number': 'ادخل رقم هاتفك ',
  'we have sent the OTP to the number':
      'تم إرسال كلمة المرور لمرة واحده الي الرقم ',
  ' & Privacy policy.': '& سياسة الخصوصية.',

// set your password screen
  "Set your account password": ' قم بتعيين كلمة مرور حسابك  ',
  'Password*': 'كلمة المرور *',
  'Password requirements': 'متطلبات كلمة المرور ',
  'At least 8 characters': '8 حرفًا على الأقل',
  'A mixture of both uppercase and lowercase letters.':
      'مزيج من الأحرف الكبيرة والصغيرة.',
  'A mixture of letters and numbers.': 'مزيج من الحروف والأرقام.',
  'Inclusion of at lease one spacial character, e.g ! @ # ? ]':
      'تتضمن علي الاقل أحد الرموز الاتيه, e.g ! @ # ? ]',

//Signature Screen
  'E-Signature': 'التوقيع الالكتروني ',
  'Please, provide you E-Signature in the below box':
      'الرجاء ، تزويدنا بالتوقيع الإلكتروني في المربع أدناه',
  'Clear': 'مسح',
  'Finish': 'إنتهاء ',

//Link your Fingerprint
  'Link your Fingerprint?': 'اربط بصمة إصبعك?',
  'Skip, for later': 'تخطي ، في وقت لاحق',
  'Link': 'ربط',
  'Fingerprint': 'بصمة',
  'Face': 'وجه',
  'Authentication required': 'يلزم التوثيق',
  'verify identity': 'التحقق من الهوية',
  'Scan your fingerprint to authenticate': 'امسح بصمة اصبعك للمصادقة',
  'Scan your face to authenticate': 'امسح بصمة الوجه للمصادقة ',

//password screen
  'Forgot Password?': 'نسيت كلمة المرور?',

//Forgot Password screen
  'we have sent OTP to the number':
      'تم ارسال كلمة المرور لمرة واحدة الي الرقم ',

//Dashboard screen
  "Hi,": 'مرحبا ,',
  'Create Invoice': 'إنشاء فاتورة ',
  'Create Subscription': 'إنشاء إشتراك ',
  'Create QR Code': 'إنشاء رمز الاستجابة السريعة ',
  'POS Payment': 'دفع نقاط البيع',

//E-commerce payment
  'Success Rate': 'معدل النجاح',
  'Refund Accepted': 'تم قبول إسترجاع الاموال ',
  'Product sold Amount': 'قيمة المنتج المباع',
  'Calendly': 'التقويم',
  'Refunds Accepted': 'العمليات المستردة المقبولة ',
  'Transactions Count': 'عدد المعاملات',

//POS screen
  'Sadad POS': 'اجهزة نقاط البيع سداد ',
  'Active Terminals': 'أجهزة نشطة',
  'Inactive Terminals': 'أجهزة غير نشطة',

//success Rate Dialog
  'Total successful transactions received out of total transactions including failed and successful.':
      'إجمالي العمليات الناجحة المستلمة من إجمالي العمليات بما في ذلك العمليات الفاشلة والناجحة.',

//settlement screen
  'Settlement Reports': 'تقارير التسوية',
  'Withdrawals': 'سحوبات الأموال ',
  'Payout': 'الإيداعات',

//notification screen
  'Mark All as read': 'ضع علامة علي الكل كمقروء',

//invoice create
  'Notify once the Invoice is Viewed': 'تنبيهي بمجرد مشاهدة الفاتورة',
  'Max Image dimension 500px X 500px, MAX 1 MB':
      'الحد الاقصي لابعاد الصورة  500px X 500px, MAX 1 MB',
  'Unlimited product Quantity': 'كمية غير محدودة من المنتجات ',
  "You don't have any item added yet": "لم تتم إضافة أي عنصر حتى الآن",
//withdrawal detail screen
  'Withdrawal ID': 'رقم عملية سحب الاموال ',
  'Withdrawal Type': 'نوع سحب الاموال ',
  'Withdrawal Amount': 'قيمة سحب الاموال ',
  'Balance At Withdrawal Request': 'الرصيد عند طلب سحب الأموال',
  'Bank Name': 'إسم البنك',
  'Payout Status': 'حالات الإيداع',
  'Withdrawal Details': 'تفاصيل سحب الأموال ',
  'Amount': 'مقدار',
//payout detail screen
  'Payout Details': 'تفاصيل الإيداع',
  'Payout ID': 'رقم الإيداع ',
  'Payout Amount': 'قيمة الإيداع',
  'Payout charges': 'عمولة الإيداع',
  'Bank Number(IBAN)': 'رقم البنك(رقم الايبان الدولي)',
  'Bank reference No': 'الرقم المرجعي للبنك,',
  'Rejection Reason': 'سبب الرفض',

// Withdrawal Screen
  'Auto Withdrawal': 'سحب تلقائي',
  'Set your auto withdrawal on then select withdrawal period.':
      'قم بضبط السحب التلقائي الخاص بك ثم حدد فترة السحب.',
  'Set Auto withdrawal on': 'ضبط سحب الاموال التلقائي على',
  'Manual Withdrawal': 'سحب يدوي',
  'Withdrawal amount': 'قيمة سحب الأموال ',
  'choose your bank': 'اختر البنك',
  'Choose withdrawal Request Period': 'اختر فترة طلب سحب الأموال',
  'Daily': 'يومي',
  'Weekly': 'اسبوعي ',
  'Monthly': 'شهري',
  'Auto Withdrawal Request': 'طلب سحب تلقائي ',
  'Submit': 'تقديم',
  'Select Bank': 'حدد البنك',
  'Set Auto Withdrawal on': 'اضبط السحب التلقائي على',
  'Choose your bank': 'اختر البنك الذي تتعامل معه',
  'Active Users': 'المستخدمين النشطين',
  'My QRcode': 'QRcode الخاص بي',
  'Business informations': 'المعلومات التجارية',
  'Signed contract': 'عقد موقع',
  'Mail sent successFully': 'إرسال البريد بنجاح',
  'Personal Information': 'معلومات شخصية',
  'Settings': 'إعدادات',
  'Logout': 'تسجيل خروج',
  'Business details': 'تفاصيل العمل',
  'Business name': 'الاسم التجاري',
  'Business Registration Number': 'رقم التسجيل التجاري',
  'Email ID': 'عنوان الايميل',
  'Address': 'العنوان',
  'Zone': 'منطقة',
  'Business Documents': 'الملفات التجارية',
  'Street no.': 'رقم الشارع.',
  'Bldg.no.': 'رقم المبني .',
  'Unit no.': 'رقم الوحدة.',
  'Default Account': 'الحساب الافتراضي',
  'Account status': 'حالة الحساب',
  'Actions': 'أجراءات',
  'The Authorization letter is not right, kindly check it an upload another one.':
      'خطاب التفويض غير صحيح ، يرجى التحقق منه وتحميله مرة أخرى.',
  'Bank': 'بنك',
  'Add bank account': 'إضافة حساب مصرفي',
  'Bank Account details': 'تفاصيل الحساب المصرفي',
  'Bank IBAN': 'بنك IBAN',
  'Account Name': 'أسم الحساب',
  'Note: You have to add below documents to verify your account':
      'ملاحظة: يجب عليك إضافة المستندات أدناه للتحقق من حسابك',
  'IBAN number cannot be empty': 'لا يمكن أن يكون رقم IBAN فارغًا',
  "IBAN number can't less then 4 digit":
      "لا يمكن أن يكون رقم IBAN أقل من 4 أرقام",
  'Account Name cannot be empty': 'لا يمكن أن يكون اسم الحساب فارغًا',
  'Authorization letter': 'خطاب تفويض',
  'Upload the bank authorization letter': 'قم بتحميل خطاب التفويض البنكي',
  'Expiration date': 'تاريخ إنتهاء الصلاحية',
  'Expiry date': 'تاريخ انتهاء الصلاحية',
  'Add Document': 'أضف وثيقة',
  'Upload Below Documents': 'تحميل المستندات أدناه',
  'You have to add the below documents to verify\nyour account.':
      'يجب عليك إضافة المستندات أدناه للتحقق\nالحساب الخاص بك',
  'Your account status': 'حالة حسابك',
  'Requirement Documents': 'المستندات المطلوبة',
  'You can uploading following document for business registration certificate:':
      'يمكنك تحميل المستند التالي لشهادة تسجيل الأعمال:',
  'Commercial registration': 'السجل التجاري',
  'Commercial license': 'رخصة تجارية',
  'Computer card': 'بطاقة كمبيوتر',
  'Establishment card': 'بطاقة التأسيس',
  'Owner\'s ID card': 'بطاقة هوية المالك',
  'Zone cannot be empty': 'لا يمكن أن تكون المنطقة فارغة',
  'Street cannot be empty': 'لا يمكن أن يكون الشارع فارغًا',
  'Bldg cannot be empty': 'لا يمكن أن يكون المبنى فارغًا',
  'Unit cannot be empty': 'لا يمكن أن تكون الوحدة فارغة',
  'Scan QRCODE or copy the below code': 'امسح QRCODE أو انسخ الكود أدناه',
  'Sadad ID': 'معرف سداد',
  'My Name': 'اسمي',
  'Change Password': 'غير كلمة السر',
  'Status': 'حالة',
  'Admin': 'مسؤل',
  'Language': 'لغة',
  'Login and security': 'تسجيل الدخول والأمان',
  'Face detection': 'الكشف عن الوجه',
  'App ver': 'إصدار التطبيق',
  'Current password*': 'كلمة المرور الحالية*',
  'Password cannot be empty': 'لا يمكن أن تكون كلمة المرور فارغة',
  'Current Password not valid': 'كلمة المرور الحالية غير صالحة',
  "Current password and new password can't be same":
      "لا يمكن أن تكون كلمة المرور الحالية وكلمة المرور الجديدة متطابقتين",
  'Enter valid password': 'أدخل كلمة مرور صالحة',
  'Confirm Password*': 'تأكيد كلمة المرور*',
  'New password and confirm password does not match':
      'كلمة المرور الجديدة وتأكيد كلمة المرور غير متطابقين',
  'Please enter password': 'الرجاء إدخال كلمة المرور',
  'Play Sound': 'تشغيل الصوت',
  'Receive order': 'إستقبال الطلبات ',
  'Received payment': 'تم استلام المبلغ',
  'When I get notification': 'عندما أحصل على إشعار',
  'Receive in Arabic Language': 'استلام باللغة العربية',
  'When i receive alert message': 'عندما أستلم رسالة تنبيه',
  'Are you sure you want to Logout ?': 'هل أنت متأكد أنك تريد تسجيل الخروج ؟',
  'You are add there to follow below terms and conditions by clicking "I agree",\n\n1. The auto withdrawal would be generated based on the chosen request frequency.\n2. You are not allowed to cancel the auto withdrawal request.\n3. You can’t get refund for the auto withdrawal request. \n4. Your auto withdrawal would be on hold.':
      'أنت تضيف هناك لمتابعة البنود والشروط أدناه بالنقر فوق "أوافق" ، 1\n سيتم إنشاء السحب التلقائي بناءً على تردد الطلب المختار. 2\n. غير مسموح لك بإلغاء طلب السحب التلقائي. 3\n. لا يمكنك استرداد أموال طلب السحب التلقائي. 4\n. سيكون السحب التلقائي معلقًا.',
  '\u2022 If the primary bank account details are changed and not verified by SADAD Admin.\n\u2022 If the sufficient amount is not maintained in your SADAD wallet account which is less than the set auto withdrawal amount.\n\u2022 If subscribed services (POS Rental, SADAD paid services) charges are due and not cleared from your SADAD wallet account':
      '\u2022 إذا تم تغيير تفاصيل الحساب المصرفي الأساسي ولم يتم التحقق منها من قبل مسؤول سداد. \n\u2022 إذا لم يتم الاحتفاظ بالمبلغ الكافي في حساب محفظة سداد الخاص بك وهو أقل من مبلغ السحب التلقائي المحدد. \n\u2022 في حالة الاشتراك في الخدمات (تأجير نقاط البيع ، خدمات سداد المدفوعة) الرسوم مستحقة ولم يتم تسويتها من حساب محفظة سداد الخاص بك',
  'Selected Dates: ': 'التواريخ المحددة:',
  'Edit terminal name': 'تحرير اسم المحطة',
  'View by': 'عرض بواسطة',
  'In stock': 'متوفر في المخزن',
  'Out of stock': 'غير متوفر في المخزن ',
  'Product View': 'عرض المنتج',
  'Price': 'سعر',
  'Name': 'اسم',
  'Form': 'من',
  'Product Link has been': 'رابط المنتج كان',
  'Please select Format!': 'الرجاء تحديد تنسيق!',
  'ex. device Id...': 'السابق. معرّف الجهاز ...',
  'Change period': 'فترة التغيير',
  'Next Withdrawal date': 'تاريخ الانسحاب القادم',
  'Your withdraw request is sent successfully':
      'تم إرسال طلب السحب الخاص بك بنجاح',
  'Done': 'منتهي',
  'Your withdrawal status has been change to':
      'تم تغيير حالة السحب الخاصة بك إلى',
  'Your withdrawal status has been change to manual.':
      'تم تغيير حالة السحب الخاصة بك إلى يدوي.',

//pos req
  'Kindly fill up POS Terminal request details':
      'يرجى تعبئة تفاصيل طلب جهاز نقاط البيع',
  'Transaction Volume': 'حجم المعاملة',
  'Choose Transaction Volume': 'اختر حجم المعاملة',
  'more than 500000': 'أكثر من 500000',
  'You can not add more than 10 quantity!!':
      'لا يمكنك إضافة أكثر من 10 كمية !!',
  'I accept the ': 'أقبل',
  'Terms and conditions & Privacy policy.': 'الشروط والأحكام وسياسة الخصوصية.',
  'Please choose Transaction volume': 'الرجاء اختيار حجم المعاملات',
  'Please select valid quantity of Terminal device!!':
      'الرجاء تحديد كمية صالحة من الجهاز الطرفي !!',
  'Please accept terms and conditions': 'الرجاء قبول الشروط والأحكام',
  'Your request sent successfully': 'تم إرسال طلبك بنجاح',
  'We will contact with you soon': 'سوف نتواصل معك قريبا',
  'terminals': 'محطات',
  'Mobile number is invalid': 'رقم الجوال غير صحيح',
  'New Password*': 'كلمة السر الجديدة*',
  'Confirm New Password*': 'تأكيد كلمة المرور الجديدة*',
  'Upload your valid Commercial Registration copy as issued by the Ministry of Economy & Commerce':
      'قم بتحميل نسخة سارية المفعول من السجل التجاري الخاص بك كما هو صادر عن وزارة الاقتصاد والتجارة وأدخل رقم السجل التجاري',
  'Upload your valid Commercial License copy as issued by the Ministry of Municipality':
      'قم بتحميل نسخة من الرخصة التجارية سارية المفعول كما صادرة عن وزارة البلدية',
  'Upload your valid Company Establishment card':
      'قم بتحميل بطاقة كمبيوتر الشركة الصالحة',
  "Upload your authorized person or owner's valid Residency ID card":
      'قم بتحميل النسخة المصرح بها أو بطاقة هوية صاحب الإقامة الصالحة',
  'Company Registration Certificate': 'السجل التجاري للشركة',
  'No': 'لا',
  'Yes': "نعم",
  'Auth number': "رقم المصادقة",
  'Customer IP': 'IP للعميل',
  'Terminal': 'صالة',
  '2 Month': '2 شهر',
  '1 Month': '1 شهر',
  '2-4 Weeks': '2-4 أسابيع',
  'Username': 'اسم المستخدم',
  'ex. product name...': 'السابق. اسم المنتج...',
  'Save': 'يحفظ',
  'Full amount refund': 'استرداد كامل المبلغ',
  "+ Add More": "+ إضافة المزيد",

  'Delivered date': 'تاريخ تسليمها',
  'Withdrawal Status': 'حالة الانسحاب',
  'Accepted': 'وافقت',
  'On Hold': 'في الانتظار',
  'Cancelled': 'ألغيت',
  'Processed': 'معالجتها',
  'Manual': 'يدوي',
  'SMS': 'رسالة قصيرة',
  'Email': 'البريد الإلكتروني',
  'Push notification': 'دفع الإخطار',
  'Notice': 'يلاحظ',
  'A new version is available. Update the app to continue.':
      'إصدار جديد متوفر. قم بتحديث التطبيق للمتابعة.',
  'UPDATE': 'تحديث',
  'Total Transactions': 'إجمالي المعاملات',
  'Fill out this application to be guided by the required quantity for point-of-sale devices only':
      ' تعبئة هذا الطلب للإسترشاد بالكمية المطلوبة لأجهزة نقاط البيع فقط',
  'This request does not require Sadad to submit the entire number of devices requested':
      ' هذا الطلب لا يُلزم سداد بتسليم عدد الأجهزة المطلوبة بالكامل',
  'Distribution mechanism (Sadad merchants - members of entrepreneurs - registration priority).':
      'آلية التوزيع ( عملاء سداد - اعضاء رواد الاعمال -اولوية التسجيل ).',
  'Applications submitted will be subject to the laws and regulations of the Central Bank and Qatar National Bank':
      'تخضع الطلبات المقدمة لقوانين وأنظمة المصرف المركزي وبنك قطر الوطني',
  'Choose one of our online payment services':
      'اختر إحدى خدمات الدفع عبر الإنترنت',
  'Fill out this application to be guided by the required quantity for point-of-sale devices only.':
      ' تعبئة هذا الطلب للإسترشاد بالكمية المطلوبة لأجهزة نقاط البيع فقط',
  'This request does not require Sadad to submit the entire number of devices requested.':
      ' هذا الطلب لا يُلزم سداد بتسليم عدد الأجهزة المطلوبة بالكامل',
  'Distribution mechanism (Sadad merchants - members of entrepreneurs - registration priority).':
      'آلية التوزيع ( عملاء سداد - اعضاء رواد الاعمال -اولوية التسجيل ).',
  'Applications submitted will be subject to the laws and regulations of the Central Bank and Qatar National Bank.':
      'تخضع الطلبات المقدمة لقوانين وأنظمة المصرف المركزي وبنك قطر الوطني',
  'Choose one of our online payment services':
      'اختر إحدى خدمات الدفع عبر الإنترنت',

  'Business Information': 'المعلومات التجارية',
  "Business Profile Details": "تفاصيل الملف التجاري",
  "Business name": "الاسم التجاري",
  "Business name cannot be empty":
      "لا يمكن ان يكون اسم النشاط التجاري فارغً  ا",
  "Business Registration Number": "رقم السجل التجاري",
  "Business Registration Number cannot be empty":
      "لا يمكن أن يكون رقم السجل التجاري فارغا",
  "Required minimum 3 characters": "مطلوب 3 أحرف على الأقل ",
  "Email ID cannot be empty": "لا يمكن أن يكون البريد الالكتروني فارغأ ",
  "Enter a valid email address": "أدخل عنوان بريد إلكتروني صالح",
  "Mobile Number": "رقم الهاتف",
  "Mobile Number cannot be empty": "رقم  الهاتف  لا يمكن أن يكون فارغا ",
  "Zone": "المنطقة",
  "Zone cannot be empty": "رقم المنطقة لا يمكن ان يكون فارغا",
  "Street no.": "رقم الشارع",
  "Street cannot be empty": " لا يمكن أن يكون رقم الشارع فارغا",
  "Bldg.no.": " رقم المبني",
  "Bldg cannot be empty": " رقم المبني لا يمكن أن يكون فارغا",
  "Unit no.": "رقم الوحدة",
  "Alert : ": " تنبية",
  "Are you sure?": " هل أنت متأكد ؟",
  "Your account status would be Under Review\nYour operation kept on hold until it gets verified.":
      "ستكون حالة حسابك  قيد المراجعة \ سيتم تعليق العملية حتى يتم التحقق منها.",
  "Please provide valid details": "الرجاء تقديم تفاصيل صحيح ",
  "The changes won't be saved": "لم يتم حفظ التغييرات",
  "Confirm": "يتأكد",
  "Cancel": " الغاء",
  "Business Documents": "	المستندات التجارية",
  "Upload Below Documents": "تحميل المستندات أدناه",
  "Mobile number already exist": "رقم الهاتف  موجود بالفعل",
  "Email address already exist": " البريد الالكتروني موجود بالفعل",
  "You can view or download the legally signed contract between Sadad and your company.":
      "يمكنك عرض أو تنزيل العقد الموقع قانونًا بين سداد وشركتك.",
  "By going back your edited changes will be removed.":
      "بالرجوع ، ستتم إزالة التغييرات التي تم إجراؤها.",

  "Owner ID card": "بطاقة هوية المالك",

  "Upload your Owner's valid residency Card":
      "قم بتحميل بطاقة إقامة صالحة لمالك العقار الخاص بك",

  "Sample": "عينة",

  "Owner ID": "بطاقة المالك",

  "Do you want to remove this Owner ID?": "هل تريد ازالة بطاقة هوية المالك",

  "(Upload front and back of Qatar ID)": "(تحميل الأمامي والخلف من معرف قطر)",

  "Upload": " تحميل",

  "Maximum number of page limits has been reached. You're allowed to upload only 2 pages for Owner ID document category.":
      "تم الوصول إلى الحد الأقصى لعدد الصفحات المسموح بها. يُسمح لك بتحميل صفحتين فقط لفئة مستند هوية  المالك.",

  "please select Document format to": " الرجاء تحديد تنسيق مستند لـ",

  "upload from below": "تحميل من الأسفل",
  "document in Establishment card document category.":
      "وثيقة في فئة وثيقة بطاقة المنشأة.",
  "Sorry! You didn't upload a valid Establishment card document.Kindly reupload the document.":
      "آسف! لم تقم بتحميل مستند بطاقة مؤسسة صالح. يرجى إعادة تحميل المستند.",

  "PDF": "pdf",

  "Image": " صورة",

  "File size limit 20 MB.": "حد حجم الملف هو 20 ميغا بايت.",

  "Oversize file": " ملف كبير الحجم ",

  "file is founded more than 20 mb size.":
      " ملفات تم تأسيسها بحجم يزيد عن 20 ميغا بايت.",
  "There is": "يوجد",

  "An Error occurred while uploading a lower quality version of this file: [testImage.png] Please upload a high quality version of the file.":
      "حدث خطأ أثناء تحميل إصدار أقل جودة من هذا الملف: [testImage.png] يرجى تحميل نسخة عالية الجودة من الملف.",

  "You have uploaded Owner ID card document with valid type document. Please remove it.":
      "لقد قمت بتحميل مستند بطاقة هوية المالك مع مستند نوع صالح. الرجاء إزالته.",

  "You have uploaded": "لقد قمت بتحميل مستند",
  "document with valid type document. Please remove it.":
      "مع مستند نوع صالح. الرجاء إزالته.",

  "You have uploaded Commercial registration document with valid type document. Please remove it.":
      "لقد قمت بتحميل مستند السجل التجاري بمستند نوع صالح. الرجاء إزالته.",

  "You have uploaded Establishment card document with valid type document. Please remove it.":
      "لقد قمت بتحميل بطاقة المنشأةمستند بنوع مستند صالح. يرجى إزالته ",

  "You have uploaded Owner ID card document in Owner ID card document category.":
      "لقد قمت بتحميل مستند بطاقة هوية المالك في فئة مستند بطاقة هوية المالك.",

  "You have uploaded Commercial registration document in Owner ID card document category.":
      "لقد قمت بتحميل مستند السجل التجاري في فئة مستند بطاقة هوية المالك.",

  "You have uploaded Commercial license document in Owner ID card document category.":
      "لقد قمت بتحميل مستند الترخيص التجاري في فئة مستند بطاقة هوية المالك.",

  "You have already uploaded this document so can not upload same document twice.":
      "لقد قمت بالفعل بتحميل هذا المستند ، لذا لا يمكنك تحميله مرتين",
  "You have uploaded Establishment card document in Owner ID card document category.":
      "لقد قمت بتحميل مستند بطاقة المنشأة في فئة مستند بطاقة هوية المالك.",
  "Sorry! You didn't upload a valid Commercial registration document.Kindly reupload the document.":
      "آسف! لم تقم بتحميل مستند سجل تجاري صالح ، يرجى إعادة تحميل المستند.",

  "You have already uploaded this document so can not upload same document twice.":
      "لقد قمت بالفعل بتحميل هذا المستند ، لذا لا يمكنك تحميله مرتين",
  "You have uploaded Establishment card document in Owner ID card document category.":
      "لقد قمت بتحميل مستند بطاقة المنشأة في فئة مستند بطاقة هوية المالك.",
  "Sorry! You didn't upload a valid Commercial registration document.Kindly reupload the document.":
      "آسف! لم تقم بتحميل مستند سجل تجاري صالح ، يرجى إعادة تحميل المستند.",

  "Kindly remove this document from Owner ID card category.":
      "يرجى إزالة هذا المستند من فئة بطاقة هوية المالك .",
  "Sorry! You didn't upload a valid Owner ID card document.Kindly reupload the document.":
      "عذرًا! لم تقم بتحميل مستند بطاقة هوية مالك صالح. يرجى إعادة تحميل المستند.",

  "An Error occurred while uploading a lower quality version of this file: [testimage.png] Please upload a high quality version of the file.":
      "حدث خطأ أثناء تحميل إصدار أقل جودة من هذا الملف: [testimage.png] يرجى تحميل نسخة عالية الجودة من الملف.",

  "An Error occurred while uploading a lower quality version of this file:":
      "حدث خطأ أثناء تحميل إصدار أقل جودة من هذا الملف:",
  "Please upload a high quality version of the file.":
      " يرجى تحميل نسخة عالية الجودة من الملف.",

  "You have uploaded the expired document. Please reupload the valid document":
      "لقد قمت بتحميل مستند منتهي الصلاحية. الرجاء إعادة تحميل المستند الصحيح",

  "You have uploaded two different Owner's Id. Please upload single Owner's Id":
      "لقد قمت بتحميل هويتين مالك مختلفين الرجاء تحميل بطاقة مالك واحد",

  "You have uploaded multiple Owner ID card document. Kindly upload only one document here.":
      "لقد قمت بتحميل مستندات متعددة لبطاقة هوية المالك. الرجاء تحميل مستند واحد فقط هنا.",
  "You have uploaded multiple Commercial license document. Kindly upload only one document here.":
      "لقد قمت بتحميل مستندات متعددة ل  الرخصة التجارية. الرجاء تحميل مستند واحد فقط هنا.",
  "You have uploaded two different Commercial license. Please upload single Commercial license":
      "لقد قمت بتحميل رخصتين تجاريتين مختلفتين. الرجاء تحميل رخصة تجارية واحدة",
  "You have uploaded multiple Commercial registration card document. Kindly upload only one document here.":
      "لقد قمت بتحميل عدة مستندات لبطاقة السجل التجاري. يرجى تحميل وثيقة واحدة فقط هنا.",
  "You have uploaded multiple Commercial registration document. Kindly upload only one document here.":
      "لقد قمت بتحميل عدة مستندات تسجيل تجاري. يرجى تحميل وثيقة واحدة فقط هنا.",
  "You have uploaded multiple Establishment card document. Kindly upload only one document here.":
      "لقد قمت بتحميل عدة مستندات لبطاقة المنشأة. يرجى تحميل وثيقة واحدة فقط هنا.",

  "Success": "ناجحة",

  "Your document uploaded and validated successfully.":
      "تم تحميل المستند الخاص بك والتحقق من صحته بنجاح.",
  "Sorry! You didn't upload a valid Commercial license document.Kindly reupload the document.":
      "عذرا ، لم تقم بتحميل وثيقة رخصة تجارية صالحة. يرجى إعادة تحميل المستند.",

  "Update Successfully": "تم التحديث بنجاح",

  "error": " خطأ",

  "First": "الاول",

  "Second": "الثاني",

  "Third": "الثالث",

  "Fourth": "الرابع",

  "Fifth": "الخامس,",

  "Sixth": "السادس",

  "Seventh": "السابع",

  "Eighth": "الثامن",

  "Ninth": "التاسع",

  "Tenth": "العاشر",

//==========================================

  "Commercial license": " الرخصة التجارية",

  "Do you want to remove this Commercial license?":
      " هل تريد حذف الرخصة التجارية",

  "Maximum number of page limits has been reached. You're allowed to upload only 5 pages for Commercial license document category.":
      "تم الوصول إلى الحد الأقصى لعدد الصفحات المسموح بها. يُسمح لك بتحميل 5 صفحات فقط لفئة مستند الرخصة التجارية.",

  "Alert : You can upload more than 5 Commercial licence documents from your merchant panel account.":
      "تنبيه: يمكنك تحميل أكثر من 5 مستندات ترخيص تجاري من حساب لوحة التاجر.",

//===========================================

  "Establishment card": " بطاقة قيد المنشأ",

  "Upload your valid Company Establishment card ":
      "قم بتحميل بطاقة تأسيس شركة صالحة",

  "Do you want to remove this Establishment card?":
      "هل تريد إزالة بطاقة المنشأة هذه؟",

  "Maximum number of page limits has been reached. You're allowed to upload only 2 pages for Establishment card document category.":
      "تم الوصول إلى الحد الأقصى لعدد الصفحات المسموح بها. يُسمح لك بتحميل صفحتين فقط لفئة مستند بطاقة قيد المنشأ .",

//=============================================

  "Other": "اخري",

  "Upload other type of document here": " قم بتحميل نوع آخر من المستندات هنا.",

  "Do you want to remove this Other document?":
      "هل تريد إزالة هذا المستند الآخر؟",

  "Maximum number of page limits has been reached. You're allowed to upload only 5 pages for Other document category.":
      "تم الوصول إلى الحد الأقصى لعدد الصفحات المسموح بها. يُسمح لك بتحميل 5 صفحات فقط لفئة المستندات الأخرى.",
  "Selected pages :": "اختر الصفحة",

  "Other document": "مستند اخر",

//=================================================

  "Commercial registration": " الرخصة التجارية",

  "Upload your valid Commercial Registration copy as issued by the Ministry of Economy & Commerce":
      "قم بتحميل نسخة من السجل التجاري الخاص بك ساري المفعول كما هو صادر عن وزارة الاقتصاد والتجارة",
  "Do you want to remove this Commercial registration?":
      "هل تريد ازالة السجل التجاري",

  "Maximum number of page limits has been reached. You're allowed to upload only 10 pages for Commercial registration document category.":
      "تم الوصول إلى الحد الأقصى لعدد الصفحات المسموح بها. يُسمح لك بتحميل 10. ",

  "Good Morning!": "صباح الخير!",
  "Good Afternoon!": "مساء الخير!",
  "Good Evening!": "مساء الخير!",
  "Sadad ID": "معرف سداد",
  "Default": "افتراضي",
  "Close": "أغلق",
  "Primary": "الرئيسي",
  "Manage Merchants": "إدارة التجار",
  "Linked Date :": "تاريخ الربط : ",
  "Link Merchant": "ربط التاجر",
  "Merchant Sadad ID": "معرف التاجر سداد",
  "Submit": "تقديم",
  "No, thanks": "ًلا شكرا",
  "CR Number": "رقم السجل التجاري ",
  "Available Balance": "الرصيد المتاح",
  "Business Status": "حالة الحساب",
  "Bank Status": "حالة البنك",
  "Create Merchant": "إنشاء تجار",
  "Add Merchant": "أضف تاجر",
  "Unlink Merchant": "فك ربط التاجر",
  "Do you want to unlink the merchant account?":
      "هل تريد إلغاء ربط حساب التاجر؟",
  "Confirm": "تآكيد",
  "Alert": "تنبية",
  "You need to change the mobile number & email id before unlinking the merchant account":
      "تحتاج إلى تغيير رقم الجوال و البريد الإلكتروني قبل إلغاء ربط حساب التاجر",
  "Cell Number": "رقم الجوال",
  "Email id": "البريد الإلكتروني",
  "Marchant Sadad ID cannot be empty": "لا يمكن ترك رقم حساب سداد فارغًا",
  "Marchant Sadad ID is not valid": "رقم حساب سداد غير صالح",
  "Mobile Number cannot be empty": "لا يمكن أن يكون رقم الجوال فارغًا",
  "Invalid Mobile Number.": "رقم الجوال غير صالح.",

  "Success : ": "نجاح :",
  "Failure : ": "فشل :",

  "Please check your connection": "يرجى التحقق من اتصالك",
  "Authentication set Successfully": "تم ارسال المصادقة بنجاح",
  "Device Not Supported": "الجهاز غير مدعوم",
  "device does not have hardware support for biometrics":
      "لا يحتوي الجهاز على دعم الأجهزة للقياسات الحيوية",
  "QAR": "ريال قطري",
  "UnLink merchant successfully.": "تم إلغاء ربط التاجر بنجاح.",
  "Link merchant request sent.": "تم إرسال طلب رابط التاجر.",
  "Submerchant created successfully.": "تم إنشاء الحساب الفرعي بنجاح.",
  "Validating...": "التحقق من صحة ...",
  "We are validating your document. \nThis may take couple of more seconds":
      "نحن نتحقق من صحة وثيقتك. \n قد يستغرق ذلك ثانيتين.",
  "Please login with your updated details.":
      "الرجاء تسجيل الدخول مع التفاصيل الخاصة بك المحدثة.",
  "Please on location service for registration":
      "من فضلك على خدمة الموقع للتسجيل",
  "On Location Service": "في خدمة الموقع",
  "Sorry, we couldn't find you in Qatar. The registration couldn't be completed.":
      "عذرا ، لم نتمكن من العثور عليك في قطر. لا يمكن إتمام التسجيل.",
  'Note': 'خطأ',
  'failure': 'فاشلة',
  'Please Note': 'يرجى الملاحظة',

  //batch summary
  'Batch Summary': "صيف الدُفعات",
  'Batch Summery': "صيف الدُفعات",
  'Device Serial Number :': "الرقم التسلسلي للجهاز:",
  'Total Amount : ': "المبلغ الإجمالي:",
  'Total Count -': "العدد الإجمالي -",

  //batch summary detail
  'Batch Summery Detail': "تفاصيل ملخص الدُفعات ",
  'Apply': "تطبيق",
  'Count': 'عدد',
  'Sales': "المبيعات",
  'PreAuth': 'PreAuth',
  'Total': "إجمالي",

  //Terminal Screen
  'Terminal status': "حالة الجهاز",
  'Online': "عبر الإنترنت",
  'Offline': "غير متصل",
  'Live Terminal Status': "حالة الجهاز المباشر",

  'Terminal name*': "اسم الجهاز *",
  'update': "تحديث",
  'ex. ID, Name, D-SR number, Terminal location':
      ' ex. المعرّف ، الاسم ، رقم D-SR ، موقع الجهاز ',
  'Device Model': "نوع الجهاز",
  'Terminal Login Id': "معرف تسجيل الدخول إلى الجهاز",
  'View Transactions': "عرض العمليات",
  'Set Up Fees': "رسوم التأسيس",
  'SIM Number': "SIM رقم",
  'View Terminal History': 'عرض تاريخ الجهاز',
  'Last Transaction Date & Time': 'تاريخ ووقت آخر عملية',
  'Terminal History': 'تاريخ الجها',
  'Device Activation Date': 'تاريخ تنشيط الجهاز',
  'Device Deactivation Date': 'تاريخ إلغاء تنشيط الجهاز',
  'Device Type/model': 'نوع / طراز الجهاز',
  'Sim Number': 'SIM رقم',
  'Device Rental Amount': 'مبلغ إيجار الجهاز',
  'WPOS-3': 'WPOS-3',
  'WPOS-QT': 'WPOS-QT',

  //FilterPosPaymentScreen
  'Terminal Selection': 'تحديد الجهاز',
  'Choose Terminal ID': 'اختر معرف الجهاز',
  'ID:': 'التعريفي:',
  'Choose your Terminal': ' اختر الجهاز الخاص بك',

  //Internet Not Found
  'Please check your connection': 'الرجاء التحقق من الاتصال الخاص بك',
  'sorry, We can’t connect you.': 'عذراً ، لا يمكننا الاتصال بك.',
  'Try Later': 'حاول لاحقًا',
  'Looks like we can’t connect to one of our services right now,Please check your internet Connectivity Please try again later':
      'يبدو أنه لا يمكننا الاتصال بإحدى خدماتنا في الوقت الحالي ، يرجى التحقق من اتصالك بالإنترنت ، يرجى المحاولة مرة أخرى لاحقًا',
  'Search for :': 'بحث عن :',
  'Selection': 'اختيار',
  "Rental Payments": "مدفوعات الإيجار",
  "Terminal Activation Date": "تاريخ تفعيل المحطة",
  "Please select correct date": "الرجاء تحديد التاريخ الصحيح",
  "Your user account is not allowed to login from the app, you can login from ":
      "لا يُسمح لحساب المستخدم الخاص بك بتسجيل الدخول من التطبيق ، يمكنك تسجيل الدخول من",
  "Refund ID": "معرف الاسترداد",
  "Format": "شكل",
  "Credit card": "بطاقة إئتمان",
  "Debit card": "بطاقة ائتمان",
  "Order Number": "رقم الأمر",
  "Transaction Id": "رقم المعاملة",
  "Buyer Name": "اسم المشتري",
  "Integration Types": "أنواع التكامل",
  "Store Order Details": "تفاصيل طلب المتجر",
  "withdrawals": "الانسحابات",
  "Transfers": "التحويلات",
  "Your user account is not allowed to login from the app, you can login from ":
      "لا يُسمح لحساب المستخدم الخاص بك بتسجيل الدخول من التطبيق ، يمكنك تسجيل الدخول من",
  "Commercial registration number already exist":
      "رقم السجل التجاري موجود بالفعل",
  "Add Marchant": "أضف مارشانت",
  "I hereby acknowledge that I have read, understood and agree to the":
      "أقر بموجبه أنني قد قرأته وفهمته وأوافق عليه",
  "Marchant Sadad ID": "الرقم التعريفي للتاجر في سداد",
  "Please, Provide your E-Signature in below box":
      "من فضلك ، أدخل التوقيع الإلكتروني الخاص بك في المربع أدناه",
  "Your user account is not allowed to login from the app,\nYou can login from panel.sadad.qa":
      "لا يُسمح لحساب المستخدم الخاص بك بتسجيل الدخول من التطبيق ، \ n يمكنك تسجيل الدخول من panel.sadad.qa",
  "Total Count": "العدد الإجمالي",

  "Link Request": "طلب ربط",
  "Pending for Approval": "في انتظار لموافقة",

  /// Delete Account ////
  "Account Settings": "إعدادت الحساب",
  "Delete Account": "حذف الحساب",
  "Terms & Conditions": "الأحكام والشروط",
  "Confirm Delete": "تأكيد الحذف",
  "We can't delete your account yet": "لا يمكننا حذف حسابك حتى الآن",
  "Looks like you’re the primary merchant of the sub users linked with you account. You’ll need to go to your manage merchant page and unlink all sub merchants then return to settings to delete your account.":
      "يبدو أنك التاجر الأساسي للمستخدمين الفرعيين المرتبطين بحسابك. ستحتاج إلى الانتقال إلى صفحة إدارة التاجر وإلغاء ربط جميع التجار الفرعيين ثم العودة إلى الإعدادات لحذف حسابك.",
  "Looks like you have some amount in your wallet account, you need to withdraw the full amount.":
      "يبدو أن لديك بعض المبلغ في حساب محفظتك ،أنت بحاجة إلى سحب المبلغ بالكامل.",
  "It looks like something needs to be resolved before we can delete your account. Once you have resolved the issue, please retry deleting your account from the settings.":
      "يبدو أن هناك شيئًا ما يحتاج إلى حل قبل أن نتمكن من حذف حسابك. بمجرد حل المشكلة ، يرجى إعادة محاولة حذف حسابك من الإعدادات.",
  "We’re sorry to see you leave, we would love to know why you’re deleting your account.":
      "نأسف لمغادرتك ، نود أن نعرف سبب حذفك لحسابك.",
  "We care deeply about the user experience and listening closely to the feedback you provide.":
      "نحن نهتم بشدة بتجربة المستخدم ونستمع عن كثب إلى التعليقات التي تقدمها.",
  "Continue to Account Deletion": "انتقل إلى حذف الحساب",
  "No longer find SADAD useful": "لم تعد تجد تطبيق سداد مفيدًا",
  "Don't feel convenient service/support": "لا تشعر بالراحة في الخدمة / الدعم",
  "Required features aren't available": "الميزات المطلوبة غير متوفرة",
  "Security and Privacy concerns": "مخاوف تتعلق بالأمان والخصوصية",
  "Delay in settlement": "التأخير في السداد",
  "Created another account": "إنشاء حساب آخر",
  "Others": "اخري",
  "Please note deleting your Sadad account does not release you from any liability related to your account balance, including but not limited to POS terminal rentals, SADAD paid services, disputes etc.":
      "يرجى ملاحظة أن حذف حساب سداد الخاص بك لا يعفيك من أي مسؤولية تتعلق برصيد حسابك ، بما في ذلك على سبيل المثال لا الحصر ، إيجارات نقاط البيع ، وخدمات سداد المدفوعة ، والنزاعات وما إلى ذلك.",
  "Once you delete your Sadad account, you will no longer be able to process any refunds, issue any payments or respond to any customer disputes.":
      "بمجرد حذف حساب سداد الخاص بك ، لن تتمكن بعد الآن من معالجة أي عمليات استرداد أو إصدار أي مدفوعات أو الرد على أي نزاعات مع العملاء.",
  "If you have any reason to believe that you may have further refunds to issue or disputes to respond to, we recommend keeping your account open until those have been resolved.":
      "إذا كان لديك أي سبب للاعتقاد بأنه قد يكون لديك المزيد من المبالغ المستردة لإصدار أو نزاعات للرد عليها ، فنحن نوصي بإبقاء حسابك مفتوحًا حتى يتم حلها.",
  "We also recommend exporting any reports that are required, as Sadad Support has limited access once an account is deleted.":
      "نوصي أيضًا بتصدير أي تقارير مطلوبة ، نظرًا لأن دعم Sadad له وصول محدود بمجرد حذف الحساب.",
  "Deleting an account will not prevent settlement payouts from happening (e.g. if an account was deleted today, a withdrawal accepted before delete request would still deposit into the account’s bank account) We strongly recommend waiting until all funds have been successfully paid out to your bank account before deleting your Sadad account.":
      "لن يؤدي حذف الحساب إلى منع حدوث مدفوعات التسوية (على سبيل المثال ، إذا تم حذف حساب اليوم ، فسيتم قبول السحب قبل إيداع طلب الحذف في الحساب المصرفي للحساب) نوصي بشدة بالانتظار حتى يتم دفع جميع الأموال بنجاح إلى حسابك المصرفي قبل حذف حساب سداد الخاص بك.",
  "Your sub users’ accounts would be terminated automatically by Deleting your account.":
      "سيتم إنهاء حسابات المستخدمين الفرعيين تلقائيًا عن طريق حذف حسابك.",
  "We delay deletion 60 days after it's requested. A deletion request is cancelled if you log back in to your Sadad account during this time.":
      "نقوم بتأخير الحذف بعد 60 يومًا من طلبه. يتم إلغاء طلب الحذف إذا قمت بتسجيل الدخول مرة أخرى إلى حساب سداد الخاص بك خلال هذا الوقت.",
  "After 60 days, your account and all of your information will be permanently deleted, and you won't be able to retrieve your information. You can't regain access once it's deleted":
      "بعد 60 يومًا ، سيتم حذف حسابك وجميع معلوماتك نهائيًا ، ولن تتمكن من استرداد معلوماتك. لا يمكنك استعادة الوصول بمجرد حذفه",
  "Copies of some information (e.g. log records) may remain in our database but are disassociated from personal identifiers.":
      "قد تظل نسخ بعض المعلومات (مثل سجلات السجل) في قاعدة البيانات الخاصة بنا ولكن يتم فصلها عن المعرفات الشخصية.",
  "Some information may remain visible to others (past Sadad wallet transfer payments history).":
      "قد تظل بعض المعلومات مرئية للآخرين (سجل مدفوعات تحويل محفظة سداد السابقة).",

  "Closing my business": "أغلق عملي",
  "Keep your account safe, please verify your identity":
      "حافظ على حسابك آمنًا ، يرجى التحقق من هويتك",
  "Your Delete account request is submitted.": "تم تقديم طلب حذف حسابك.",
  "You can exit the app.": "يمكنك الخروج من التطبيق.",
  "Please enter reason to continue": "الرجاء إدخال سبب للاستمرار",
  "Please enter reason": "الرجاء إدخال السبب",
  "Please select any one to continue": "الرجاء تحديد أي واحد للمتابعة",

  "Successfully deleted": "Successfully deleted",
  "Welcome back,\n You can continue to login your account":
      "مرحبًا بعودتك ، \n يمكنك الاستمرار في تسجيل الدخول إلى حسابك",
  "or": "أو",
  "You can register a new account": "يمكنك تسجيل حساب جديد",
  "Successfully deleted": "تم الحذف بنجاح",

  "Your user account is not allowed to login from the app, you can login from ":
      "لا يُسمح لحساب المستخدم الخاص بك بتسجيل الدخول من التطبيق ، يمكنك تسجيل الدخول من",
  "Commercial registration number already exist":
      "رقم السجل التجاري موجود بالفعل",
  "Add Marchant": "أضف مارشانت",
  "I hereby acknowledge that I have read, understood and agree to the":
      "أقر بموجبه أنني قد قرأته وفهمته وأوافق عليه",
  "Marchant Sadad ID": "الرقم التعريفي للتاجر في سداد",
  "Please, Provide your E-Signature in below box":
      "من فضلك ، أدخل التوقيع الإلكتروني الخاص بك في المربع أدناه",
  "Your user account is not allowed to login from the app,\nYou can login from panel.sadad.qa":
      "لا يُسمح لحساب المستخدم الخاص بك بتسجيل الدخول من التطبيق ، \ n يمكنك تسجيل الدخول من panel.sadad.qa",
  "Total Count": "العدد الإجمالي",
  "Subscription ID": "معرف الإشتراك",
  "Merchant Reference Number": "الرقم المرجعي للتاجر",
  "Masked Card Number": "رقم البطاقة محجوب",
  "Transaction origin": "أصل المعاملة",
  "Refund Requested date & time": "تاريخ ووقت طلب استرداد الأموال",
  "Dispute Created Date & Time": "تاريخ ووقت إنشاء النزاع",
  "Dispute Amount": "المبلغ المتنازع عليه",
  "Dispute Status": "حالة النزاع",
  "Comments": "تعليقات",
  "Invoice Number": "رقم الفاتورة",
  "Invoice Created Date": "تاريخ إنشاء الفاتورة",
  "Invoice Description": "وصف الفاتورة",
  "Bin Country": "بن البلد",
  "Integration Source": "مصدر التكامل",
  "Delivery Status": "حالة التسليم",
  "Are you sure you want to reactivate the account?":"هل أنت متأكد أنك تريد إعادة تنشيط الحساب؟",
};
