﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Процедура СоздатьУдержанияПоНастройкам(НастройкиРасчетаЗарплаты = Неопределено, КоллекторУдержаний = Неопределено, ПараметрыПланаВидовРасчета = Неопределено) Экспорт
	
	Если НастройкиРасчетаЗарплаты = Неопределено Тогда
		НастройкиРасчетаЗарплаты = РасчетЗарплатыРасширенный.НастройкиРасчетаЗарплаты();
	КонецЕсли;
	
	Если ПараметрыПланаВидовРасчета = Неопределено Тогда
		ПараметрыПланаВидовРасчета = РасчетЗарплатыРасширенный.ОписаниеПараметровПланаВидовРасчета();
	КонецЕсли;
	
	ЗаписыватьУдержания = Ложь;
	Если КоллекторУдержаний = Неопределено Тогда
		// Соответствие, в которое будем накапливать объекты для последующей "пакетной" записи.
		КоллекторУдержаний = Новый Соответствие;
		ЗаписыватьУдержания = Истина;
	КонецЕсли;
	
	СвойстваУдержаний = СвойстваУдержанийПоКатегориям();
	
	// Профсоюзные взносы
	Если НастройкиРасчетаЗарплаты.ИспользоватьПрофсоюзныеВзносы Тогда
		Описание = ОписаниеУдержания();
		Описание.КатегорияУдержания	= Перечисления.КатегорииУдержаний.ПрофсоюзныеВзносы;
		ЗаполнитьЗначенияСвойств(Описание, СвойстваУдержаний[Перечисления.КатегорииУдержаний.ПрофсоюзныеВзносы]);
		Описание.Код					= НСтр("ru = 'ПРФВЗ'");
		Описание.Наименование			= НСтр("ru = 'Профсоюзные взносы'");
		Описание.КраткоеНаименование 	= НСтр("ru = 'Профвзносы'");
		Описание.ФормулаРасчета			= "РасчетнаяБаза * ПроцентПрофсоюзныхВзносов / 100";
		СоздатьИзменитьУдержанияПоОписанию(КоллекторУдержаний, Описание);
	Иначе
		ОтключитьИспользованиеУдержания(КоллекторУдержаний, Перечисления.КатегорииУдержаний.ПрофсоюзныеВзносы);
	КонецЕсли;
	
	// Исполнительные документы
	Если НастройкиРасчетаЗарплаты.ИспользоватьИсполнительныеЛисты Тогда
		// Исполнительный лист
		Описание = ОписаниеУдержания();
		Описание.КатегорияУдержания			= Перечисления.КатегорииУдержаний.ИсполнительныйЛист;
		ЗаполнитьЗначенияСвойств(Описание, СвойстваУдержаний[Перечисления.КатегорииУдержаний.ИсполнительныйЛист]);
		Описание.Код						= НСтр("ru = 'ИСПДК'");
		Описание.Наименование				= НСтр("ru = 'Удержание по исполнительному документу'");
		Описание.КраткоеНаименование 		= НСтр("ru = 'Исп. лист'");
		СоздатьИзменитьУдержанияПоОписанию(КоллекторУдержаний, Описание);
		
		// Вознаграждение платежному агенту.
		Описание = ОписаниеУдержания();
		Описание.КатегорияУдержания			= Перечисления.КатегорииУдержаний.ВознаграждениеПлатежногоАгента;
		ЗаполнитьЗначенияСвойств(Описание, СвойстваУдержаний[Перечисления.КатегорииУдержаний.ВознаграждениеПлатежногоАгента]);
		Описание.Код						= НСтр("ru = 'АГЕНТ'");
		Описание.Наименование				= НСтр("ru = 'Вознаграждение платежного агента'");
		Описание.КраткоеНаименование 		= НСтр("ru = 'Возн. плат. агента'");
		СоздатьИзменитьУдержанияПоОписанию(КоллекторУдержаний, Описание);
		
		// Создание тарифов платежных агентов.
		Справочники.ТарифыПлатежныхАгентов.СоздатьТарифыПоНастройкам(НастройкиРасчетаЗарплаты);
	Иначе
		ОтключитьИспользованиеУдержания(КоллекторУдержаний, Перечисления.КатегорииУдержаний.ИсполнительныйЛист);
		ОтключитьИспользованиеУдержания(КоллекторУдержаний, Перечисления.КатегорииУдержаний.ВознаграждениеПлатежногоАгента);
	КонецЕсли;
	
	// ДСВ
	Если НастройкиРасчетаЗарплаты.ИспользоватьДСВ Тогда
		Описание = ОписаниеУдержания();
		Описание.КатегорияУдержания			= Перечисления.КатегорииУдержаний.ДСВ;
		ЗаполнитьЗначенияСвойств(Описание, СвойстваУдержаний[Перечисления.КатегорииУдержаний.ДСВ]);
		Описание.Код						= НСтр("ru = 'ДСВЗН'");
		Описание.Наименование				= НСтр("ru = 'Добровольные страховые взносы'");
		Описание.КраткоеНаименование 		= НСтр("ru = 'Добр. страх. взносы'");
		Описание.ФормулаРасчета				= "РасчетнаяБазаСтраховыеВзносы * ПроцентДСВ / 100";
		СоздатьИзменитьУдержанияПоОписанию(КоллекторУдержаний, Описание);
	Иначе
		ОтключитьИспользованиеУдержания(КоллекторУдержаний, Перечисления.КатегорииУдержаний.ДСВ);
	КонецЕсли;
	
	// Добровольные взносы в НПФ
	Если НастройкиРасчетаЗарплаты.ИспользоватьДобровольныеВзносыВНПФ Тогда
		Описание = ОписаниеУдержания();
		Описание.КатегорияУдержания			= Перечисления.КатегорииУдержаний.ДобровольныеВзносыВНПФ;
		ЗаполнитьЗначенияСвойств(Описание, СвойстваУдержаний[Перечисления.КатегорииУдержаний.ДобровольныеВзносыВНПФ]);
		Описание.Код						= НСтр("ru = 'ДВНПФ'");
		Описание.Наименование				= НСтр("ru = 'Добровольные взносы в НПФ'");
		Описание.КраткоеНаименование 		= НСтр("ru = 'Добр. взносы НПФ'");
		Описание.ФормулаРасчета				= "РасчетнаяБазаСтраховыеВзносы * ПроцентНПФ / 100";
		СоздатьИзменитьУдержанияПоОписанию(КоллекторУдержаний, Описание);
	Иначе
		ОтключитьИспользованиеУдержания(КоллекторУдержаний, Перечисления.КатегорииУдержаний.ДобровольныеВзносыВНПФ);
	КонецЕсли;
	
	// Удержание в счет возмещения ущерба.
	Описание = ОписаниеУдержания();
	Описание.КатегорияУдержания			= Перечисления.КатегорииУдержаний.УдержаниеВСчетРасчетовПоПрочимОперациям;
	ЗаполнитьЗначенияСвойств(Описание, СвойстваУдержаний[Перечисления.КатегорииУдержаний.УдержаниеВСчетРасчетовПоПрочимОперациям]);
	Описание.Код						= НСтр("ru = 'ВЗМУЩ'");
	Описание.Наименование				= НСтр("ru = 'Удержание в счет возмещения ущерба'");
	Описание.КраткоеНаименование 		= НСтр("ru = 'Возмещ. ущерба'");
	Описание.ФормулаРасчета 			= "";
	Описание.Рассчитывается 			= Ложь;
	Описание.СсылкаНаОбъект = ПараметрыПланаВидовРасчета.СсылкиНачисленийУдержаний.УдержаниеВСчетВозмещенияУщерба;
	Описание.Отбор = "Ссылка";
	Если ПараметрыПланаВидовРасчета.ИспользоватьУдержаниеВСчетВозмещенияУщерба Тогда
		СоздатьИзменитьУдержанияПоОписанию(КоллекторУдержаний, Описание);
		ПараметрыПланаВидовРасчета.СсылкиНачисленийУдержаний.УдержаниеВСчетВозмещенияУщерба = Описание.СсылкаНаОбъект;
	ИначеЕсли ПараметрыПланаВидовРасчета.НачальнаяНастройкаПрограммы Тогда
		Отбор = Новый Структура("Ссылка", Описание.СсылкаНаОбъект);
		ОтключитьИспользованиеУдержания(КоллекторУдержаний, Перечисления.КатегорииУдержаний.УдержаниеВСчетРасчетовПоПрочимОперациям, Отбор);
	КонецЕсли;
	
	// Удержания по ученическому договору.
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ОбучениеРазвитие") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ОбучениеРазвитие");
		Модуль.СоздатьОтключитьУдержаниеПоУченическомуДоговору(КоллекторУдержаний);
	КонецЕсли;
	
	// Удержания за неотработанные дни отпуска
	НастройкиПрограммы = ЗарплатаКадрыРасширенный.НастройкиПрограммыБюджетногоУчреждения();
	Если НастройкиПрограммы.ИспользоватьРасчетСохраняемогоДенежногоСодержания Тогда
		КатегорияУдержания = Перечисления.КатегорииУдержаний.ДенежноеСодержаниеУдержаниеЗаНеотработанныеДниОтпуска;
	Иначе
		КатегорияУдержания = Перечисления.КатегорииУдержаний.УдержаниеЗаНеотработанныеДниОтпуска;
	КонецЕсли;
	Если НастройкиРасчетаЗарплаты.СпособУдержанияИзлишнеНачисленныхОтпускных = ПредопределенноеЗначение("Перечисление.СпособыУдержанияИзлишнеНачисленныхОтпускных.Удержание") Тогда
		
		Описание = ОписаниеУдержания();
		Описание.КатегорияУдержания = КатегорияУдержания;
		Описание.Отбор = "КатегорияУдержания"; 
		СоздатьИзменитьУдержанияПоОписанию(КоллекторУдержаний, Описание);
	Иначе
		ОтключитьИспользованиеУдержания(КоллекторУдержаний, КатегорияУдержания);
	КонецЕсли;
	
	Если ЗаписыватьУдержания Тогда
		РасчетЗарплатыРасширенный.ЗаписатьПакетВидовРасчета(КоллекторУдержаний);
	КонецЕсли;
	
