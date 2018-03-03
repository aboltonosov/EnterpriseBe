﻿#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	УчетСтраховыхВзносовВызовСервера.ВидыДоходовПоСтраховымВзносамОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти


#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Процедура НачальноеЗаполнение() Экспорт
	
	ЗаполнитьВидыДоходовПоСтраховымВзносам();
	
КонецПроцедуры

Процедура ЗаполнитьВидыДоходовПоСтраховымВзносам()
	
	// 4D:ERP для Беларуси, Яна, 30.08.2017 14:23:08 
	// Справочник виды доходов, №15866, № 16534
	
	// 4D:ERP для Беларуси, АлексейЧ, 02.02.2018 11:35:18 
	// Локализовать документ "Начисление зарплаты и взносов", № 15928
	// Добавлено значение реквизита "ВходитВБазуПенсионныйФонд" и "ВходитВБазуППС"
	
	// {	
	ОписатьВидДоходаПоСтраховымВзносамЛокализация("ОблагаетсяЦеликом",					"Доходы, целиком облагаемые страховыми взносами",		Истина,	Истина,	Истина,	Истина, Истина,	Истина,	1); 
	
	// 4D:ERP для Беларуси, АлексейЧ, 02.02.2018 11:35:18 
	// Локализовать документ "Начисление зарплаты и взносов", № 15928
	// {	
	ОписатьВидДоходаПоСтраховымВзносамЛокализация("ОблагаетсяКромеППС",					"Доходы, облагаемые страховыми взносами кроме профессионального пенсионного страхования",		Истина,	Истина,	Истина,	Истина, Истина,	Ложь,	1); 
	// }
	// 4D
	
	ОписатьВидДоходаПоСтраховымВзносамЛокализация("ДоговорыГПХ",						"Договоры гражданско-правового характера",				Истина,	Истина,	Истина,	Истина, Истина,	Истина,	2); 
	ОписатьВидДоходаПоСтраховымВзносамЛокализация("ОблагаетсяФСЗН",						"Входит в базу только для ФСЗН",						Истина,	Истина,	Ложь,	Истина, Истина,	Ложь,	3);
	ОписатьВидДоходаПоСтраховымВзносамЛокализация("ОблагаетсяСтрах",					"Входит в базу только для обязательного страхования",	Ложь,	Ложь,	Истина,	Ложь,	Ложь,	Ложь,	4);
	ОписатьВидДоходаПоСтраховымВзносамЛокализация("БольничныйИзФСЗН",					"Пособия из средств ФСЗН",								Ложь,	Ложь,	Ложь,	Ложь,	Ложь,	Ложь,	5); 
	ОписатьВидДоходаПоСтраховымВзносамЛокализация("ПособияИзФСЗН",						"Пособия за счет средств ФСЗН, не входящие в ПУ-3",		Ложь,	Ложь,	Ложь,	Ложь,	Ложь,	Ложь,	6);
	ОписатьВидДоходаПоСтраховымВзносамЛокализация("НеОблагаетсяЦеликом",				"Не входит в базу ни для одного из отчислений с ФОТ",	Ложь,	Ложь,	Ложь,	Ложь,	Ложь,	Ложь,	7);
	ОписатьВидДоходаПоСтраховымВзносамЛокализация("ОтчисленияТолькоВПенсионныйФонд",	"Отчисления только в Пенсионный фонд",					Ложь,	Ложь,	Ложь,	Ложь,	Истина,	Ложь,	8);

	
	ОписатьВидДоходаПоСтраховымВзносам("НеЯвляетсяОбъектом",												"(не используется)Доходы, не являющиеся объектом обложения страховыми взносами",																Ложь, 	Ложь,	Ложь,	Ложь,	8); 
	ОписатьВидДоходаПоСтраховымВзносам("ПособияЗаСчетФСС",													"(не используется)Государственные пособия обязательного социального страхования, выплачиваемые за счет ФСС",									Ложь, 	Ложь, 	Ложь, 	Ложь,	4);
	ОписатьВидДоходаПоСтраховымВзносам("ПособияЗаСчетФСС_НС",												"(не используется)Государственные пособия по обязательному страхованию от несчастных случаев и профзаболеваний",								Ложь, 	Ложь, 	Ложь, 	Ложь,	5);
	ОписатьВидДоходаПоСтраховымВзносам("ДенежноеДовольствиеВоеннослужащих",									"(не используется)Денежное довольствие военнослужащих и приравненных к ним лиц рядового и начальствующего состава МВД и других ведомств",					Ложь, 	Ложь, 	Ложь, 	Ложь,	19);
	ОписатьВидДоходаПоСтраховымВзносам("НеОблагаетсяЦеликомПрокуроров",										"(не используется)Доходы прокуроров, следователей и судей, целиком не облагаемые страховыми взносами",										Ложь,	Ложь, 	Ложь, 	Ложь,	21); 	
	ОписатьВидДоходаПоСтраховымВзносам("ДенежноеСодержаниеПрокуроров",										"(не используется)Денежное содержание прокуроров, следователей и судей, не облагаемое страховыми взносами в ПФР",								Ложь, 	Истина, Истина, Истина,	20); 	
	ОписатьВидДоходаПоСтраховымВзносам("КомпенсацииОблагаемыеВзносами",										"(не используется)Возмещаемые ФСС компенсации, облагаемые страховыми взносами",																Истина, Истина, Истина, Истина,	9);
	ОписатьВидДоходаПоСтраховымВзносам("КомпенсацииОблагаемыеВзносамиПрокуроров",							"(не используется)Возмещаемые ФСС компенсации, облагаемые страховыми взносами, выплачиваемые прокурорам, следователям и судьям",						Ложь, 	Истина, Истина, Истина, 24); 
	ОписатьВидДоходаПоСтраховымВзносам("Матпомощь",															"(не используется)Материальная помощь, облагаемая страховыми взносами частично",																Истина, Истина, Истина, Истина,	6,	Истина);
	ОписатьВидДоходаПоСтраховымВзносам("МатпомощьПрокуроров",												"(не используется)Материальная помощь прокуроров, следователей и судей, облагаемая страховыми взносами частично",								Ложь, 	Истина, Истина, Истина,	22,	Истина); 
	ОписатьВидДоходаПоСтраховымВзносам("МатпомощьПриРожденииРебенка",										"(не используется)Материальная помощь при рождении ребенка, облагаемая страховыми взносами частично",										Истина, Истина, Истина, Истина,	7,	Истина);
	ОписатьВидДоходаПоСтраховымВзносам("МатпомощьПриРожденииРебенкаПрокуроров",								"(не используется)Материальная помощь при рождении ребенка прокурорам, следователям и судьям, облагаемая страховыми взносами частично",					Ложь, 	Истина, Истина, Истина,	23,	Истина); 
	ОписатьВидДоходаПоСтраховымВзносам("ДоходыСтудентовЗаРаботуВСтудотрядеПоТрудовомуДоговору",				"(не используется)Доходы студентов за работу в студотряде по трудовому договору",															Ложь,	Истина, Истина, Истина,	25); 
	ОписатьВидДоходаПоСтраховымВзносам("ДоходыСтудентовЗаРаботуВСтудотрядеПоГражданскоПравовомуДоговору",	"(не используется)Доходы студентов за работу в студотряде по гражданско-правовому договору",													Ложь, 	Истина, Ложь, 	Ложь,	26);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеАудиовизуальныеПроизведения",								"(не используется)Создание аудиовизуальных произведений (видео-, теле- и кинофильмов)",														Истина,	Истина, Ложь, 	Ложь,	12,	Истина,	Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеГрафическиеПроизведения",									"(не используется)Создание художественно-графических произведений, фоторабот для печати, произведений архитектуры и дизайна",						Истина, Истина, Ложь, 	Ложь,	14,	Истина,	Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеДругиеМузыкальныеПроизведения",							"(не используется)Создание других музыкальных произведений, в том числе подготовленных к опубликованию",										Истина, Истина, Ложь, 	Ложь,	13,	Истина,	Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеИсполнениеПроизведений",									"(не используется)Исполнение произведений литературы и искусства",																			Истина,	Истина, Ложь, 	Ложь,	10,	Истина,	Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеЛитературныеПроизведения",									"(не используется)Создание литературных произведений, в том числе для театра, кино, эстрады и цирка",										Истина, Истина, Ложь, 	Ложь,	15,	Истина,	Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеМузыкальноСценическиеПроизведение",						"(не используется)Создание музыкально-сценических произведений (опер, балетов и др.), симфонических, хоровых, камерных, оригинальной музыки для кино и др.",			Истина,	Истина, Ложь, 	Ложь,	16,	Истина,	Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеНаучныеТруды",												"(не используется)Создание научных трудов и разработок",																						Истина,	Истина, Ложь, 	Ложь,	17,	Истина,	Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеОткрытия",													"(не используется)Открытия, изобретения и создание промышленных образцов (процент суммы дохода, полученного за первые два года использования)", 				Истина,	Истина, Ложь, 	Ложь,	11,	Истина,	Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеСкульптуры",												"(не используется)Создание произведений скульптуры, монументально- декоративной живописи, декоративно-прикладного и оформительского искусства, станковой живописи и др.",	Истина,	Истина, Ложь, 	Ложь,	18,	Истина,	Истина);
	
	ОписатьВидДоходаПоСтраховымВзносам("ОблагаетсяЦеликомНеОблагаемыеФСС_НС",								"(не используется)Доходы, целиком облагаемые страховыми взносами на ОПС, ОМС и соц.страхование, не облагаемые взносами на страхование от несчастных случаев",		Истина, Истина, Истина, Ложь,	27);
	ОписатьВидДоходаПоСтраховымВзносам("ДенежноеСодержаниеПрокуроровНеОблагаемыеФСС_НС",					"(не используется)Денежное содержание прокуроров, следователей и судей, не облагаемое страховыми взносами в ПФР и взносами на страхование от несчастных случаев",		Ложь, 	Истина, Истина, Ложь,	28); 
	ОписатьВидДоходаПоСтраховымВзносам("ДоговорыГПХОблагаемыеФСС_НС",										"(не используется)Договоры гражданско-правового характера, облагаемые взносами на страхование от несчастных случаев",							Истина,	Истина, Ложь, 	Истина,	29); 
	
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеАудиовизуальныеПроизведенияОблагаемыеФСС_НС",				"(не используется)Создание аудиовизуальных произведений (видео-, теле- и кинофильмов), облагаемые взносами на страхование от несчастных случаев",				Истина,	Истина, Ложь, 	Истина,	32,	Истина,	Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеГрафическиеПроизведенияОблагаемыеФСС_НС",					"(не используется)Создание художественно-графических произведений, фоторабот для печати, произведений архитектуры и дизайна, обл.взносами на страхование от несч.случаев",	Истина, Истина, Ложь, 	Истина,	34,	Истина,	Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеДругиеМузыкальныеПроизведенияОблагаемыеФСС_НС",			"(не используется)Создание других музыкальных произведений, в том числе подготовленных к опубликованию, облагаемые взносами на страхование от несчастных случаев",		Истина, Истина, Ложь, 	Истина,	33,	Истина,	Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеИсполнениеПроизведенийОблагаемыеФСС_НС",					"(не используется)Исполнение произведений литературы и искусства, облагаемые взносами на страхование от несчастных случаев",							Истина,	Истина, Ложь, 	Истина,	30,	Истина,	Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеЛитературныеПроизведенияОблагаемыеФСС_НС",					"(не используется)Создание литературных произведений, в том числе для театра, кино, эстрады и цирка, облагаемые взносами на страхование от несчастных случаев",		Истина, Истина, Ложь, 	Истина,	35,	Истина,	Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеМузыкальноСценическиеПроизведениеОблагаемыеФСС_НС",		"(не используется)Создание музыкально-сценических произведений (опер, балетов и др.), симфонических, хоровых и др., обл.взносами на страхование от несч.случаев",		Истина,	Истина, Ложь, 	Истина,	36,	Истина,	Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеНаучныеТрудыОблагаемыеФСС_НС",								"(не используется)Создание научных трудов и разработок, облагаемые взносами на страхование от несчастных случаев",								Истина,	Истина, Ложь, 	Истина,	37,	Истина,	Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеОткрытияОблагаемыеФСС_НС",									"(не используется)Открытия, изобретения и создание промышленных образцов, облагаемые взносами на страхование от несчастных случаев",		 				Истина,	Истина, Ложь, 	Истина,	31,	Истина,	Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеСкульптурыОблагаемыеФСС_НС",								"(не используется)Создание произведений скульптуры, монументально-декоративной живописи и др., облагаемые взносами на страхование от несчастных случаев",			Истина,	Истина, Ложь, 	Истина,	38,	Истина,	Истина);
	// }
	// 4D
		
