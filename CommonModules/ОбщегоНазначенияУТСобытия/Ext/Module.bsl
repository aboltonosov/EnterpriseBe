﻿
#Область ПрограммныйИнтерфейс

// Обработчик подписки на событие ПриЗаписиКонстанты.
//
Процедура ПриЗаписиКонстанты(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ИмяКонстанты 	  = Источник.ЭтотОбъект.Метаданные().Имя;
	ЗначениеКонстанты = Источник.Значение;
	
	//При включении разделенного режима, сбрасывается кэш значений констант, 
	//т.к. при установки зависимых констант идет проверка режима работы, для фильтрации неразделенных констант.
	Если ИмяКонстанты = "ИспользоватьРазделениеПоОбластямДанных"
		или ИмяКонстанты = "НеИспользоватьРазделениеПоОбластямДанных"
		или ИмяКонстанты = "НеИспользоватьРазделениеПоОбластямДанныхИЭтоКА"
		или ИмяКонстанты = "НеИспользоватьРазделениеПоОбластямДанныхИЭтоУТ" Тогда
		ОбновитьПовторноИспользуемыеЗначения();
	КонецЕсли;
	
	СинхронизироватьЗначенияПодчиненныхКонстант(ИмяКонстанты, ЗначениеКонстанты, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИсключенияПоискаСсылокПередУдалением(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Источник) = Тип("ПланВидовХарактеристикОбъект.ДополнительныеРеквизитыИСведения") Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Реквизиты.Ссылка
		|ИЗ
		|	(ВЫБРАТЬ
		|		ТабличнаяЧасть.Ссылка КАК Ссылка
		|	ИЗ
		|		Справочник.ВидыНоменклатуры.РеквизитыДляКонтроляНоменклатуры КАК ТабличнаяЧасть
		|	ГДЕ
		|		ТабличнаяЧасть.Свойство = &УдаляемоеСвойство
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		ТабличнаяЧасть.Ссылка
		|	ИЗ
		|		Справочник.ВидыНоменклатуры.РеквизитыДляКонтроляХарактеристик КАК ТабличнаяЧасть
		|	ГДЕ
		|		ТабличнаяЧасть.Свойство = &УдаляемоеСвойство
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		ТабличнаяЧасть.Ссылка
		|	ИЗ
		|		Справочник.ВидыНоменклатуры.РеквизитыДляКонтроляСерий КАК ТабличнаяЧасть
		|	ГДЕ
		|		ТабличнаяЧасть.Свойство = &УдаляемоеСвойство
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		ТабличнаяЧасть.Ссылка
		|	ИЗ
		|		Справочник.ВидыНоменклатуры.РеквизитыБыстрогоОтбораНоменклатуры КАК ТабличнаяЧасть
		|	ГДЕ
		|		ТабличнаяЧасть.Свойство = &УдаляемоеСвойство
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		ТабличнаяЧасть.Ссылка
		|	ИЗ
		|		Справочник.ВидыНоменклатуры.РеквизитыБыстрогоОтбораХарактеристик КАК ТабличнаяЧасть
		|	ГДЕ
		|		ТабличнаяЧасть.Свойство = &УдаляемоеСвойство) КАК Реквизиты";
		
		Запрос.УстановитьПараметр("УдаляемоеСвойство", Источник.Ссылка);
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		НачатьТранзакцию();
			
		Попытка
			
			Пока Выборка.Следующий() Цикл
				
				Блокировка = Новый БлокировкаДанных;
				ЭлементБлокировки = Блокировка.Добавить("Справочник.ВидыНоменклатуры");
				ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
				ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Ссылка);
				
				Блокировка.Заблокировать();
				ЗаблокироватьДанныеДляРедактирования(Выборка.Ссылка);
				ОбъектССсылкой = Выборка.Ссылка.ПолучитьОбъект();
				
				УдалитьВхожденияЭлементаИзТабличнойЧасти(ОбъектССсылкой.РеквизитыДляКонтроляНоменклатуры,     Источник.Ссылка, "Свойство");
				УдалитьВхожденияЭлементаИзТабличнойЧасти(ОбъектССсылкой.РеквизитыДляКонтроляХарактеристик,    Источник.Ссылка, "Свойство");
				УдалитьВхожденияЭлементаИзТабличнойЧасти(ОбъектССсылкой.РеквизитыДляКонтроляСерий,            Источник.Ссылка, "Свойство");
				УдалитьВхожденияЭлементаИзТабличнойЧасти(ОбъектССсылкой.РеквизитыБыстрогоОтбораНоменклатуры,  Источник.Ссылка, "Свойство");
				УдалитьВхожденияЭлементаИзТабличнойЧасти(ОбъектССсылкой.РеквизитыБыстрогоОтбораХарактеристик, Источник.Ссылка, "Свойство");
				
				ОбъектССсылкой.Записать();
				
			КонецЦикла;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ОписаниеОшибки = ОписаниеОшибки();
			ВызватьИсключение ОписаниеОшибки;
			
		КонецПопытки;
		
	КонецЕсли;
	
КонецПроцедуры

// Служебная.
//
Функция ПроверитьСоответствиеЗначенийКонстант() Экспорт
	
	ТаблицаКонстант  = ОбщегоНазначенияУТПовтИсп.ПолучитьТаблицуЗависимостиКонстант();
	ЗначенияКонстант = Новый Структура;
	
	ТаблицаНесоответствия = Новый ТаблицаЗначений;
	ТаблицаНесоответствия.Колонки.Добавить("ИмяРодительскойКонстанты", Новый ОписаниеТипов("Строка"));
	ТаблицаНесоответствия.Колонки.Добавить("ИмяПодчиненнойКонстанты",  Новый ОписаниеТипов("Строка"));
	
	// Получим значения всех констант, родительских и подчиненных
	Для Каждого Строка Из ТаблицаКонстант Цикл
		Если НЕ ЗначенияКонстант.Свойство(Строка.ИмяРодительскойКонстанты) Тогда
			ЗначенияКонстант.Вставить(Строка.ИмяРодительскойКонстанты, Константы[Строка.ИмяРодительскойКонстанты].Получить());
		КонецЕсли;
		Если НЕ ЗначенияКонстант.Свойство(Строка.ИмяПодчиненнойКонстанты) Тогда
			ЗначенияКонстант.Вставить(Строка.ИмяПодчиненнойКонстанты, Константы[Строка.ИмяПодчиненнойКонстанты].Получить());
		КонецЕсли;
	КонецЦикла; 
	
	// Заполним несоответствия допустимых и фактических сочетаний значений констант
	Для Каждого Строка Из ТаблицаКонстант Цикл
		Если Строка.ЗначениеРодительскойКонстанты = ЗначенияКонстант[Строка.ИмяРодительскойКонстанты]
		 И Строка.ЗначениеПодчиненнойКонстанты <> ЗначенияКонстант[Строка.ИмяПодчиненнойКонстанты] Тогда
			СтрокаНесоответствия = ТаблицаНесоответствия.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаНесоответствия, Строка);
		КонецЕсли;
	КонецЦикла;
	
	ТаблицаНесоответствия.Сортировать("ИмяРодительскойКонстанты, ИмяПодчиненнойКонстанты");
	
	Возврат ТаблицаНесоответствия;
	