КонецПроцедуры

// Процедура создает в плане видов расчета элементы для отпуска и компенсации, 
// используемые в документе "Отпуск" и "Увольнение".
//
Процедура СоздатьУдержаниеЗаНеотработанныеДниОтпуска(ВидОтпуска, НаименованиеОтпуска, ДополнениеКода, КоллекторУдержаний, ДенежноеСодержание = Ложь) Экспорт
	
	СвойстваУдержаний = СвойстваУдержанийПоКатегориям();
	
	НастройкиРасчетаЗарплаты = РасчетЗарплатыРасширенный.НастройкиРасчетаЗарплаты();
	
	Если ДенежноеСодержание Тогда
		
		НастройкиПрограммы = ЗарплатаКадрыРасширенный.НастройкиПрограммыБюджетногоУчреждения();
		
		КатегорияУдержания	= Перечисления.КатегорииУдержаний.ДенежноеСодержаниеУдержаниеЗаНеотработанныеДниОтпуска;
		Если НастройкиПрограммы.ИспользоватьРасчетСохраняемогоДенежногоСодержания
			И НастройкиРасчетаЗарплаты.СпособУдержанияИзлишнеНачисленныхОтпускных = ПредопределенноеЗначение("Перечисление.СпособыУдержанияИзлишнеНачисленныхОтпускных.Удержание") Тогда
			Описание = ОписаниеУдержания();
			Описание.КатегорияУдержания = КатегорияУдержания;
			ЗаполнитьЗначенияСвойств(Описание, СвойстваУдержаний[Перечисления.КатегорииУдержаний.ДенежноеСодержаниеУдержаниеЗаНеотработанныеДниОтпуска]);
			Описание.Наименование		= СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Удержание за неотраб. отпуск (%1)'"), НаименованиеОтпуска); 
			Описание.КраткоеНаименование = КраткоеНаименованиеУдержанияПоВидуОтпуска(ВидОтпуска);
			Описание.Код 				= СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'УОТ%1'"), ДополнениеКода);
			Описание.ФормулаРасчета		= "ОКР(СохраняемоеДенежноеСодержание / СреднемесячноеКоличествоКалендарныхДнейОтпускаГосслужащих, 2) * КоличествоДнейКомпенсации";
			Описание.ВидОтпуска			= ВидОтпуска; 
			Описание.Отбор				= "ВидОтпуска,КатегорияУдержания"; 
			СоздатьИзменитьУдержанияПоОписанию(КоллекторУдержаний, Описание);
		Иначе
			ОтключитьИспользованиеУдержания(КоллекторУдержаний, КатегорияУдержания);
		КонецЕсли;
		
	Иначе
		
		КатегорияУдержания = Перечисления.КатегорииУдержаний.УдержаниеЗаНеотработанныеДниОтпуска;
		Если НастройкиРасчетаЗарплаты.СпособУдержанияИзлишнеНачисленныхОтпускных = ПредопределенноеЗначение("Перечисление.СпособыУдержанияИзлишнеНачисленныхОтпускных.Удержание") Тогда
			Описание = ОписаниеУдержания();
			Описание.КатегорияУдержания = КатегорияУдержания;
			ЗаполнитьЗначенияСвойств(Описание, СвойстваУдержаний[Перечисления.КатегорииУдержаний.УдержаниеЗаНеотработанныеДниОтпуска]);
			Описание.Наименование		= СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Удержание за неотработанный отпуск (%1)'"), НаименованиеОтпуска); 
			Описание.КраткоеНаименование = КраткоеНаименованиеУдержанияПоВидуОтпуска(ВидОтпуска);
			Описание.Код 				= СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'УОТ%1'"), ДополнениеКода);
			Описание.ФормулаРасчета		= "СреднийЗаработокОбщий * КоличествоДнейКомпенсации";
			Описание.ВидОтпуска			= ВидОтпуска; 
			Описание.Отбор				= "ВидОтпуска,КатегорияУдержания"; 
			СоздатьИзменитьУдержанияПоОписанию(КоллекторУдержаний, Описание);
		Иначе
			ОтключитьИспользованиеУдержания(КоллекторУдержаний, КатегорияУдержания);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Функция КраткоеНаименованиеУдержанияПоВидуОтпуска(ВидОтпуска)
	
	НаименованиеУдержания = "";
	
	Если ВидОтпуска = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыОтпусков.ОтпускПострадавшимВАварииЧАЭС") Тогда
		НаименованиеУдержания = НСтр("ru = 'Неотраб. отп. ЧАЭС'")
	ИначеЕсли ВидОтпуска = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыОтпусков.ОтпускУчебный") Тогда
		НаименованиеУдержания = НСтр("ru = 'Неотраб. учебн. отп.'")
	ИначеЕсли ВидОтпуска = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыОтпусков.ОтпускБезОплатыУчебный") Тогда
		НаименованиеУдержания = НСтр("ru = 'Неотраб. учебн. отп. б/о'")
	ИначеЕсли ВидОтпуска = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыОтпусков.Основной") Тогда
		НаименованиеУдержания = НСтр("ru = 'Неотраб. отпуск'")
	ИначеЕсли ВидОтпуска = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыОтпусков.ОтпускЗаСвойСчет") Тогда
		НаименованиеУдержания = НСтр("ru = 'Неотраб. отп. за св. сч.'")
	ИначеЕсли ВидОтпуска = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыОтпусков.ОтпускБезОплатыПоТКРФ") Тогда
		НаименованиеУдержания = НСтр("ru = 'Неотраб. отп. без опл.'")
	ИначеЕсли ВидОтпуска = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыОтпусков.ОтпускЗаВредность") Тогда
		НаименованиеУдержания = НСтр("ru = 'Неотраб. отп. за вредн.'")
	ИначеЕсли ВидОтпуска = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыОтпусков.ОтпускЗаВыслугуЛет") Тогда
		НаименованиеУдержания = НСтр("ru = 'Неотраб. отп. высл. лет'")
	ИначеЕсли ВидОтпуска = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыОтпусков.ОтпускЗаВыслугуЛетНаГосударственнойСлужбе") Тогда
		НаименованиеУдержания = НСтр("ru = 'Неотраб. отп. высл. лет'")
	ИначеЕсли ВидОтпуска = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыОтпусков.ОтпускНаСанаторноКурортноеЛечение") Тогда
		НаименованиеУдержания = НСтр("ru = 'Неотраб. отп. на лечение'")
	ИначеЕсли ВидОтпуска = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыОтпусков.Северный") Тогда
		НаименованиеУдержания = НСтр("ru = 'Неотраб. северн. отп.'")
	КонецЕсли;
	
	Возврат НаименованиеУдержания;
	