КонецПроцедуры

Процедура ОписатьВидДоходаПоСтраховымВзносам(ИмяПредопределенныхДанных, Наименование, ВходитВБазуПФР, ВходитВБазуФОМС, ВходитВБазуФСС, ВходитВБазуФСС_НС, ДопУпорядочивание = 0, ОблагаетсяВзносамиЧастично = Ложь, АвторскиеВознаграждения = Ложь)

	СсылкаПредопределенного = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыДоходовПоСтраховымВзносам." + ИмяПредопределенныхДанных);
	Если ЗначениеЗаполнено(СсылкаПредопределенного) Тогда
		Объект = СсылкаПредопределенного.ПолучитьОбъект();
	Иначе
		Объект = Справочники.ВидыДоходовПоСтраховымВзносам.СоздатьЭлемент();
		Объект.ИмяПредопределенныхДанных = ИмяПредопределенныхДанных;
	КонецЕсли;

	Объект.Наименование = Наименование;
	
	Если Объект.ВходитВБазуПФР <> ВходитВБазуПФР Тогда
		Объект.ВходитВБазуПФР = ВходитВБазуПФР
	КонецЕсли;
	Если Объект.ВходитВБазуФОМС <> ВходитВБазуФОМС Тогда
		Объект.ВходитВБазуФОМС = ВходитВБазуФОМС
	КонецЕсли;
	Если Объект.ВходитВБазуФСС <> ВходитВБазуФСС Тогда
		Объект.ВходитВБазуФСС = ВходитВБазуФСС
	КонецЕсли;
	Если Объект.ВходитВБазуФСС_НС <> ВходитВБазуФСС_НС Тогда
		Объект.ВходитВБазуФСС_НС = ВходитВБазуФСС_НС
	КонецЕсли;
	Если Объект.ОблагаетсяВзносамиЧастично <> ОблагаетсяВзносамиЧастично Тогда
		Объект.ОблагаетсяВзносамиЧастично = ОблагаетсяВзносамиЧастично
	КонецЕсли;
	Если Объект.АвторскиеВознаграждения <> АвторскиеВознаграждения Тогда
		Объект.АвторскиеВознаграждения = АвторскиеВознаграждения
	КонецЕсли;
	Если ЗначениеЗаполнено(ДопУпорядочивание) И Не ЗначениеЗаполнено(Объект.РеквизитДопУпорядочивания) Тогда
		Объект.РеквизитДопУпорядочивания = ДопУпорядочивание
	КонецЕсли;

	Если Объект.Модифицированность() Тогда
		
		Объект.ДополнительныеСвойства.Вставить("ЗаписьОбщихДанных");
		Объект.ОбменДанными.Загрузка = Истина;
		Объект.Записать();
		
	КонецЕсли;