КонецФункции

Процедура СинхронизироватьЗначенияПодчиненныхКонстант(ИмяКонстанты, ЗначениеКонстанты, Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ТипКонстанты	= ТипЗнч(ЗначениеКонстанты);
	ПримитивныеТипы = Новый ОписаниеТипов("Число,Строка,Дата,Булево,Неопределено");
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Синхронизировать "простые" зависимые константы
	Если ПримитивныеТипы.СодержитТип(ТипКонстанты)
	 ИЛИ ОбщегоНазначения.ЗначениеСсылочногоТипа(ЗначениеКонстанты) Тогда
		
		ПодчиненныеКонстанты = ОбщегоНазначенияУТПовтИсп.ПолучитьДопустимыеЗначенияПодчиненныхКонстант(ИмяКонстанты, ЗначениеКонстанты);
		
		Если ЗначениеЗаполнено(ПодчиненныеКонстанты) Тогда
			
			Для Каждого КлючИЗначение Из ПодчиненныеКонстанты Цикл
				УстановитьЗначениеКонстанты(Константы[КлючИЗначение.Ключ], КлючИЗначение.Значение);
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
	// Синхронизировать "сложные" зависимые константы
	Если ИмяКонстанты = "БазоваяВерсия" И ЗначениеКонстанты
		И Константы.ИспользоватьРасширенноеОбеспечениеПотребностей.Получить() Тогда
	
		УстановитьЗначениеКонстанты(Константы.ИспользоватьРасширенноеОбеспечениеПотребностей, Ложь);
	
	//++ НЕ УТКА
	ИначеЕсли ИмяКонстанты = "ИспользоватьПроизводствоИзДавальческогоСырья" Тогда
		
		ОбеспечениеСервер.ИспользоватьУправлениеПеремещениемОбособленныхТоваровВычислитьИЗаписать();
		
	//-- НЕ УТКА
	ИначеЕсли ИмяКонстанты = "РазрешитьОбособлениеТоваровСверхПотребности" Тогда
		
		ОбеспечениеСервер.ИспользоватьУправлениеПеремещениемОбособленныхТоваровВычислитьИЗаписать();
		
	ИначеЕсли ИмяКонстанты = "ИспользоватьЗаказыПоставщикам"
				Или ИмяКонстанты = "ИспользоватьЗаказыНаПеремещение"
				Или ИмяКонстанты = "ИспользоватьЗаказыНаСборку"
				//++ НЕ УТКА
				Или ИмяКонстанты = "ИспользоватьУправлениеПроизводством"
				Или ИмяКонстанты = "ИспользоватьУправлениеПроизводством2_2"
				//-- НЕ УТКА
				Или ИмяКонстанты = "ИспользоватьПроизводство" Тогда
			
			ЗначениеИстинаДоступноДляКонстанты =
				Константы.ИспользоватьЗаказыПоставщикам.Получить()
				Или Константы.ИспользоватьЗаказыНаПеремещение.Получить()
				Или Константы.ИспользоватьЗаказыНаСборку.Получить()
				//++ НЕ УТКА
				Или Константы.ИспользоватьУправлениеПроизводством.Получить()
				Или Константы.ИспользоватьУправлениеПроизводством2_2.Получить()
				//-- НЕ УТКА
				Или Константы.ИспользоватьПроизводство.Получить();
				
			Если Константы.ИспользоватьРасширенноеОбеспечениеПотребностей.Получить() Тогда
				
				Если Не ЗначениеИстинаДоступноДляКонстанты Тогда
					УстановитьЗначениеКонстанты(Константы.ИспользоватьРасширенноеОбеспечениеПотребностей, Ложь);
				КонецЕсли;
				
			Иначе
				
				Если Не Константы.ИспользоватьЗаказыПоставщикам.Получить() Тогда
					
					Если ЗначениеИстинаДоступноДляКонстанты Тогда
						УстановитьЗначениеКонстанты(Константы.ИспользоватьРасширенноеОбеспечениеПотребностей, Истина);
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЕсли;
			
	КонецЕсли;

	Если ИмяКонстанты = "ИспользоватьОплатуПлатежнымиКартами"
	 ИЛИ ИмяКонстанты = "ИспользоватьПодключаемоеОборудование" Тогда
		
		Если ИмяКонстанты = "ИспользоватьОплатуПлатежнымиКартами" Тогда
			ЗначениеПодчиненнойКонстанты = ЗначениеКонстанты И Константы.ИспользоватьПодключаемоеОборудование.Получить();
		Иначе
			ЗначениеПодчиненнойКонстанты = ЗначениеКонстанты И Константы.ИспользоватьОплатуПлатежнымиКартами.Получить();
		КонецЕсли;
		
		УстановитьЗначениеКонстанты(
			Константы.ИспользоватьПодключаемоеОборудованиеИОплатуПлатежнымиКартами, ЗначениеПодчиненнойКонстанты);
	 	
	ИначеЕсли ИмяКонстанты = "ИспользоватьНесколькоКасс"
	 	  ИЛИ ИмяКонстанты = "ИспользоватьНесколькоРасчетныхСчетов" Тогда
		
		Если ИмяКонстанты = "ИспользоватьНесколькоКасс" Тогда
			ЗначениеПодчиненнойКонстанты = ЗначениеКонстанты ИЛИ Константы.ИспользоватьНесколькоРасчетныхСчетов.Получить();
		Иначе
			ЗначениеПодчиненнойКонстанты = ЗначениеКонстанты ИЛИ Константы.ИспользоватьНесколькоКасс.Получить();
		КонецЕсли;
		
		УстановитьЗначениеКонстанты(
			Константы.ИспользоватьНесколькоРасчетныхСчетовКасс, ЗначениеПодчиненнойКонстанты);
		
	ИначеЕсли ИмяКонстанты = "ИспользоватьНесколькоВалют" Тогда
		
		Если НЕ ЗначениеКонстанты Тогда
			
			ЗначениеПодчиненнойКонстанты = ДоходыИРасходыСервер.ПолучитьВалютуУправленческогоУчета();
			
			УстановитьЗначениеКонстанты(
				Константы.ВалютаУправленческогоУчета, 	  ЗначениеПодчиненнойКонстанты);
			УстановитьЗначениеКонстанты(
				Константы.ВалютаРегламентированногоУчета, ЗначениеПодчиненнойКонстанты);				
		КонецЕсли;
		
	//++ НЕ УТКА
	ИначеЕсли ИмяКонстанты = "ИспользоватьСтатусыЗаказовДавальцев" Тогда
		
		Если НЕ Константы.ИспользоватьСтатусыЗаказовДавальцев.Получить() Тогда
			УстановитьЗначениеКонстанты(Константы.НеЗакрыватьЗаказыДавальцевБезПолнойОплаты,	Ложь);
			УстановитьЗначениеКонстанты(Константы.НеЗакрыватьЗаказыДавальцевБезПолнойОтработки,	Ложь);
		КонецЕсли;
	//-- НЕ УТКА
	//++ НЕ УТ
	ИначеЕсли ИмяКонстанты = "ИспользоватьСтатусыЗаказовПереработчикам" Тогда
		
		Если НЕ Константы.ИспользоватьСтатусыЗаказовПереработчикам.Получить() Тогда
			УстановитьЗначениеКонстанты(Константы.НеЗакрыватьЗаказыПереработчикамБезПолнойОплаты,		Ложь);
			УстановитьЗначениеКонстанты(Константы.НеЗакрыватьЗаказыПереработчикамБезПолнойОтработки,	Ложь);
		КонецЕсли;
	//-- НЕ УТ
		
	ИначеЕсли ИмяКонстанты = "ИспользоватьЗаказыКлиентов" 
		ИЛИ ИмяКонстанты = "ИспользоватьЗаявкиНаВозвратТоваровОтКлиентов" Тогда
		
		Если НЕ Константы.ИспользоватьЗаказыКлиентов.Получить() 
			И НЕ Константы.ИспользоватьЗаявкиНаВозвратТоваровОтКлиентов.Получить() Тогда
		
			УстановитьЗначениеКонстанты(
				Константы.ИспользоватьРасширенныеВозможностиЗаказаКлиента,   Ложь);
				
			КонецЕсли;
			
	ИначеЕсли ИмяКонстанты = "ИспользоватьРасширенныеВозможностиЗаказаКлиента" Тогда
		
		Если НЕ Константы.ИспользоватьРасширенныеВозможностиЗаказаКлиента.Получить() Тогда
		
			УстановитьЗначениеКонстанты(
				Константы.НеЗакрыватьЗаказыКлиентовБезПолнойОплаты,   Ложь);
			УстановитьЗначениеКонстанты(
				Константы.НеЗакрыватьЗаказыКлиентовБезПолнойОтгрузки, Ложь);
			
		КонецЕсли;
		
	ИначеЕсли ИмяКонстанты = "ИспользоватьСогласованиеЧерез1СДокументооборот" Тогда
		
		Если НЕ ЗначениеКонстанты Тогда
			УстановитьЗначениеКонстанты(
				Константы.ИспользоватьВнутреннееСогласованиеЗаявокНаВозвратТоваровОтКлиентов,
				Константы.ИспользоватьСогласованиеЗаявокНаВозвратТоваровОтКлиентов.Получить());
			УстановитьЗначениеКонстанты(
				Константы.ИспользоватьВнутреннееСогласованиеЗаказовКлиентов,
				Константы.ИспользоватьСогласованиеЗаказовКлиентов.Получить());
			УстановитьЗначениеКонстанты(
				Константы.ИспользоватьВнутреннееСогласованиеКоммерческихПредложений,
				Константы.ИспользоватьСогласованиеКоммерческихПредложений.Получить());
			УстановитьЗначениеКонстанты(
				Константы.ИспользоватьВнутреннееСогласованиеСоглашенийСКлиентами,
				Константы.ИспользоватьСогласованиеСоглашенийСКлиентами.Получить());
		Иначе
			УстановитьЗначениеКонстанты(
				Константы.ИспользоватьПроцессыИЗадачи1СДокументооборота,
				Истина);
		КонецЕсли;
		
	ИначеЕсли ИмяКонстанты = "ИспользоватьСогласованиеЗаявокНаВозвратТоваровОтКлиентов"
	 ИЛИ ИмяКонстанты = "ИспользоватьСогласованиеЗаказовКлиентов"
	 ИЛИ ИмяКонстанты = "ИспользоватьСогласованиеКоммерческихПредложений"
	 ИЛИ ИмяКонстанты = "ИспользоватьСогласованиеСоглашенийСКлиентами" Тогда
		
		ИмяПодчиненнойКонстанты 	 = СтрЗаменить(ИмяКонстанты, "ИспользоватьСогласование", "ИспользоватьВнутреннееСогласование");
		ЗначениеПодчиненнойКонстанты = ЗначениеКонстанты И НЕ Константы.ИспользоватьСогласованиеЧерез1СДокументооборот.Получить();
		
		УстановитьЗначениеКонстанты(
			Константы[ИмяПодчиненнойКонстанты], ЗначениеПодчиненнойКонстанты);
			
	ИначеЕсли ИмяКонстанты = "ИспользоватьСделкиСКлиентами" Тогда
		
		УстановитьЗначениеКонстанты(
			Константы.ИспользоватьУправлениеСделками, ЗначениеКонстанты И Константы.ИспользоватьУправлениеСделками.Получить());
		УстановитьЗначениеКонстанты(
			Константы.ИспользоватьПервичныйСпрос, 	  ЗначениеКонстанты И Константы.ИспользоватьПервичныйСпрос.Получить());
		
	ИначеЕсли ИмяКонстанты = "ИспользоватьУправлениеСделками" Тогда
		
		УстановитьЗначениеКонстанты(
			Константы.ИспользоватьКоммерческиеПредложенияКлиентам, ЗначениеКонстанты ИЛИ Константы.ИспользоватьКоммерческиеПредложенияКлиентам.Получить());
		УстановитьЗначениеКонстанты(
			Константы.ИспользоватьЗаказыКлиентов, 	  			   ЗначениеКонстанты ИЛИ Константы.ИспользоватьЗаказыКлиентов.Получить());
		
	ИначеЕсли ИмяКонстанты = "ИспользоватьПострочнуюОтгрузкуВЗаказеКлиента"
	//++ НЕ УТКА
	 ИЛИ ИмяКонстанты = "ИспользоватьУправлениеРемонтами"
	 ИЛИ ИмяКонстанты = "ИспользоватьПроизводство"
	 ИЛИ ИмяКонстанты = "ИспользоватьПроизводствоНаСтороне"
	//-- НЕ УТКА
	 ИЛИ ИмяКонстанты = "ИспользоватьЗаказыНаПеремещение"
	 ИЛИ ИмяКонстанты = "ИспользоватьЗаказыНаВнутреннееПотребление"
	 ИЛИ ИмяКонстанты = "ИспользоватьЗаказыНаСборку" Тогда
		
		ЗначениеПодчиненнойКонстанты =
			Константы.ИспользоватьПострочнуюОтгрузкуВЗаказеКлиента.Получить()
			ИЛИ Константы.ИспользоватьЗаказыНаПеремещение.Получить()
			ИЛИ Константы.ИспользоватьЗаказыНаВнутреннееПотребление.Получить()
			ИЛИ Константы.ИспользоватьЗаказыНаСборку.Получить();
		//++ НЕ УТКА
		ЗначениеПодчиненнойКонстанты = ЗначениеПодчиненнойКонстанты
			ИЛИ Константы.ИспользоватьУправлениеРемонтами.Получить()
			ИЛИ Константы.ИспользоватьПроизводство.Получить()
			ИЛИ Константы.ИспользоватьПроизводствоНаСтороне.Получить();
		//-- НЕ УТКА
		УстановитьЗначениеКонстанты(
			Константы.ИспользоватьОбособленноеОбеспечениеЗаказов, ЗначениеПодчиненнойКонстанты И Константы.ИспользоватьОбособленноеОбеспечениеЗаказов.Получить());
			
	ИначеЕсли ИмяКонстанты = "ДетализироватьЗаданияТорговымПредставителямПоНоменклатуре"
	 ИЛИ ИмяКонстанты = "ИспользованиеЗаданийТорговымПредставителям" Тогда
		
		Если ИмяКонстанты = "ДетализироватьЗаданияТорговымПредставителямПоНоменклатуре" Тогда
			ЗначениеПодчиненнойКонстанты = НЕ ЗначениеКонстанты
				И Константы.ИспользованиеЗаданийТорговымПредставителям.Получить() = Перечисления.ИспользованиеЗаданийТорговымПредставителям.ИспользуютсяДляУправленияТорговымиПредставителями;
		Иначе
			ЗначениеПодчиненнойКонстанты = НЕ Константы.ДетализироватьЗаданияТорговымПредставителямПоНоменклатуре.Получить()
				И ЗначениеКонстанты = Перечисления.ИспользованиеЗаданийТорговымПредставителям.ИспользуютсяДляУправленияТорговымиПредставителями;
		КонецЕсли;
		
		УстановитьЗначениеКонстанты(
			Константы.НеДетализироватьЗаданияТорговымПредставителямПоНоменклатуре, ЗначениеПодчиненнойКонстанты);
				
	ИначеЕсли ИмяКонстанты = "ИспользоватьРучныеСкидкиВПродажах"
		ИЛИ ИмяКонстанты = "ИспользоватьАвтоматическиеСкидкиВПродажах" Тогда
		
		Если НЕ Константы.ИспользоватьРучныеСкидкиВПродажах.Получить()
			И НЕ Константы.ИспользоватьАвтоматическиеСкидкиВПродажах.Получить() Тогда
		
			УстановитьЗначениеКонстанты(Константы.ВыбиратьВариантВыводаСкидокПриПечатиДокументовПродажи, Ложь);
			УстановитьЗначениеКонстанты(Константы.ОтображениеСкидокВПечатныхФормахДокументовПродажи, Перечисления.ВариантыВыводаСкидокВПечатныхФормах.НеВыводитьСкидки);
		КонецЕсли;
	ИначеЕсли ИмяКонстанты = "ИспользоватьСчетаНаОплатуКлиентам" Тогда
		
		ЗначениеПодчиненнойКонстанты = ?(НЕ ЗначениеКонстанты, Константы.ВыбиратьВариантВыводаСкидокПриПечатиДокументовПродажи.Получить(), Ложь);
		
		УстановитьЗначениеКонстанты(Константы.НеИспользоватьСчетаНаОплатуНеВыбиратьВариантВыводаСкидок, ?(НЕ ЗначениеКонстанты, НЕ ЗначениеПодчиненнойКонстанты, ЗначениеПодчиненнойКонстанты));
		УстановитьЗначениеКонстанты(Константы.НеИспользоватьСчетаНаОплатуВыбиратьВариантВыводаСкидок, ЗначениеПодчиненнойКонстанты);
		
	ИначеЕсли ИмяКонстанты = "ОтображениеСкидокВПечатныхФормахДокументовПродажи" Тогда
		
		ИспользоватьСчетаНаОплатуКлиентом = Константы.ИспользоватьСчетаНаОплатуКлиентам.Получить();
		
		ЗначениеПодчиненнойКонстанты = ?(НЕ ИспользоватьСчетаНаОплатуКлиентом, Константы.ВыбиратьВариантВыводаСкидокПриПечатиДокументовПродажи.Получить(), Ложь);
		
		УстановитьЗначениеКонстанты(Константы.НеИспользоватьСчетаНаОплатуВыбиратьВариантВыводаСкидок, ЗначениеПодчиненнойКонстанты);
		УстановитьЗначениеКонстанты(Константы.НеИспользоватьСчетаНаОплатуНеВыбиратьВариантВыводаСкидок, ?(НЕ ИспользоватьСчетаНаОплатуКлиентом, НЕ ЗначениеПодчиненнойКонстанты, ЗначениеПодчиненнойКонстанты));
		
	ИначеЕсли ИмяКонстанты = "ФормироватьОтчетностьПоНДС" Тогда
		
		УстановитьЗначениеКонстанты(
			Константы.ИспользоватьНДС0,
			ЗначениеКонстанты И Константы.ИспользоватьПродажиНаЭкспорт.Получить());
		
	ИначеЕсли ИмяКонстанты = "ИспользоватьПродажиНаЭкспортНесырьевыхТоваров" 
			ИЛИ ИмяКонстанты = "ИспользоватьПродажиНаЭкспортСырьевыхТоваровУслуг" Тогда
			
		Если ИмяКонстанты = "ИспользоватьПродажиНаЭкспортНесырьевыхТоваров" Тогда
			ЗначениеПодчиненнойКонстанты = ЗначениеКонстанты ИЛИ Константы.ИспользоватьПродажиНаЭкспортСырьевыхТоваровУслуг.Получить();
		Иначе
			ЗначениеПодчиненнойКонстанты = ЗначениеКонстанты ИЛИ Константы.ИспользоватьПродажиНаЭкспортНесырьевыхТоваров.Получить();
		КонецЕсли;
		
		УстановитьЗначениеКонстанты(
			Константы.ИспользоватьПродажиНаЭкспорт,
			ЗначениеПодчиненнойКонстанты);
		
		УстановитьЗначениеКонстанты(
			Константы.ИспользоватьНДС0,
			ЗначениеПодчиненнойКонстанты И Константы.ФормироватьОтчетностьПоНДС.Получить());
			
	ИначеЕсли ИмяКонстанты = "ИспользоватьРаздельныйУчетПоНалогообложению" Тогда
		
		ЕстьУчетОС = Константы.ИспользоватьУчетПрочихДоходовРасходов.Получить()
						И (Константы.УправлениеПредприятием.Получить() ИЛИ Константы.КомплекснаяАвтоматизация.Получить());
		
		УстановитьЗначениеКонстанты(
			Константы.РаспределятьНДС,
			ЗначениеКонстанты ИЛИ ЕстьУчетОС);
		
	ИначеЕсли ИмяКонстанты = "ИспользоватьУчетПрочихДоходовРасходов" Тогда
		
		ЕстьУчетОС = ЗначениеКонстанты
						И (Константы.УправлениеПредприятием.Получить() ИЛИ Константы.КомплекснаяАвтоматизация.Получить());
		
		УстановитьЗначениеКонстанты(
			Константы.РаспределятьНДС,
			Константы.ИспользоватьРаздельныйУчетПоНалогообложению.Получить() ИЛИ ЕстьУчетОС);
	
	//++ НЕ УТ
	ИначеЕсли Найти(ИмяКонстанты, "ИспользоватьУправлениеПроизводством") > 0 Тогда
		
		Если ИмяКонстанты = "ИспользоватьУправлениеПроизводством" Тогда
			ИспользуетсяПроизводство21 = ЗначениеКонстанты;
			ИспользуетсяПроизводство22 = Константы.ИспользоватьУправлениеПроизводством2_2.Получить();
		Иначе
			ИспользуетсяПроизводство21 = Константы.ИспользоватьУправлениеПроизводством.Получить();
			ИспользуетсяПроизводство22 = ЗначениеКонстанты;
		КонецЕсли;
		
		// подчиненные константы
		УстановитьЗначениеКонстанты(Константы.ИспользоватьПроизводство, ИспользуетсяПроизводство21 ИЛИ ИспользуетсяПроизводство22);
		//++ НЕ УТКА
		Если Не ИспользуетсяПроизводство22 Тогда
			УстановитьЗначениеКонстанты(Константы.МетодикаУправленияПроизводством, Перечисления.МетодикаУправленияПроизводством.БезПланирования);
		КонецЕсли;
		//-- НЕ УТКА
		
		// служебные константы
		//++ НЕ УТКА
		УстановитьЗначениеКонстанты(Константы.ИспользуетсяТолькоУправлениеПроизводством21, ИспользуетсяПроизводство21 И НЕ ИспользуетсяПроизводство22);
		УстановитьЗначениеКонстанты(Константы.ИспользуетсяТолькоУправлениеПроизводством22, НЕ ИспользуетсяПроизводство21 И ИспользуетсяПроизводство22);
		УстановитьЗначениеКонстанты(Константы.ИспользуетсяУправлениеПроизводством21и22, ИспользуетсяПроизводство21 И ИспользуетсяПроизводство22);
		//-- НЕ УТКА
	
	//-- НЕ УТ
		
	КонецЕсли;
	
	//++ НЕ УТКА
	Если ИмяКонстанты = "ИспользоватьПроизводствоНаСтороне" 
		ИЛИ ИмяКонстанты = "ИспользоватьПроизводство" 
		ИЛИ ИмяКонстанты = "ИспользоватьУправлениеПроизводством" 
		ИЛИ ИмяКонстанты = "ИспользоватьУправлениеПроизводством2_2" Тогда
		
		Если Константы.ИспользоватьПроизводствоНаСтороне.Получить()
			И НЕ Константы.ИспользоватьСтатусыЗаказовПереработчикам.Получить()
			И (Константы.ИспользоватьПроизводство.Получить() 
				ИЛИ Константы.ИспользоватьУправлениеПроизводством.Получить()
				ИЛИ Константы.ИспользоватьУправлениеПроизводством2_2.Получить()) Тогда
			
			УстановитьЗначениеКонстанты(Константы.ИспользоватьСтатусыЗаказовПереработчикам, Истина);
		КонецЕсли; 
		
	КонецЕсли;
	//-- НЕ УТКА
	
КонецПроцедуры

Процедура УстановитьЗначениеКонстанты(МенеджерКонстанты, ЗначениеКонстанты)
	
	Если МенеджерКонстанты.Получить() <> ЗначениеКонстанты Тогда
		МенеджерКонстанты.Установить(ЗначениеКонстанты);
	КонецЕсли;
	
КонецПроцедуры

Процедура УдалитьВхожденияЭлементаИзТабличнойЧасти(ТабличнаяЧасть, Ссылка, Колонка)
	
	Отбор = Новый Структура(Колонка, Ссылка);
	
	Строки = ТабличнаяЧасть.НайтиСтроки(Отбор);
	Для Каждого ТекСтр Из Строки Цикл
		ТабличнаяЧасть.Удалить(ТекСтр);
	КонецЦикла;
	
КонецПроцедуры

Процедура ОчиститьОтветственногоВСправочникахОбработкаЗаполнения(Источник, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) Экспорт
	
	ОтветственныйВДокументах = ПолучитьФункциональнуюОпцию("ОтветственныйВДокументах");
	СтандартнаяСсылка 		 = Справочники.Пользователи.ПолучитьСсылку(Новый УникальныйИдентификатор("aa00559e-ad84-4494-88fd-f0826edc46f0"));
	ТекущийПользователь		 = ПользователиКлиентСервер.АвторизованныйПользователь();
	МетаданныеДокумента 	 = Источник.Метаданные();
	
	Если Не ОтветственныйВДокументах ИЛИ (СтандартнаяСсылка = ТекущийПользователь И ТекущийПользователь.Служебный) Тогда
		
		Если Не Источник.ЭтоГруппа Тогда 
			Если МетаданныеДокумента.Реквизиты.Найти("Ответственный") <> Неопределено Тогда
				Источник.Ответственный = Неопределено;
			КонецЕсли;
			
			Если МетаданныеДокумента.Реквизиты.Найти("Менеджер") <> Неопределено Тогда
				Источник.Менеджер = Неопределено;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОчиститьОтветственногоВДокументахОбработкаЗаполнения(Источник, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) Экспорт
	
	ОтветственныйВДокументах = ПолучитьФункциональнуюОпцию("ОтветственныйВДокументах");
	СтандартнаяСсылка 		 = Справочники.Пользователи.ПолучитьСсылку(Новый УникальныйИдентификатор("aa00559e-ad84-4494-88fd-f0826edc46f0"));
	ТекущийПользователь		 = ПользователиКлиентСервер.АвторизованныйПользователь();
	МетаданныеДокумента 	 = Источник.Метаданные();
	
	Если Не ОтветственныйВДокументах ИЛИ (СтандартнаяСсылка = ТекущийПользователь И ТекущийПользователь.Служебный) Тогда
		
		Если МетаданныеДокумента.Реквизиты.Найти("Ответственный") <> Неопределено Тогда
			Источник.Ответственный = Неопределено;
		КонецЕсли;
			
		Если МетаданныеДокумента.Реквизиты.Найти("Менеджер") <> Неопределено Тогда
			Источник.Менеджер = Неопределено;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры 

// Обработчик подписки на событие ЗарегистрироватьДанныеПервичныхДокументов
Процедура ПриЗаписиДокументаРегистрацияДанныхПервичныхДокументов(Источник, Отказ) Экспорт
	Перем НомерДокумента, ДатаДокумента;
	
	Если Источник.ОбменДанными.Загрузка = Истина
		И Источник.ДополнительныеСвойства.Свойство("РегистрироватьДанныеПервичныхДокументов")
		И Источник.ДополнительныеСвойства.РегистрироватьДанныеПервичныхДокументов = Ложь Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Ссылка = Источник.Ссылка;
	МетаданныеДокумента = Источник.Метаданные();
	
	ИменаРеквизитов = "Номер, Дата";
	
	ЭтоДокументИнтеркампани     = ОбщегоНазначения.ЕстьРеквизитОбъекта("РасчетыЧерезОтдельногоКонтрагента", МетаданныеДокумента);
	ЕстьНомерВходящегоДокумента = ОбщегоНазначения.ЕстьРеквизитОбъекта("НомерВходящегоДокумента", МетаданныеДокумента);
	ЕстьДатаВходящегоДокумента  = ОбщегоНазначения.ЕстьРеквизитОбъекта("ДатаВходящегоДокумента", МетаданныеДокумента); 
	
	Если ?(ЭтоДокументИнтеркампани, Источник["РасчетыЧерезОтдельногоКонтрагента"], Истина) 
		 И ЕстьНомерВходящегоДокумента Тогда
		 
		ИменаРеквизитов = ИменаРеквизитов + ", НомерВходящегоДокумента";
		Если ЕстьДатаВходящегоДокумента Тогда
			ИменаРеквизитов = ИменаРеквизитов + ", ДатаВходящегоДокумента";
		КонецЕсли;
		
	КонецЕсли;
	
	Реквизиты = Новый Структура(ИменаРеквизитов);
	ЗаполнитьЗначенияСвойств(Реквизиты, Источник);
	
	// Установка управляемой блокировки.
	БлокировкаДанных = Новый БлокировкаДанных;
	ЭлементБлокировки = БлокировкаДанных.Добавить("РегистрСведений.ДанныеПервичныхДокументов");
	ЭлементБлокировки.УстановитьЗначение("Документ", Ссылка);
	БлокировкаДанных.Заблокировать();
	
	НомерДокумента	= "";
	ДатаДокумента	= '00010101';
	
	Если Реквизиты.Свойство("НомерВходящегоДокумента") Тогда
		НомерДокумента	= СокрЛП(Реквизиты.НомерВходящегоДокумента);
		Если Реквизиты.Свойство("ДатаВходящегоДокумента") Тогда
			ДатаДокумента = Реквизиты.ДатаВходящегоДокумента;
		КонецЕсли;
	Иначе
		НомерДокумента	= ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Реквизиты.Номер, Истина, Истина);
		ДатаДокумента	= Реквизиты.Дата;
	КонецЕсли;
	
	ОрганизацииКРегистрации = Новый Соответствие;
	
	// Дополним МассивОрганизаций организациями из шапки документа
	МассивРеквизитовОрганизация = ИменаРеквизитовОраганизаций(МетаданныеДокумента);
	Для каждого РеквизитОрганизация Из МассивРеквизитовОрганизация Цикл
		ДобавитьОрганизацию(ОрганизацииКРегистрации, Источник, РеквизитОрганизация);
	КонецЦикла;
	
	// Дополним МассивОрганизаций организациями из табличных частей
	Для каждого ТабличнаяЧасть Из МетаданныеДокумента.ТабличныеЧасти Цикл
		
		МассивРеквизитовОрганизация = ИменаРеквизитовОраганизаций(ТабличнаяЧасть);
		Если МассивРеквизитовОрганизация.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Для каждого Строка Из Источник[ТабличнаяЧасть.Имя] Цикл
			Для каждого РеквизитОрганизация Из МассивРеквизитовОрганизация Цикл
				ДобавитьОрганизацию(ОрганизацииКРегистрации, Строка, РеквизитОрганизация);
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
	НаборЗаписейРегистра = РегистрыСведений.ДанныеПервичныхДокументов.СоздатьНаборЗаписей();
	НаборЗаписейРегистра.Отбор.Документ.Установить(Ссылка);
	
	Для каждого КлючИЗначение Из ОрганизацииКРегистрации Цикл
		
		Организация = КлючИЗначение.Ключ;
		ИмяРеквизита = КлючИЗначение.Значение;
		
		НоваяЗапись = НаборЗаписейРегистра.Добавить();
		НоваяЗапись.Организация = Организация;
		НоваяЗапись.Документ    = Ссылка;
		
		Если ЭтоДокументИнтеркампани И ИмяРеквизита = "Организация" Тогда
			НоваяЗапись.Номер    = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Реквизиты.Номер, Истина, Истина);
			НоваяЗапись.Дата     = Реквизиты.Дата;
		Иначе
			НоваяЗапись.Номер    = НомерДокумента;
			НоваяЗапись.Дата     = ДатаДокумента;
		КонецЕсли;
		
		НоваяЗапись.НомерРегистратора = Реквизиты.Номер;
		НоваяЗапись.ДатаРегистратора = Реквизиты.Дата;
		
	КонецЦикла;
	
	НаборЗаписейРегистра.Записать(Истина);
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ИменаРеквизитовОраганизаций(ОбъектМетаданных)
	
	Результат = Новый Массив;
	
	ТипОрганизация = Тип("СправочникСсылка.Организации");
	Для каждого Реквизит Из ОбъектМетаданных.Реквизиты Цикл
		Если Реквизит.Тип.СодержитТип(ТипОрганизация) Тогда
			Результат.Добавить(Реквизит.Имя);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Процедура ДобавитьОрганизацию(ОрганизацииКРегистрации, Данные, ИмяРеквизита)
	
	ЗначениеРеквизита = Данные[ИмяРеквизита];
	
	Если ЗначениеЗаполнено(ЗначениеРеквизита) 
		И ТипЗнч(ЗначениеРеквизита) = Тип("СправочникСсылка.Организации") Тогда
		
		ОрганизацииКРегистрации.Вставить(ЗначениеРеквизита, ИмяРеквизита);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