КонецФункции

// Создает и заполняет соответствие, ключом которого является категория удержания, 
// а значением — структура значений, определяющая заполнение свойств удержания данной категории.
//
// Параметры:
//	- КатегорияУдержания - ПеречислениеСсылка.КатегорииУдержаний
//
// Возвращаемое значение - соответствие.
//
Функция СвойстваУдержанийПоКатегориям() Экспорт
	
	СвойстваПоКатегориям = Новый Соответствие;
	
	// Значение по умолчанию
	СвойстваПоКатегориям.Вставить(Перечисления.КатегорииУдержаний.ПустаяСсылка(), СвойстваУдержанияПоКатегорииПоУмолчанию());
	
	// Профсоюзные взносы
	Описание = СвойстваУдержанияПоКатегорииПоУмолчанию();
	Описание.СпособВыполненияУдержания = Перечисления.СпособыВыполненияУдержаний.ЕжемесячноПриОкончательномРасчете;
	Описание.СпособРасчета = Перечисления.СпособыРасчетаУдержаний.ПроизвольнаяФормула;
	Описание.ВидОперацииПоЗарплате = Перечисления.ВидыОперацийПоЗарплате.Профвзносы;
	Описание.НедоступныеСвойства.Добавить("СпособВыполненияУдержания");
	Описание.ОтборБазовых = Новый Структура("КатегорияНачисления", КатегорииБазовыхНачисленийПрофсоюзныхВзносов());
	СвойстваПоКатегориям.Вставить(Перечисления.КатегорииУдержаний.ПрофсоюзныеВзносы, Описание);
	
	// Исполнительный лист
	Описание = СвойстваУдержанияПоКатегорииПоУмолчанию();
	Описание.СпособВыполненияУдержания = Перечисления.СпособыВыполненияУдержаний.ЕжемесячноПриОкончательномРасчете;
	Описание.СпособРасчета = Перечисления.СпособыРасчетаУдержаний.ИсполнительныйЛист;
	Описание.ВидОперацииПоЗарплате = Перечисления.ВидыОперацийПоЗарплате.АлиментыПрочиеИсполнительныеЛисты;
	Описание.ОчередностьРасчета = 1;
	Описание.НедоступныеСвойства.Добавить("СпособВыполненияУдержания");
	Описание.ОтборБазовых = Новый Структура("КатегорияНачисления", КатегорииБазовыхНачисленийУдержанийПоИсполнительнымДокументам());
	Описание.СтратегияОтраженияВУчете = Перечисления.СтратегииОтраженияВУчетеНачисленийУдержаний.ПоБазовымРасчетам;
	СвойстваПоКатегориям.Вставить(Перечисления.КатегорииУдержаний.ИсполнительныйЛист, Описание);
	
	// Вознаграждение платежного агента.
	Описание = СвойстваУдержанияПоКатегорииПоУмолчанию();
	Описание.СпособВыполненияУдержания = Перечисления.СпособыВыполненияУдержаний.ЕжемесячноПриОкончательномРасчете;
	Описание.СпособРасчета = Перечисления.СпособыРасчетаУдержаний.ВознаграждениеПлатежногоАгента;
	Описание.ВидОперацииПоЗарплате = Перечисления.ВидыОперацийПоЗарплате.ВознаграждениеПлатежногоАгента;
	Описание.ОчередностьРасчета = 2;
	Описание.НедоступныеСвойства.Добавить("СпособВыполненияУдержания");
	Описание.СтратегияОтраженияВУчете = Перечисления.СтратегииОтраженияВУчетеНачисленийУдержаний.ПоБазовымРасчетам;
	СвойстваПоКатегориям.Вставить(Перечисления.КатегорииУдержаний.ВознаграждениеПлатежногоАгента, Описание);
	
	// Удержание за неотработанные дни отпуска.
	Описание = СвойстваУдержанияПоКатегорииПоУмолчанию();
	Описание.СпособВыполненияУдержания = Перечисления.СпособыВыполненияУдержаний.ПоОтдельномуДокументуДоОкончательногоРасчета;
	Описание.ВидДокументаУдержания = Перечисления.ВидыДокументовУдержания.Увольнение;
	Описание.СпособРасчета = Перечисления.СпособыРасчетаУдержаний.ПроизвольнаяФормула;
	Описание.ФормулаРасчета = "СреднийЗаработокОбщий * КоличествоДнейКомпенсации";
	Описание.ВидОперацииПоЗарплате = Перечисления.ВидыОперацийПоЗарплате.УдержаниеЗаОтпуск;
	Описание.НедоступныеСвойства.Добавить("СпособВыполненияУдержания");
	СвойстваПоКатегориям.Вставить(Перечисления.КатегорииУдержаний.УдержаниеЗаНеотработанныеДниОтпуска, Описание);
	
	// Удержание за неотработанные дни отпуска, сохраняемое денежное содержание.
	Описание = СвойстваУдержанияПоКатегорииПоУмолчанию();
	Описание.СпособВыполненияУдержания = Перечисления.СпособыВыполненияУдержаний.ПоОтдельномуДокументуДоОкончательногоРасчета;
	Описание.ВидДокументаУдержания = Перечисления.ВидыДокументовУдержания.Увольнение;
	Описание.СпособРасчета = Перечисления.СпособыРасчетаУдержаний.ПроизвольнаяФормула;
	Описание.ФормулаРасчета = "ОКР(СохраняемоеДенежноеСодержание / СреднемесячноеКоличествоКалендарныхДнейОтпускаГосслужащих, 2) * КоличествоДнейКомпенсации";
	Описание.ВидОперацииПоЗарплате = Перечисления.ВидыОперацийПоЗарплате.УдержаниеЗаОтпуск;
	Описание.НедоступныеСвойства.Добавить("СпособВыполненияУдержания");
	СвойстваПоКатегориям.Вставить(Перечисления.КатегорииУдержаний.ДенежноеСодержаниеУдержаниеЗаНеотработанныеДниОтпуска, Описание);
	
	// Прочее удержание в пользу третих лиц.
	Описание = СвойстваУдержанияПоКатегорииПоУмолчанию();
	Описание.СпособВыполненияУдержания = Перечисления.СпособыВыполненияУдержаний.ЕжемесячноПриОкончательномРасчете;
	Описание.СпособРасчета = Перечисления.СпособыРасчетаУдержаний.ПроизвольнаяФормула;
	Описание.ВидОперацииПоЗарплате = Перечисления.ВидыОперацийПоЗарплате.ПрочиеУдержания;
	СвойстваПоКатегориям.Вставить(Перечисления.КатегорииУдержаний.ПрочееУдержаниеВПользуТретьихЛиц, Описание);
	
	// Прочее удержание в пользу компании.
	Описание = СвойстваУдержанияПоКатегорииПоУмолчанию();
	Описание.СпособВыполненияУдержания = Перечисления.СпособыВыполненияУдержаний.ЕжемесячноПриОкончательномРасчете;
	Описание.СпособРасчета = Перечисления.СпособыРасчетаУдержаний.ПроизвольнаяФормула;
	Описание.ВидОперацииПоЗарплате = Перечисления.ВидыОперацийПоЗарплате.ВозмещениеУщерба;
	СвойстваПоКатегориям.Вставить(Перечисления.КатегорииУдержаний.УдержаниеВСчетРасчетовПоПрочимОперациям, Описание);
	
	// ДСВ
	Описание = СвойстваУдержанияПоКатегорииПоУмолчанию();
	Описание.СпособВыполненияУдержания = Перечисления.СпособыВыполненияУдержаний.ЕжемесячноПриОкончательномРасчете;
	Описание.СпособРасчета = Перечисления.СпособыРасчетаУдержаний.ПроизвольнаяФормула;
	Описание.ВидОперацииПоЗарплате = Перечисления.ВидыОперацийПоЗарплате.ДСВ;
	СвойстваПоКатегориям.Вставить(Перечисления.КатегорииУдержаний.ДСВ, Описание);
	
	// ДобровольныеВзносыВНПФ
	Описание = СвойстваУдержанияПоКатегорииПоУмолчанию();
	Описание.СпособВыполненияУдержания = Перечисления.СпособыВыполненияУдержаний.ЕжемесячноПриОкончательномРасчете;
	Описание.СпособРасчета = Перечисления.СпособыРасчетаУдержаний.ПроизвольнаяФормула;
	Описание.ВидОперацииПоЗарплате = Перечисления.ВидыОперацийПоЗарплате.ДобровольныеВзносыВНПФ;
	СвойстваПоКатегориям.Вставить(Перечисления.КатегорииУдержаний.ДобровольныеВзносыВНПФ, Описание);
	
	// По ученическому договору
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ОбучениеРазвитие") Тогда
	    Модуль = ОбщегоНазначения.ОбщийМодуль("ОбучениеРазвитие");
		Модуль.ДополнитьСвойстваПоКатегориямУдержаниемПоУченическимДоговорам(СвойстваПоКатегориям, СвойстваУдержанияПоКатегорииПоУмолчанию());
	КонецЕсли;
	
	Возврат СвойстваПоКатегориям;
	