КонецПроцедуры

// 4D:ERP для Беларуси, Яна, 30.08.2017 14:23:08 
// справочник виды доходов, №15866 
// {
Процедура ОписатьВидДоходаПоСтраховымВзносамЛокализация(ИмяПредопределенныхДанных, Наименование, ВходитВБазуПС, ВходитВБазуСС, ВходитВБазуБелгосстрах, ВходитВБазуФСЗН, ВходитВБазуПенсионныйФонд, ВходитВБазуППС, ДопУпорядочивание = 0 )

	СсылкаПредопределенного = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыДоходовПоСтраховымВзносам." + ИмяПредопределенныхДанных);
	Если ЗначениеЗаполнено(СсылкаПредопределенного) Тогда
		Объект = СсылкаПредопределенного.ПолучитьОбъект();
	Иначе
		Объект = Справочники.ВидыДоходовПоСтраховымВзносам.СоздатьЭлемент();
		Объект.ИмяПредопределенныхДанных = ИмяПредопределенныхДанных;
	КонецЕсли;

	Объект.Наименование = Наименование;
	
	Если Объект.ВходитВБазуФСЗН <> ВходитВБазуФСЗН Тогда
		Объект.ВходитВБазуФСЗН = ВходитВБазуФСЗН
	КонецЕсли;
	
	Если Объект.ВходитВБазуПС <> ВходитВБазуПС Тогда
		Объект.ВходитВБазуПС = ВходитВБазуПС
	КонецЕсли;
	
	Если Объект.ВходитВБазуСС <> ВходитВБазуСС Тогда
		Объект.ВходитВБазуСС = ВходитВБазуСС
	КонецЕсли;

	Если Объект.ВходитВБазуБелгосстрах <> ВходитВБазуБелгосстрах Тогда
		Объект.ВходитВБазуБелгосстрах = ВходитВБазуБелгосстрах
	КонецЕсли;
	 
	// 4D:ERP для Беларуси, АлексейЧ, 02.02.2018 11:27:32 
	// <описание>, №
	// {
	Если Объект.ВходитВБазуПенсионныйФонд <> ВходитВБазуПенсионныйФонд Тогда
		Объект.ВходитВБазуПенсионныйФонд = ВходитВБазуПенсионныйФонд
	КонецЕсли;
	
	Если Объект.ВходитВБазуППС <> ВходитВБазуППС Тогда
		Объект.ВходитВБазуППС = ВходитВБазуППС
	КонецЕсли;
	
	// }
	// 4D
	
	Если ЗначениеЗаполнено(ДопУпорядочивание) И Не ЗначениеЗаполнено(Объект.РеквизитДопУпорядочивания) Тогда
		Объект.РеквизитДопУпорядочивания = ДопУпорядочивание
	КонецЕсли;

	Если Объект.Модифицированность() Тогда
		
		Объект.ДополнительныеСвойства.Вставить("ЗаписьОбщихДанных");
		Объект.Записать();
		
	КонецЕсли;

