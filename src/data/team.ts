export interface TeamMember {
  name: string;
  nameAr: string;
  role: string;
  roleAr: string;
  description: string;
  descriptionAr: string;
  image: string;
}

export const teamMembers: TeamMember[] = [
  {
    name: "Abdelrahman Khaled",
    nameAr: "عبد الرحمن خالد",
    role: "Flutter Developer",
    roleAr: "مطور تطبيقات فلاتر",
    description: "Leads the development of the Sekka mobile application, building a seamless experience across Android and iOS platforms.",
    descriptionAr: "يقود تطوير تطبيق سكة المحمول، ويبني تجربة سلسة عبر منصتي Android و iOS.",
    image: "team1.png"
  },
  {
    name: "Hussein Yasser",
    nameAr: "حسين ياسر",
    role: "Mobile Penetration Tester",
    roleAr: "مختبر اختراق تطبيقات المحمول",
    description: "Secures the Sekka application through comprehensive security testing on both Android and iOS platforms.",
    descriptionAr: "يؤمن تطبيق سكة من خلال اختبارات أمنية شاملة على منصتي Android و iOS.",
    image: "team2.png"
  },
  {
    name: "Abdelrahman Hamdy",
    nameAr: "عبد الرحمن حمدي",
    role: "Assistant Flutter Developer",
    roleAr: "مطور فلاتر مساعد",
    description: "Supports the core development team in building features and maintaining code quality for the Sekka application.",
    descriptionAr: "يدعم فريق التطوير الأساسي في بناء الميزات والحفاظ على جودة الكود لتطبيق سكة.",
    image: "team3.png"
  },
  {
    name: "Mostafa Aly",
    nameAr: "مصطفى علي",
    role: "Web Developer",
    roleAr: "مطور مواقع الويب",
    description: "Creates and maintains the Sekka website, ensuring a beautiful and responsive user experience.",
    descriptionAr: "ينشئ ويحافظ على موقع سكة الإلكتروني، مما يضمن تجربة مستخدم جميلة ومتجاوبة.",
    image: "team4.png"
  },
  {
    name: "Ahmed ElShebawy",
    nameAr: "أحمد الشباوي",
    role: "AI Engineer",
    roleAr: "مهندس ذكاء اصطناعي",
    description: "Develops the intelligent chatbot that powers Sekka's customer support and user assistance features.",
    descriptionAr: "يطور روبوت الدردشة الذكي الذي يدعم ميزات دعم العملاء والمساعدة في تطبيق سكة.",
    image: "team5.png"
  },
  {
    name: "Zeyad Farouk",
    nameAr: "زياد فاروق",
    role: "UI/UX & Graphic Designer",
    roleAr: "مصمم واجهات وتجربة مستخدم",
    description: "Designs the stunning visual identity and intuitive user experience that makes Sekka beautiful and easy to use.",
    descriptionAr: "يصمم الهوية البصرية المذهلة وتجربة المستخدم البديهية التي تجعل سكة جميلة وسهلة الاستخدام.",
    image: "team6.png"
  },
  {
    name: "Shahd Yasser",
    nameAr: "شهد ياسر",
    role: "ML Engineer",
    roleAr: "مهندس تعلم الآلة",
    description: "Builds the AI prediction models that forecast crowding levels, helping users find less crowded transportation options.",
    descriptionAr: "تبني نماذج تنبؤية بالذكاء الاصطناعي تتوقع مستويات الازدحام، مما يساعد المستخدمين على إيجاد خيارات نقل أقل ازدحاماً.",
    image: "team7.png"
  },
  {
    name: "Azmiralda Loay",
    nameAr: "أزميرالدا لؤى",
    role: "Embedded Systems Engineer",
    roleAr: "مهندس أنظمة مضمنة",
    description: "Develops IoT sensor integration and embedded systems for enhanced transportation tracking capabilities.",
    descriptionAr: "يطور تكامل مستشعرات إنترنت الأشياء والأنظمة المدمجة لقدرات تتبع النقل المحسنة.",
    image: "team8.png"
  }
];

export const features = [
  {
    icon: "Route",
    title: "Smart Routing",
    titleAr: "توجيه ذكي",
    description: "AI-powered route optimization finds the fastest path across all transport modes.",
    descriptionAr: "تحسين المسار المدعوم بالذكاء الاصطناعي يجد أسرع مسار عبر جميع وسائل النقل."
  },
  {
    icon: "Brain",
    title: "Crowding Prediction",
    titleAr: "توقع الازدحام",
    description: "ML models predict crowd levels to help you choose less busy options.",
    descriptionAr: "تتنبأ نماذج التعلم الآلي بمستويات الازدحام لمساعدتك في اختيار خيارات أقل ازدحاماً."
  },
  {
    icon: "MapPin",
    title: "Nearest Station Finder",
    titleAr: "كاشف أقرب محطة",
    description: "Instantly locate the closest station for any transport type near you.",
    descriptionAr: "حدد موقع أقرب محطة لأي نوع من وسائل النقل بالقرب منك فوراً."
  },
  {
    icon: "Ticket",
    title: "Multi-Modal Booking",
    titleAr: "حجز متعدد الأنماط",
    description: "Book tickets across Metro, Monorail, Bus, and Microbus in one unified platform.",
    descriptionAr: "احجز تذاكر المترو والمونوريل والأتوبيس والميكروباص في منصة موحدة واحدة."
  },
  {
    icon: "Radio",
    title: "Real-Time Tracking",
    titleAr: "تتبع فوري",
    description: "Live updates on vehicle locations and arrival times for accurate planning.",
    descriptionAr: "تحديثات مباشرة على مواقع المركبات وأوقات الوصول للتخطيط الدقيق."
  },
  {
    icon: "Expand",
    title: "Expandable Platform",
    titleAr: "منصة قابلة للتوسع",
    description: "Built to grow with Egypt's transportation network, adding new modes and routes.",
    descriptionAr: "مصممة للنمو مع شبكة النقل في مصر، مع إضافة أوضاع ومسارات جديدة."
  }
];

export const transportTypes = [
  {
    icon: "Train",
    name: "Metro",
    nameAr: "المترو",
    description: "Egypt's underground railway network",
    descriptionAr: "شبكة السكك الحديدية تحت الأرض في مصر"
  },
  {
    icon: "CableCar",
    name: "Monorail",
    nameAr: "المونوريل",
    description: "Modern elevated rail transit",
    descriptionAr: "سكك حديدية معلقة حديثة"
  },
  {
    icon: "Bus",
    name: "Bus",
    nameAr: "الأتوبيس",
    description: "Public bus services nationwide",
    descriptionAr: "خدمات الحافلات العامة في جميع أنحاء البلاد"
  },
  {
    icon: "Car",
    name: "Microbus",
    nameAr: "الميكروباص",
    description: "Shared transport for flexibility",
    descriptionAr: "نقل مشترك للمرونة"
  }
];