КонецФункции

// Функция составляет массив действующих удержаний, 
// выполняемых документом определенного вида.
//
// Параметры:
//	ВидДокумента - ПеречислениеСсылка.ВидыДокументовУдержания
// 		или просто ссылка на документ.
//	ДополнительныйОтбор - необязательный, 
//		структура для уточнения особенностей подходящих начислений.
//
// Возвращаемое значение - массив начислений.
//
Функция УдержанияПоВидуДокумента(ВидДокумента, ДополнительныйОтбор = Неопределено) Экспорт
	
	Если ТипЗнч(ВидДокумента) <> Тип("ПеречислениеСсылка.ВидыДокументовУдержания") Тогда
		ВидДокумента = РасчетЗарплатыРасширенный.ВидДокументаУдержанияПоДокументу(ВидДокумента);
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	Удержания.Ссылка
	|ИЗ
	|	ПланВидовРасчета.Удержания КАК Удержания
	|ГДЕ
	|	Удержания.СпособВыполненияУдержания = ЗНАЧЕНИЕ(Перечисление.СпособыВыполненияУдержаний.ПоОтдельномуДокументуДоОкончательногоРасчета)
	|	И Удержания.ВидДокументаУдержания = &ВидДокумента
	|	И НЕ Удержания.ВАрхиве
	|	И НЕ Удержания.ПометкаУдаления
	|	И &ДополнительныйОтбор";
	
	Запрос = Новый Запрос;
	
	СтрокаДопУсловия = "ИСТИНА";
	Если ДополнительныйОтбор <> Неопределено Тогда
		СтрокаДопУсловия = "";
		Для Каждого КлючИЗначение Из ДополнительныйОтбор Цикл
			СтрокаДопУсловия = СтрокаДопУсловия + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1=&%1 И ", КлючИЗначение.Ключ);
			Запрос.УстановитьПараметр(КлючИЗначение.Ключ, КлючИЗначение.Значение);
		КонецЦикла;
		СтроковыеФункцииКлиентСервер.УдалитьПоследнийСимволВСтроке(СтрокаДопУсловия, 2);
	КонецЕсли;
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ДополнительныйОтбор", СтрокаДопУсловия);
	
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("ВидДокумента", ВидДокумента);
	
	МассивУдержаний = Новый Массив;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		МассивУдержаний.Добавить(Выборка.Ссылка);
	КонецЕсли;
	
	Возврат МассивУдержаний;
	