КонецПроцедуры
// }
// 4D

Функция НеДоступныеЭлементыПоЗначениямФункциональныхОпций() Экспорт
	
	НеДоступныеЗначения = Новый Массив;
	
	ИмяОпции = "ИспользоватьРасчетДенежногоСодержанияПрокуроров";
	ФункциональнаяОпцияИспользуется =
		(Метаданные.ФункциональныеОпции.Найти(ИмяОпции) <> Неопределено);
		
	Если НЕ ФункциональнаяОпцияИспользуется
		ИЛИ НЕ ПолучитьФункциональнуюОпцию(ИмяОпции) Тогда
		
		НеДоступныеЗначения.Добавить(Справочники.ВидыДоходовПоСтраховымВзносам.КомпенсацииОблагаемыеВзносамиПрокуроров);
		НеДоступныеЗначения.Добавить(Справочники.ВидыДоходовПоСтраховымВзносам.ДенежноеСодержаниеПрокуроров);
		НеДоступныеЗначения.Добавить(Справочники.ВидыДоходовПоСтраховымВзносам.ДенежноеСодержаниеПрокуроровНеОблагаемыеФСС_НС);
		НеДоступныеЗначения.Добавить(Справочники.ВидыДоходовПоСтраховымВзносам.НеОблагаетсяЦеликомПрокуроров);
		НеДоступныеЗначения.Добавить(Справочники.ВидыДоходовПоСтраховымВзносам.МатпомощьПрокуроров);
		НеДоступныеЗначения.Добавить(Справочники.ВидыДоходовПоСтраховымВзносам.МатпомощьПриРожденииРебенкаПрокуроров);
		
	КонецЕсли; 
	
	ИмяОпции = "ИспользуетсяТрудСтудентов";
	ФункциональнаяОпцияИспользуется =
		(Метаданные.ФункциональныеОпции.Найти(ИмяОпции) <> Неопределено);
		
	Если НЕ ФункциональнаяОпцияИспользуется
		ИЛИ НЕ ПолучитьФункциональнуюОпцию(ИмяОпции) Тогда
		
		НеДоступныеЗначения.Добавить(Справочники.ВидыДоходовПоСтраховымВзносам.ДоходыСтудентовЗаРаботуВСтудотрядеПоГражданскоПравовомуДоговору);
		НеДоступныеЗначения.Добавить(Справочники.ВидыДоходовПоСтраховымВзносам.ДоходыСтудентовЗаРаботуВСтудотрядеПоТрудовомуДоговору);
		
	КонецЕсли; 
	
	ИмяОпции = "ИспользоватьВоеннуюСлужбу";
	ФункциональнаяОпцияИспользуется =
		(Метаданные.ФункциональныеОпции.Найти(ИмяОпции) <> Неопределено);
		
	Если НЕ ФункциональнаяОпцияИспользуется
		ИЛИ НЕ ПолучитьФункциональнуюОпцию(ИмяОпции) Тогда
		
		НеДоступныеЗначения.Добавить(Справочники.ВидыДоходовПоСтраховымВзносам.ДенежноеДовольствиеВоеннослужащих);
		
	КонецЕсли; 
	
	Возврат НеДоступныеЗначения;
	
КонецФункции

#КонецОбласти

#КонецЕсли
