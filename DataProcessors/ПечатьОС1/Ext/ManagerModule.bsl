﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область Печать

// Сформировать печатные формы объектов
//
// Параметры:
// 		МассивОбъектов - Массив - Массив ссылок на объекты которые нужно распечатать
// 		ПараметрыПечати - Структура - Структура дополнительных параметров печати
// 		КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы
// 		ОбъектыПечати - Объекты печати
// 		ПараметрыВывода - Структура - Параметры сформированных табличных документов
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	// 4D:ERP Для Беларуси, Яна, 03.04.2017, 10:00:58 
    // Принятие к учету ОС, №14610 
    // {
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ОС1_Локализация") Тогда
		
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		ИмяМакета = "ОС1_Локализация";
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			ИмяМакета,
			НСтр("ru='ОС-1 (Акт о приеме-передаче ОС)'"),
			ПечатьОС1_Локализация(
				МассивОбъектов,
				ОбъектыПечати,
				ПараметрыПечати,
				ИмяМакета));

	КонецЕсли;
   // }
   // 4D

	
КонецПроцедуры

// 4D:ERP Для Беларуси, Евгений, 12.12.2016, 10:05:58 
// Печатные формы по ОС, №13507
// {
Функция ПечатьОС1_Локализация(МассивОбъектов, ОбъектыПечати, ПараметрыПечати, ИмяМакета)
    	 	  
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПринятиеКУчетуОС_ОС1";
    	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьОС1.ПФ_MXL_ОС1_Локализация");
	
	// Области
	ОбластьМакетаЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	СтрокаДМ               = Макет.ПолучитьОбласть("СтрокаДМ");
	Подвал                 = Макет.ПолучитьОбласть("Подвал");
 		
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПринятиеКУчетуОСОсновныеСредства.Ссылка,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ПринятиеКУчетуОСОсновныеСредства.ОсновноеСредство) КАК КоличествоСтрок
	|ПОМЕСТИТЬ ПринятиеКУчетуОС
	|ИЗ
	|	Документ.ПринятиеКУчетуОС.ОС КАК ПринятиеКУчетуОСОсновныеСредства
	|ГДЕ
	|	ПринятиеКУчетуОСОсновныеСредства.Ссылка В(&МассивОбъектов)
	|
	|СГРУППИРОВАТЬ ПО
	|	ПринятиеКУчетуОСОсновныеСредства.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПринятиеКУчетуОСОсновныеСредства.Ссылка,
	|	ПринятиеКУчетуОСОсновныеСредства.Ссылка.Организация КАК Организация,
	|	ПринятиеКУчетуОСОсновныеСредства.ОсновноеСредство,
	|	МАКСИМУМ(ПервоначальныеСведенияОСБухгалтерскийУчет.Период) КАК МаксПериод
	|ПОМЕСТИТЬ ВТ_МаксПериодыСведенийОСБУ
	|ИЗ
	|	Документ.ПринятиеКУчетуОС.ОС КАК ПринятиеКУчетуОСОсновныеСредства
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПервоначальныеСведенияОСБухгалтерскийУчет КАК ПервоначальныеСведенияОСБухгалтерскийУчет
	|		ПО ПринятиеКУчетуОСОсновныеСредства.ОсновноеСредство = ПервоначальныеСведенияОСБухгалтерскийУчет.ОсновноеСредство
	|			И ПринятиеКУчетуОСОсновныеСредства.Ссылка.Организация = ПервоначальныеСведенияОСБухгалтерскийУчет.Организация
	|			И (ПервоначальныеСведенияОСБухгалтерскийУчет.Период <= КОНЕЦПЕРИОДА(ПринятиеКУчетуОСОсновныеСредства.Ссылка.Дата, МЕСЯЦ))
	|ГДЕ
	|	ПринятиеКУчетуОСОсновныеСредства.Ссылка В(&МассивОбъектов)
	|
	|СГРУППИРОВАТЬ ПО
	|	ПринятиеКУчетуОСОсновныеСредства.Ссылка,
	|	ПринятиеКУчетуОСОсновныеСредства.ОсновноеСредство,
	|	ПринятиеКУчетуОСОсновныеСредства.Ссылка.Организация
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПринятиеКУчетуОСОсновныеСредства.Ссылка КАК Ссылка,
	|	ПринятиеКУчетуОСОсновныеСредства.Ссылка.Номер КАК НомерАкта,
	|	ПринятиеКУчетуОСОсновныеСредства.Ссылка.Дата КАК Дата,
	|	ПринятиеКУчетуОСОсновныеСредства.Ссылка.Дата КАК ДатаВвода,
	|	ПринятиеКУчетуОСОсновныеСредства.Ссылка.Дата КАК ДатаВводаПриПередаче,
	|	ПринятиеКУчетуОСОсновныеСредства.Ссылка.МОЛ,
	|	ПринятиеКУчетуОСОсновныеСредства.Ссылка.Местонахождение КАК Местонахождение,
	|	ПринятиеКУчетуОСОсновныеСредства.Ссылка.Местонахождение.Наименование КАК ПодрПолучателя,
	|	ПринятиеКУчетуОСОсновныеСредства.Ссылка.СрокИспользованияБУ КАК СрокПолезнИспПриПост,
	|	ПринятиеКУчетуОСОсновныеСредства.Ссылка.МетодНачисленияАмортизацииБУ КАК СпособАмортизации,
	|	ПринятиеКУчетуОСОсновныеСредства.Ссылка.Организация КАК Организация,
	|	Сведения.ИнвентарныйНомер КАК ИнвНомер,
	|	ЕСТЬNULL(Сведения.ПервоначальнаяСтоимость, 0) КАК НачСтоимость,
	|	ПринятиеКУчетуОСОсновныеСредства.ОсновноеСредство.Изготовитель КАК Изготовитель,
	|	ПринятиеКУчетуОСОсновныеСредства.ОсновноеСредство КАК ОсновноеСредство,
	|	ПринятиеКУчетуОСОсновныеСредства.НомерСтроки КАК НомерСтроки,
	|	ПринятиеКУчетуОСОсновныеСредства.ОсновноеСредство.НаименованиеПолное КАК НаименованиеОС,
	|	ПринятиеКУчетуОСОсновныеСредства.ОсновноеСредство.ЗаводскойНомер КАК ЗаводскойНомер,
	|	ЕСТЬNULL(ПринятиеКУчетуОС.КоличествоСтрок, 0) КАК КоличествоСтрок,
	|	ПринятиеКУчетуОС.Ссылка.Организация.ИНН КАК ПолучУНП,
	|	ПринятиеКУчетуОС.Ссылка.СчетУчета КАК СчетУчетаВнеоборотногоАктива,
	|	ВЫБОР
	|		КОГДА ПринятиеКУчетуОСОсновныеСредства.Ссылка.СрокИспользованияБУ = 0
	|			ТОГДА """"
	|		ИНАЧЕ 12 * 100 / ПринятиеКУчетуОСОсновныеСредства.Ссылка.СрокИспользованияБУ
	|	КОНЕЦ КАК НормаАморт,
	|	ПринятиеКУчетуОС.Ссылка.Подразделение КАК ПодразделениеОрганизации
	|ИЗ
	|	Документ.ПринятиеКУчетуОС.ОС КАК ПринятиеКУчетуОСОсновныеСредства
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПринятиеКУчетуОС КАК ПринятиеКУчетуОС
	|		ПО ПринятиеКУчетуОСОсновныеСредства.Ссылка = ПринятиеКУчетуОС.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_МаксПериодыСведенийОСБУ КАК ВТ_МаксПериодыСведенийОСБУ
	|		ПО ПринятиеКУчетуОСОсновныеСредства.Ссылка = ВТ_МаксПериодыСведенийОСБУ.Ссылка
	|			И ПринятиеКУчетуОСОсновныеСредства.ОсновноеСредство = ВТ_МаксПериодыСведенийОСБУ.ОсновноеСредство
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПервоначальныеСведенияОСБухгалтерскийУчет КАК Сведения
	|		ПО (ВТ_МаксПериодыСведенийОСБУ.ОсновноеСредство = Сведения.ОсновноеСредство)
	|			И (ВТ_МаксПериодыСведенийОСБУ.Организация = Сведения.Организация)
	|			И (ВТ_МаксПериодыСведенийОСБУ.МаксПериод = Сведения.Период)
	|ГДЕ
	|	ПринятиеКУчетуОСОсновныеСредства.Ссылка В(&МассивОбъектов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата,
	|	Ссылка,
	|	НомерСтроки";

	ВыборкаПоОС = Запрос.Выполнить().Выбрать();

	ПервыйДокумент = Истина;
    	
		Пока ВыборкаПоОС.Следующий() Цикл
				
			Если НЕ ПервыйДокумент Тогда
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			КонецЕсли;
			
			ПервыйДокумент = Ложь;
			НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
			
			ОбластьМакетаЗаголовок.Параметры.Заполнить(ВыборкаПоОС);
			
			Если ПустаяСтрока(ВыборкаПоОС.НаименованиеОС) Тогда
				ОбластьМакетаЗаголовок.Параметры.НаименованиеОС = СокрЛП(ВыборкаПоОС.ОсновноеСредство);
			КонецЕсли;
			
			ОбластьМакетаЗаголовок.Параметры.НомерАкта    = ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(ВыборкаПоОС.НомерАкта, Истина, Истина);
			ОбластьМакетаЗаголовок.Параметры.ПодрПолучателя = Строка(ВыборкаПоОС.ПодразделениеОрганизации);
			ЗаполнитьДанныеОрганизацииПолучателя(ВыборкаПоОС, ОбластьМакетаЗаголовок);
						
			ТабличныйДокумент.Вывести(ОбластьМакетаЗаголовок);
						
			ТабличныйДокумент.Вывести(Подвал);
			УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ВыборкаПоОС.Ссылка);
			
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЦикла;
		
		ТабличныйДокумент.АвтоМасштаб = Истина;
		ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
				
		Возврат ТабличныйДокумент;
		
	КонецФункции
	
//Процедура заполняет параметры организации-получателя формы ОС1
Процедура ЗаполнитьДанныеОрганизацииПолучателя(ПараметрыДокумента, ОбластьМакета)

	СведенияОбОрганизации = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(ПараметрыДокумента.Организация, ПараметрыДокумента.Дата);
	ОтветственныеЛицаОрганизации = ОтветственныеЛицаБП.ОтветственныеЛица(ПараметрыДокумента.Организация,
		ПараметрыДокумента.Дата, ПараметрыДокумента.ПодразделениеОрганизации);

	ПараметрыОрганизации = Новый Структура("ОрганизацияПолучатель, АдресПолучателя, РеквПолучателя, ДолжРукПолуч,
		|РукПолучателя, КодПоОКПОПолучателя, ГлавБухПолучателя");

	ПредставлениеОрганизации = ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОбОрганизации, "НаименованиеДляПечатныхФорм,");
	ПараметрыОрганизации.ОрганизацияПолучатель = ПредставлениеОрганизации;
	ПараметрыОрганизации.АдресПолучателя = ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОбОрганизации,
		"ЮридическийАдрес, Телефоны,");
	ПараметрыОрганизации.РеквПолучателя = ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОбОрганизации,
		"НомерСчета, Банк, БИК, КоррСчет,");
	ПараметрыОрганизации.КодПоОКПОПолучателя = СведенияОбОрганизации.КодПоОКПО;

	ПараметрыОрганизации.РукПолучателя = ОтветственныеЛицаОрганизации.РуководительПредставление;
	ПараметрыОрганизации.ДолжРукПолуч = ОтветственныеЛицаОрганизации.РуководительДолжностьПредставление;
	ПараметрыОрганизации.ГлавБухПолучателя = ОтветственныеЛицаОрганизации.ГлавныйБухгалтерПредставление;

	ОбластьМакета.Параметры.Заполнить(ПараметрыОрганизации);

КонецПроцедуры	
// }
// 4D
Функция СформироватьПечатнуюФормуОС1(МассивОбъектов, ОбъектыПечати, ПараметрыПечати, КомплектыПечати)
	
	УстановитьПривилегированныйРежим(Истина);
	
	СтруктураТипов = ОбщегоНазначенияУТ.СоответствиеМассивовПоТипамОбъектов(МассивОбъектов);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ОриентацияСтраницы  = ОриентацияСтраницы.Ландшафт;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ОС1";
	
	НомерТипаДокумента = 0;
	
	Для Каждого СтруктураОбъектов Из СтруктураТипов Цикл
		
		НомерТипаДокумента = НомерТипаДокумента + 1;
		Если НомерТипаДокумента > 1 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(СтруктураОбъектов.Ключ);
		ДанныеДляПечати = МенеджерОбъекта.ПолучитьДанныеДляПечатнойФормыОС1(ПараметрыПечати, СтруктураОбъектов.Значение);
		
		ЗаполнитьТабличныйДокументОС1(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати, КомплектыПечати);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Процедура ЗаполнитьТабличныйДокументОС1(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати, КомплектыПечати)
	
	ШаблонОшибки = НСтр("ru = 'В документе %1 отсутствуют основные средства. Печать ""ОС-1"" не требуется'");
	
	ТоварКод = "";
	
	ПервыйДокумент = Истина;
	ВыборкаДокументы = ДанныеДляПечати.РезультатПоШапке.Выбрать();
	ВыборкаПоТабличнымЧастям = ДанныеДляПечати.РезультатПоТабличнойЧасти.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	ВыборкаПоДрагоценнымМатериалам = ДанныеДляПечати.РезультатПоДрагоценнымМатериалам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	СтруктураОтбора = Новый Структура("Ссылка");
	
	Пока ВыборкаДокументы.Следующий() Цикл
		
		// Для печати комплектов
		Если КомплектыПечати <> Неопределено И КомплектыПечати.Колонки.Найти("Ссылка") <> Неопределено Тогда
			КомплектПечатиПоСсылке = КомплектыПечати.Найти(ВыборкаДокументы.Ссылка,"Ссылка");
			Если КомплектПечатиПоСсылке = Неопределено Тогда
				КомплектПечатиПоСсылке = КомплектыПечати[0];
			КонецЕсли;
			Если КомплектПечатиПоСсылке.Экземпляров = 0 Тогда
				Продолжить
			КонецЕсли;
		КонецЕсли;
		
		СтруктураОтбора.Ссылка = ВыборкаДокументы.Ссылка;
		ВыборкаПоТабличнымЧастям.Сбросить();
		Если Не ВыборкаПоТабличнымЧастям.НайтиСледующий(СтруктураОтбора) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					ШаблонОшибки,
					ВыборкаДокументы.Ссылка
				),
				ВыборкаДокументы.Ссылка);
			Продолжить;
		КонецЕсли;
		
		ВыборкаПоСтрокам = ВыборкаПоТабличнымЧастям.Выбрать();
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		Если ВыборкаПоСтрокам.Количество() = 1 Тогда
			ВыборкаПоСтрокам.Следующий();
			Если ВыборкаПоСтрокам.ГруппаОС = Перечисления.ГруппыОС.Здания
				Или ВыборкаПоСтрокам.ГруппаОС = Перечисления.ГруппыОС.Сооружения Тогда
				
				ЗаполнитьМакетОС1а(ТабличныйДокумент, ВыборкаДокументы, ВыборкаПоСтрокам, ВыборкаПоДрагоценнымМатериалам);
				
			Иначе
				ЗаполнитьМакетОС1(ТабличныйДокумент, ВыборкаДокументы, ВыборкаПоСтрокам, ВыборкаПоДрагоценнымМатериалам);
			КонецЕсли;
			
		Иначе
			Если ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт Тогда
				ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
			КонецЕсли;
			ЗаполнитьМакетОС1б(ТабличныйДокумент, ВыборкаДокументы, ВыборкаПоСтрокам, ВыборкаПоДрагоценнымМатериалам);
		КонецЕсли;
		
		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		
		// Выведем нужное количество экземпляров (при печати комплектов)
		Если КомплектыПечати <> Неопределено И КомплектыПечати.Колонки.Найти("Ссылка") <> Неопределено И КомплектПечатиПоСсылке.Экземпляров > 1 Тогда
			ОбластьКопирования = ТабличныйДокумент.ПолучитьОбласть(НомерСтрокиНачало,,ТабличныйДокумент.ВысотаТаблицы);
			Для Итератор = 2 По КомплектПечатиПоСсылке.Экземпляров Цикл
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				ТабличныйДокумент.Вывести(ОбластьКопирования);
			КонецЦикла;
		КонецЕсли;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ВыборкаДокументы.Ссылка);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьМакетОС1(ТабличныйДокумент, ВыборкаПоДокументам, ВыборкаПоТабличнымЧастям, ВыборкаПоДрагоценнымМеталлам)
	
	РеквизитыОтветственныхЛиц = РеквизитыОтветственныхЛиц(ВыборкаПоДокументам);
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьОС1.ПФ_MXL_ОС1");
	
	Страница1 = Макет.ПолучитьОбласть("Страница1");
	Страница2_Шапка = Макет.ПолучитьОбласть("Страница2_Шапка");
	Страница2_Таблица3_Шапка = Макет.ПолучитьОбласть("Страница2_Таблица3_Шапка");
	Страница2_Таблица3_Строка = Макет.ПолучитьОбласть("Страница2_Таблица3_Строка");
	Страница2_Таблица3_Подвал = Макет.ПолучитьОбласть("Страница2_Таблица3_Подвал");
	Страница2_Подвал = Макет.ПолучитьОбласть("Страница2_Подвал");
	Страница3 = Макет.ПолучитьОбласть("Страница3");
	
	Страница1.Параметры.Заполнить(ВыборкаПоДокументам);
	Страница1.Параметры.Заполнить(ВыборкаПоТабличнымЧастям);
	Страница1.Параметры.Заполнить(РеквизитыОтветственныхЛиц);
	ЗаполнитьРеквизитыШапкиОС1(ВыборкаПоДокументам, Страница1, ТабличныйДокумент);
	Страница1.Параметры.ДатаВвода = ВыборкаПоТабличнымЧастям.ДатаВводаВЭксплуатацию;
	Если ВыборкаПоТабличнымЧастям.АмортизационнаяГруппа = 11 Тогда
		Страница1.Параметры.АмортизационнаяГруппа = НСтр("ru='Отдельная'");
	КонецЕсли;
	ТабличныйДокумент.Вывести(Страница1);
	ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
	
	Страница2_Шапка.Параметры.Заполнить(ВыборкаПоДокументам);
	Страница2_Шапка.Параметры.Заполнить(ВыборкаПоТабличнымЧастям);
	Страница2_Шапка.Параметры.СрокИспользованияФакт = ОбъектыЭксплуатации.КоличествоМесяцевСтрокой(
		ВыборкаПоТабличнымЧастям.СрокИспользованияФакт);
	Страница2_Шапка.Параметры.СрокИспользования = ОбъектыЭксплуатации.КоличествоМесяцевСтрокой(
		ВыборкаПоТабличнымЧастям.СрокИспользования);
	Страница2_Шапка.Параметры.СрокИспользованияРаздел2 = ОбъектыЭксплуатации.КоличествоМесяцевСтрокой(
		ВыборкаПоТабличнымЧастям.СрокИспользованияРаздел2);
	ТабличныйДокумент.Вывести(Страница2_Шапка);
	
	ТабличныйДокумент.Вывести(Страница2_Таблица3_Шапка);
	СтруктураПоиска = Новый Структура("Ссылка", ВыборкаПоДокументам.Ссылка);
	ВыборкаПоДрагоценнымМеталлам.Сбросить();
	Если ВыборкаПоДрагоценнымМеталлам.НайтиСледующий(СтруктураПоиска) Тогда
		ВыборкаПоДМ = ВыборкаПоДрагоценнымМеталлам.Выбрать();
		Пока ВыборкаПоДМ.Следующий() Цикл
			Страница2_Таблица3_Строка.Параметры.Заполнить(ВыборкаПоДМ);
			ТабличныйДокумент.Вывести(Страница2_Таблица3_Строка);
		КонецЦикла;
	Иначе
		Для к=0 По 6 Цикл // Вывод 6 пустых строк для заполнения вручную
			ТабличныйДокумент.Вывести(Страница2_Таблица3_Строка);
		КонецЦикла;
	КонецЕсли;
	
	
	ТабличныйДокумент.Вывести(Страница2_Таблица3_Подвал);
	ТабличныйДокумент.Вывести(Страница2_Подвал);
	
	ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
	
	Страница3.Параметры.Заполнить(ВыборкаПоДокументам);
	Страница3.Параметры.Заполнить(РеквизитыОтветственныхЛиц);
	Страница3.Параметры.ТабельныйНомерСдалМОЛ = ТабельныйНомерФизЛица(
		ВыборкаПоДокументам.СдалМОЛ, ВыборкаПоДокументам.Сдатчик, ВыборкаПоДокументам.ДатаДокумента);
	ТабличныйДокумент.Вывести(Страница3);
	
КонецПроцедуры

Процедура ЗаполнитьМакетОС1а(ТабличныйДокумент, ВыборкаПоДокументам, ВыборкаПоТабличнымЧастям, ВыборкаПоДрагоценнымМеталлам)
	
	РеквизитыОтветственныхЛиц = РеквизитыОтветственныхЛиц(ВыборкаПоДокументам);
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьОС1.ПФ_MXL_ОС1а");
	
	Страница1 = Макет.ПолучитьОбласть("Страница1");
	Страница2_Шапка = Макет.ПолучитьОбласть("Страница2_Шапка");
	Страница2_Таблица3_Шапка = Макет.ПолучитьОбласть("Страница2_Таблица3_Шапка");
	Страница2_Таблица3_Строка = Макет.ПолучитьОбласть("Страница2_Таблица3_Строка");
	Страница2_Таблица3_Подвал = Макет.ПолучитьОбласть("Страница2_Таблица3_Подвал");
	Страница3 = Макет.ПолучитьОбласть("Страница3");
	
	Страница2_Таблица4 = Макет.ПолучитьОбласть("Страница2_Таблица4");
	
	Страница1.Параметры.Заполнить(ВыборкаПоДокументам);
	Страница1.Параметры.Заполнить(ВыборкаПоТабличнымЧастям);
	Страница1.Параметры.Заполнить(РеквизитыОтветственныхЛиц);
	ЗаполнитьРеквизитыШапкиОС1(ВыборкаПоДокументам, Страница1, ТабличныйДокумент);
	Страница1.Параметры.ДатаВвода = ВыборкаПоТабличнымЧастям.ДатаВводаВЭксплуатацию;
		Если ВыборкаПоТабличнымЧастям.АмортизационнаяГруппа = 11 Тогда
		Страница1.Параметры.АмортизационнаяГруппа = НСтр("ru='Отдельная'");
	КонецЕсли;
	ТабличныйДокумент.Вывести(Страница1);
	ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
	
	Страница2_Шапка.Параметры.Заполнить(ВыборкаПоДокументам);
	Страница2_Шапка.Параметры.Заполнить(ВыборкаПоТабличнымЧастям);
	Страница2_Шапка.Параметры.СрокИспользованияФакт = ОбъектыЭксплуатации.КоличествоМесяцевСтрокой(
		ВыборкаПоТабличнымЧастям.СрокИспользованияФакт);
	Страница2_Шапка.Параметры.СрокИспользованияРаздел2 = ОбъектыЭксплуатации.КоличествоМесяцевСтрокой(
		ВыборкаПоТабличнымЧастям.СрокИспользованияРаздел2);
	ТабличныйДокумент.Вывести(Страница2_Шапка);
	
	ТабличныйДокумент.Вывести(Страница2_Таблица3_Шапка);
	СтруктураПоиска = Новый Структура("Ссылка", ВыборкаПоДокументам.Ссылка);
	ВыборкаПоДрагоценнымМеталлам.Сбросить();
	Если ВыборкаПоДрагоценнымМеталлам.НайтиСледующий(СтруктураПоиска) Тогда
		ВыборкаПоДМ = ВыборкаПоДрагоценнымМеталлам.Выбрать();
		Пока ВыборкаПоДМ.Следующий() Цикл
			Страница2_Таблица3_Строка.Параметры.Заполнить(ВыборкаПоДМ);
			ТабличныйДокумент.Вывести(Страница2_Таблица3_Строка);
		КонецЦикла;
	Иначе
		Для к=0 По 6 Цикл // Вывод 6 пустых строк для заполнения вручную
			ТабличныйДокумент.Вывести(Страница2_Таблица3_Строка);
		КонецЦикла;
	КонецЕсли;
	
	
	ТабличныйДокумент.Вывести(Страница2_Таблица3_Подвал);
	
	ТабличныйДокумент.Вывести(Страница2_Таблица4);
	
	ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
	
	Страница3.Параметры.Заполнить(ВыборкаПоДокументам);
	Страница3.Параметры.Заполнить(РеквизитыОтветственныхЛиц);
	Страница3.Параметры.ТабельныйНомерСдалМОЛ = ТабельныйНомерФизЛица(
		ВыборкаПоДокументам.СдалМОЛ, ВыборкаПоДокументам.Сдатчик, ВыборкаПоДокументам.ДатаДокумента);
	ТабличныйДокумент.Вывести(Страница3);
	
КонецПроцедуры

Процедура ЗаполнитьМакетОС1б(ТабличныйДокумент, ВыборкаПоДокументам, ВыборкаПоТабличнымЧастям, ВыборкаПоДрагоценнымМеталлам)
	
	РеквизитыОтветственныхЛиц = РеквизитыОтветственныхЛиц(ВыборкаПоДокументам);
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьОС1.ПФ_MXL_ОС1б");
	
	ОбщаяДатаВводаВЭксплуатацию = Истина;
	ДатаВводаВЭксплуатацию = Неопределено;
	Пока ВыборкаПоТабличнымЧастям.Следующий() Цикл
		
		Если ОбщаяДатаВводаВЭксплуатацию Тогда
			Если ДатаВводаВЭксплуатацию = Неопределено Тогда
				ДатаВводаВЭксплуатацию = ВыборкаПоТабличнымЧастям.ДатаВводаВЭксплуатацию;
			КонецЕсли;
			Если ДатаВводаВЭксплуатацию <> ВыборкаПоТабличнымЧастям.ДатаВводаВЭксплуатацию Тогда
				ОбщаяДатаВводаВЭксплуатацию = Ложь;
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	Страница1 = Макет.ПолучитьОбласть("Страница1");
	Страница2_Шапка = Макет.ПолучитьОбласть("Страница2_Шапка");
	Страница2_Таблица1_Шапка = Макет.ПолучитьОбласть("Страница2_Таблица1_Шапка");
	Страница2_Таблица1_Строка = Макет.ПолучитьОбласть("Страница2_Таблица1_Строка");
	Страница2_Таблица1_СтрокаПусто = Макет.ПолучитьОбласть("Страница2_Таблица1_СтрокаПусто");
	Страница2_Таблица1_Подвал = Макет.ПолучитьОбласть("Страница2_Таблица1_Подвал");
	Страница2_Подвал = Макет.ПолучитьОбласть("Страница2_Подвал");
	
	Страница3_Шапка = Макет.ПолучитьОбласть("Страница3_Шапка");
	Страница3_Таблица2_Шапка = Макет.ПолучитьОбласть("Страница3_Таблица2_Шапка");
	Страница3_Таблица2_Строка = Макет.ПолучитьОбласть("Страница3_Таблица2_Строка");
	Страница3_Таблица2_СтрокаПусто = Макет.ПолучитьОбласть("Страница3_Таблица2_СтрокаПусто");
	Страница3_Таблица2_Подвал = Макет.ПолучитьОбласть("Страница3_Таблица2_Подвал");
	Страница3_Подвал = Макет.ПолучитьОбласть("Страница3_Подвал");
	Страница4_Шапка = Макет.ПолучитьОбласть("Страница4_Шапка");
	Страница4_Таблица3_Шапка = Макет.ПолучитьОбласть("Страница4_Таблица3_Шапка");
	Страница4_Таблица3_Строка = Макет.ПолучитьОбласть("Страница4_Таблица3_Строка");
	Страница4_Таблица3_Подвал = Макет.ПолучитьОбласть("Страница4_Таблица3_Подвал");
	Страница4_Подвал = Макет.ПолучитьОбласть("Страница4_Подвал");
	
	СтруктураДанных = Новый Структура("СчетУчетаОС", Неопределено);
	СоответствиеСчетовУчета = Новый Соответствие;
	
	ВыборкаПоТабличнымЧастям.Сбросить();
	Пока ВыборкаПоТабличнымЧастям.Следующий() Цикл
		
		ЗаполнитьЗначенияСвойств(СтруктураДанных, ВыборкаПоТабличнымЧастям);
		Если ЗначениеЗаполнено(СтруктураДанных.СчетУчетаОС) Тогда
			СоответствиеСчетовУчета.Вставить(СтруктураДанных.СчетУчетаОС, Истина);
		КонецЕсли;
		
	КонецЦикла;
	Если СоответствиеСчетовУчета.Количество() <> 1 Тогда
		СтруктураДанных.СчетУчетаОС = Неопределено;
	КонецЕсли;
	
	// Страница 1 //////////////////////////////////////////////////
	Страница1.Параметры.Заполнить(ВыборкаПоДокументам);
	Страница1.Параметры.Заполнить(СтруктураДанных);
	Страница1.Параметры.Заполнить(РеквизитыОтветственныхЛиц);
	ЗаполнитьРеквизитыШапкиОС1(ВыборкаПоДокументам, Страница1, ТабличныйДокумент);
	Если ОбщаяДатаВводаВЭксплуатацию Тогда
		Страница1.Параметры.ДатаВвода = ДатаВводаВЭксплуатацию;
	КонецЕсли;
	Если ВыборкаПоТабличнымЧастям.АмортизационнаяГруппа = 11 Тогда
		Страница1.Параметры.АмортизационнаяГруппа = НСтр("ru='Отдельная'");
	КонецЕсли;
	ТабличныйДокумент.Вывести(Страница1);
	
	ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
	
	// Страница 2 //////////////////////////////////////////////////
	
	ТабличныйДокумент.Вывести(Страница2_Шапка);
	ТабличныйДокумент.Вывести(Страница2_Таблица1_Шапка);
	
	НомПП = 0;
	ВыборкаПоТабличнымЧастям.Сбросить();
	Пока ВыборкаПоТабличнымЧастям.Следующий() Цикл
		
		НомПП = НомПП + 1;
		Страница2_Таблица1_Строка.Параметры.Заполнить(ВыборкаПоДокументам);
		Страница2_Таблица1_Строка.Параметры.Заполнить(ВыборкаПоТабличнымЧастям);
		Страница2_Таблица1_Строка.Параметры.НС = НомПП;
		
		ТабличныйДокумент.Вывести(Страница2_Таблица1_Строка);
		
	КонецЦикла;
	
	ТабличныйДокумент.Вывести(Страница2_Таблица1_Подвал);
	ТабличныйДокумент.Вывести(Страница2_Подвал);
	
	ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
	
	// Страница 3 //////////////////////////////////////////////////
	
	ТабличныйДокумент.Вывести(Страница3_Шапка);
	ТабличныйДокумент.Вывести(Страница3_Таблица2_Шапка);
	
	ИтогСтоимостьПервоначальная = 0;
	ИтогЦенаПродажи = 0;
	
	ВыборкаПоТабличнымЧастям.Сбросить();
	Пока ВыборкаПоТабличнымЧастям.Следующий() Цикл
		СтруктураСтроки = Новый Структура("СтоимостьПервоначальная, ЦенаПродажи", 0, 0);
		ЗаполнитьЗначенияСвойств(СтруктураСтроки, ВыборкаПоТабличнымЧастям);
		ИтогСтоимостьПервоначальная = ИтогСтоимостьПервоначальная + СтруктураСтроки.СтоимостьПервоначальная;
		ИтогЦенаПродажи = ИтогЦенаПродажи + СтруктураСтроки.ЦенаПродажи;
		
		Страница3_Таблица2_Строка.Параметры.Заполнить(ВыборкаПоДокументам);
		Страница3_Таблица2_Строка.Параметры.Заполнить(ВыборкаПоТабличнымЧастям);
		Страница3_Таблица2_Строка.Параметры.СрокИспользованияФакт = ОбъектыЭксплуатации.КоличествоМесяцевСтрокой(
			ВыборкаПоТабличнымЧастям.СрокИспользованияФакт);
		Страница3_Таблица2_Строка.Параметры.СрокИспользования = ОбъектыЭксплуатации.КоличествоМесяцевСтрокой(
			ВыборкаПоТабличнымЧастям.СрокИспользованияРаздел2);
		
		ТабличныйДокумент.Вывести(Страница3_Таблица2_Строка);
		
	КонецЦикла;
	
	Страница3_Таблица2_Подвал.Параметры.ИтогСтоимостьПервоначальная = ИтогСтоимостьПервоначальная;
	Страница3_Таблица2_Подвал.Параметры.ИтогЦенаПродажи = ИтогЦенаПродажи;
	ТабличныйДокумент.Вывести(Страница3_Таблица2_Подвал);
	Страница3_Подвал.Параметры.Заполнить(ВыборкаПоДокументам);
	Страница3_Подвал.Параметры.Заполнить(РеквизитыОтветственныхЛиц);
	Страница3_Подвал.Параметры.ТабельныйНомерСдалМОЛ = ТабельныйНомерФизЛица(
		ВыборкаПоДокументам.СдалМОЛ, ВыборкаПоДокументам.Сдатчик, ВыборкаПоДокументам.ДатаДокумента);
	ТабличныйДокумент.Вывести(Страница3_Подвал);
	
	ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
	
	// Страница 4 //////////////////////////////////////////////////
	
	ТабличныйДокумент.Вывести(Страница4_Шапка);
	ТабличныйДокумент.Вывести(Страница4_Таблица3_Шапка);
	
	СтруктураПоиска = Новый Структура("Ссылка", ВыборкаПоДокументам.Ссылка);
	ВыборкаПоДрагоценнымМеталлам.Сбросить();
	Если ВыборкаПоДрагоценнымМеталлам.НайтиСледующий(СтруктураПоиска) Тогда
		ВыборкаПоДМ = ВыборкаПоДрагоценнымМеталлам.Выбрать();
		Пока ВыборкаПоДМ.Следующий() Цикл
			Страница4_Таблица3_Строка.Параметры.Заполнить(ВыборкаПоДМ);
			ТабличныйДокумент.Вывести(Страница4_Таблица3_Строка);
		КонецЦикла;
	Иначе
		Для к=0 По 6 Цикл // Вывод 6 пустых строк для заполнения вручную
			ТабличныйДокумент.Вывести(Страница4_Таблица3_Строка);
		КонецЦикла;
	КонецЕсли;
	
	ТабличныйДокумент.Вывести(Страница4_Таблица3_Подвал);
	
	Страница4_Подвал.Параметры.Заполнить(РеквизитыОтветственныхЛиц);
	ТабличныйДокумент.Вывести(Страница4_Подвал);
	
	ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
	
КонецПроцедуры

Процедура ЗаполнитьРеквизитыШапкиОС1(ДанныеПечати, ОбластьМакета, ТабличныйДокумент)
	
	// Выводим общие реквизиты шапки
	СведенияОСдатчике = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати.Сдатчик, ДанныеПечати.ДатаДокумента,, ДанныеПечати.БанковскийСчетСдатчика);
	СведенияОПолучателе = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати.Получатель, ДанныеПечати.ДатаДокумента,, ДанныеПечати.БанковскийСчетПолучателя);
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Номер", ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ДанныеПечати.НомерДокумента));
	СтруктураПараметров.Вставить("Дата", ДанныеПечати.ДатаДокумента);
	
	СтруктураПараметров.Вставить("ОрганизацияСдатчик", ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОСдатчике, "НаименованиеДляПечатныхФорм"));
	СтруктураПараметров.Вставить("АдресСдатчика", ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОСдатчике, "ФактическийАдрес, Телефоны"));
	СтруктураПараметров.Вставить("БанковскиеРеквизитыСдатчика", ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОСдатчике, "НомерСчета,Банк,БИК,КоррСчет"));
	СтруктураПараметров.Вставить("КодПоОКПОСдатчика", СведенияОСдатчике.КодПоОКПО);
	
	СтруктураПараметров.Вставить("ОрганизацияПолучатель", ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПолучателе, "НаименованиеДляПечатныхФорм"));
	СтруктураПараметров.Вставить("АдресПолучателя", ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПолучателе, "ФактическийАдрес, Телефоны"));
	СтруктураПараметров.Вставить("БанковскиеРеквизитыПолучателя", ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПолучателе, "НомерСчета,Банк,БИК,КоррСчет"));
	СтруктураПараметров.Вставить("КодПоОКПОПолучателя", СведенияОПолучателе.КодПоОКПО);
	
	ОбластьМакета.Параметры.Заполнить(СтруктураПараметров);
	
КонецПроцедуры

Функция РеквизитыОтветственныхЛиц(Выборка)
	
	СтруктураВозврата = Новый Структура;
	
	СтруктураВозврата.Вставить("ДолжностьРуководителяСдатчика");
	СтруктураВозврата.Вставить("РуководительСдатчика");
	СтруктураВозврата.Вставить("ГлавныйБухгалтерСдатчика");
	
	СтруктураВозврата.Вставить("СдалМОЛ");
	СтруктураВозврата.Вставить("ДолжностьСдалМОЛ");
	СтруктураВозврата.Вставить("ТабельныйНомерСдалМОЛ");
	
	СтруктураВозврата.Вставить("ДолжностьРуководителяПолучателя");
	СтруктураВозврата.Вставить("РуководительПолучателя");
	СтруктураВозврата.Вставить("ГлавныйБухгалтерПолучателя");
	
	СтруктураВозврата.Вставить("ПринялМОЛ");
	СтруктураВозврата.Вставить("ДолжностьПринялМОЛ");
	СтруктураВозврата.Вставить("ТабельныйНомерПринялМОЛ");
	
	ЗаполнитьЗначенияСвойств(СтруктураВозврата, Выборка);
	
	Если Не (ЗначениеЗаполнено(СтруктураВозврата.РуководительСдатчика) И ЗначениеЗаполнено(СтруктураВозврата.ГлавныйБухгалтерСдатчика)) Тогда
		ОтветственныеЛица = ОтветственныеЛицаСервер.ПолучитьОтветственныеЛицаОрганизации(Выборка.Сдатчик, Выборка.ДатаДокумента);
		
		Если Не ЗначениеЗаполнено(СтруктураВозврата.РуководительСдатчика) Тогда
			ОтветственныеЛица.Свойство("Руководитель", СтруктураВозврата.РуководительСдатчика);
			ОтветственныеЛица.Свойство("РуководительДолжность", СтруктураВозврата.ДолжностьРуководителяСдатчика);
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(СтруктураВозврата.ГлавныйБухгалтерСдатчика) Тогда
			ОтветственныеЛица.Свойство("ГлавныйБухгалтер", СтруктураВозврата.ГлавныйБухгалтерСдатчика);
		КонецЕсли;
		
	КонецЕсли;
	Если ЗначениеЗаполнено(СтруктураВозврата.РуководительСдатчика) Тогда
		СтруктураВозврата.РуководительСдатчика = ФизическиеЛицаУТ.ФамилияИнициалыФизЛица(СтруктураВозврата.РуководительСдатчика, Выборка.ДатаДокумента);
	КонецЕсли;
	Если ЗначениеЗаполнено(СтруктураВозврата.ГлавныйБухгалтерСдатчика) Тогда
		СтруктураВозврата.ГлавныйБухгалтерСдатчика = ФизическиеЛицаУТ.ФамилияИнициалыФизЛица(СтруктураВозврата.ГлавныйБухгалтерСдатчика, Выборка.ДатаДокумента);
	КонецЕсли;
	Если ЗначениеЗаполнено(СтруктураВозврата.СдалМОЛ) Тогда
		СтруктураВозврата.СдалМОЛ = ФизическиеЛицаУТ.ФамилияИнициалыФизЛица(СтруктураВозврата.СдалМОЛ, Выборка.ДатаДокумента);
		СтруктураВозврата.ТабельныйНомерСдалМОЛ = ТабельныйНомерФизЛица(СтруктураВозврата.СдалМОЛ, Выборка.Сдатчик, Выборка.ДатаДокумента);
	КонецЕсли;
	
	Если Не (ЗначениеЗаполнено(СтруктураВозврата.РуководительПолучателя) И ЗначениеЗаполнено(СтруктураВозврата.ГлавныйБухгалтерПолучателя)) Тогда
		ОтветственныеЛица = ОтветственныеЛицаСервер.ПолучитьОтветственныеЛицаОрганизации(Выборка.Получатель, Выборка.ДатаДокумента);
		
		Если Не ЗначениеЗаполнено(СтруктураВозврата.РуководительПолучателя) Тогда
			ОтветственныеЛица.Свойство("Руководитель", СтруктураВозврата.РуководительПолучателя);
			ОтветственныеЛица.Свойство("РуководительДолжность", СтруктураВозврата.ДолжностьРуководителяПолучателя);
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(СтруктураВозврата.ГлавныйБухгалтерПолучателя) Тогда
			ОтветственныеЛица.Свойство("ГлавныйБухгалтер", СтруктураВозврата.ГлавныйБухгалтерПолучателя);
		КонецЕсли;
		
	КонецЕсли;
	Если ЗначениеЗаполнено(СтруктураВозврата.РуководительПолучателя) Тогда
		СтруктураВозврата.РуководительПолучателя = ФизическиеЛицаУТ.ФамилияИнициалыФизЛица(СтруктураВозврата.РуководительПолучателя, Выборка.ДатаДокумента);
	КонецЕсли;
	Если ЗначениеЗаполнено(СтруктураВозврата.ГлавныйБухгалтерПолучателя) Тогда
		СтруктураВозврата.ГлавныйБухгалтерПолучателя = ФизическиеЛицаУТ.ФамилияИнициалыФизЛица(СтруктураВозврата.ГлавныйБухгалтерПолучателя, Выборка.ДатаДокумента);
	КонецЕсли;
	Если ЗначениеЗаполнено(СтруктураВозврата.ПринялМОЛ) Тогда
		СтруктураВозврата.ПринялМОЛ = ФизическиеЛицаУТ.ФамилияИнициалыФизЛица(СтруктураВозврата.ПринялМОЛ, Выборка.ДатаДокумента);
		СтруктураВозврата.ТабельныйНомерПринялМОЛ = ТабельныйНомерФизЛица(СтруктураВозврата.ПринялМОЛ, Выборка.Получатель, Выборка.ДатаДокумента);
	КонецЕсли;
	
	Возврат СтруктураВозврата;
	
КонецФункции

Функция ТабельныйНомерФизЛица(ФизЛицо, Организация, Период)
	
	Если Не ЗначениеЗаполнено(ФизЛицо) Тогда
		Возврат "";
	КонецЕсли;
	Список = Новый Массив;
	Список.Добавить(ФизЛицо);
	ОсновныеСотрудники = КадровыйУчет.ОсновныеСотрудникиФизическихЛиц(Список, Истина, Организация, Период);
	Если ОсновныеСотрудники.Количество() = 1 Тогда
		Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОсновныеСотрудники[0].Сотрудник, "Код");
	КонецЕсли;
	Возврат "";
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