КонецФункции

Функция КатегорииУдержанийУчитывающихНДФЛ() Экспорт
	
	КатегорииУдержаний = Новый Массив;
	КатегорииУдержаний.Добавить(Перечисления.КатегорииУдержаний.ИсполнительныйЛист);
	КатегорииУдержаний.Добавить(Перечисления.КатегорииУдержаний.ВознаграждениеПлатежногоАгента);
		
	Возврат КатегорииУдержаний;
	
КонецФункции

Функция КатегорииУдержанийВлияющихНаНДФЛ() Экспорт
	
	КатегорииУдержаний = Новый Массив;
	КатегорииУдержаний.Добавить(Перечисления.КатегорииУдержаний.ДСВ);
	КатегорииУдержаний.Добавить(Перечисления.КатегорииУдержаний.ДобровольныеВзносыВНПФ);
		
	Возврат КатегорииУдержаний;
	
КонецФункции

Функция КатегорииУдержанийЗависящиеОтСтраховыхВзносов() Экспорт
	
	КатегорииУдержаний = Новый Массив;
	КатегорииУдержаний.Добавить(Перечисления.КатегорииУдержаний.ДСВ);
	КатегорииУдержаний.Добавить(Перечисления.КатегорииУдержаний.ДобровольныеВзносыВНПФ);
		
	Возврат КатегорииУдержаний;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СвойстваУдержанияПоКатегорииПоУмолчанию()
	
	Описание = Новый Структура(
		"СпособВыполненияУдержания, 
		|СпособРасчета, 
		|ФормулаРасчета, 
		|ВидДокументаУдержания, 
		|ВидОтпуска, 
		|ВидОперацииПоЗарплате,
		|ПорядокОпределенияРасчетногоПериодаСреднегоЗаработка,
		|ОтборБазовых,
		|ИменаИнструкций, 
		|ПараметрыВыбора, 
		|Рассчитывается,
		|ОчередностьРасчета,
		|НедоступныеСвойства,
		|СтратегияОтраженияВУчете");
	
	// Недоступные свойства: строка, в которой перечислены имена свойств начислений, 
	// выбор которых недоступен для указанной категории.
	
	// Свойства по умолчанию
	Описание.НедоступныеСвойства = Новый Массив;
	Описание.ИменаИнструкций = "НедоступныеСвойства,ИменаИнструкций,ПараметрыВыбора,ОтборБазовых"; 
	Описание.Рассчитывается = Истина;
	Описание.ОчередностьРасчета = 0;
	Описание.СтратегияОтраженияВУчете = Перечисления.СтратегииОтраженияВУчетеНачисленийУдержаний.ПоФактическимНачислениям;
	
	Возврат Описание;
	
КонецФункции

Функция ОписаниеУдержания() Экспорт
	
	Описание = Новый Структура(
	"Код, 
	|Наименование,
	|КраткоеНаименование,
	|КатегорияУдержания,
	|СпособВыполненияУдержания,
	|СпособРасчета,
	|ФормулаРасчета,
	|ВидОперацииПоЗарплате,
	|УчаствуетВРасчетеПервойПоловиныМесяца,
	|ВидОтпуска,
	|ОтборБазовых,
	|ОпределяющиеПоказатели,
	|Отбор,
	|Рассчитывается,
	|СсылкаНаОбъект"); // Содержит ссылку на объект, который уже был создан Из помощника начальной настройки программы);
	
	Описание.СпособВыполненияУдержания = Перечисления.СпособыВыполненияУдержаний.ЕжемесячноПриОкончательномРасчете;
	Описание.СпособРасчета = Перечисления.СпособыРасчетаУдержаний.ПроизвольнаяФормула;
	Описание.УчаствуетВРасчетеПервойПоловиныМесяца = Истина;
	
	Возврат Описание;
	
КонецФункции

Процедура СоздатьИзменитьУдержанияПоОписанию(Коллектор, Описание) Экспорт
	
	Отбор = Неопределено;
	Если ЗначениеЗаполнено(Описание.Отбор) Тогда
		Отбор = Новый Структура(Описание.Отбор);
		Если Описание.Отбор = "Ссылка" Тогда
			Отбор.Ссылка = Описание.СсылкаНаОбъект;
		Иначе
			ЗаполнитьЗначенияСвойств(Отбор, Описание, Описание.Отбор);
		КонецЕсли;
	КонецЕсли;
	
	УдержанияПоКатегории = РасчетЗарплаты.УдержанияПоКатегории(Описание.КатегорияУдержания, Отбор);
	
	УдержаниеОбъект = Неопределено;
	Если УдержанияПоКатегории.Количество() > 0 Тогда
		
		Если Описание.Отбор = "Ссылка" Тогда
			УдержаниеОбъект = УдержанияПоКатегории[0].ПолучитьОбъект();
		Иначе
			Для Каждого УдержаниеСсылка Из УдержанияПоКатегории Цикл
				УдержаниеОбъект = Коллектор[УдержаниеСсылка];
				Если УдержаниеОбъект = Неопределено Тогда
					УдержаниеОбъект = УдержаниеСсылка.ПолучитьОбъект();
					Коллектор.Вставить(УдержаниеСсылка, УдержаниеОбъект);
				КонецЕсли;
				УдержаниеОбъект.ВАрхиве = Ложь;
				УдержаниеОбъект.ПометкаУдаления = Ложь;
			КонецЦикла;
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	Если УдержаниеОбъект = Неопределено Тогда
		// Устанавливаем ссылку новому объекту.
		УдержаниеСсылка = ПланыВидовРасчета.Удержания.ПолучитьСсылку();
		УдержаниеОбъект = ПланыВидовРасчета.Удержания.СоздатьВидРасчета();
		УдержаниеОбъект.УстановитьСсылкуНового(УдержаниеСсылка);
		Описание.СсылкаНаОбъект = УдержаниеСсылка;
	Иначе
		УдержаниеСсылка = УдержаниеОбъект.Ссылка;
		УдержаниеОбъект.ВАрхиве = Ложь;
		УдержаниеОбъект.ПометкаУдаления = Ложь;
	КонецЕсли;
	
	Коллектор.Вставить(УдержаниеСсылка, УдержаниеОбъект);
	
	ЗаполнитьЗначенияСвойств(УдержаниеОбъект, Описание);
	
	РасчетЗарплатыРасширенный.ЗаполнитьТаблицуПоказателейВидаРасчета(УдержаниеОбъект, Коллектор);

	// Базовые начисления
	Если Описание.ОтборБазовых <> Неопределено Тогда
		ОтборБазовых = ОбщегоНазначенияКлиентСервер.СкопироватьСтруктуру(Описание.ОтборБазовых);
		УдержаниеОбъект.ДополнительныеСвойства.Вставить("ОтборБазовых", ОтборБазовых);
	КонецЕсли;
	
	// Определяющие показатели
	ЗарплатаКадрыРасширенный.ОтметитьОпределяющиеПоказатели(УдержаниеОбъект, Описание.ОпределяющиеПоказатели);
	
КонецПроцедуры

Процедура ОтключитьИспользованиеУдержания(Коллектор, КатегорияУдержания, Отбор = Неопределено) Экспорт
		
	УдержанияПоКатегории = РасчетЗарплаты.УдержанияПоКатегории(КатегорияУдержания, Отбор);
	
	Для Каждого УдержаниеСсылка Из УдержанияПоКатегории Цикл
		УдержаниеОбъект = Коллектор[УдержаниеСсылка];
		Если УдержаниеОбъект = Неопределено Тогда
			УдержаниеОбъект = УдержаниеСсылка.ПолучитьОбъект();
			Коллектор.Вставить(УдержаниеСсылка, УдержаниеОбъект);
		КонецЕсли;
		УдержаниеОбъект.ВАрхиве = Истина;
	КонецЦикла;

КонецПроцедуры

Функция КатегорииБазовыхНачисленийУдержанийПоИсполнительнымДокументам()
	
	Категории = Новый Массив;
	Категории.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ПовременнаяОплатаТруда);
	Категории.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.СдельнаяОплатаТруда);
	Категории.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.Премия);
	Категории.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.РайонныйКоэффициент);
	Категории.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.СевернаяНадбавка);
	Категории.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаОтпуска);
	Категории.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.КомпенсацияОтпуска);
	Категории.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.МатериальнаяПомощь);
	Категории.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.МатериальнаяПомощьПриОтпуске);
	Категории.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаПростояПоВинеРаботодателя);
	Категории.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаПростояПоНезависящимОтРаботодателяПричинам);
	Категории.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаКомандировки);
	Категории.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаПоСреднемуЗаработку);
	Категории.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ДоплатаДоСреднегоЗаработка);
	Категории.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ДоплатаЗаСовмещение);
	Категории.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ВыходноеПособие);
	Категории.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ДоходВНатуральнойФорме);
	Категории.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаТрудаВНатуральнойФорме);
	
	Категории.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ДенежноеСодержаниеНаПериодКомандировки);
	Категории.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ДенежноеСодержаниеНаПериодОтпуска);
	Категории.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ДенежноеСодержаниеКомпенсацияОтпуска);
	Категории.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.СохраняемоеДенежноеСодержание);
	Категории.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ВыходноеПособиеМесячноеДенежноеСодержание);
	
	// Добавляем еще и больничные листы, но при расчете будем включать сумму расчетной базы только для тех исполнительных
	// документов,  для которых указано "Учитывать больничные листы".
	Категории.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаБольничногоЛиста);
	Категории.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаБольничногоЛистаЗаСчетРаботодателя);
	Категории.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаБольничногоНесчастныйСлучайНаПроизводстве);
	Категории.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаБольничногоПрофзаболевание);
	Категории.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ДоплатаДоСреднегоЗаработкаЗаДниБолезни);
	Категории.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ДоплатаДоДенежногоСодержанияЗаДниБолезни);
	
	Возврат Категории;
	
