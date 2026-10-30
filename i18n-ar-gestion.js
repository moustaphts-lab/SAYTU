/* Saytu — traduction arabe des écrans de gestion (étape 2), générée à partir des textes de l'application.
   exact : texte entier ; pats : formules à trous (§1, §2… = parties variables, dans l'ordre du texte français). */
(function(){const A=window.SAYTU_AR;if(!A)return;
const X={
"(calcul provisoire)": "(احتساب مؤقت)",
"(en cours)": "(جارٍ)",
"(en plus de ceux déjà placés cette semaine)": "(إضافة إلى ما سبق برمجته هذا الأسبوع)",
"(montant masqué)": "(المبلغ مخفي)",
"(pied de page)": "(أسفل الصفحة)",
"(terminée)": "(منتهٍ)",
"(université)": "(الجامعة)",
"(à décocher avant d'utiliser de vraies données)": "(ألغِ التحديد قبل استعمال بيانات حقيقية)",
"+ Ajouter": "+ إضافة",
"+ Nouvelle période": "+ فترة جديدة",
", ouvrez l'emploi du temps, touchez le cours puis « Reporter » : la demande se règle toute seule.": "، افتح الجدول، والمس الدرس ثم «تأجيل»: يُسوّى الطلب تلقائيًا.",
", paie": "، الرواتب",
", salle": "، القاعة",
", visée": "، مؤشَّر عليها",
", à viser": "، للتأشير",
"/ semaine ·": "/ أسبوع ·",
"0 = sans limite": "0 = بلا حد",
": les professeurs ne voient rien tant que vous ne publiez pas la semaine. Vous pouvez ensuite modifier ou supprimer chaque créneau.": ": لا يرى الأساتذة شيئًا ما لم تنشر الأسبوع. يمكنك بعد ذلك تعديل كل حصة أو حذفها.",
": même professeur, même salle, même moment, même volume. Une seule séance est émargée et payée. Le groupe principal ne peut pas être retiré ici.": ": الأستاذ نفسه، القاعة نفسها، الوقت نفسه، الحجم نفسه. تُسجَّل حصة واحدة وتُدفع. لا يمكن سحب الفوج الرئيسي من هنا.",
"ANNULÉ": "ملغى",
"ANNULÉ ·": "ملغى ·",
"Absences": "الغيابات",
"Actif": "نشِط",
"Actif · mot de passe provisoire à changer": "نشِط · كلمة مرور مؤقتة يجب تغييرها",
"Actifs": "النشطون",
"Action": "الإجراء",
"Activité récente": "النشاط الأخير",
"Activité": "النشاط",
"Nom donné aux facultés dans Saytu": "الاسم المعطى للكليات في Saytu",
"Vocabulaire enregistré": "تم حفظ المصطلحات",
"Administrateur (comptes)": "مهندس النظام (الحسابات)",
"Administration des comptes": "إدارة الحسابات",
"Adresse": "العنوان",
"Affectation": "الإسناد",
"Affectations reprises de": "إسنادات مستعادة من",
"Affectée": "مُسندة",
"Afficher": "عرض",
"Afficher aussi les dates passées": "عرض التواريخ الماضية أيضًا",
"Afficher les comptes de démonstration sur l'écran de connexion": "عرض الحسابات التجريبية في شاشة الدخول",
"Afficher par": "العرض حسب",
"Afficher plus": "عرض المزيد",
"Ajouter un cours": "إضافة درس",
"Ajouter une matière d'une autre filière": "إضافة مادة من شعبة أخرى",
"Amphithéâtre": "مدرج",
"Annonce": "إعلان",
"Annonce publiée": "تم نشر الإعلان",
"Annonce retirée": "تم سحب الإعلان",
"Annoncer les bulletins aux professeurs ?": "إعلام الأساتذة بالكشوف؟",
"Annonces": "الإعلانات",
"Annulations": "الإلغاءات",
"Annuler ce cours ?": "إلغاء هذا الدرس؟",
"Annuler la séance": "إلغاء الحصة",
"Annuler le cours": "إلغاء الدرس",
"Annulé :": "ملغى:",
"Annulées": "الملغاة",
"Année": "السنة",
"Année en cours": "السنة الجارية",
"Année en cours :": "السنة الجارية:",
"Année universitaire": "السنة الجامعية",
"Années": "السنوات",
"Années et semestres": "السنوات والسداسيات",
"Années universitaires": "السنوات الجامعية",
"Aperçu": "معاينة",
"Appliquer": "تطبيق",
"Appliquer cette semaine à partir d'ici ?": "تطبيق هذا الأسبوع ابتداءً من هنا؟",
"Appliquer à partir de cette semaine": "تطبيق ابتداءً من هذا الأسبوع",
"Approuver": "مصادقة",
"Approuver et générer les bulletins": "المصادقة وإنشاء الكشوف",
"Approuver la période ?": "المصادقة على الفترة؟",
"Approuvé (FCFA)": "المصادَق عليه (FCFA)",
"Après-midi": "بعد الظهر",
"Attendu (%)": "المتوقع (%)",
"Au": "إلى",
"Au (inclus)": "إلى (ضمنًا)",
"Au rythme suivi jusqu'ici, ces matières n'atteindraient pas leur volume avant la fin du semestre.": "بالوتيرة المتبعة حتى الآن، لن تبلغ هذه المواد حجمها الساعي قبل نهاية السداسي.",
"Aucun administrateur actif": "لا يوجد مهندس نشِط",
"Aucun autre semestre.": "لا يوجد سداسي آخر.",
"Aucun bulletin ne correspond à cette recherche.": "لا يوجد كشف يطابق هذا البحث.",
"Aucun choix disponible pour «": "لا يوجد اختيار متاح لـ «",
"Aucun compte ne correspond.": "لا يوجد حساب مطابق.",
"Aucun conflit": "لا يوجد تعارض",
"Aucun cours cette semaine.": "لا يوجد درس هذا الأسبوع.",
"Aucun cours publié pour ce groupe cette semaine.": "لا توجد دروس منشورة لهذا الفوج هذا الأسبوع.",
"Aucun cours à exporter.": "لا يوجد درس للتصدير.",
"Aucun cours écarté.": "لم يُستبعد أي درس.",
"Aucun créneau avec ces réglages.": "لا توجد حصة بهذه الإعدادات.",
"Aucun créneau n'a pu être placé avec ces réglages.": "لم يمكن برمجة أي حصة بهذه الإعدادات.",
"Aucun droit": "لا صلاحية",
"Aucun département n'est rattaché à votre poste. Contactez l'administrateur.": "لا يوجد قسم مرتبط بمنصبك. اتصل بمهندس النظام.",
"Aucun groupe.": "لا يوجد فوج.",
"Aucun jour sans cours à venir. Ajoutez les jours fériés et les vacances du semestre.": "لا توجد أيام بدون دروس قادمة. أضف العطل الرسمية وعطل السداسي.",
"Aucun poste": "لا يوجد منصب",
"Aucun professeur concerné.": "لا يوجد أستاذ معني.",
"Aucun professeur n'a de matière en cours.": "لا يوجد أستاذ لديه مادة جارية.",
"Aucun professeur.": "لا يوجد أستاذ.",
"Aucun retard : toutes les séances sont émargées": "لا تأخير: سُجّل الحضور في كل الحصص",
"Aucun semestre en cours ou aucune affectation.": "لا يوجد سداسي جارٍ أو لا يوجد إسناد.",
"Aucun statut d'enseignant : ajoutez-en un dans « Statuts des enseignants ».": "لا توجد صفة أستاذ: أضف واحدة في «صفات الأساتذة».",
"Aucun écart de plus de 50 % par enseignant avec la période précédente.": "لا يوجد فارق يزيد على 50 % لأي أستاذ مقارنة بالفترة السابقة.",
"Aucun émargement avec ces filtres.": "لا يوجد تسجيل حضور بهذه المرشحات.",
"Aucun émargement conforme en attente.": "لا يوجد تسجيل حضور مطابق في الانتظار.",
"Aucune affectation pour le semestre de cette semaine.": "لا يوجد إسناد لسداسي هذا الأسبوع.",
"Aucune annonce en cours.": "لا يوجد إعلان جارٍ.",
"Aucune année universitaire.": "لا توجد سنة جامعية.",
"Aucune année.": "لا توجد سنة.",
"Aucune faculté rattachée à votre compte.": "لا توجد كلية مرتبطة بحسابك.",
"Aucune faculté.": "لا توجد كلية.",
"Aucune heure validée payable dans cette période.": "لا توجد ساعات معتمدة قابلة للدفع في هذه الفترة.",
"Aucune matière d'un semestre en cours cette semaine. Vérifiez les dates des semestres et les affectations.": "لا توجد مادة من سداسي جارٍ هذا الأسبوع. تحقق من تواريخ السداسيات والإسنادات.",
"Aucune matière dans un semestre en cours.": "لا توجد مادة في سداسي جارٍ.",
"Aucune matière du département dans un semestre en cours.": "لا توجد مادة للقسم في سداسي جارٍ.",
"Aucune opération enregistrée.": "لا توجد عملية مسجلة.",
"Aucune opération sur cette période avec ces filtres.": "لا توجد عملية في هذه الفترة بهذه المرشحات.",
"Aucune paie calculée sur cette année.": "لا توجد رواتب محتسبة في هذه السنة.",
"Aucune période. Créez la première période de rémunération.": "لا توجد فترة. أنشئ أول فترة رواتب.",
"Aucune salle.": "لا توجد قاعة.",
"Aucune sauvegarde des données faite depuis cet appareil.": "لم تُنجز أي نسخة احتياطية للبيانات من هذا الجهاز.",
"Aucune sauvegarde faite depuis cet appareil.": "لم تُنجز أي نسخة احتياطية من هذا الجهاز.",
"Aucune séance annulée sur cette période.": "لا توجد حصة ملغاة في هذه الفترة.",
"Aucune séance en attente d'émargement sur les 45 derniers jours.": "لا توجد حصة في انتظار تسجيل الحضور خلال الأيام الخمسة والأربعين الأخيرة.",
"Aucune séance prévue sur cette période": "لا توجد حصة مقررة في هذه الفترة",
"Aucune séance sur cette période.": "لا توجد حصة في هذه الفترة.",
"Autre filière": "شعبة أخرى",
"Avancement": "التقدم",
"Avancement (%)": "التقدم (%)",
"Avancement des matières": "تقدم المواد",
"Avancement des programmes au": "تقدم البرامج في",
"Avancement par filière": "التقدم حسب الشعبة",
"Avancement par filière et niveau": "التقدم حسب الشعبة والمستوى",
"Brouillon, non publiée": "مسودة، غير منشورة",
"Brouillons existants": "المسودات الموجودة",
"Budget des enseignements": "ميزانية التدريس",
"Bulletin (PDF)": "الكشف (PDF)",
"Bulletins": "كشوف الرواتب",
"Bulletins (FCFA)": "الكشوف (FCFA)",
"Bulletins de la période de paie": "كشوف فترة الرواتب",
"Bulletins disponibles": "الكشوف المتاحة",
"Calculer la paie": "احتساب الرواتب",
"Capacité": "السعة",
"Capacité (places)": "السعة (مقاعد)",
"Ce code de département existe déjà.": "رمز القسم هذا موجود مسبقًا.",
"Ce code de faculté existe déjà.": "رمز الكلية هذا موجود مسبقًا.",
"Ce code de filière existe déjà.": "رمز الشعبة هذا موجود مسبقًا.",
"Ce code de groupe existe déjà.": "رمز الفوج هذا موجود مسبقًا.",
"Ce code de matière existe déjà.": "رمز المادة هذا موجود مسبقًا.",
"Ce code de salle existe déjà dans cette faculté.": "رمز القاعة هذا موجود مسبقًا في هذه الكلية.",
"Ce code de salle existe déjà.": "رمز القاعة هذا موجود مسبقًا.",
"Ce cours a déjà été émargé : il ne peut plus être déplacé ni annulé.": "سُجّل الحضور في هذا الدرس: لم يعد ممكنًا نقله ولا إلغاؤه.",
"Ce département contient encore des filières : supprimez-les ou déplacez-les d'abord.": "ما زال هذا القسم يضم شعبًا: احذفها أو انقلها أولًا.",
"Ce département contient encore des matières.": "ما زال هذا القسم يضم مواد.",
"Ce professeur est": "هذا الأستاذ",
"Ce professeur n'a pas donné ses disponibilités pour cette semaine.": "لم يحدد هذا الأستاذ أوقاته المتاحة لهذا الأسبوع.",
"Ce semestre existe déjà pour cette année dans cette faculté.": "هذا السداسي موجود مسبقًا لهذه السنة في هذه الكلية.",
"Ce semestre existe déjà pour cette année.": "هذا السداسي موجود مسبقًا لهذه السنة.",
"Ce tarif a déjà servi au calcul d'une paie : il ne peut pas être supprimé.": "استُعمل أجر الساعة هذا في احتساب رواتب: لا يمكن حذفه.",
"Ces dates redeviennent des jours de cours.": "تعود هذه التواريخ أيام دروس.",
"Ces séances sont déjà émargées : elles ne seront pas touchées.": "سُجّل الحضور في هذه الحصص: لن تُمسّ.",
"Cette année contient encore des semestres : supprimez-les d'abord.": "ما زالت هذه السنة تضم سداسيات: احذفها أولًا.",
"Cette année universitaire existe déjà.": "هذه السنة الجامعية موجودة مسبقًا.",
"Cette filière contient encore des groupes : supprimez-les d'abord.": "ما زالت هذه الشعبة تضم أفواجًا: احذفها أولًا.",
"Cette semaine est déjà publiée : les créneaux enregistrés sont": "هذا الأسبوع منشور مسبقًا: الحصص المسجلة",
"Changer": "تغيير",
"Changer le poste": "تغيير المنصب",
"Chaque action sensible est enregistrée avec son auteur et l'heure. Le journal ne peut pas être modifié.": "كل عملية حساسة تُسجَّل مع صاحبها ووقتها. لا يمكن تعديل السجل.",
"Chaque département appartient à une faculté. Commencez par les départements : filières, matières et enseignants en dépendent.": "كل قسم تابع لكلية. ابدأ بالأقسام: تتوقف عليها الشعب والمواد والأساتذة.",
"Chaque faculté a ses départements, ses salles, ses semestres, ses horaires et ses jours sans cours. Son nom et son logo figureront avec ceux de l'université sur ses documents.": "لكل كلية أقسامها وقاعاتها وسداسياتها وتوقيتاتها وأيامها بدون دروس. يظهر اسمها وشعارها مع اسم الجامعة وشعارها في وثائقها.",
"Chaque faculté a ses semestres et leurs dates. Elles servent à calculer le nombre de semaines de cours.": "لكل كلية سداسياتها وتواريخها. تُستعمل لحساب عدد أسابيع الدراسة.",
"Chaque groupe a des cours cette semaine": "لكل فوج دروس هذا الأسبوع",
"Chaque matière appartient à un département et à une ou plusieurs filières. Plusieurs filières = matière commune (tronc commun) : elle sera proposée à chacune lors des affectations. Le volume horaire est le total prévu sur le semestre.": "كل مادة تابعة لقسم ولشعبة أو أكثر. عدة شعب = مادة مشتركة (جذع مشترك): تُقترح على كل منها عند الإسناد. الحجم الساعي هو المجموع المقرر في السداسي.",
"Chaque professeur peut télécharger son bulletin dans « Heures et paiements ». Vous pouvez le lui annoncer.": "يمكن لكل أستاذ تحميل كشفه من «الساعات والمدفوعات». يمكنك إعلامه بذلك.",
"Chaque professeur reçoit la liste de ses cours annulés et le motif.": "يتلقى كل أستاذ قائمة دروسه الملغاة والسبب.",
"Chaque professeur reçoit la liste de ses séances à émarger.": "يتلقى كل أستاذ قائمة حصصه في انتظار تسجيل الحضور.",
"Chaque professeur reçoit son adresse et son mot de passe provisoire. Il choisira le sien à la première connexion.": "يتلقى كل أستاذ عنوانه وكلمة مروره المؤقتة. وسيختار كلمته عند أول دخول.",
"Chaque professeur voit le paiement dans son espace. Vous pouvez aussi le lui confirmer.": "يرى كل أستاذ الدفعة في فضائه. يمكنك أيضًا تأكيدها له.",
"Chaque salle appartient à une faculté. La capacité est comparée à l'effectif des groupes lors du placement des créneaux.": "كل قاعة تابعة لكلية. تُقارن السعة بعدد طلبة الأفواج عند برمجة الحصص.",
"Chaque séance validée a un tarif.": "لكل حصة معتمدة أجر ساعة.",
"Charge des professeurs": "عبء الأساتذة",
"Chef de département (son département : consultation et validation)": "رئيس القسم (قسمه: اطلاع واعتماد)",
"Choisir le poste…": "اختر المنصب…",
"Choisir un logo": "اختيار شعار",
"Choisir…": "اختر…",
"Choisissez au moins un jour.": "اختر يومًا واحدًا على الأقل.",
"Choisissez d'abord, dans la grille, le même type d'affichage (groupe, professeur ou salle).": "اختر أولًا، في الشبكة، نوع العرض نفسه (فوج أو أستاذ أو قاعة).",
"Choisissez le poste de la personne.": "اختر منصب الشخص.",
"Choisissez un groupe : ses matières s'affichent avec leur volume prévu. Indiquez le professeur de chaque matière puis enregistrez. La charge de chaque professeur se met à jour pendant la saisie.": "اختر فوجًا: تظهر مواده مع حجمها الساعي المقرر. حدّد أستاذ كل مادة ثم احفظ. يُحدَّث عبء كل أستاذ أثناء الإدخال.",
"Cochez au moins un bulletin.": "حدّد كشفًا واحدًا على الأقل.",
"Cochez au moins un droit.": "حدّد صلاحية واحدة على الأقل.",
"Code": "الرمز",
"Commentaire": "تعليق",
"Commentaire (facultatif)": "تعليق (اختياري)",
"Compléter": "إكمال",
"Compris": "فهمت",
"Compte": "الحساب",
"Compte créé": "تم إنشاء الحساب",
"Compte créé, mais le poste n'a pas pu être enregistré :": "تم إنشاء الحساب، لكن تعذّر حفظ المنصب:",
"Compte désactivé": "تم تعطيل الحساب",
"Compte réactivé": "تمت إعادة تفعيل الحساب",
"Comptes de démonstration (mot de passe : Demo-2026!)": "حسابات تجريبية (كلمة المرور: Demo-2026!)",
"Comptes et rôles": "الحسابات والأدوار",
"Conflits": "التعارضات",
"Consultation sans modification": "اطلاع دون تعديل",
"Contrôle des émargements": "التحقق من تسجيل الحضور",
"Contrôler": "تحقق",
"Contrôler l'émargement": "التحقق من تسجيل الحضور",
"Copie impossible : sélectionnez le texte": "تعذّر النسخ: حدّد النص",
"Copier le message commun": "نسخ الرسالة المشتركة",
"Copié": "تم النسخ",
"Correction demandée au professeur": "طُلب التصحيح من الأستاذ",
"Correction en cours": "التصحيح جارٍ",
"Cours ajouté": "تمت إضافة الدرس",
"Cours annulé": "تم إلغاء الدرس",
"Cours magistral (CM)": "محاضرة (CM)",
"Cours modifié": "تم تعديل الدرس",
"Cours reporté": "تم تأجيل الدرس",
"Cours rétabli": "تمت استعادة الدرس",
"Cours supprimé": "تم حذف الدرس",
"Cours ·": "الدرس ·",
"Coût": "الكلفة",
"Coût (FCFA)": "الكلفة (FCFA)",
"Créer l'année": "إنشاء السنة",
"Créer la période": "إنشاء الفترة",
"Créer le compte": "إنشاء الحساب",
"Créer les comptes": "إنشاء الحسابات",
"Créer un compte": "إنشاء حساب",
"Créer un compte professeur": "إنشاء حساب أستاذ",
"Créez d'abord un département (onglet Structure).": "أنشئ أولًا قسمًا (تبويب الهيكلة).",
"Créez d'abord un groupe d'étudiants (Référentiel > Structure).": "أنشئ أولًا فوجًا من الطلبة (البيانات المرجعية > الهيكلة).",
"Créez d'abord un semestre (Référentiel > Années et semestres).": "أنشئ أولًا سداسيًا (البيانات المرجعية > السنوات والسداسيات).",
"Créez d'abord une année universitaire (onglet Années et semestres).": "أنشئ أولًا سنة جامعية (تبويب السنوات والسداسيات).",
"Créez d'abord une filière (onglet Structure).": "أنشئ أولًا شعبة (تبويب الهيكلة).",
"Créneaux d'une journée": "حصص اليوم الواحد",
"Créneaux de cours cette semaine : touchez un créneau, un jour ou une heure pour le marquer": "حصص الدروس هذا الأسبوع: المس حصة أو يومًا أو ساعة لتحديدها",
"Créneaux proposés": "الحصص المقترحة",
"Créé le": "أُنشئ في",
"Date d'effet": "تاريخ السريان",
"Date de paiement": "تاريخ الدفع",
"Dates": "التواريخ",
"Demande d'absence": "طلب غياب",
"Demander une correction": "طلب تصحيح",
"Demandes d'absence": "طلبات الغياب",
"Demandé :": "المطلوب:",
"Depuis le": "منذ",
"Dernière connexion": "آخر دخول",
"Dernière sauvegarde depuis cet appareil :": "آخر نسخة احتياطية من هذا الجهاز:",
"Dernière sauvegarde des données il y a plus d'un mois.": "آخر نسخة احتياطية للبيانات منذ أكثر من شهر.",
"Des constats, pas des notes : ce qui s'est passé sur la période, par département et par enseignant. Un chiffre élevé appelle une question, pas une conclusion.": "معاينات لا تقييمات: ما جرى خلال الفترة، حسب القسم وحسب الأستاذ. الرقم المرتفع يستدعي سؤالًا لا حكمًا.",
"Directeur des études (enseigne aussi)": "مدير الدراسات (يدرّس أيضًا)",
"Direction": "الإدارة",
"Direction (doyen ou rectorat)": "الإدارة (العميد أو رئاسة الجامعة)",
"Direction : doyen (visa de la paie) ou rectorat (consultation)": "الإدارة: العميد (التأشير على الرواتب) أو رئاسة الجامعة (اطلاع)",
"Direction générale": "الإدارة العامة",
"Disponibilités de": "الأوقات المتاحة لـ",
"Disponibilités · semaine du": "الأوقات المتاحة · أسبوع",
"Domaine": "المجال",
"Donnez un nom au poste.": "أعطِ المنصب اسمًا.",
"Droits": "الصلاحيات",
"Droits :": "الصلاحيات:",
"Droits donnés par ce poste": "الصلاحيات التي يمنحها هذا المنصب",
"Droits optionnels": "صلاحيات اختيارية",
"Droits optionnels enregistrés": "تم حفظ الصلاحيات الاختيارية",
"Du": "من",
"Durée": "المدة",
"Durée d'un créneau": "مدة الحصة",
"Durée et horaire identiques au prévu, sans commentaire, émargés par le professeur, sans signalement.": "مدة وتوقيت مطابقان للمقرر، دون تعليق، سجّلها الأستاذ، دون ملاحظة.",
"Durée retenue (minutes)": "المدة المعتمدة (بالدقائق)",
"Durée réduite": "مدة مخفّضة",
"Début": "البداية",
"Début de journée": "بداية اليوم",
"Déclaré": "المصرَّح",
"Délégation": "النيابة",
"Département": "القسم",
"Départements": "الأقسام",
"Désactiver": "تعطيل",
"Désactiver ces droits ?": "تعطيل هذه الصلاحيات؟",
"Désactiver quand même": "تعطيل رغم ذلك",
"Désactivé": "معطَّل",
"Désactivés": "المعطَّلون",
"Détail": "التفاصيل",
"Détail des séances": "تفاصيل الحصص",
"E-mail": "البريد الإلكتروني",
"E-mail (sert à lier son compte)": "البريد الإلكتروني (يُستعمل لربط حسابه)",
"Effacer": "مسح",
"Effectif": "عدد الطلبة",
"Elle n'a aucun département. Ses horaires et ses jours sans cours sont supprimés avec elle.": "لا تضم أي قسم. تُحذف توقيتاتها وأيامها بدون دروس معها.",
"Emploi du temps": "الجدول الدراسي",
"Emploi du temps fixe pour le semestre.": "جدول ثابت للسداسي.",
"En attente de la réponse du professeur.": "في انتظار رد الأستاذ.",
"En attente du professeur": "في انتظار الأستاذ",
"En attente du visa du doyen": "في انتظار تأشيرة العميد",
"En cours": "جارٍ",
"En cours (FCFA)": "جارٍ (FCFA)",
"En double": "مكرر",
"En enregistrant, les": "عند الحفظ، فإن",
"En faire tout de suite l'année en cours (sinon, plus tard avec « Mettre en cours »)": "جعلها السنة الجارية فورًا (وإلا فلاحقًا عبر «جعلها جارية»)",
"En retard sur le rythme": "متأخرة عن الوتيرة",
"Engagé (bulletins approuvés)": "الملتزم به (كشوف مصادق عليها)",
"Enregistre les paiements et prépare l'ordre de paiement, sans calculer ni approuver la paie ni toucher aux tarifs.": "يسجّل المدفوعات ويُعدّ أمر الدفع، دون احتساب الرواتب أو المصادقة عليها أو المساس بأجور الساعات.",
"Enregistrement refusé.": "رُفض الحفظ.",
"Enregistrer et publier": "حفظ ونشر",
"Enregistrer l'identité": "حفظ الهوية",
"Enregistrer la fiche liée": "حفظ البطاقة المرتبطة",
"Enregistrer les droits optionnels": "حفظ الصلاحيات الاختيارية",
"Enregistrer les paiements": "حفظ المدفوعات",
"Enregistrer un paiement": "تسجيل دفعة",
"Enregistré": "محفوظ",
"Enseignant": "الأستاذ",
"Enseignant actif": "أستاذ نشِط",
"Enseignant sans compte (facultatif)": "أستاذ دون حساب (اختياري)",
"Enseignants": "الأساتذة",
"Enseigne": "يدرّس",
"Enseigne aussi (a des cours, des disponibilités et des émargements)": "يدرّس أيضًا (له دروس وأوقات متاحة وتسجيلات حضور)",
"Enseigner (cours, disponibilités, émargement)": "التدريس (دروس، أوقات متاحة، تسجيل حضور)",
"Entièrement réglé": "مُسدَّد بالكامل",
"Envoyer le nouveau mot de passe": "إرسال كلمة المرور الجديدة",
"Envoyer les identifiants": "إرسال بيانات الدخول",
"Envoyer par WhatsApp / SMS": "إرسال عبر واتساب / رسالة نصية",
"Estimation": "التقدير",
"Estimation du reste à venir": "تقدير المتبقي القادم",
"Estimation restante": "التقدير المتبقي",
"Estimation restante (FCFA)": "التقدير المتبقي (FCFA)",
"Ex. : Novembre 2026": "مثال: نوفمبر 2026",
"Ex. : décision du conseil du 12/10/2026": "مثال: قرار المجلس بتاريخ 12/10/2026",
"Ex. Direction des études": "مثال: إدارة الدراسات",
"Ex. Décanat · Direction des études": "مثال: العمادة · إدارة الدراسات",
"Ex. FSRC, FLSH": "مثال: FSRC، FLSH",
"Ex. Faculté des lettres et sciences humaines": "مثال: كلية الآداب والعلوم الإنسانية",
"Ex. Grand Magal, Tabaski, vacances de fin de semestre…": "مثال: المَغال الكبير، عيد الأضحى، عطلة نهاية السداسي…",
"Ex. Merci de donner vos disponibilités de la semaine prochaine avant jeudi 18 h.": "مثال: يُرجى تحديد أوقاتكم المتاحة للأسبوع القادم قبل الخميس الساعة 18.",
"Ex. Trésorier, Scolarité, Adjoint du directeur": "مثال: أمين المال، الشؤون الدراسية، نائب المدير",
"Ex. adresse, téléphone": "مثال: العنوان، الهاتف",
"Examens": "الامتحانات",
"Exporter en Excel": "تصدير إلى Excel",
"Exporter en PDF": "تصدير إلى PDF",
"FCFA": "FCFA",
"Faculté": "الكلية",
"Faculté créée": "تم إنشاء الكلية",
"Faculté enregistrée": "تم حفظ الكلية",
"Faculté supprimée": "تم حذف الكلية",
"Facultés": "الكليات",
"Failed to send a request to the Edge Function": "تعذّر الاتصال بالخدمة. أعد المحاولة بعد قليل.",
"Faire une remarque": "إبداء ملاحظة",
"Faites / prévues": "المنجزة / المقررة",
"Fiche enseignant": "بطاقة الأستاذ",
"Fiche enseignant déliée": "تم فك ربط بطاقة الأستاذ",
"Fiche enseignant liée": "تم ربط بطاقة الأستاذ",
"Filière": "الشعبة",
"Filières": "الشعب",
"Filières qui suivent cette matière": "الشعب التي تدرس هذه المادة",
"Fin": "النهاية",
"Fin de journée": "نهاية اليوم",
"Finance et paie": "المالية والرواتب",
"Fixe : le même chaque semaine du semestre, disponibilités une fois par semestre": "ثابت: نفسه كل أسبوع من السداسي، والأوقات المتاحة مرة في السداسي",
"Groupe ajouté au cours commun": "تمت إضافة الفوج إلى الدرس المشترك",
"Groupes": "الأفواج",
"Groupes d'étudiants": "أفواج الطلبة",
"Groupes réunis enregistrés": "تم حفظ الأفواج المجمَّعة",
"Groupes réunis…": "تجميع الأفواج…",
"Générer l'emploi du temps": "إنشاء الجدول",
"Gérer les affectations →": "تسيير الإسنادات ←",
"Hebdomadaire : refait chaque semaine, disponibilités chaque semaine": "أسبوعي: يُعاد كل أسبوع، والأوقات المتاحة كل أسبوع",
"Heure": "الساعة",
"Heures de cours max par jour pour un groupe": "الحد الأقصى لساعات الدرس يوميًا للفوج",
"Heures de cours max par jour pour un professeur": "الحد الأقصى لساعات الدرس يوميًا للأستاذ",
"Heures en attente": "ساعات في الانتظار",
"Heures en attente de validation": "ساعات في انتظار الاعتماد",
"Heures faites": "الساعات المنجزة",
"Heures prévues": "الساعات المقررة",
"Heures retenues": "الساعات المحتسبة",
"Heures validées et prévues": "الساعات المعتمدة والمقررة",
"Heures validées pas encore payées": "ساعات معتمدة لم تُدفع بعد",
"Historique": "السجل",
"Horaires": "التوقيتات",
"Hors disponibilités": "خارج الأوقات المتاحة",
"Hors disponibilités du professeur": "خارج الأوقات المتاحة للأستاذ",
"Identifiants de connexion": "بيانات الدخول",
"Identité": "الهوية",
"Identité enregistrée": "تم حفظ الهوية",
"Il devra être changé à la prochaine connexion.": "يجب تغييرها عند الدخول القادم.",
"Il disparaît de l'emploi du temps du professeur sans explication. Pour un empêchement, préférez « Annuler » : le professeur voit le motif.": "يختفي من جدول الأستاذ دون تفسير. في حال وجود مانع، يُفضَّل «إلغاء»: فيرى الأستاذ السبب.",
"Il reste des points à régler avant le calcul de la paie.": "ما زالت هناك نقاط يجب تسويتها قبل احتساب الرواتب.",
"Il voit la réponse dans l'application. Vous pouvez aussi la lui envoyer.": "يرى الرد في التطبيق. يمكنك أيضًا إرساله إليه.",
"Image illisible.": "صورة غير مقروءة.",
"Image trop lourde (5 Mo maximum).": "الصورة ثقيلة جدًا (5 ميغابايت كحد أقصى).",
"Impossible de rétablir : l'horaire a été repris par un autre cours.": "تعذّرت الاستعادة: أُخذ التوقيت من طرف درس آخر.",
"Imprimer / exporter la semaine": "طباعة / تصدير الأسبوع",
"Inclure le personnel qui enseigne": "تضمين الموظفين الذين يدرّسون",
"Indicateur": "المؤشر",
"Indicateurs du mois": "مؤشرات الشهر",
"Indicateurs par faculté": "المؤشرات حسب الكلية",
"Indiquez la source de la saisie.": "اذكر مصدر الإدخال.",
"Indiqué indisponible": "مُشار إليه غير متاح",
"Individuel": "فردي",
"Intitulé": "العنوان",
"Invalid login": "البريد الإلكتروني أو كلمة المرور غير صحيحة.",
"Jamais connectés": "لم يدخلوا قط",
"Jour férié": "عطلة رسمية",
"Journal des opérations": "سجل العمليات",
"Jours de présence max par professeur": "الحد الأقصى لأيام الحضور لكل أستاذ",
"Jours et horaires": "الأيام والتوقيتات",
"Jours et horaires enregistrés": "تم حفظ الأيام والتوقيتات",
"Jours fériés, vacances, examens, Magal, Gamou… Le générateur ne place aucun cours ces jours-là, on ne peut pas y déplacer un cours, et le rythme des matières est calculé sans eux.": "العطل الرسمية، العطل، الامتحانات، المَغال، المولد… لا يبرمج المولّد أي درس في هذه الأيام، ولا يمكن نقل درس إليها، وتُحسب وتيرة المواد دونها.",
"Jours sans cours de l'université": "أيام بدون دروس في الجامعة",
"Jusqu'au (facultatif)": "حتى (اختياري)",
"L'année en cours est celle affichée en haut de l'écran et utilisée par défaut. Les années passées restent consultables : rien n'est effacé.": "السنة الجارية هي المعروضة في أعلى الشاشة والمستعملة افتراضيًا. تبقى السنوات الماضية متاحة للاطلاع: لا يُمحى شيء.",
"L'effectif ne peut pas être négatif.": "لا يمكن أن يكون عدد الطلبة سالبًا.",
"L'emploi du temps de cette semaine n'est pas publié.": "جدول هذا الأسبوع غير منشور.",
"L'emploi du temps de la semaine prochaine n'est pas encore publié.": "جدول الأسبوع القادم لم يُنشر بعد.",
"L'identité affichée dans l'application et sur les documents, l'année universitaire et la sauvegarde des données.": "الهوية المعروضة في التطبيق وفي الوثائق، والسنة الجامعية، والنسخ الاحتياطي للبيانات.",
"L'émargement est enregistré à votre nom, marqué « saisi par délégation », et devra être validé par un autre responsable.": "يُسجَّل تسجيل الحضور باسمك، ويوسم «سُجِّل بالنيابة»، ويجب أن يعتمده مسؤول آخر.",
"L'état des comptes en un coup d'œil. Touchez un chiffre ou un nom pour l'ouvrir dans Comptes.": "حالة الحسابات في لمحة. المس رقمًا أو اسمًا لفتحه في الحسابات.",
"La base n'est pas à jour : le script « retirer_publication.sql » doit être exécuté dans Supabase.": "قاعدة البيانات غير محدَّثة: يجب تنفيذ السكربت «retirer_publication.sql» في Supabase.",
"La base n'est pas à jour : le script « semaines_dispos.sql » doit être exécuté dans Supabase.": "قاعدة البيانات غير محدَّثة: يجب تنفيذ السكربت «semaines_dispos.sql» في Supabase.",
"La capacité doit être d'au moins 1 place.": "يجب أن تكون السعة مقعدًا واحدًا على الأقل.",
"La date de fin doit être après la date de début.": "يجب أن يكون تاريخ النهاية بعد تاريخ البداية.",
"La date de fin doit être postérieure à la date de début.": "يجب أن يكون تاريخ النهاية لاحقًا لتاريخ البداية.",
"La fin de journée doit être après le début.": "يجب أن تكون نهاية اليوم بعد بدايته.",
"La journée est plus courte qu'un créneau.": "اليوم أقصر من حصة واحدة.",
"La liste des montants restant dus, avec le mode et le numéro de chaque enseignant, à remettre à la banque ou à utiliser pour les envois Wave / Orange Money. Complétez ici les modes et numéros manquants : ils sont enregistrés sur la fiche de l'enseignant.": "قائمة المبالغ المتبقية المستحقة، مع طريقة الدفع ورقم كل أستاذ، لتسليمها إلى البنك أو لاستعمالها في تحويلات Wave / Orange Money. أكمل هنا الطرق والأرقام الناقصة: تُحفظ في بطاقة الأستاذ.",
"La nouvelle faculté reçoit des jours et horaires par défaut, à régler ensuite dans Référentiel › Jours et horaires.": "تتلقى الكلية الجديدة أيامًا وتوقيتات افتراضية، تُضبط لاحقًا في البيانات المرجعية › الأيام والتوقيتات.",
"La personne ne pourra plus se connecter. Ses données et son historique sont conservés.": "لن يتمكن الشخص من الدخول بعد الآن. تُحفظ بياناته وسجله.",
"La personne pourra de nouveau se connecter.": "سيتمكن الشخص من الدخول مجددًا.",
"La période n'a pas encore été approuvée. Aucune donnée d'émargement ne sera perdue.": "لم يُصادق على الفترة بعد. لن تضيع أي بيانات تسجيل حضور.",
"La période peut durer un mois, une quinzaine, un semestre ou toute autre durée.": "يمكن أن تمتد الفترة شهرًا أو نصف شهر أو سداسيًا أو أي مدة أخرى.",
"La semaine n'est plus visible dans leur emploi du temps. Vous pouvez les en informer.": "لم يعد الأسبوع ظاهرًا في جدولهم. يمكنك إبلاغهم بذلك.",
"La semaine précédente est vide.": "الأسبوع السابق فارغ.",
"La suppression est définitive. Si cet élément est déjà utilisé (séances, affectations, bulletins), elle sera refusée.": "الحذف نهائي. إذا كان هذا العنصر مستعملًا (حصص، إسنادات، كشوف)، فسيُرفض.",
"La séance apparaît annulée dans son emploi du temps. Vous pouvez aussi le lui confirmer.": "تظهر الحصة ملغاة في جدوله. يمكنك أيضًا تأكيد ذلك له.",
"Laboratoire": "مختبر",
"Lancez le calcul pour obtenir les montants de la période.": "شغّل الاحتساب للحصول على مبالغ الفترة.",
"Le changement est déjà visible dans son emploi du temps. Vous pouvez aussi le lui envoyer.": "التغيير ظاهر مسبقًا في جدوله. يمكنك أيضًا إرساله إليه.",
"Le contrôle des émargements n'est pas terminé": "لم ينته التحقق من تسجيل الحضور",
"Le générateur place, dans cette semaine, les heures qui restent à faire pour chaque matière, avec les professeurs disponibles. Un professeur sans réponse n'est pas placé (vous pouvez saisir ses disponibilités depuis l'emploi du temps). Il respecte les conflits et les salles. Vous voyez le résultat avant de l'enregistrer.": "يبرمج المولّد، في هذا الأسبوع، الساعات المتبقية لكل مادة مع الأساتذة المتاحين. لا يُبرمج الأستاذ الذي لم يرد (يمكنك إدخال أوقاته المتاحة من الجدول). يراعي التعارضات والقاعات. ترى النتيجة قبل حفظها.",
"Le module Excel n'a pas pu être chargé. Vérifiez la connexion et rechargez la page.": "تعذّر تحميل وحدة Excel. تحقق من الاتصال وأعد تحميل الصفحة.",
"Le module PDF n'a pas pu être chargé. Vérifiez la connexion et rechargez la page.": "تعذّر تحميل وحدة PDF. تحقق من الاتصال وأعد تحميل الصفحة.",
"Le nom, le logo, l'en-tête des documents, le mode d'emploi du temps et la règle du visa de la paie de votre faculté. Les comptes de la faculté se gèrent dans « Comptes ».": "اسم كليتك وشعارها وترويسة وثائقها ونمط جدولها وقاعدة التأشير على رواتبها. تُدار حسابات الكلية في «الحسابات».",
"Le paiement est enregistré par le service financier. Il n'exécute aucun virement.": "تُسجّل المصلحة المالية الدفعة. ولا تنفذ أي تحويل.",
"Le paiement est visible dans son espace « Heures et paiements ». Vous pouvez aussi le lui confirmer.": "الدفعة ظاهرة في فضائه «الساعات والمدفوعات». يمكنك أيضًا تأكيدها له.",
"Le service financier voit votre remarque sur la période. La paie reste en attente de votre visa.": "ترى المصلحة المالية ملاحظتك على الفترة. تبقى الرواتب في انتظار تأشيرتك.",
"Le statut détermine le tarif horaire. L'e-mail sert à relier le compte de l'enseignant.": "تحدد الصفة أجر الساعة. يُستعمل البريد الإلكتروني لربط حساب الأستاذ.",
"Les comptes de connexion, le poste de chacun et le lien avec les fiches enseignants.": "حسابات الدخول، ومنصب كل شخص، والربط ببطاقات الأساتذة.",
"Les créneaux en vert sont libres dans cette salle. Pour placer un cours, utilisez « Ajouter un cours » ou le glisser-déposer dans la grille.": "الحصص الخضراء شاغرة في هذه القاعة. لبرمجة درس، استعمل «إضافة درس» أو السحب والإفلات في الشبكة.",
"Les créneaux sont enregistrés en": "تُحفظ الحصص في",
"Les dates du semestre doivent rester dans l'année": "يجب أن تبقى تواريخ السداسي ضمن السنة",
"Les données de l'université. Chaque changement est enregistré dans le journal. Les affectations et les créneaux se saisissent dans « Emplois du temps ».": "بيانات الجامعة. يُسجَّل كل تغيير في سجل العمليات. تُدخل الإسنادات والحصص في «الجداول الدراسية».",
"Les fêtes nationales et religieuses communes à toutes les facultés. Chaque faculté ajoute ses propres jours (examens, vacances) dans son Référentiel.": "الأعياد الوطنية والدينية المشتركة بين كل الكليات. تضيف كل كلية أيامها الخاصة (امتحانات، عطل) في بياناتها المرجعية.",
"Les groupes cochés suivent ce cours": "الأفواج المحددة تتابع هذا الدرس",
"Les jours fériés, vacances, examens et événements se déclarent dans « Jours sans cours ». Pour un créneau ponctuel, utilisez « Générer la semaine ».": "تُصرَّح العطل الرسمية والعطل والامتحانات والمناسبات في «أيام بدون دروس». لحصة ظرفية، استعمل «إنشاء الأسبوع».",
"Les montants de paie ne sont pas inclus : l'administrateur n'y a pas accès. Le responsable financier les exporte depuis la Paie.": "مبالغ الرواتب غير مضمّنة: لا يطّلع عليها مهندس النظام. يصدّرها المسؤول المالي من الرواتب.",
"Les paiements pourront être enregistrés après le visa.": "يمكن تسجيل المدفوعات بعد التأشير.",
"Les postes et leurs noms se règlent dans Établissement › Postes.": "تُضبط المناصب وأسماؤها في المؤسسة › المناصب.",
"Les postes sont définis par l'administrateur central.": "المناصب يحددها المهندس العام.",
"Les professeurs": "الأساتذة",
"Les séances déjà payées ne sont jamais recalculées.": "لا يُعاد أبدًا احتساب الحصص المدفوعة.",
"Lesquels": "أيّها",
"Libellé": "العنوان",
"Libellé (ex. 2027-2028)": "العنوان (مثال: 2027-2028)",
"Libellé (ex. Semestre 1)": "العنوان (مثال: السداسي 1)",
"Ligne d'en-tête de ses PDF (facultatif)": "سطر ترويسة ملفات PDF الخاصة بها (اختياري)",
"Ligne d'en-tête des PDF": "سطر ترويسة ملفات PDF",
"Lignes de paie": "أسطر الرواتب",
"Limite d'émargement": "آخر أجل لتسجيل الحضور",
"Lié": "مرتبط",
"Logo": "الشعار",
"Logo de la faculté": "شعار الكلية",
"Manque estimé en fin de semestre": "النقص المتوقع في نهاية السداسي",
"Marqué disponible toute la semaine": "مُشار إليه متاح طوال الأسبوع",
"Masquer": "إخفاء",
"Masquer l'annonce": "إخفاء الإعلان",
"Matin": "الصباح",
"Matières": "المواد",
"Matières ce semestre": "مواد هذا السداسي",
"Matières en retard": "المواد المتأخرة",
"Matières en retard sur le rythme du semestre (heures restantes ÷ semaines restantes) : à placer à la main ou après avoir ajusté les réglages": "المواد المتأخرة عن وتيرة السداسي (الساعات المتبقية ÷ الأسابيع المتبقية): تُبرمج يدويًا أو بعد ضبط الإعدادات",
"Matières qui risquent de ne pas atteindre leur volume avant la fin du semestre": "مواد قد لا تبلغ حجمها الساعي قبل نهاية السداسي",
"Matières terminées": "المواد المنتهية",
"Matières-filières": "المواد والشعب",
"Message": "الرسالة",
"Message commun": "رسالة مشتركة",
"Mettre en cours": "جعلها جارية",
"Mise en place": "الإعداد",
"Mode": "الطريقة",
"Mode de paiement habituel": "طريقة الدفع المعتادة",
"Modification refusée.": "رُفض التعديل.",
"Modifier la faculté": "تعديل الكلية",
"Modifier le cours": "تعديل الدرس",
"Modifier le poste": "تعديل المنصب",
"Modifiée": "معدَّلة",
"Mois": "الشهر",
"Mois en cours": "الشهر الجاري",
"Moment": "الوقت",
"Montant": "المبلغ",
"Montant (FCFA)": "المبلغ (FCFA)",
"Montant = durée retenue × tarif horaire en vigueur à la date de la séance. * tarif individuel.": "المبلغ = المدة المحتسبة × أجر الساعة الساري في تاريخ الحصة. * أجر فردي.",
"Mot de passe provisoire": "كلمة مرور مؤقتة",
"Motif (obligatoire pour un rejet, une correction ou une durée retenue supérieure au prévu)": "السبب (إلزامي للرفض أو التصحيح أو لمدة محتسبة تزيد على المقرر)",
"Motif (visible par le professeur)": "السبب (يراه الأستاذ)",
"Motif du report (visible par le professeur)": "سبب التأجيل (يراه الأستاذ)",
"Motifs d'annulation": "أسباب الإلغاء",
"Net à payer (FCFA)": "الصافي المستحق (FCFA)",
"Niveau": "المستوى",
"Niveau (L1, L2, M1…)": "المستوى (L1، L2، M1…)",
"Nom": "الاسم",
"Nom complet": "الاسم الكامل",
"Nom court (facultatif)": "الاسم المختصر (اختياري)",
"Nom de l'établissement": "اسم المؤسسة",
"Nom du poste": "اسم المنصب",
"Nom ou adresse…": "الاسم أو العنوان…",
"Non affectée": "غير مُسندة",
"Non défini": "غير محدَّد",
"Non émargées": "غير مسجّلة",
"Non émargés": "غير مسجّلة",
"Note": "ملاحظة",
"Notez ou transmettez ces identifiants maintenant : les mots de passe provisoires ne seront plus affichés.": "دوِّن بيانات الدخول هذه أو أرسلها الآن: لن تُعرض كلمات المرور المؤقتة مجددًا.",
"Nouveau mot de passe": "كلمة مرور جديدة",
"Nouveau poste": "منصب جديد",
"Nouveau tarif": "أجر جديد",
"Nouveau tarif horaire": "أجر ساعة جديد",
"Nouvelle annonce": "إعلان جديد",
"Nouvelle faculté": "كلية جديدة",
"Nouvelle période de rémunération": "فترة رواتب جديدة",
"Numéro / compte": "الرقم / الحساب",
"N° Wave / Orange Money / compte": "رقم Wave / Orange Money / الحساب",
"N° de lot, de virement…": "رقم الدفعة، التحويل…",
"N° de virement, de transaction…": "رقم التحويل، المعاملة…",
"Occupation de chaque salle sur la semaine (cours non annulés) et créneaux encore libres, utiles pour placer un rattrapage.": "إشغال كل قاعة خلال الأسبوع (الدروس غير الملغاة) والحصص الشاغرة، المفيدة لبرمجة حصة استدراكية.",
"Orange Money": "Orange Money",
"Ordre de paiement": "أمر بالدفع",
"Ordre de paiement :": "أمر بالدفع:",
"Ouvrir l'emploi du temps": "فتح الجدول",
"Ouvrir la paie": "فتح الرواتب",
"PAUSE": "استراحة",
"PNG ou JPEG, carré de préférence. Il est réduit automatiquement.": "PNG أو JPEG، ويُفضَّل مربعًا. يُصغَّر تلقائيًا.",
"Paie :": "الرواتب:",
"Paie en cours de calcul": "الرواتب قيد الاحتساب",
"Paie engagée": "الرواتب الملتزم بها",
"Paie engagée (FCFA)": "الرواتب الملتزم بها (FCFA)",
"Paie et tarifs": "الرواتب وأجور الساعة",
"Paie visée": "رواتب مؤشَّر عليها",
"Paie, tarifs et paiements": "الرواتب وأجور الساعة والمدفوعات",
"Paiement enregistré": "تم تسجيل الدفعة",
"Paiements enregistrés dans le mois": "المدفوعات المسجلة في الشهر",
"Paiements seulement (sans calcul ni approbation de la paie)": "المدفوعات فقط (دون احتساب الرواتب أو المصادقة عليها)",
"Par département": "حسب القسم",
"Par enseignant": "حسب الأستاذ",
"Par mois": "حسب الشهر",
"Par statut": "حسب الصفة",
"Par statut d'enseignant": "حسب صفة الأستاذ",
"Part": "الحصة",
"Pas commencée": "لم تبدأ",
"Pas de logo": "لا يوجد شعار",
"Pas de période précédente approuvée pour comparer.": "لا توجد فترة سابقة مصادق عليها للمقارنة.",
"Pas de réponse": "لا رد",
"Pas encore prêt pour la paie": "غير جاهز بعد للرواتب",
"Pause : de": "الاستراحة: من",
"Pause : indiquez une heure de début et de fin (ou laissez les deux vides).": "الاستراحة: حدّد ساعة البداية والنهاية (أو اتركهما فارغتين).",
"Pause : à": "الاستراحة: إلى",
"Payer": "دفع",
"Payer en lot": "دفع جماعي",
"Payé (FCFA)": "المدفوع (FCFA)",
"Pensez à vérifier avec le directeur des études si des cours sont encore programmés pour ce professeur.": "تذكّر أن تتحقق مع مدير الدراسات مما إذا كانت ما زالت هناك دروس مبرمجة لهذا الأستاذ.",
"Perso.": "فردي",
"Personne": "لا أحد",
"Personne n'occupe ce poste.": "لا أحد يشغل هذا المنصب.",
"Personne à ce poste": "الشخص في هذا المنصب",
"Personnel": "الموظفون",
"Personnel administratif": "الموظفون الإداريون",
"Pied de page des PDF": "تذييل ملفات PDF",
"Placé": "مبرمج",
"Points d'attention": "نقاط تستدعي الانتباه",
"Points à régler": "نقاط يجب تسويتها",
"Portée": "النطاق",
"Poste": "المنصب",
"Poste créé": "تم إنشاء المنصب",
"Poste enregistré": "تم حفظ المنصب",
"Poste personnalisé": "منصب مخصص",
"Poste supprimé": "تم حذف المنصب",
"Postes": "المناصب",
"Pour": "لـ",
"Pour le détail d'une faculté, choisissez-la en haut de l'écran puis ouvrez « Synthèse », « Suivi des enseignements » ou « Paie ».": "لتفاصيل كلية، اخترها في أعلى الشاشة ثم افتح «الملخص» أو «متابعة التدريس» أو «الرواتب».",
"Professeur (cours programmés)": "أستاذ (دروس مبرمجة)",
"Professeur sans réponse": "أستاذ دون رد",
"Professeurs": "الأساتذة",
"Professeurs ayant répondu": "الأساتذة الذين ردّوا",
"Programmé": "مبرمج",
"Programmé / prévu": "المبرمج / المقرر",
"Projection": "الإسقاط",
"Proposition": "الاقتراح",
"Provisoire": "مؤقت",
"Prénom": "الاسم الشخصي",
"Préparer la nouvelle année": "إعداد السنة الجديدة",
"Présence par professeur (avec les créneaux déjà enregistrés)": "الحضور حسب الأستاذ (مع الحصص المسجلة)",
"Prévenir les": "إبلاغ",
"Prévenir les professeurs": "إبلاغ الأساتذة",
"Prévenir les professeurs ?": "إبلاغ الأساتذة؟",
"Prévenir les professeurs de leur emploi du temps ?": "إبلاغ الأساتذة بجدولهم؟",
"Prévenir les professeurs payés": "إبلاغ الأساتذة الذين دُفع لهم",
"Prévenir les professeurs payés ?": "إبلاغ الأساتذة الذين دُفع لهم؟",
"Prévues": "المقررة",
"Prêt pour la paie": "جاهز للرواتب",
"Publication retirée : la semaine est de nouveau en brouillon": "تم التراجع عن النشر: عاد الأسبوع مسودة",
"Publier": "نشر",
"Publier l'annonce": "نشر الإعلان",
"Publier la semaine": "نشر الأسبوع",
"Publier pour le semestre": "النشر للسداسي",
"Publier pour tout le semestre": "النشر للسداسي كله",
"Publier pour tout le semestre ?": "النشر للسداسي كله؟",
"Période créée": "تم إنشاء الفترة",
"Période supprimée": "تم حذف الفترة",
"Période sélectionnée": "الفترة المختارة",
"Périodes de paie": "فترات الرواتب",
"Périodes de rémunération": "فترات الرواتب",
"Qui": "من",
"Rappel des séances à émarger.": "تذكير بالحصص في انتظار تسجيل الحضور.",
"Rapport du mois": "تقرير الشهر",
"Rapport mensuel ·": "التقرير الشهري ·",
"Rattrapage": "حصة استدراكية",
"Rattrapage inclus": "مع الاستدراك",
"Recalculer": "إعادة الاحتساب",
"Rechercher dans": "البحث في",
"Rechercher dans les résultats…": "البحث في النتائج…",
"Rechercher un enseignant ou un n° de bulletin…": "البحث عن أستاذ أو رقم كشف…",
"Rechercher un enseignant…": "البحث عن أستاذ…",
"Rechercher un professeur, un cours ou un groupe…": "البحث عن أستاذ أو درس أو فوج…",
"Rechercher une matière, un groupe, un professeur…": "البحث عن مادة أو فوج أو أستاذ…",
"Refaire la semaine": "إعادة إنشاء الأسبوع",
"Refuser": "رفض",
"Regroupements": "التجميعات",
"Regrouper les cours d'un professeur sur peu de jours, enchaînés": "تجميع دروس الأستاذ في أيام قليلة ومتتابعة",
"Regrouper par professeur": "التجميع حسب الأستاذ",
"Rejeter": "رفض",
"Rejetés": "المرفوضة",
"Relancer": "تذكير",
"Relancer le professeur": "تذكير الأستاذ",
"Relancer les professeurs": "تذكير الأساتذة",
"Relevé": "الكشف",
"Remarque": "ملاحظة",
"Remarque enregistrée": "تم حفظ الملاحظة",
"Remplacer par": "الاستبدال بـ",
"Reporter": "تأجيل",
"Reporter le cours": "تأجيل الدرس",
"Reporter…": "تأجيل…",
"Reprendre": "استعادة",
"Reprendre la semaine précédente": "استعادة الأسبوع السابق",
"Reprendre les affectations d'un autre semestre": "استعادة إسنادات سداسي آخر",
"Reprendre un autre semestre": "استعادة سداسي آخر",
"Respecter les disponibilités de la semaine (décocher : tout le monde est considéré disponible)": "مراعاة الأوقات المتاحة للأسبوع (عند إلغاء التحديد: يُعتبر الجميع متاحين)",
"Reste": "المتبقي",
"Reste dû": "المتبقي المستحق",
"Reste dû (FCFA)": "المتبقي المستحق (FCFA)",
"Reste dû sur les paies approuvées": "المتبقي المستحق من الرواتب المصادق عليها",
"Reste dû sur les paies approuvées (FCFA)": "المتبقي المستحق من الرواتب المصادق عليها (FCFA)",
"Reste prévu": "المتبقي المقرر",
"Retirer la publication": "التراجع عن النشر",
"Retirer le logo": "إزالة الشعار",
"Retrait impossible": "السحب غير ممكن",
"Rien pour l'instant.": "لا شيء حاليًا.",
"Rien à changer": "لا شيء للتغيير",
"Rien à enregistrer": "لا شيء للحفظ",
"Rien à régler : chaque compte a un poste, chaque professeur a sa fiche, et il y a au moins deux administrateurs.": "لا شيء للتسوية: لكل حساب منصب، ولكل أستاذ بطاقته، ويوجد مهندسان على الأقل.",
"Rien à signaler.": "لا شيء يُذكر.",
"Rubrique": "البند",
"Rythme nécessaire": "الوتيرة اللازمة",
"Règlements": "التسديدات",
"Règlements enregistrés": "التسديدات المسجلة",
"Réactiver": "إعادة التفعيل",
"Réduits": "المخفّضة",
"Référence": "المرجع",
"Référence commune (facultatif)": "مرجع مشترك (اختياري)",
"Référentiel et affectations": "البيانات المرجعية والإسنادات",
"Référentiel et emplois du temps": "البيانات المرجعية والجداول الدراسية",
"Référentiel, affectations et emplois du temps": "البيانات المرجعية والإسنادات والجداول الدراسية",
"Réglé (FCFA)": "المسدَّد (FCFA)",
"Réinitialiser": "إعادة التعيين",
"Réinitialiser le mot de passe": "إعادة تعيين كلمة المرور",
"Rémunération à l'heure, calculée uniquement sur les heures validées. Une fois la période approuvée, les bulletins sont figés.": "أجر بالساعة، يُحتسب فقط على الساعات المعتمدة. بعد المصادقة على الفترة، تُجمَّد الكشوف.",
"Réponse au professeur (facultatif pour annuler, utile pour refuser)": "الرد على الأستاذ (اختياري للإلغاء، مفيد للرفض)",
"Réponse pour la semaine": "الرد للأسبوع",
"Réponses dispos": "ردود الأوقات المتاحة",
"Résumé": "الملخص",
"Rétablir": "استعادة",
"Rôles": "الأدوار",
"S'applique à": "يُطبَّق على",
"S'il perd son accès, plus personne ne pourra gérer les comptes. Donnez ce poste à une deuxième personne de confiance.": "إذا فقد صلاحية الدخول، فلن يستطيع أحد تسيير الحسابات. أسند هذا المنصب إلى شخص ثانٍ موثوق.",
"Saisi par vous": "أدخلتَه أنت",
"Saisie par le directeur des études (par exemple pour des disponibilités données par téléphone).": "أدخلها مدير الدراسات (مثلًا لأوقات متاحة أُبلغ بها هاتفيًا).",
"Saisir": "إدخال",
"Saisis par délégation": "مُدخلة بالنيابة",
"Salle habituelle": "القاعة المعتادة",
"Salle habituelle (facultatif)": "القاعة المعتادة (اختياري)",
"Salle informatique": "قاعة الإعلام الآلي",
"Salle requise": "القاعة المطلوبة",
"Salle requise (vide = n'importe quelle salle)": "القاعة المطلوبة (فارغ = أي قاعة)",
"Salles": "القاعات",
"Sans compte": "دون حساب",
"Sans cours :": "بدون دروس:",
"Sans département": "دون قسم",
"Sans limite d'émargement": "دون أجل لتسجيل الحضور",
"Sans poste enregistré": "دون منصب مسجل",
"Sans émargement": "دون تسجيل حضور",
"Sauvegarde des données": "النسخ الاحتياطي للبيانات",
"Sauvegarde téléchargée ·": "تم تحميل النسخة الاحتياطية ·",
"Sauvegarder": "حفظ نسخة احتياطية",
"Saytu : « veiller sur », en wolof.": "Saytu: «السهر على» بلغة الولوف.",
"Semaine": "الأسبوع",
"Semaine déjà publiée : le générateur ajoute seulement les heures qui manquent, sans toucher aux cours publiés.": "الأسبوع منشور مسبقًا: يضيف المولّد الساعات الناقصة فقط، دون المساس بالدروس المنشورة.",
"Semaine publiée : toute modification est visible tout de suite par les professeurs. Pour un empêchement, touchez le cours puis « Annuler » ou « Reporter » : le professeur voit le motif.": "الأسبوع منشور: كل تعديل يراه الأساتذة فورًا. في حال وجود مانع، المس الدرس ثم «إلغاء» أو «تأجيل»: يرى الأستاذ السبب.",
"Semaine à préparer": "أسبوع للإعداد",
"Semaines publiées": "الأسابيع المنشورة",
"Semaines suivantes mises à jour": "تم تحديث الأسابيع التالية",
"Semestre": "السداسي",
"Semestre 1": "السداسي 1",
"Semestre 2": "السداسي 2",
"Semestre choisi, tous groupes confondus.": "السداسي المختار، كل الأفواج.",
"Semestre en cours. Heures faites = séances passées non annulées. Une matière commune (tronc commun) compte pour chaque filière concernée. Touchez une filière pour voir ses matières.": "السداسي الجاري. الساعات المنجزة = الحصص الماضية غير الملغاة. المادة المشتركة (جذع مشترك) تُحتسب لكل شعبة معنية. المس شعبة لرؤية موادها.",
"Semestre publié": "السداسي منشور",
"Semestre source": "السداسي المصدر",
"Semestres": "السداسيات",
"Seulement celui affiché dans la grille": "المعروض في الشبكة فقط",
"Seules les fiches libres de": "فقط البطاقات الشاغرة لـ",
"Source de la saisie (ex. fiche de cours n°…)": "مصدر الإدخال (مثال: بطاقة الدرس رقم…)",
"Sous-titre (écran de connexion)": "العنوان الفرعي (شاشة الدخول)",
"Standard": "عادي",
"Statut": "الصفة",
"Statut (détermine le tarif)": "الصفة (تحدد أجر الساعة)",
"Statuts": "الصفات",
"Statuts des enseignants": "صفات الأساتذة",
"Structure": "الهيكلة",
"Suivez l'ordre : chaque étape dépend de la précédente.": "اتبع الترتيب: كل خطوة تتوقف على سابقتها.",
"Suivi des enseignements par département": "متابعة التدريس حسب القسم",
"Suppression refusée : la faculté a encore des salles, des semestres ou des données.": "رُفض الحذف: ما زالت للكلية قاعات أو سداسيات أو بيانات.",
"Suppression refusée.": "رُفض الحذف.",
"Supprimer ce cours ?": "حذف هذا الدرس؟",
"Supprimé": "محذوف",
"Système": "النظام",
"Séances": "الحصص",
"Séances annulées": "الحصص الملغاة",
"Séances payables": "الحصص القابلة للدفع",
"Séances prévues": "الحصص المقررة",
"Séances sans émargement": "حصص دون تسجيل حضور",
"Séances terminées": "الحصص المنتهية",
"Séances terminées (à émarger)": "الحصص المنتهية (في انتظار تسجيل الحضور)",
"Séances émargées": "الحصص المسجّل حضورها",
"Tardifs": "المتأخرة",
"Tarif": "أجر الساعة",
"Tarif (FCFA/h)": "أجر الساعة (FCFA/س)",
"Tarif enregistré": "تم حفظ أجر الساعة",
"Tarif horaire": "أجر الساعة",
"Tarif horaire (FCFA)": "أجر الساعة (FCFA)",
"Tarif supprimé": "تم حذف أجر الساعة",
"Tarif(s)": "أجور الساعة",
"Tarifs de la": "أجور الساعة لـ",
"Tarifs horaires": "أجور الساعة",
"Taux d'émargement": "نسبة تسجيل الحضور",
"Taux d'émargement (%)": "نسبة تسجيل الحضور (%)",
"Terminé": "منتهٍ",
"Terminées": "المنتهية",
"Total": "المجموع",
"Total (FCFA)": "المجموع (FCFA)",
"Total :": "المجموع:",
"Total de l'année, estimation comprise": "مجموع السنة، مع التقدير",
"Total estimé de l'année": "المجموع التقديري للسنة",
"Total par enseignant (FCFA)": "المجموع حسب الأستاذ (FCFA)",
"Total à payer (brut = net)": "المجموع المستحق (الإجمالي = الصافي)",
"Touchez le cours, puis « Reporter ».": "المس الدرس، ثم «تأجيل».",
"Touchez un cours pour le modifier, l'annuler ou le reporter. Cours barrés : annulés.": "المس درسًا لتعديله أو إلغائه أو تأجيله. الدروس المشطوبة: ملغاة.",
"Touchez un créneau pour le modifier, ou faites-le glisser pour le déplacer (sur tablette : appui long puis glisser).": "المس حصة لتعديلها، أو اسحبها لنقلها (على اللوحة: ضغط مطوّل ثم سحب).",
"Touchez une ou plusieurs filières. Plusieurs filières = matière commune.": "المس شعبة أو أكثر. عدة شعب = مادة مشتركة.",
"Tous les cours respectent les disponibilités": "كل الدروس تراعي الأوقات المتاحة",
"Tous les créneaux sont marqués sans cours : il n'y a rien à générer.": "كل الحصص محددة بدون دروس: لا شيء لإنشائه.",
"Tous les créneaux sont ouverts.": "كل الحصص مفتوحة.",
"Tous les départements": "كل الأقسام",
"Tous les postes": "كل المناصب",
"Tous les professeurs placés ont donné leurs disponibilités": "كل الأساتذة المبرمجين حدّدوا أوقاتهم المتاحة",
"Tous les émargements du mois sont contrôlés. Le responsable financier peut calculer la paie.": "تم التحقق من كل تسجيلات حضور الشهر. يمكن للمسؤول المالي احتساب الرواتب.",
"Tout cocher": "تحديد الكل",
"Tout est renseigné.": "كل شيء مُعبّأ.",
"Tout le monde": "الجميع",
"Toute l'université": "الجامعة كلها",
"Toute la journée": "اليوم كله",
"Toutes les matières": "كل المواد",
"Toutes les matières ont atteint leur volume prévu.": "بلغت كل المواد حجمها الساعي المقرر.",
"Toutes les matières ont déjà leurs heures de la semaine ou sont terminées.": "كل المواد لها ساعات الأسبوع مسبقًا أو منتهية.",
"Traiter": "معالجة",
"Transmettez-le à la personne. Il ne sera plus affiché. Elle pourra le changer depuis « Mon mot de passe ».": "سلّمها للشخص. لن تُعرض مجددًا. يمكنه تغييرها من «كلمة المرور».",
"Travaux dirigés (TD)": "أعمال موجهة (TD)",
"Travaux pratiques (TP)": "أعمال تطبيقية (TP)",
"Type": "النوع",
"Téléphone": "الهاتف",
"Un PDF de quelques pages : indicateurs, points d'attention, avancement par filière, matières en retard, suivi des enseignements et paie. À imprimer ou à partager en conseil de direction.": "ملف PDF من بضع صفحات: مؤشرات، نقاط تستدعي الانتباه، التقدم حسب الشعبة، المواد المتأخرة، متابعة التدريس والرواتب. للطباعة أو للمشاركة في مجلس الإدارة.",
"Un compte avec le rôle Professeur sera créé pour chaque enseignant sans compte, avec son adresse e-mail de la fiche et un mot de passe provisoire. Vous pourrez ensuite imprimer la liste des identifiants ou les envoyer par WhatsApp ou SMS.": "سيُنشأ حساب بدور أستاذ لكل أستاذ دون حساب، ببريده الإلكتروني من بطاقته وكلمة مرور مؤقتة. يمكنك بعد ذلك طباعة قائمة بيانات الدخول أو إرسالها عبر واتساب أو رسالة نصية.",
"Un emploi du temps par": "جدول لكل",
"Un groupe appartient à une filière. L'effectif sert à choisir une salle assez grande. La salle habituelle est choisie en priorité par le générateur quand elle convient.": "الفوج تابع لشعبة. يُستعمل عدد الطلبة لاختيار قاعة كبيرة بما يكفي. يختار المولّد القاعة المعتادة أولًا إذا كانت مناسبة.",
"Un message court affiché en haut de l'écran à la connexion, par exemple « Disponibilités à donner avant jeudi 18 h ». Il disparaît après la date de fin.": "رسالة قصيرة تظهر في أعلى الشاشة عند الدخول، مثل «حدّدوا أوقاتكم المتاحة قبل الخميس الساعة 18». تختفي بعد تاريخ النهاية.",
"Un montant est vide ou dépasse le reste dû.": "أحد المبالغ فارغ أو يتجاوز المتبقي المستحق.",
"Un mot de passe provisoire sera généré et affiché une seule fois. La personne devra choisir le sien à la première connexion.": "ستُنشأ كلمة مرور مؤقتة وتُعرض مرة واحدة. يجب على الشخص اختيار كلمته عند أول دخول.",
"Un nouveau mot de passe provisoire sera créé pour": "ستُنشأ كلمة مرور مؤقتة جديدة لـ",
"Un poste est un nom (Trésorier, Scolarité, Adjoint…) posé sur des droits. Renommez-les comme dans votre établissement. Le nom apparaît dans la barre latérale, les comptes et la signature des messages.": "المنصب اسم (أمين المال، الشؤون الدراسية، النائب…) يُطلق على صلاحيات. أعد تسميتها كما في مؤسستك. يظهر الاسم في الشريط الجانبي والحسابات وتوقيع الرسائل.",
"Un professeur sans réponse n'est pas placé par le générateur. Si ses disponibilités vous ont été données en dehors de la plateforme, saisissez-les ici.": "لا يبرمج المولّد الأستاذ الذي لم يرد. إذا أُبلغت بأوقاته المتاحة خارج المنصة، فأدخلها هنا.",
"Un seul administrateur": "مهندس واحد فقط",
"Une faculté (choisie à l'attribution)": "كلية (تُختار عند الإسناد)",
"Une filière appartient à un département (ex. Informatique L1).": "الشعبة تابعة لقسم (مثال: الإعلام الآلي L1).",
"Une seule année est « en cours ». Les semestres se créent dans l'année.": "سنة واحدة فقط «جارية». تُنشأ السداسيات داخل السنة.",
"Utilisé en paie": "مستعمل في الرواتب",
"Vacances": "عطلة",
"Valeur": "القيمة",
"Validation des heures": "اعتماد الساعات",
"Validation des heures émargées": "اعتماد الساعات المسجّل حضورها",
"Valider l'émargement conforme": "اعتماد تسجيل الحضور المطابق",
"Valider maintenant": "الاعتماد الآن",
"Validées": "المعتمدة",
"Validés": "المعتمدة",
"Vide": "فارغ",
"Visa du doyen obligatoire avant d'enregistrer les paiements": "تأشيرة العميد إلزامية قبل تسجيل المدفوعات",
"Visa en attente": "التأشيرة في الانتظار",
"Viser": "تأشير",
"Viser la paie": "التأشير على الرواتب",
"Visée": "مؤشَّر عليها",
"Voir": "عرض",
"Voir / modifier": "عرض / تعديل",
"Voir la liste": "عرض القائمة",
"Voir la proposition": "عرض الاقتراح",
"Voir le budget": "عرض الميزانية",
"Voir les professeurs jamais connectés": "عرض الأساتذة الذين لم يدخلوا قط",
"Voir tout le journal": "عرض السجل كاملًا",
"Voit l'emploi du temps et l'avancement des matières de son département, et valide les émargements de ce département.": "يطّلع على جدول قسمه وتقدم مواده، ويعتمد تسجيلات الحضور في هذا القسم.",
"Voit la synthèse, le suivi, le budget, la paie et le journal, sans rien pouvoir modifier (contrôleur, auditeur, conseil).": "يطّلع على الملخص والمتابعة والميزانية والرواتب وسجل العمليات، دون أي تعديل (مراقب، مدقق، مجلس).",
"Volume": "الحجم",
"Volume (h)": "الحجم (س)",
"Volume horaire (h)": "الحجم الساعي (س)",
"Vos heures": "ساعاتك",
"Vous": "أنت",
"Vous avez indiqué être indisponible": "أشرت إلى أنك غير متاح",
"Vous ne pouvez pas valider vos propres heures ni celles que vous avez saisies.": "لا يمكنك اعتماد ساعاتك ولا الساعات التي أدخلتها.",
"Vous pouvez calculer quand même : ce qui n'est pas validé ne sera pas payé dans cette période et passera dans une suivante. L'aide du responsable financier voit le détail dans Contrôle › Prêt pour la paie.": "يمكنك الاحتساب رغم ذلك: ما لم يُعتمد لن يُدفع في هذه الفترة وسينتقل إلى فترة لاحقة. يرى مساعد المسؤول المالي التفاصيل في التحقق › جاهز للرواتب.",
"Vue d'ensemble": "نظرة عامة",
"Vérifications avant d'approuver": "عمليات التحقق قبل المصادقة",
"Vérifications indisponibles :": "عمليات التحقق غير متاحة:",
"Vérifiez les bulletins, puis visez la paie : le service financier pourra alors enregistrer les paiements.": "راجع الكشوف، ثم أشِّر على الرواتب: ستتمكن المصلحة المالية حينئذ من تسجيل المدفوعات.",
"Vérifiez les déclarations des professeurs de vos départements. Seules les heures validées comptent pour la paie. Vous ne pouvez pas valider vos propres heures ni celles que vous avez saisies vous-même.": "راجع تصريحات أساتذة أقسامك. الساعات المعتمدة وحدها تُحتسب في الرواتب. لا يمكنك اعتماد ساعاتك ولا الساعات التي أدخلتها بنفسك.",
"Wave": "Wave",
"a approuvé la paie": "صادق على الرواتب",
"a attribué": "أسند",
"a calculé la paie": "احتسب الرواتب",
"a corrigé un émargement": "صحّح تسجيل حضور",
"a créé": "أنشأ",
"a demandé une correction d'émargement": "طلب تصحيح تسجيل حضور",
"a déjà des créneaux : changez plutôt le professeur": "له حصص مسبقًا: غيّر الأستاذ بدلًا من ذلك",
"a déplacé ou modifié": "نقل أو عدّل",
"a enregistré": "سجّل",
"a fixé": "حدّد",
"a modifié": "عدّل",
"a modifié la paie": "عدّل الرواتب",
"a modifié les jours et horaires de cours": "عدّل أيام الدروس وتوقيتاتها",
"a modifié un émargement": "عدّل تسجيل حضور",
"a placé": "برمج",
"a rejeté un émargement": "رفض تسجيل حضور",
"a retiré": "سحب",
"a soldé la paie": "سدّد الرواتب",
"a supprimé": "حذف",
"a validé un émargement": "اعتمد تسجيل حضور",
"a émargé une séance": "سجّل الحضور في حصة",
"a émargé une séance pour un professeur (délégation)": "سجّل الحضور في حصة نيابة عن أستاذ",
"absence du professeur (": "غياب الأستاذ (",
"annulées": "ملغاة",
"année universitaire": "السنة الجامعية",
"approuvé": "مصادَق عليه",
"approuvée": "مصادَق عليها",
"aucun créneau possible avec ces réglages": "لا حصة ممكنة بهذه الإعدادات",
"aucune période": "لا توجد فترة",
"aucune salle assez grande": "لا توجد قاعة كبيرة بما يكفي",
"aucune salle de type «": "لا توجد قاعة من نوع «",
"aucune salle libre": "لا توجد قاعة شاغرة",
"avec un compte": "بحساب",
"brouillon(s) retiré(s)": "مسودة (مسودات) مسحوبة",
"ce cours est commun à d'autres groupes : retirez d'abord ce groupe avec « Groupes réunis… », ou changez le professeur": "هذا الدرس مشترك مع أفواج أخرى: اسحب هذا الفوج أولًا عبر «تجميع الأفواج…»، أو غيّر الأستاذ",
"chevauche un autre cours émargé le même jour": "يتداخل مع درس آخر سُجّل حضوره في اليوم نفسه",
"chèque": "شيك",
"complète": "مكتملة",
"cours dans le fichier calendrier": "درس في ملف التقويم",
"de cette semaine": "من هذا الأسبوع",
"de la semaine sont remplacés par cette proposition.": "من الأسبوع تُستبدل بهذا الاقتراح.",
"de votre visa": "تأشيرتك",
"droit désactivé": "صلاحية معطَّلة",
"du visa du doyen": "تأشيرة العميد",
"déjà connectés": "سبق أن دخلوا",
"département": "القسم",
"désactivés": "المعطَّلون",
"en cours de calcul": "قيد الاحتساب",
"en ligne)": "متصل)",
"en vérification": "قيد المراجعة",
"espèces": "نقدًا",
"est annulé": "ملغى",
"est prévu": "مقرر",
"et les professeurs les voient.": "ويراها الأساتذة.",
"et publié": "ومنشور",
"et seront publiés immédiatement": "وستُنشر فورًا",
"ex. jour férié, professeur malade": "مثال: عطلة رسمية، أستاذ مريض",
"ex. professeur en mission": "مثال: أستاذ في مهمة",
"faculté": "الكلية",
"filière": "الشعبة",
"filière de la matière": "شعبة المادة",
"groupe déjà occupé": "الفوج مشغول مسبقًا",
"horaire décalé": "توقيت مختلف",
"hors disponibilités du professeur": "خارج الأوقات المتاحة للأستاذ",
"hors du semestre en cours": "خارج السداسي الجاري",
"il manquerait environ": "سينقص نحو",
"indisponible toute la semaine": "غير متاح طوال الأسبوع",
"jamais connectés": "لم يدخلوا قط",
"jour sans cours :": "يوم بدون دروس:",
"jour sans cours dans la semaine type": "يوم بدون دروس في الأسبوع النموذجي",
"l'année": "السنة",
"l'émargement conforme": "تسجيل الحضور المطابق",
"l'établissement": "المؤسسة",
"la faculté": "الكلية",
"la filière": "الشعبة",
"la matière": "المادة",
"la salle est déjà occupée": "القاعة مشغولة مسبقًا",
"le département": "القسم",
"le groupe a déjà un cours": "للفوج درس مسبقًا",
"le professeur a déjà un cours": "للأستاذ درس مسبقًا",
"le professeur n'est pas disponible": "الأستاذ غير متاح",
"les cours annulés redeviennent des brouillons ordinaires.": "تعود الدروس الملغاة مسودات عادية.",
"les filières d'une matière": "شعب المادة",
"ligne(s) · sauvegarde du": "سطر · نسخة احتياطية بتاريخ",
"limite d'heures par jour du groupe": "حد الساعات اليومية للفوج",
"limite d'heures par jour du professeur": "حد الساعات اليومية للأستاذ",
"limite de jours de présence du professeur": "حد أيام حضور الأستاذ",
"matière": "المادة",
"matière terminée": "مادة منتهية",
"matières en retard": "مواد متأخرة",
"mot de passe provisoire": "كلمة مرور مؤقتة",
"motif non précisé": "سبب غير محدد",
"où il est": "التي يكون فيها",
"où vous êtes": "التي تكون فيها",
"par délégation": "بالنيابة",
"pas d'adresse": "لا عنوان",
"pas d'adresse e-mail": "لا بريد إلكتروني",
"pas de numéro (Référentiel > Enseignants)": "لا رقم (البيانات المرجعية > الأساتذة)",
"pas de réponse du professeur pour cette semaine": "لا رد من الأستاذ لهذا الأسبوع",
"pas encore commencée": "لم تبدأ بعد",
"pas encore commencée,": "لم تبدأ بعد،",
"pas encore en vigueur": "لم يسرِ بعد",
"payée": "مدفوعة",
"pour ce professeur": "لهذا الأستاذ",
"professeur déjà occupé": "الأستاذ مشغول مسبقًا",
"prévues": "مقررة",
"publiés immédiatement": "تُنشر فورًا",
"réponses reçues": "ردود واردة",
"saisi par délégation": "سُجِّل بالنيابة",
"saisi par le directeur": "أدخله المدير",
"salle :": "القاعة:",
"sem. restantes": "أسابيع متبقية",
"semestre terminé": "السداسي منتهٍ",
"sont proposées.": "مقترحة.",
"sont prévus": "مقررة",
"suppression refusée": "رُفض الحذف",
"séance(s) annulée(s)": "حصة (حصص) ملغاة",
"séances passées": "الحصص الماضية",
"trop d'heures de suite pour la même matière": "ساعات متتالية كثيرة للمادة نفسها",
"un des groupes réunis est déjà occupé": "أحد الأفواج المجمَّعة مشغول مسبقًا",
"un regroupement (tronc commun)": "تجميع (جذع مشترك)",
"une plage de disponibilité": "فترة إتاحة",
"validées": "معتمدة",
"vont être générés. Après approbation, les montants sont figés et ces séances ne pourront plus être payées dans une autre période.": "ستُنشأ. بعد المصادقة، تُجمَّد المبالغ ولا يمكن دفع هذه الحصص في فترة أخرى.",
"·  Semaine du": "·  أسبوع",
"·  brouillon, non publiée": "·  مسودة، غير منشورة",
"·  édité le": "·  حُرّر في",
"· Attention : en dehors des disponibilités du professeur": "· تنبيه: خارج الأوقات المتاحة للأستاذ",
"· Attention : hors disponibilités du professeur": "· تنبيه: خارج الأوقات المتاحة للأستاذ",
"· Ce professeur n'a pas donné ses disponibilités": "· لم يحدد هذا الأستاذ أوقاته المتاحة",
"· Emploi du temps ·": "· الجدول ·",
"· Proposition :": "· الاقتراح:",
"· approuvée le": "· صودق عليها في",
"· brouillon": "· مسودة",
"· en-tête :": "· الترويسة:",
"· enseigne": "· يدرّس",
"· enseigne aussi": "· يدرّس أيضًا",
"· jusqu'au": "· حتى",
"· manque ≈": "· ينقص ≈",
"· montants par mois de la séance, en milliers de FCFA": "· المبالغ حسب شهر الحصة، بآلاف FCFA",
"· montants restant dus au": "· المبالغ المتبقية المستحقة في",
"· non publiée": "· غير منشور",
"· non publiée : les cours sont marqués « brouillon »": "· غير منشور: الدروس موسومة «مسودة»",
"· paie de l'année": "· رواتب السنة",
"· proposition :": "· الاقتراح:",
"· retenu": "· المحتسب",
"· sans date de fin": "· دون تاريخ نهاية",
"· semaine publiée : le changement est visible tout de suite par le professeur": "· الأسبوع منشور: يرى الأستاذ التغيير فورًا",
"· situation au": "· الوضعية في",
"· visible par le professeur": "· يراه الأستاذ",
"· vérifiez l'emploi du temps : les créneaux déjà placés doivent convenir à tous les groupes": "· تحقق من الجدول: يجب أن تناسب الحصص المبرمجة كل الأفواج",
"· Édité le": "· حُرّر في",
"» assez grande": "» كبيرة بما يكفي",
"À activer seulement si votre établissement en a besoin. Désactivé, un droit n'apparaît nulle part.": "لا تفعّلها إلا إذا احتاجتها مؤسستك. الصلاحية المعطّلة لا تظهر في أي مكان.",
"À contrôler": "للتحقق",
"À lier": "للربط",
"À partir du": "ابتداءً من",
"À préciser": "للتحديد",
"À remettre à chaque enseignant ·": "تُسلَّم لكل أستاذ ·",
"À retirer": "للسحب",
"À valider": "للاعتماد",
"À viser": "للتأشير",
"Écart (min)": "الفارق (د)",
"Écart de durée, horaire décalé, commentaire, saisie par délégation ou signalement : à contrôler un par un.": "فارق في المدة، توقيت مختلف، تعليق، إدخال بالنيابة أو ملاحظة: تُفحص واحدًا واحدًا.",
"Échéance de régularisation": "أجل التسوية",
"Écrivez le message.": "اكتب الرسالة.",
"Édité avec": "حُرّر بواسطة",
"Émargement avant le": "تسجيل الحضور قبل",
"Émargement enregistré, en attente de validation": "تم حفظ تسجيل الحضور، في انتظار الاعتماد",
"Émargement par enseignant": "تسجيل الحضور حسب الأستاذ",
"Émargement rejeté": "تسجيل حضور مرفوض",
"Émargement validé": "تسجيل حضور معتمد",
"Émargements": "تسجيلات الحضور",
"Émargements contrôlés": "تسجيلات الحضور المتحقق منها",
"Émargements en attente": "تسجيلات الحضور في الانتظار",
"Émargements et validations": "تسجيلات الحضور والاعتمادات",
"Émargements rejetés": "تسجيلات الحضور المرفوضة",
"Émargements tardifs (plus de 7 jours)": "تسجيلات الحضور المتأخرة (أكثر من 7 أيام)",
"Émargements validés": "تسجيلات الحضور المعتمدة",
"Émarger pour lui": "تسجيل الحضور نيابة عنه",
"Émarger pour un professeur": "تسجيل الحضور نيابة عن أستاذ",
"Émargé": "مسجَّل",
"Émargé tardivement : plus de 7 jours après la séance. Durée réduite : validé pour moins que la durée déclarée. Les demandes d'absence comptent celles envoyées pour une séance de la période.": "سُجّل متأخرًا: بعد أكثر من 7 أيام من الحصة. مدة مخفّضة: اعتُمد لأقل من المدة المصرّح بها. تُحتسب طلبات الغياب المرسلة لحصة من الفترة.",
"Émargées": "المسجّلة",
"Émargées (%)": "المسجّلة (%)",
"Émargés tardivement": "سُجّلت متأخرة",
"Équipe administrative": "الفريق الإداري",
"État de la paie": "حالة الرواتب",
"État de paie :": "حالة الرواتب:",
"Événement": "مناسبة",
"à faire": "للإنجاز",
"à la place de": "بدلًا من",
"à partir du": "ابتداءً من",
"à préciser": "للتحديد",
"à valider": "للاعتماد",
"élément": "عنصر",
"émargements conformes": "تسجيلات حضور مطابقة",
"émargé": "مسجَّل",
"— Non affectée —": "— غير مُسندة —",
"— aucune —": "— لا شيء —",
"← Modifier les réglages": "→ تعديل الإعدادات",
"← Retour à l'emploi du temps": "→ العودة إلى الجدول",
"✓ Contrôle terminé : la période peut être calculée.": "✓ انتهى التحقق: يمكن احتساب الفترة.",
"✓ Mois prêt pour la paie": "✓ الشهر جاهز للرواتب",
"✓ Rien à examiner.": "✓ لا شيء للفحص.",
"✓ Toutes les séances passées de la période sont émargées.": "✓ سُجّل الحضور في كل الحصص الماضية من الفترة.",
"✓ Visée par le doyen": "✓ أشّر عليها العميد",
"✨ Générer la semaine": "✨ إنشاء الأسبوع",
"(rien n'est supprimé) ;": "(لا يُحذف شيء)؛",
"Ce que coûtent les enseignements sur l'année : les montants réels viennent de la paie ; l'estimation du reste à venir est calculée à partir des affectations.": "كلفة التدريس خلال السنة: المبالغ الفعلية مأخوذة من الرواتب؛ وتقدير المتبقي القادم محسوب انطلاقًا من الإسنادات.",
"Cochez les bulletins réglés. Le montant proposé est le reste dû ; le mode vient de la fiche de l'enseignant s'il est connu. Rien n'est versé par l'application : elle enregistre les paiements que vous avez faits.": "حدّد الكشوف المسدَّدة. المبلغ المقترح هو المتبقي المستحق؛ وطريقة الدفع مأخوذة من بطاقة الأستاذ إن كانت معروفة. لا يدفع التطبيق شيئًا: إنه يسجّل المدفوعات التي أنجزتموها.",
"Construisez une semaine, puis « Publier pour tout le semestre » : elle est recopiée sur les semaines suivantes, en sautant les jours sans cours. Pour un changement ponctuel, modifiez la semaine concernée ; pour un changement durable, modifiez une semaine puis « Appliquer à partir de cette semaine ». Les disponibilités affichées sont celles données pour le semestre.": "أنشئ أسبوعًا، ثم «النشر للسداسي كله»: يُنسخ على الأسابيع التالية مع تخطي أيام بدون دروس. لتغيير ظرفي، عدّل الأسبوع المعني؛ ولتغيير دائم، عدّل أسبوعًا ثم «تطبيق ابتداءً من هذا الأسبوع». الأوقات المتاحة المعروضة هي المحددة للسداسي.",
"Montants réels issus de la paie ; estimation calculée à partir des affectations": "مبالغ فعلية من الرواتب؛ وتقدير محسوب انطلاقًا من الإسنادات",
"Recopier les affectations (les enseignants désactivés sont ignorés ; vous pourrez tout ajuster dans Affectations)": "نسخ الإسنادات (يُتجاهل الأساتذة المعطَّلون؛ ويمكنك ضبط كل شيء في الإسناد)",
"les professeurs peuvent de nouveau modifier leurs disponibilités ;": "يمكن للأساتذة مجددًا تعديل أوقاتهم المتاحة؛",
"les séances datées sont retirées : les professeurs ne voient plus cette semaine ;": "تُسحب الحصص المؤرَّخة: لم يعد الأساتذة يرون هذا الأسبوع؛",
". Après votre visa, le service financier pourra enregistrer les paiements. Le visa est enregistré dans le journal.": ". بعد تأشيرتك، ستتمكن المصلحة المالية من تسجيل المدفوعات. تُسجَّل التأشيرة في سجل العمليات.",
". L'ancien ne fonctionnera plus, et la personne devra choisir le sien à la prochaine connexion.": ". لن تعمل الكلمة القديمة بعد الآن، وعلى الشخص اختيار كلمته عند الدخول القادم.",
". Les horaires viennent de Référentiel > Jours et horaires.": ". التوقيتات مأخوذة من البيانات المرجعية > الأيام والتوقيتات.",
"cette semaine": "هذا الأسبوع",
"comptes actifs": "حسابات نشطة",
"sans compte": "دون حساب",
"sans cours": "بدون دروس",
"une affectation": "إسنادًا",
"volume manquant": "حجم ساعي ناقص",
"conflits": "تعارضات",
"hebdomadaire": "أسبوعي",
"fixe": "ثابت",
"obligatoire": "إلزامية",
"non requis": "غير مطلوبة",
"emploi du temps hebdomadaire": "جدول أسبوعي",
"emploi du temps fixe": "جدول ثابت",
"visa du doyen obligatoire": "تأشيرة العميد إلزامية",
"visa du doyen non requis": "تأشيرة العميد غير مطلوبة",
"groupe": "فوج",
"salle": "قاعة",
"année": "سنة",
"semestre": "سداسي",
"statut": "صفة",
"enseignant": "أستاذ",
"virement": "تحويل بنكي",
"pour vous": "لك",
"pour lui": "له",
"Bulletin de rémunération": "كشف الرواتب",
"Relevé détaillé des heures": "الكشف التفصيلي للساعات",
"Service financier": "المصلحة المالية",
"ENSEIGNANT": "الأستاذ",
"PÉRIODE": "الفترة",
"Approuvé le": "صودق عليها في",
"Désignation": "البيان",
"Heures antérieures régularisées": "ساعات سابقة مسوّاة",
"Le détail des séances figure dans le relevé détaillé des heures, disponible sur demande ou dans l'application.": "تفاصيل الحصص واردة في الكشف التفصيلي للساعات، المتاح عند الطلب أو في التطبيق.",
"Heures payables": "الساعات القابلة للدفع",
"Rémunération brute": "الأجر الإجمالي",
"Primes": "المكافآت",
"Retenues et cotisations": "الاقتطاعات والاشتراكات",
"Réglé à ce jour": "المسدَّد حتى اليوم",
"Montant = heures retenues × tarif horaire en vigueur à la date de chaque séance. * Tarif individuel.": "المبلغ = الساعات المحتسبة × أجر الساعة الساري في تاريخ كل حصة. * أجر فردي.",
"Aucune retenue ni cotisation n'est appliquée selon les règles actuelles de l'établissement.": "لا يُطبَّق أي اقتطاع أو اشتراك وفق القواعد الحالية للمؤسسة.",
"le service financier": "المصلحة المالية",
"Rapport mensuel": "التقرير الشهري",
"brouillon, non publiée": "مسودة، غير منشورة",
"brouillon": "مسودة",
"Changer d'établissement": "تغيير المؤسسة",
"Un compte existe déjà avec cette adresse dans votre établissement.": "يوجد حساب بهذا البريد في مؤسستك مسبقًا.",
"Ce compte sert aussi dans un autre établissement : la personne gère elle-même son mot de passe.": "يُستعمل هذا الحساب في مؤسسة أخرى أيضًا: يدير صاحبه كلمة مروره بنفسه.",
"Compte ajouté à votre établissement. La personne se connecte avec son mot de passe habituel.": "أُضيف الحساب إلى مؤسستك. يدخل صاحبه بكلمة مروره المعتادة.",
"l'accès d'un compte": "صلاحية دخول حساب",
"Établissements": "المؤسسات",
"Les établissements qui utilisent Saytu. Vous voyez leur fiche et leur activité, jamais leurs données : chacun se gère lui-même avec son administrateur central.": "المؤسسات التي تستعمل Saytu. ترى بطاقتها ونشاطها، ولا ترى بياناتها أبدًا: كل مؤسسة تُسيّر نفسها بمهندسها العام.",
"+ Nouvel établissement": "+ مؤسسة جديدة",
"Nouvel établissement": "مؤسسة جديدة",
"Comptes actifs": "الحسابات النشطة",
"Administrateurs": "المهندسون",
"+ Administrateur": "+ مهندس",
"Code (court, sans espace)": "الرمز (قصير، دون مسافات)",
"Modèle de départ": "نموذج البداية",
"Université publique": "جامعة عمومية",
"Université privée": "جامعة خاصة",
"École ou institut": "مدرسة أو معهد",
"Le modèle donne les postes et les statuts d'enseignants de départ ; l'établissement les ajuste ensuite. Une école ou un institut reçoit une faculté unique à son nom.": "يحدد النموذج المناصب وصفات الأساتذة في البداية، ثم تضبطها المؤسسة. تتلقى المدرسة أو المعهد كلية واحدة باسمها.",
"Nom complet de l'administrateur central": "الاسم الكامل للمهندس العام",
"Son adresse e-mail": "بريده الإلكتروني",
"Créer l'établissement": "إنشاء المؤسسة",
"Ajouter un administrateur central": "إضافة مهندس عام",
"Par exemple si l'établissement a perdu l'accès à son administrateur.": "مثلًا إذا فقدت المؤسسة الوصول إلى مهندسها.",
"Administrateur central créé": "تم إنشاء المهندس العام",
"Compte ajouté comme administrateur central. La personne se connecte avec son mot de passe habituel.": "أُضيف الحساب مهندسًا عامًا. يدخل صاحبه بكلمة مروره المعتادة.",
"Désactiver cet établissement ?": "تعطيل هذه المؤسسة؟",
"Plus aucun de ses membres ne pourra y accéder. Ses données sont conservées et l'établissement peut être réactivé.": "لن يتمكن أي من أعضائها من الدخول إليها. تُحفظ بياناتها ويمكن إعادة تفعيلها.",
"Établissement réactivé": "تمت إعادة تفعيل المؤسسة",
"Établissement désactivé": "تم تعطيل المؤسسة",
"Code invalide (2 à 20 lettres ou chiffres, sans espace).": "رمز غير صالح (من 2 إلى 20 حرفًا أو رقمًا، دون مسافات).",
"Ce code d'établissement existe déjà.": "رمز المؤسسة هذا موجود مسبقًا.",
"Réservé à l'administrateur de la plateforme.": "مخصص لمهندس المنصة.",
"Établissement introuvable.": "المؤسسة غير موجودة.",
"Ex. Université de Thiès": "مثال: جامعة تييس",
"Ex. UT": "مثال: UT",
"Ajouter": "إضافة",
"Plateforme": "المنصة",
"Gérer": "تسيير",
"Administrateurs centraux": "المهندسون العامون",
"Aucun administrateur central.": "لا يوجد مهندس عام.",
"Désactiver l'établissement": "تعطيل المؤسسة",
"Réactiver l'établissement": "إعادة تفعيل المؤسسة",
"+ Administrateur central": "+ مهندس عام",
"Réservé à l'administrateur de la plateforme, pour un administrateur central.": "مخصص لمهندس المنصة، لمهندس عام."
};
const P=[
[
"^Les mêmes indicateurs pour chaque faculté, pour situer chacune et repérer où poser une question\\. Les séances, émargements et heures portent sur la période choisie ; l'avancement porte sur le semestre en cours, la paie sur l'année universitaire(.*?)\\.$",
"المؤشرات نفسها لكل كلية، لتحديد موقع كل منها ومعرفة أين يُطرح السؤال. الحصص وتسجيلات الحضور والساعات تخص الفترة المختارة؛ والتقدم يخص السداسي الجاري، والرواتب السنة الجامعية§1."
],
[
"^(.*?)Le tarif dépend du statut de l'enseignant\\. Une exception individuelle remplace le tarif du statut\\. Pour changer un tarif, ajoutez\\-en un nouveau avec sa date d'effet : l'ancien reste appliqué aux séances antérieures\\.$",
"§1يتوقف أجر الساعة على صفة الأستاذ. الاستثناء الفردي يحل محل أجر الصفة. لتغيير أجر، أضف أجرًا جديدًا مع تاريخ سريانه: يبقى الأجر القديم مطبقًا على الحصص السابقة."
],
[
"^La semaine du (.*?) \\((.*?) cours, (.*?)\\) est publiée, puis recopiée et publiée sur chaque semaine suivante jusqu'à la fin du semestre\\. Les jours sans cours sont sautés ; les semaines qui ont déjà des cours ne sont pas touchées\\.$",
"يُنشر أسبوع §1 (§2 درس، §3)، ثم يُنسخ ويُنشر على كل أسبوع تالٍ حتى نهاية السداسي. تُتخطى أيام بدون دروس؛ ولا تُمسّ الأسابيع التي فيها دروس مسبقًا."
],
[
"^Toutes les affectations du semestre choisi \\(tous groupes\\) sont recopiées dans « (.*?) », avec le même professeur et le même volume\\. Celles qui existent déjà ici sont ignorées\\. Vous pourrez ensuite ajuster\\.$",
"تُنسخ كل إسنادات السداسي المختار (كل الأفواج) إلى «§1»، بالأستاذ نفسه والحجم نفسه. يُتجاهل ما هو موجود هنا مسبقًا. يمكنك التعديل بعد ذلك."
],
[
"^: heures prévues dans les affectations de l'année, moins les heures déjà émargées, multipliées par le tarif actuel de chaque enseignant\\. Elle change avec les affectations, les annulations et les tarifs(.*?)\\.$",
": الساعات المقررة في إسنادات السنة، ناقص الساعات المسجّل حضورها، مضروبة في أجر الساعة الحالي لكل أستاذ. تتغير بتغير الإسنادات والإلغاءات والأجور§1."
],
[
"^(.*?) séance\\(s\\) de cette semaine ont déjà été émargées\\. Pour ne pas toucher aux heures déclarées, la publication ne peut plus être retirée\\. Annulez ou reportez plutôt les autres cours un par un\\.$",
"سُجّل الحضور في §1 حصة من هذا الأسبوع. حفاظًا على الساعات المصرّح بها، لم يعد ممكنًا التراجع عن النشر. ألغِ الدروس الأخرى أو أجّلها واحدًا واحدًا."
],
[
"^Un fichier Excel avec toutes les données : comptes, référentiel, affectations, emplois du temps, émargements(.*?) et journal\\. Gardez\\-en une copie dans l'établissement, par exemple chaque mois\\.$",
"ملف Excel بكل البيانات: الحسابات، البيانات المرجعية، الإسنادات، الجداول، تسجيلات الحضور§1 وسجل العمليات. احتفظ بنسخة منه في المؤسسة، مثلًا كل شهر."
],
[
"^Les cours des semaines suivantes, jusqu'à la fin du semestre, sont remplacés par ceux de la semaine du (.*?)\\. Les séances déjà émargées ne sont pas touchées\\. Les jours sans cours sont sautés\\.$",
"تُستبدل دروس الأسابيع التالية، حتى نهاية السداسي، بدروس أسبوع §1. لا تُمسّ الحصص المسجّل حضورها. تُتخطى أيام بدون دروس."
],
[
"^L'assistant crée l'année et ses semestres\\. Il peut recopier les affectations \\(qui enseigne quoi à quel groupe\\) pour gagner du temps\\. L'année (.*?) reste intacte et consultable\\.$",
"ينشئ المساعد السنة وسداسياتها. ويمكنه نسخ الإسنادات (من يدرّس ماذا ولأي فوج) لربح الوقت. تبقى السنة §1 سليمة ومتاحة للاطلاع."
],
[
"^Définissez la semaine type de (.*?)\\. Ces réglages s'appliquent à la grille de disponibilités des professeurs, à la grille de l'emploi du temps et au générateur automatique\\.$",
"حدّد الأسبوع النموذجي لـ §1. تُطبَّق هذه الإعدادات على شبكة الأوقات المتاحة للأساتذة وشبكة الجدول والمولّد الآلي."
],
[
"^(.*?) séance\\(s\\) de cours sont encore programmées à partir du (.*?)\\. Prévenez le directeur des études pour qu'il les réattribue \\(Affectations > changer le professeur\\)\\.$",
"ما زالت §1 حصة مبرمجة ابتداءً من §2. أبلغ مدير الدراسات ليعيد إسنادها (الإسناد > تغيير الأستاذ)."
],
[
"^Aucune fiche enseignant libre dans (.*?)\\. Le directeur des études doit d'abord créer la fiche dans Référentiel › Enseignants ; revenez ensuite ici pour la lier\\.$",
"لا توجد بطاقة أستاذ شاغرة في §1. يجب على مدير الدراسات أولًا إنشاء البطاقة في البيانات المرجعية › الأساتذة؛ ثم عُد إلى هنا لربطها."
],
[
"^(.*?) cours, (.*?)\\. Les séances sont créées, les professeurs voient leur emploi du temps et ne peuvent plus modifier leurs disponibilités de cette semaine\\.$",
"§1 درس، §2. أُنشئت الحصص، ويرى الأساتذة جدولهم ولم يعد بإمكانهم تعديل أوقاتهم المتاحة لهذا الأسبوع."
],
[
"^Aucune matière n'est rattachée à la filière (.*?)\\. Rattachez\\-les dans Référentiel > Matières \\(champ « Filières »\\), ou ajoutez\\-les ci\\-dessous\\.$",
"لا توجد مادة مرتبطة بالشعبة §1. اربطها في البيانات المرجعية > المواد (حقل «الشعب»)، أو أضفها أدناه."
],
[
"^Semaine du (.*?)\\. Envoyez le message par WhatsApp ou SMS \\(le téléphone s'ouvre avec le texte prêt\\), ou copiez\\-le pour un groupe WhatsApp\\.$",
"أسبوع §1. أرسل الرسالة عبر واتساب أو رسالة نصية (يفتح الهاتف والنص جاهز)، أو انسخها لمجموعة واتساب."
],
[
"^(.*?) cours concernent des professeurs qui n'ont pas encore donné leurs disponibilités pour cette semaine : ils sont repris, à vérifier\\.$",
"§1 درس لأساتذة لم يحددوا بعد أوقاتهم المتاحة لهذا الأسبوع: تمت استعادتها، يجب التحقق منها."
],
[
"^C'est la seule personne au poste « (.*?) » : plus personne ne pourra faire ce travail\\. Donnez d'abord ce poste à quelqu'un d'autre\\.$",
"هو الشخص الوحيد في منصب «§1»: لن يستطيع أحد القيام بهذا العمل. أسند هذا المنصب أولًا إلى شخص آخر."
],
[
"^(.*?)\\. Émargez chaque séance après l'avoir dispensée\\. Seules les heures validées par le responsable comptent pour la rémunération\\.$",
"§1. سجّل حضورك في كل حصة بعد تقديمها. الساعات التي يعتمدها المسؤول وحدها تُحتسب في الأجر."
],
[
"^cours annulé\\(s\\)(.*?)\\. Les professeurs les voient barrés avec le motif ; ils ne comptent ni dans l'émargement ni dans la paie\\.$",
"درس ملغى§1. يراها الأساتذة مشطوبة مع السبب؛ ولا تُحتسب في تسجيل الحضور ولا في الرواتب."
],
[
"^Des personnes occupent un poste qui les utilise : (.*?)\\. Elles gardent leurs droits actuels ; changez leur poste dans Comptes\\.$",
"هناك أشخاص يشغلون منصبًا يستعملها: §1. يحتفظون بصلاحياتهم الحالية؛ غيّر منصبهم في الحسابات."
],
[
"^(.*?) professeur\\(s\\) sans numéro de téléphone : ajoutez\\-le dans Référentiel > Enseignants pour les boutons WhatsApp et SMS\\.$",
"§1 أستاذ دون رقم هاتف: أضفه في البيانات المرجعية > الأساتذة لتفعيل أزرار واتساب والرسائل النصية."
],
[
"^(.*?)Emplois du temps publiés et avancement des matières du département\\. Les émargements se valident dans « Contrôle »\\.$",
"§1الجداول المنشورة وتقدم مواد القسم. يُعتمد تسجيل الحضور في «التحقق»."
],
[
"^(.*?) · (.*?), (.*?) (.*?)–(.*?)\\. Le cours reste visible, barré, avec le motif\\. Ses heures ne sont pas comptées et l'horaire est libéré\\.$",
"§1 · §2، §3 §4–§5. يبقى الدرس ظاهرًا مشطوبًا مع السبب. لا تُحتسب ساعاته ويُحرَّر توقيته."
],
[
"^Nécessaire pour un professeur : c'est ce qui relie le compte à ses cours, ses disponibilités et ses émargements\\.(.*?)$",
"ضروري للأستاذ: هو ما يربط الحساب بدروسه وأوقاته المتاحة وتسجيلات حضوره.§1"
],
[
"^Elle sera affichée en haut de l'écran pour tout le monde(.*?)\\. Les données des autres années ne changent pas\\.$",
"ستظهر في أعلى الشاشة للجميع§1. لا تتغير بيانات السنوات الأخرى."
],
[
"^Relevé joint au bulletin (.*?)\\. Il reprend chaque séance émargée et validée prise en compte dans ce bulletin\\.$",
"كشف مرفق بالكشف §1. يتضمن كل حصة سُجّل حضورها واعتُمدت واحتُسبت في هذا الكشف."
],
[
"^(.*?) séance\\(s\\) validée\\(s\\) sans tarif, donc non payées : (.*?)\\. Ajoutez un tarif \\(Tarifs\\) puis recalculez\\.$",
"§1 حصة معتمدة دون أجر ساعة، فهي غير مدفوعة: §2. أضف أجر ساعة (أجر الساعة) ثم أعد الاحتساب."
],
[
"^(.*?) émargement\\(s\\) de la période ne sont pas encore validés : ils ne seront pas payés dans cette période\\.$",
"§1 تسجيل حضور في الفترة لم يُعتمد بعد: لن يُدفع في هذه الفترة."
],
[
"^Chacun est validé pour la durée prévue \\((.*?) au total\\)\\. Les émargements à examiner ne sont pas touchés\\.$",
"تُعتمد كل منها للمدة المقررة (§1 في المجموع). لا تُمسّ تسجيلات الحضور التي تحتاج إلى فحص."
],
[
"^L'emploi du temps de la semaine du (.*?) est publié\\. Envoyez à chaque professeur la liste de ses cours\\.$",
"جدول أسبوع §1 منشور. أرسل إلى كل أستاذ قائمة دروسه."
],
[
"^(.*?) compte\\(s\\) professeur sans fiche enseignant liée : ils ne voient pas leurs cours\\. Liez\\-les :$",
"§1 حساب أستاذ دون بطاقة أستاذ مرتبطة: لا يرون دروسهم. اربطها:"
],
[
"^(.*?) enseignant\\(s\\) sans compte : ils ne peuvent ni déclarer leurs disponibilités ni émarger \\((.*?)(.*?)\\)\\.$",
"§1 أستاذ دون حساب: لا يمكنهم تحديد أوقاتهم المتاحة ولا تسجيل الحضور (§2§3)."
],
[
"^(.*?) demande\\(s\\) d'absence de professeurs en attente de traitement par la direction des études\\.$",
"§1 طلب غياب لأساتذة في انتظار معالجة إدارة الدراسات."
],
[
"^(.*?) personne\\(s\\) occupent ce poste : si vous changez les droits, les leurs seront mis à jour\\.$",
"§1 شخص يشغلون هذا المنصب: إذا غيّرت الصلاحيات فستُحدَّث صلاحياتهم."
],
[
"^(.*?) affectation\\(s\\) de ce semestre sont encore à son nom\\. Prévenez le directeur des études\\.$",
"§1 إسناد في هذا السداسي ما زال باسمه. أبلغ مدير الدراسات."
],
[
"^(.*?) compte\\(s\\) sans poste : la personne ne voit rien après connexion\\. Choisissez son poste :$",
"§1 حساب دون منصب: لا يرى صاحبه شيئًا بعد الدخول. اختر منصبه:"
],
[
"^(.*?) émargement\\(s\\) rejeté\\(s\\) ce mois : voir « Mon emploi du temps » › Liste et émargement\\.$",
"§1 تسجيل حضور مرفوض هذا الشهر: انظر «جدولي» › القائمة وتسجيل الحضور."
],
[
"^(.*?) matière\\(s\\) du semestre en cours · (.*?) professeur\\(s\\) ont donné leurs disponibilités$",
"§1 مادة في السداسي الجاري · §2 أستاذ حدّدوا أوقاتهم المتاحة"
],
[
"^(.*?) point\\(s\\) signalé\\(s\\) dans les vérifications : relisez\\-les avant d'approuver\\.$",
"§1 ملاحظة في عمليات التحقق: راجعها قبل المصادقة."
],
[
"^Dernier calcul : (.*?)\\. Recalculez si de nouveaux émargements ont été validés depuis\\.$",
"آخر احتساب: §1. أعد الاحتساب إذا اعتُمدت تسجيلات حضور جديدة منذ ذلك الحين."
],
[
"^Payé\\(s\\) pour la première fois ou absent\\(s\\) de la période précédente : (.*?)\\.$",
"دُفع لهم لأول مرة أو غائبون عن الفترة السابقة: §1."
],
[
"^La base n'est pas à jour : le script « (.*?) » doit être exécuté dans Supabase\\.$",
"قاعدة البيانات غير محدَّثة: يجب تنفيذ السكربت «§1» في Supabase."
],
[
"^Les cours publiés sont annulés avec ce motif, les brouillons sont retirés\\.(.*?)$",
"تُلغى الدروس المنشورة بهذا السبب، وتُسحب المسودات.§1"
],
[
"^n'(.*?) toujours pas de tarif : ajoutez\\-le dans « Tarifs », puis recalculez\\.$",
"§1 بعد دون أجر ساعة: أضفه في «أجر الساعة»، ثم أعد الاحتساب."
],
[
"^Elles ont été validées, ou leur tarif ajouté, après le dernier calcul\\.(.*?)$",
"اعتُمدت، أو أضيف أجرها، بعد آخر احتساب.§1"
],
[
"^Touchez les créneaux (.*?) disponible, ou utilisez les boutons ci\\-dessous\\.$",
"المس الحصص التي §1 متاحًا فيها، أو استعمل الأزرار أدناه."
],
[
"^Bulletin approuvé par (.*?)\\. Ce document ne vaut pas preuve de paiement\\.$",
"صادق على الكشف: §1. لا تُعدّ هذه الوثيقة إثباتًا للدفع."
],
[
"^(.*?) cours annulé\\(s\\) cette semaine : touchez\\-les pour voir le motif\\.$",
"§1 درس ملغى هذا الأسبوع: المسها لرؤية السبب."
],
[
"^(.*?) émargement\\(s\\) non validé\\(s\\) restent en dehors de cette paie\\.$",
"§1 تسجيل حضور غير معتمد يبقى خارج هذه الرواتب."
],
[
"^Les 15 plus anciennes sur (.*?)\\. La liste complète est dans l'export\\.$",
"أقدم 15 من أصل §1. القائمة الكاملة في ملف التصدير."
],
[
"^Nombre d'heures inhabituel \\(plus du double de la médiane, (.*?)\\) : (.*?)\\.$",
"عدد ساعات غير مألوف (أكثر من ضعف الوسيط، §1): §2."
],
[
"^(.*?) semaine\\(s\\) qui avaient déjà des cours n'ont pas été touchées\\.$",
"لم يُمسّ §1 أسبوع كانت فيه دروس من قبل."
],
[
"^Effectif total : (.*?) étudiants — la salle devra être assez grande\\.$",
"العدد الإجمالي: §1 طالبًا — يجب أن تكون القاعة كبيرة بما يكفي."
],
[
"^(.*?) séance\\(s\\) validée\\(s\\) \\((.*?)\\) ne (.*?) pas encore dans le calcul\\.$",
"§1 حصة معتمدة (§2) لم §3 بعد في الاحتساب."
],
[
"^· au rythme actuel, il manquerait environ (.*?) en fin de semestre$",
"· بالوتيرة الحالية سينقص نحو §1 في نهاية السداسي"
],
[
"^(.*?) correction\\(s\\) demandée\\(s\\), sans réponse du professeur\\.$",
"§1 تصحيح مطلوب دون رد من الأستاذ."
],
[
"^Avancement des programmes \\((.*?) sur (.*?)\\) · attendu à ce jour ≈ (.*?) %$",
"تقدم البرامج (§1 من §2) · المتوقع حتى اليوم ≈ §3 %"
],
[
"^(.*?) correction\\(s\\) demandée\\(s\\), sans réponse du professeur$",
"§1 تصحيح مطلوب دون رد من الأستاذ"
],
[
"^(.*?) émargement\\(s\\) à corriger à la demande du responsable : (.*?)$",
"§1 تسجيل حضور للتصحيح بطلب من المسؤول: §2"
],
[
"^Le mois n'est pas terminé : (.*?) séance\\(s\\) restent à venir\\.$",
"لم ينته الشهر: ما زالت §1 حصة قادمة."
],
[
"^(.*?) cours placé\\(s\\) sur un jour sans cours du calendrier : (.*?)$",
"§1 درس في يوم بدون دروس في التقويم: §2"
],
[
"^(.*?) matière\\(s\\) non terminée\\(s\\) sans cours cette semaine$",
"§1 مادة غير منتهية دون درس هذا الأسبوع"
],
[
"^Poste enregistré · droits mis à jour pour (.*?) personne\\(s\\)$",
"تم حفظ المنصب · حُدّثت الصلاحيات لـ §1 شخص"
],
[
"^(.*?) séance\\(s\\) déjà émargée\\(s\\) ne seront pas touchées\\.$",
"لن تُمسّ §1 حصة سُجّل فيها الحضور."
],
[
"^La salle (.*?) \\((.*?) places\\) est trop petite pour (.*?) étudiants\\.$",
"القاعة §1 (§2 مقعدًا) صغيرة جدًا على §3 طالبًا."
],
[
"^Peu d'heures pour : (.*?) · la moitié des groupes a (.*?) ou plus$",
"ساعات قليلة لـ: §1 · نصف الأفواج لها §2 أو أكثر"
],
[
"^a saisi les disponibilités d'un professeur \\(semaine (.*?)\\)$",
"أدخل الأوقات المتاحة لأستاذ (أسبوع §1)"
],
[
"^La semaine repassera en « pas encore de réponse »\\. (.*?)$",
"سيعود الأسبوع إلى «لا إجابة بعد». §1"
],
[
"^… et (.*?) autre\\(s\\), voir Emplois du temps > Avancement$",
"… و§1 أخرى، انظر الجداول الدراسية > التقدم"
],
[
"^(.*?) matière\\(s\\) en retard sur le rythme du semestre\\.$",
"§1 مادة متأخرة عن وتيرة السداسي."
],
[
"^: (.*?) créneau(.*?) manquant(.*?)\\. Raison la plus fréquente : (.*?)\\.$",
": §1 حصة ناقصة. السبب الأكثر تكرارًا: §4."
],
[
"^Semaine publiée · (.*?) cours transformé\\(s\\) en séances$",
"الأسبوع منشور · §1 درس حُوّل إلى حصص"
],
[
"^a effacé une réponse de disponibilités \\(semaine (.*?)\\)$",
"مسح ردًا على الأوقات المتاحة (أسبوع §1)"
],
[
"^(.*?) séance\\(s\\) déjà émargée\\(s\\), non touchée\\(s\\) :$",
"§1 حصة سُجّل فيها الحضور، لم تُمسّ:"
],
[
"^Cours placés pour (.*?) professeur\\(s\\) sans réponse : (.*?)$",
"دروس مبرمجة لـ §1 أستاذ دون رد: §2"
],
[
"^Créer les comptes des (.*?) enseignant\\(s\\) sans compte$",
"إنشاء حسابات §1 أستاذ دون حساب"
],
[
"^semaine\\(s\\) suivante\\(s\\) publiée\\(s\\) jusqu'au (.*?),$",
"أسبوع (أسابيع) تالية منشورة حتى §1،"
],
[
"^(.*?) séance\\(s\\) de la période sont encore à venir\\.$",
"ما زالت §1 حصة من الفترة قادمة."
],
[
"^Émarger les (.*?) séances passées aux horaires prévus$",
"تسجيل الحضور في الحصص الماضية الـ §1 في التوقيت المقرر"
],
[
"^(.*?) enseignant\\(s\\) · emploi du temps hebdomadaire$",
"§1 أستاذ · جدول أسبوعي"
],
[
"^· (.*?) · (.*?) étudiants · (.*?)/(.*?) matière\\(s\\) affectée\\(s\\)$",
"· §1 · §2 طالبًا · §3/§4 مادة مُسندة"
],
[
"^(.*?) % des professeurs se sont déjà connectés\\.$",
"§1 % من الأساتذة سبق أن سجّلوا الدخول."
],
[
"^(.*?) séance\\(s\\) passée\\(s\\) non émargée\\(s\\)\\.$",
"§1 حصة ماضية دون تسجيل حضور."
],
[
"^Aucun cours ne sera placé (.*?) la semaine du (.*?)\\.$",
"لن يُبرمج أي درس §1 في أسبوع §2."
],
[
"^Retirer la publication de la semaine du (.*?) \\?$",
"التراجع عن نشر أسبوع §1؟"
],
[
"^· il manquerait environ (.*?) en fin de semestre$",
"· سينقص نحو §1 في نهاية السداسي"
],
[
"^(.*?) % fait \\((.*?) sur (.*?)\\) · attendu à ce jour ≈ (.*?) %(.*?)$",
"أُنجز §1 % (§2 من §3) · المتوقع حتى اليوم ≈ §4 %§5"
],
[
"^(.*?) réglés sur (.*?) · (.*?) validées pas encore payées$",
"سُدّد §1 من §2 · §3 معتمدة لم تُدفع بعد"
],
[
"^(.*?) émargement\\(s\\) rejeté\\(s\\) : non payés\\.$",
"§1 تسجيل حضور مرفوض: غير مدفوع."
],
[
"^Annuler (.*?) \\(motif : le libellé ci\\-dessus\\)$",
"إلغاء §1 (السبب: العنوان أعلاه)"
],
[
"^Relancer les (.*?) professeur\\(s\\) sans réponse$",
"تذكير §1 أستاذ دون رد"
],
[
"^(.*?) séance\\(s\\) passée\\(s\\) non émargée\\(s\\)$",
"§1 حصة ماضية دون تسجيل حضور"
],
[
"^(.*?) émargement\\(s\\) en attente de contrôle\\.$",
"§1 تسجيل حضور في انتظار التحقق."
],
[
"^Aucun cours ne sera placé(.*?) cette semaine\\.$",
"لن يُبرمج أي درس§1 هذا الأسبوع."
],
[
"^La paie « (.*?) » n'est pas encore approuvée\\.$",
"رواتب «§1» لم يُصادق عليها بعد."
],
[
"^a déclaré ses disponibilités \\(semaine (.*?)\\)$",
"حدّد أوقاته المتاحة (أسبوع §1)"
],
[
"^(.*?) Gardez une copie dans l'établissement\\.$",
"§1 احتفظ بنسخة في المؤسسة."
],
[
"^(.*?) cours hors des disponibilités déclarées$",
"§1 درس خارج الأوقات المتاحة المصرّح بها"
],
[
"^(.*?) paie\\(s\\) en attente du visa du doyen\\.$",
"§1 راتب في انتظار تأشيرة العميد."
],
[
"^(.*?) modification\\(s\\) non enregistrée\\(s\\)$",
"§1 تعديل غير محفوظ"
],
[
"^(.*?) · (.*?) département\\(s\\) · emploi du temps (.*?)(.*?)$",
"§1 · §2 قسم · الجدول §3§4"
],
[
"^(.*?) émargement\\(s\\) en attente de contrôle$",
"§1 تسجيل حضور في انتظار التحقق"
],
[
"^Aucun enseignant ne correspond à « (.*?) »\\.$",
"لا يوجد أستاذ يطابق «§1»."
],
[
"^(.*?) enseignant\\(s\\) · emploi du temps fixe$",
"§1 أستاذ · جدول ثابت"
],
[
"^(.*?) validées(.*?) sur (.*?) prévues · émargement (.*?) %$",
"§1 معتمدة§2 من §3 مقررة · تسجيل الحضور §4 %"
],
[
"^Déjà marqué d'après le calendrier : (.*?)\\.$",
"محدَّد مسبقًا حسب التقويم: §1."
],
[
"^Relancer (.*?) professeur\\(s\\) sans réponse$",
"تذكير §1 أستاذ دون رد"
],
[
"^Séances de (.*?) émargées \\((.*?)/(.*?)\\) · (.*?) validées$",
"حصص §1 المسجّل حضورها (§2/§3) · §4 معتمدة"
],
[
"^a retiré la publication de la semaine (.*?)$",
"تراجع عن نشر أسبوع §1"
],
[
"^(.*?) conflit\\(s\\) à corriger \\(bloquant\\)$",
"§1 تعارض يجب تصحيحه (مانع)"
],
[
"^(.*?) validées · (.*?) en attente · (.*?) manquantes$",
"§1 معتمدة · §2 في الانتظار · §3 ناقصة"
],
[
"^Du (.*?) à aujourd'hui, (.*?) professeur\\(s\\)\\.$",
"من §1 إلى اليوم، §2 أستاذ."
],
[
"^Tout émarger aux horaires prévus \\((.*?)\\)$",
"تسجيل الكل في التوقيت المقرر (§1)"
],
[
"^L'essentiel de l'établissement au (.*?)\\.$",
"أهم معطيات المؤسسة في §1."
],
[
"^Écart de plus de 50 % avec « (.*?) » : (.*?)\\.$",
"فارق يزيد على 50 % مع «§1»: §2."
],
[
"^(.*?) cours ne peuvent pas être repris :$",
"لا يمكن استعادة §1 درس:"
],
[
"^(.*?) enseignant\\(s\\) · emploi du temps (.*?)$",
"§1 أستاذ · الجدول §2"
],
[
"^(.*?) un tarif horaire de (.*?) à partir du (.*?)$",
"§1 أجر ساعة قدره §2 ابتداءً من §3"
],
[
"^Valider les (.*?) émargements conformes$",
"اعتماد §1 تسجيل حضور مطابق"
],
[
"^· (.*?) sans tarif ne sont pas comptées$",
"· §1 دون أجر ساعة لا تُحتسب"
],
[
"^À faire valider par un collègue · (.*?)$",
"ليعتمدها زميل · §1"
],
[
"^\\* Tarif individuel\\. Édité le (.*?) · (.*?)$",
"* أجر فردي. حُرّر في §1 · §2"
],
[
"^Relancer (.*?) professeur(.*?) sans réponse$",
"تذكير §1 أستاذ دون رد"
],
[
"^· (.*?) affectation\\(s\\) recopiée\\(s\\)$",
"· نُسخ §1 إسناد"
],
[
"^(.*?) changement\\(s\\) enregistré\\(s\\)$",
"تم حفظ §1 تغيير"
],
[
"^Avancement du semestre \\((.*?) sur (.*?)\\)$",
"تقدم السداسي (§1 من §2)"
],
[
"^Estimation du reste à venir \\((.*?)\\)$",
"تقدير المتبقي القادم (§1)"
],
[
"^paie engagée sur l'année · payé (.*?)$",
"الرواتب الملتزم بها في السنة · المدفوع §1"
],
[
"^remplace les (.*?) cours en brouillon$",
"يستبدل §1 درس في المسودة"
],
[
"^— pas encore commencée, (.*?) à faire$",
"— لم تبدأ بعد، §1 للإنجاز"
],
[
"^(.*?) bulletin\\(s\\) pour un total de$",
"§1 كشف بمجموع"
],
[
"^Faites (.*?) · programmées (.*?) · reste (.*?)$",
"منجزة §1 · مبرمجة §2 · المتبقي §3"
],
[
"^Groupe\\(s\\) sans aucun cours : (.*?)$",
"فوج (أفواج) بلا أي درس: §1"
],
[
"^Heures prévues et validées par (.*?)$",
"الساعات المقررة والمعتمدة حسب §1"
],
[
"^L'emploi du temps (.*?) est publié\\.$",
"الجدول §1 منشور."
],
[
"^Séances passées non émargées · (.*?)$",
"حصص ماضية دون تسجيل حضور · §1"
],
[
"^(.*?) affectation\\(s\\) reprise\\(s\\)$",
"تمت استعادة §1 إسناد"
],
[
"^(.*?) paiement\\(s\\) enregistré\\(s\\)$",
"تم تسجيل §1 دفعة"
],
[
"^(.*?)Télécharger la semaine \\(PDF\\)$",
"§1تحميل الأسبوع (PDF)"
],
[
"^a remis en place la séance du (.*?)$",
"أعاد الحصة يوم §1"
],
[
"^semaines de cours en (.*?) \\(sur (.*?)\\)$",
"أسابيع دراسة في §1 (من أصل §2)"
],
[
"^Créer (.*?) compte\\(s\\) professeur$",
"إنشاء §1 حساب أستاذ"
],
[
"^Total : (.*?), contre (.*?) pour « (.*?) »(.*?)\\.$",
"المجموع: §1، مقابل §2 لـ «§3»§4."
],
[
"^émargé (.*?) jours après la séance$",
"سُجّل بعد §1 يومًا من الحصة"
],
[
"^(.*?) / semaine · (.*?) sem\\. restantes$",
"§1 في الأسبوع · §2 أسابيع متبقية"
],
[
"^(.*?) : à valider par un collègue$",
"§1: في انتظار الاعتماد من زميل"
],
[
"^(.*?) enregistrement\\(s\\), (.*?) refus$",
"§1 تسجيل، §2 رفض"
],
[
"^(.*?) séance\\(s\\) payable\\(s\\) · (.*?)$",
"§1 حصة قابلة للدفع · §2"
],
[
"^(.*?) émargement\\(s\\) validé\\(s\\)$",
"§1 تسجيل حضور معتمد"
],
[
"^Risque de fin de semestre · (.*?)$",
"خطر نهاية السداسي · §1"
],
[
"^Total net des bulletins \\((.*?)\\)$",
"صافي مجموع الكشوف (§1)"
],
[
"^garde les (.*?) cours déjà placés$",
"يحتفظ بـ §1 درس مبرمج مسبقًا"
],
[
"^(.*?) paie\\(s\\) en attente (.*?) : (.*?)\\.$",
"§1 راتب في انتظار §2: §3."
],
[
"^Rejoindre le cours de (.*?) \\((.*?)\\)$",
"الانضمام إلى درس §1 (§2)"
],
[
"^Sans cours cette semaine : (.*?)$",
"بدون دروس هذا الأسبوع: §1"
],
[
"^Semaine du (.*?) → semaine du (.*?)\\.$",
"أسبوع §1 ← أسبوع §2."
],
[
"^Supprimer le poste « (.*?) » \\?$",
"حذف المنصب «§1»؟"
],
[
"^(.*?) % réglé · (.*?) bulletin(.*?) figé(.*?)$",
"سُدّد §1 % · §2 كشف مُجمَّد"
],
[
"^(.*?) : (.*?) validées sur (.*?) prévues$",
"§1: §2 معتمدة من أصل §3 مقررة"
],
[
"^(.*?) bulletin\\(s\\), net total$",
"§1 كشف، الصافي الإجمالي"
],
[
"^(.*?) cours non recopié\\(s\\) :$",
"§1 درس لم يُنسخ:"
],
[
"^(.*?)Télécharger la sauvegarde$",
"§1تحميل النسخة الاحتياطية"
],
[
"^Avancement des programmes(.*?)$",
"تقدم البرامج§1"
],
[
"^Demande du responsable : (.*?)$",
"طلب المسؤول: §1"
],
[
"^Publier (.*?) cours en attente$",
"نشر §1 درس في الانتظار"
],
[
"^Publier la semaine du (.*?) \\?$",
"نشر أسبوع §1؟"
],
[
"^Relancer les (.*?) professeurs$",
"تذكير §1 أساتذة"
],
[
"^Remarque sur la paie « (.*?) »$",
"ملاحظة على رواتب «§1»"
],
[
"^Reporté \\(prévu (.*?) (.*?) à (.*?)\\) : (.*?)$",
"مؤجَّل (كان مقررًا §1 §2 الساعة §3): §4"
],
[
"^a annulé la séance du (.*?) à (.*?)$",
"ألغى الحصة يوم §1 الساعة §2"
],
[
"^· valables chaque semaine(.*?)$",
"· صالحة كل أسبوع§1"
],
[
"^Budget des enseignements (.*?)$",
"ميزانية التدريس §1"
],
[
"^(.*?) la période de paie « (.*?) »$",
"§1 فترة الرواتب «§2»"
],
[
"^Remarque du doyen : « (.*?) »$",
"ملاحظة العميد: «§1»"
],
[
"^séance(.*?) passée(.*?) à relancer$",
"حصة ماضية للتذكير"
],
[
"^émargement(.*?) en attente · (.*?)$",
"تسجيل حضور في الانتظار · §2"
],
[
"^Montants restant dus au (.*?)$",
"المبالغ المتبقية المستحقة في §1"
],
[
"^— il manquerait environ (.*?)$",
"— سينقص نحو §1"
],
[
"^(.*?) · Dernière connexion : (.*?)$",
"§1 · آخر دخول: §2"
],
[
"^(.*?) paiement\\(s\\) · total (.*?)$",
"§1 دفعة · المجموع §2"
],
[
"^(.*?) séance(.*?) sans émargement$",
"§1 حصة دون تسجيل حضور"
],
[
"^(.*?)Rapport du mois \\(PDF\\)$",
"§1تقرير الشهر (PDF)"
],
[
"^Du (.*?) au (.*?) · approuvée le (.*?)$",
"من §1 إلى §2 · صودق عليها في §3"
],
[
"^les (.*?) cours repassent en$",
"تعود §1 درس إلى"
],
[
"^Semaine du (.*?) · Édité le (.*?)$",
"أسبوع §1 · حُرّر في §2"
],
[
"^(.*?) bulletin\\(s\\) générés$",
"تم إنشاء §1 كشف"
],
[
"^(.*?) compte\\(s\\) créé\\(s\\)$",
"تم إنشاء §1 حساب"
],
[
"^(.*?) min de plus que prévu$",
"§1 د أكثر من المقرر"
],
[
"^Faites (.*?) · programmées (.*?)(.*?)$",
"منجزة §1 · مبرمجة §2§3"
],
[
"^Taux d'émargement : (.*?) %$",
"نسبة تسجيل الحضور: §1 %"
],
[
"^Tous \\(une page par (.*?)\\)$",
"الكل (صفحة لكل §1)"
],
[
"^peuvent être repris(.*?) (.*?)\\.$",
"يمكن استعادتها§1 §2."
],
[
"^séances émargées \\((.*?)/(.*?)\\)$",
"الحصص المسجّل حضورها (§1/§2)"
],
[
"^Tarifs en vigueur au (.*?)$",
"أجور الساعة السارية في §1"
],
[
"^Viser la paie « (.*?) » \\?$",
"التأشير على رواتب «§1»؟"
],
[
"^· (.*?) refusé(.*?) \\(conflit\\)$",
"· §1 مرفوض (تعارض)"
],
[
"^· (.*?) · (.*?) · (.*?) matière\\(s\\)$",
"· §1 · §2 · §3 مادة"
],
[
"^· fin du semestre le (.*?)$",
"· نهاية السداسي في §1"
],
[
"^Enseignements du (.*?) au (.*?)$",
"التدريس من §1 إلى §2"
],
[
"^Dernière connexion : (.*?)$",
"آخر دخول: §1"
],
[
"^(.*?) séance(.*?) émargée(.*?) sur (.*?)$",
"تم تسجيل الحضور في §1 حصة من §4"
],
[
"^Ordre de paiement · (.*?)$",
"أمر بالدفع · §1"
],
[
"^Saisi par délégation(.*?)$",
"سُجِّل بالنيابة§1"
],
[
"^Séances annulées en (.*?)$",
"الحصص الملغاة في §1"
],
[
"^a publié la semaine (.*?)$",
"نشر أسبوع §1"
],
[
"^· (.*?) sans tarif défini$",
"· §1 دون أجر ساعة محدد"
],
[
"^Émarger les (.*?) séances$",
"تسجيل الحضور في §1 حصص"
],
[
"^Ordre de paiement : (.*?)$",
"أمر بالدفع: §1"
],
[
"^il faut (.*?) par semaine$",
"يلزم §1 في الأسبوع"
],
[
"^(.*?) cours en brouillon$",
"§1 درس في المسودة"
],
[
"^(.*?) toute la semaine\\.$",
"§1 طوال الأسبوع."
],
[
"^(.*?) un jour sans cours$",
"§1 يومًا بدون دروس"
],
[
"^(.*?)Imprimer / exporter$",
"§1طباعة / تصدير"
],
[
"^Mettre (.*?) en cours \\?$",
"جعل §1 جارية؟"
],
[
"^Séances annulées · (.*?)$",
"الحصص الملغاة · §1"
],
[
"^(.*?) / (.*?) · (.*?) programmées$",
"§1 / §2 · §3 مبرمجة"
],
[
"^(.*?) une ligne de paie$",
"§1 سطرًا في الرواتب"
],
[
"^Déjà payé · reste (.*?)$",
"المدفوع · المتبقي §1"
],
[
"^· (.*?) enseignant\\(s\\)$",
"· §1 أستاذ"
],
[
"^· (.*?) refusée\\(s\\) : (.*?)$",
"· §1 مرفوضة: §2"
],
[
"^… et (.*?) autre\\(s\\)\\.$",
"… و§1 أخرى."
],
[
"^Total \\((.*?) séances\\)$",
"المجموع (§1 حصة)"
],
[
"^Édité le (.*?) avec (.*?) · (.*?)$",
"حُرّر في §1 بواسطة §2 · §3"
],
[
"^(.*?) la séance du (.*?) à (.*?)$",
"§1 حصة يوم §2 الساعة §3"
],
[
"^(.*?) séances émargées$",
"§1 حصة سُجّل فيها الحضور"
],
[
"^(.*?)Ordre de paiement$",
"§1أمر بالدفع"
],
[
"^Groupes réunis · (.*?)$",
"الأفواج المجمَّعة · §1"
],
[
"^Jours et horaires(.*?)$",
"الأيام والتوقيتات§1"
],
[
"^Supprimer « (.*?) » \\?$",
"حذف «§1»؟"
],
[
"^· (.*?) refusé\\(s\\) : (.*?)$",
"· §1 مرفوض: §2"
],
[
"^(.*?) (.*?) \\(avant (.*?), (.*?)(.*?) %\\)$",
"§1 §2 (قبل §3، §4§5 %)"
],
[
"^(.*?) un paiement de (.*?)$",
"§1 دفعة بمبلغ §2"
],
[
"^(.*?)Imprimer \\(PDF\\)$",
"§1طباعة (PDF)"
],
[
"^Cours annulés · (.*?)$",
"الدروس الملغاة · §1"
],
[
"^Jours sans cours(.*?)$",
"أيام بدون دروس§1"
],
[
"^Professeur pour (.*?)$",
"أستاذ لـ §1"
],
[
"^Professeurs \\((.*?)\\)$",
"الأساتذة (§1)"
],
[
"^Reprendre (.*?) cours$",
"استعادة §1 درس"
],
[
"^cours recopiés\\.(.*?)$",
"درس منسوخ.§1"
],
[
"^il manquerait \\~(.*?)$",
"سينقص ~§1"
],
[
"^· (.*?) personne\\(s\\)$",
"· §1 شخص"
],
[
"^Émarger (.*?) séances$",
"تسجيل الحضور في §1 حصص"
],
[
"^Tarifs de la (.*?)\\. (.*?)$",
"أجور الساعة في §1. §2"
],
[
"^(.*?) le rôle « (.*?) » (.*?) (.*?)$",
"§1 الدور «§2» §3 §4"
],
[
"^(.*?) · (.*?) · déclaré (.*?)–(.*?)(.*?)$",
"§1 · §2 · المصرّح §3–§4§5"
],
[
"^Mon département(.*?)$",
"قسمي§1"
],
[
"^Payer en lot · (.*?)$",
"دفع جماعي · §1"
],
[
"^Réglé (.*?) · reste (.*?)$",
"سُدّد §1 · المتبقي §2"
],
[
"^heures validées(.*?)$",
"ساعات معتمدة§1"
],
[
"^\\+ Ajouter une (.*?)$",
"+ إضافة §1"
],
[
"^(.*?) \\(rattrapage\\)$",
"§1 (استدراك)"
],
[
"^(.*?) cours (.*?) sur (.*?)(.*?)\\.$",
"§1 درس §2 من §3§4."
],
[
"^(.*?) de (.*?) à (.*?) \\((.*?), (.*?)\\)$",
"§1 من §2 إلى §3 (§4، §5)"
],
[
"^(.*?) un émargement$",
"§1 تسجيل حضور"
],
[
"^(.*?) échec\\(s\\) : (.*?)$",
"§1 فشل: §2"
],
[
"^(.*?)Générer le PDF$",
"§1إنشاء ملف PDF"
],
[
"^· (.*?) refusé\\(s\\)$",
"· §1 مرفوض"
],
[
"^· (.*?) à contrôler$",
"· §1 للتحقق"
],
[
"^\\+ Ajouter un (.*?)$",
"+ إضافة §1"
],
[
"^(.*?) déplacé : (.*?) (.*?)–(.*?)$",
"§1 نُقل: §2 §3–§4"
],
[
"^(.*?) le compte \\?$",
"§1 الحساب؟"
],
[
"^(.*?) matière\\(s\\)$",
"§1 مادة"
],
[
"^(.*?) à partir du (.*?)$",
"§1 ابتداءً من §2"
],
[
"^Conflit avec (.*?)$",
"تعارض مع §1"
],
[
"^· (.*?) en attente$",
"· §1 في الانتظار"
],
[
"^À examiner · (.*?)$",
"للفحص · §1"
],
[
"^(.*?) cours repris$",
"تمت استعادة §1 درس"
],
[
"^Règlements : (.*?)$",
"التسديدات: §1"
],
[
"^situation au (.*?)$",
"الوضعية في §1"
],
[
"^(.*?) \\((.*?)\\) du (.*?) à (.*?)$",
"§1 (§2) من §3 إلى §4"
],
[
"^(.*?) places · (.*?) %$",
"§1 مقعد · §2 %"
],
[
"^(.*?) · (.*?) validées(.*?)$",
"§1 · §2 معتمدة§3"
],
[
"^\\+ Ajouter (.*?) (.*?)$",
"+ إضافة §1 §2"
],
[
"^Année (.*?) créée$",
"تم إنشاء السنة §1"
],
[
"^Commun avec (.*?)$",
"مشتركة مع §1"
],
[
"^Conformes · (.*?)$",
"مطابقة · §1"
],
[
"^Disponible (.*?)–(.*?)$",
"متاح §1–§2"
],
[
"^Demande de (.*?)$",
"طلب من §1"
],
[
"^Disponible (.*?)$",
"متاح §1"
],
[
"^Publiée le (.*?)$",
"نُشر في §1"
],
[
"^Valider (.*?) \\?$",
"اعتماد §1؟"
],
[
"^validées · (.*?)$",
"معتمدة · §1"
],
[
"^(.*?) cours sur (.*?)$",
"§1 درس من أصل §2"
],
[
"^Modifier : (.*?)$",
"تعديل: §1"
],
[
"^Édité avec (.*?)$",
"حُرّر بواسطة §1"
],
[
"^(.*?) % occupée$",
"مشغولة بنسبة §1 %"
],
[
"^(.*?) sur (.*?) \\((.*?)\\)$",
"§1 من §2 (§3)"
],
[
"^(.*?)Semaine du$",
"§1أسبوع"
],
[
"^Avancement(.*?)$",
"التقدم§1"
],
[
"^attendu (.*?) %$",
"المتوقع §1 %"
],
[
"^du (.*?) au (.*?) · (.*?)$",
"من §1 إلى §2 · §3"
],
[
"^Ajouter : (.*?)$",
"إضافة: §1"
],
[
"^(.*?) en retard$",
"§1 متأخرة"
],
[
"^En retard(.*?)$",
"متأخرة§1"
],
[
"^Jusqu'au (.*?)$",
"حتى §1"
],
[
"^Poste de (.*?)$",
"منصب §1"
],
[
"^Tous \\((.*?)\\)$",
"الكل (§1)"
],
[
"^Édité le (.*?)$",
"حُرّر في §1"
],
[
"^édité le (.*?)$",
"حُرّر في §1"
],
[
"^(.*?) à faire$",
"§1 للإنجاز"
],
[
"^Annonces(.*?)$",
"الإعلانات§1"
],
[
"^Page (.*?) / (.*?)$",
"الصفحة §1 / §2"
],
[
"^cours · (.*?)$",
"درس · §1"
],
[
"^salle : (.*?)$",
"القاعة: §1"
],
[
"^Du (.*?) au (.*?)$",
"من §1 إلى §2"
],
[
"^Volume (.*?)$",
"الحجم §1"
],
[
"^du (.*?) au (.*?)$",
"من §1 إلى §2"
],
[
"^Salle (.*?)$",
"القاعة §1"
],
[
"^(.*?)Excel$",
"§1Excel"
],
[
"^(.*?)PDF$",
"§1PDF"
]
];
Object.keys(X).forEach(k=>{if(!(k in A.exact))A.exact[k]=X[k]});
const mo=A.mo||(s=>s),hrs=s=>s.replace(/(\d+) h(?: (\d+))?\b/g,(_,h,m)=>m?h+" س "+m+" د":h+" س");
const cap=c=>{if(c==null)return "";if(!c.trim())return c;const t=typeof tr==="function"?tr(c):c;return t!==c?t:mo(hrs(c))};
A.pats.unshift(...P.map(([rx,ar])=>[new RegExp(rx),(...m)=>ar.replace(/§(\d)/g,(_,n)=>cap(m[+n]))]));
})();