КонецФункции

Функция КатегорииБазовыхНачисленийПрофсоюзныхВзносов()
	
	Категории = Новый Массив;
	Категории.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ПовременнаяОплатаТруда);
	Категории.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.СдельнаяОплатаТруда);
	Категории.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.Премия);
	Категории.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.РайонныйКоэффициент);
	Категории.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.СевернаяНадбавка);
	Категории.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаОтпуска);
	Категории.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.КомпенсацияОтпуска);
	Категории.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.МатериальнаяПомощьПриОтпуске);
	Категории.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаПростояПоВинеРаботодателя);
	Категории.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаПростояПоНезависящимОтРаботодателяПричинам);
	Категории.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаКомандировки);
	Категории.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаПоСреднемуЗаработку);
	Категории.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОтпускПоБеременностиИРодам);
	Категории.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаБольничногоЛиста);
	Категории.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаБольничногоЛистаЗаСчетРаботодателя);
	Категории.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаБольничногоНесчастныйСлучайНаПроизводстве);
	Категории.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаБольничногоПрофзаболевание);
	Категории.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ДоплатаДоСреднегоЗаработкаЗаДниБолезни);
	Категории.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ВыходноеПособие);
	Категории.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ДоплатаДоСреднегоЗаработка);
	Категории.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ДоплатаЗаСовмещение);
	
	Возврат Категории;
	
КонецФункции

#КонецОбласти

#КонецЕсли